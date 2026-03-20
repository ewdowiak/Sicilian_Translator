##  Copyright 2017--2022 Amazon.com, Inc. or its affiliates. All Rights Reserved.
##
##  Licensed under the Apache License, Version 2.0 (the "License"). You may not
##  use this file except in compliance with the License. A copy of the License
##  is located at
##
##      http://aws.amazon.com/apache2.0/
##
##  or in the "license" file accompanying this file. This file is distributed on
##  an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
##  express or implied. See the License for the specific language governing
##  permissions and limitations under the License.
##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##
##  * rewrite of Sockeye's "translate.py" for web translation with FastAPI
##  * Eryk Wdowiak (09 March 2026)
##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

from fastapi import FastAPI

import argparse
# import logging
import os
import sys
import time
from contextlib import ExitStack
from typing import Dict, Generator, List, Optional, Union

from sockeye.lexicon import load_restrict_lexicon, RestrictLexicon
# from sockeye.log import setup_main_logger
from sockeye.model import load_models
from sockeye.output_handler import get_output_handler, OutputHandler
# from sockeye.utils import log_basic_info, check_condition, grouper, smart_open, seed_rngs
from sockeye.utils import check_condition, grouper, smart_open, seed_rngs
from sockeye import arguments
from sockeye import constants as C
from sockeye import inference
from sockeye import utils

# logger = logging.getLogger(__name__)

##  send STDERR to /dev/null
sys.stderr = open(os.devnull, 'w')

##  Ignore all warnings
import warnings
warnings.simplefilter("ignore")

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

def prep_translate(args: argparse.Namespace):
    # Seed randomly unless a seed has been passed
    seed_rngs(args.seed if args.seed is not None else int(time.time()))

    if args.nbest_size > 1:
        if args.output_type != C.OUTPUT_HANDLER_JSON:
            # logger.warning(
            #     "For nbest translation, you must specify `--output-type '%s'; overriding your setting of '%s'.",
            #     C.OUTPUT_HANDLER_JSON, args.output_type)
            args.output_type = C.OUTPUT_HANDLER_JSON
    output_handler = get_output_handler(args.output_type,
                                        args.output)

    device = utils.init_device(args)

    models, source_vocabs, target_vocabs = load_models(device=device,
                                                       model_folders=args.models,
                                                       checkpoints=args.checkpoints,
                                                       dtype=args.dtype,
                                                       clamp_to_dtype=args.clamp_to_dtype,
                                                       inference_only=True,
                                                       knn_index=args.knn_index)

    restrict_lexicon = None  # type: Optional[Union[RestrictLexicon, Dict[str, RestrictLexicon]]]
    if args.restrict_lexicon is not None:
        if len(args.restrict_lexicon) == 1:
            # Single lexicon used for all inputs.
            # Handle a single arg of key:path or path (parsed as path:path)
            restrict_lexicon = load_restrict_lexicon(args.restrict_lexicon[0][1], source_vocabs[0], target_vocabs[0],
                                                     k=args.restrict_lexicon_topk)
        else:
            check_condition(args.json_input,
                            "JSON input is required when using multiple lexicons for vocabulary restriction")
            # Multiple lexicons with specified names
            restrict_lexicon = dict()
            for key, path in args.restrict_lexicon:
                lexicon = load_restrict_lexicon(path, source_vocabs[0], target_vocabs[0], k=args.restrict_lexicon_topk)
                restrict_lexicon[key] = lexicon

    brevity_penalty_weight = args.brevity_penalty_weight
    if args.brevity_penalty_type == C.BREVITY_PENALTY_CONSTANT:
        if args.brevity_penalty_constant_length_ratio > 0.0:
            constant_length_ratio = args.brevity_penalty_constant_length_ratio
        else:
            constant_length_ratio = sum(model.length_ratio_mean for model in models) / len(models)
    elif args.brevity_penalty_type == C.BREVITY_PENALTY_LEARNED:
        constant_length_ratio = -1.0
    elif args.brevity_penalty_type == C.BREVITY_PENALTY_NONE:
        brevity_penalty_weight = 0.0
        constant_length_ratio = -1.0
    else:
        raise ValueError("Unknown brevity penalty type %s" % args.brevity_penalty_type)

    for model in models:
        model.eval()

    scorer = inference.CandidateScorer(
        length_penalty_alpha=args.length_penalty_alpha,
        length_penalty_beta=args.length_penalty_beta,
        brevity_penalty_weight=brevity_penalty_weight)
    scorer.to(models[0].dtype)

    translator = inference.Translator(device=device,
                                      ensemble_mode=args.ensemble_mode,
                                      scorer=scorer,
                                      batch_size=args.batch_size,
                                      beam_size=args.beam_size,
                                      beam_search_stop=args.beam_search_stop,
                                      nbest_size=args.nbest_size,
                                      models=models,
                                      source_vocabs=source_vocabs,
                                      target_vocabs=target_vocabs,
                                      restrict_lexicon=restrict_lexicon,
                                      strip_unknown_words=args.strip_unknown_words,
                                      sample=args.sample,
                                      output_scores=output_handler.reports_score(),
                                      constant_length_ratio=constant_length_ratio,
                                      knn_lambda=args.knn_lambda,
                                      max_output_length_num_stds=args.max_output_length_num_stds,
                                      max_input_length=args.max_input_length,
                                      max_output_length=args.max_output_length,
                                      prevent_unk=args.prevent_unk,
                                      greedy=args.greedy,
                                      skip_nvs=args.skip_nvs,
                                      nvs_thresh=args.nvs_thresh)

    return translator , output_handler


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##


def make_inputs(input_file: Optional[str],
                input_text: Optional[str],
                translator: inference.Translator,
                input_is_json: bool,
                input_factors: Optional[List[str]] = None) -> Generator[inference.TranslatorInput, None, None]:
    """
    Generates TranslatorInput instances from input. If input is None, reads from stdin. If num_input_factors > 1,
    the function will look for factors attached to each token, separated by '|'.
    If source is not None, reads from the source file. If num_source_factors > 1, num_source_factors source factor
    filenames are required.

    :param input_file: The source file (possibly None).
    :param translator: Translator that will translate each line of input.
    :param input_is_json: Whether the input is in json format.
    :param input_factors: Source factor files.
    :return: TranslatorInput objects.
    """
    if input_file is None:
        check_condition(input_factors is None, "Translating from STDIN, not expecting any factor files.")
        for sentence_id, line in enumerate([input_text]):
            if input_is_json:
                yield inference.make_input_from_json_string(sentence_id=sentence_id,
                                                            json_string=line,
                                                            translator=translator)
            else:
                yield inference.make_input_from_factored_string(sentence_id=sentence_id,
                                                                factored_string=line,
                                                                translator=translator)
    else:
        input_factors = [] if input_factors is None else input_factors
        inputs = [input_file] + input_factors
        if not input_is_json:
            check_condition(translator.num_source_factors == len(inputs),
                            "Model(s) require %d factors, but %d given (through --input and --input-factors)." % (
                                translator.num_source_factors, len(inputs)))
        with ExitStack() as exit_stack:
            streams = [exit_stack.enter_context(smart_open(i)) for i in inputs]
            for sentence_id, inputs in enumerate(zip(*streams), 1):
                if input_is_json:
                    yield inference.make_input_from_json_string(sentence_id=sentence_id,
                                                                json_string=inputs[0],
                                                                translator=translator)
                else:
                    yield inference.make_input_from_multiple_strings(sentence_id=sentence_id, strings=list(inputs))

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

def run_translate(output_handler: OutputHandler,
                  trans_inputs: List[inference.TranslatorInput],
                  translator: inference.Translator) -> float:
    """
    Translates each line from source_data, calling output handler after translating a batch.

    :param output_handler: A handler that will be called once with the output of each translation.
    :param trans_inputs: A enumerable list of translator inputs.
    :param translator: The translator that will be used for each line of input.
    :return: Total time taken.
    """

    trans_outputs = translator.translate(trans_inputs)

    return trans_outputs

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

params = arguments.ConfigArgumentParser(description="Translate CLI")
params.add_argument("--models", type=str, default=["/home/eryk/website/translate/lib/model/tnf_m2m_se37a03"])
params.add_argument("--use-cpu", action="store_false")
params.add_argument('--seed', type=int, default=None)
params.add_argument('--output', type=ascii, default=None)
params.add_argument('--loglevel', default="INFO")
params.add_argument('--nbest_size', type=int, default=5)
params.add_argument('--output-type', default="translation")
params.add_argument('--checkpoints', default=[4])
params.add_argument('--dtype', default=None)
params.add_argument('--clamp-to-dtype', action="store_true")
params.add_argument('--knn-index', default=None)
params.add_argument('--restrict-lexicon', default=None)
params.add_argument('--brevity-penalty-weight',type=float,default=1.0)
params.add_argument('--brevity-penalty-type',default="none")
params.add_argument('--length-penalty-alpha',type=float,default=1.0)
params.add_argument('--length-penalty-beta',type=float,default=0.0)
params.add_argument('--ensemble-mode',type=ascii,default="linear")
params.add_argument('--batch-size',type=int,default=1)
params.add_argument('--beam-size',type=int,default=5)
params.add_argument('--beam-search-stop',default="all")
params.add_argument('--strip-unknown-words', action="store_false")
params.add_argument('--sample', default=None)
params.add_argument('--knn-lambda',type=float,default=0.8)
params.add_argument('--max-output-length-num-stds',type=float,default=2.0)
params.add_argument('--max-input-length',type=int,default=400)
params.add_argument('--max-output-length',type=int,default=None)
params.add_argument('--prevent-unk',action="store_true")
params.add_argument('--greedy',action="store_true")
params.add_argument('--skip-nvs',action="store_true")
params.add_argument('--nvs-thresh',type=float,default=0.5)
params.add_argument('--chunk-size',type=int,default=None)

##  INPUT
params.add_argument('--input',default=None)
## params.add_argument('--input-text',default=source_seq)

params.add_argument('--input-factors',default=None)
params.add_argument('--json-input',action="store_true")
params.add_argument('--quiet',action="store_false")

args = params.parse_args(["--loglevel","INFO"])

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

persist_trans , persist_othand = prep_translate(args)

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

def translate(translator: inference.Translator,
              output_handler: OutputHandler,
              chunk_size: Optional[int],
              input_file: Optional[str] = None,
              input_text: Optional[str] = None,
              input_factors: Optional[List[str]] = None,
              input_is_json: bool = False) -> None:
    """
    Reads from either a file or stdin and translates each line, calling the output_handler with the result.

    :param output_handler: Handler that will write output to a stream.
    :param translator: Translator that will translate each line of input.
    :param chunk_size: The size of the portion to read at a time from the input.
    :param input_file: Optional path to file which will be translated line-by-line if included, if none use stdin.
    :param input_factors: Optional list of paths to files that contain source factors.
    :param input_is_json: Whether the input is in json format.
    """

    chunk_size = C.CHUNK_SIZE_NO_BATCHING

    for chunk in grouper(make_inputs(input_file, input_text, translator, input_is_json, input_factors), size=chunk_size):
        translations = run_translate(output_handler, chunk, translator)
        
    ##  return the translations!  :-)
    return translations

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

app = FastAPI()

@app.get("/{intext}")
def se_translate(intext: str):

    ##  capture source sequence
    source_seq = intext

    ##  translate
    translations = translate(translator=persist_trans,
                             output_handler=persist_othand,
                             chunk_size=args.chunk_size,
                             input_file=args.input,
                             input_text=source_seq,
                             input_factors=args.input_factors,
                             input_is_json=args.json_input)
    
    ##  what's the translation?
    # ot_trans = translations[0].translation
    
    ##  what are the translations?    
    t1 = str(translations[0].nbest_scores[0][0]) + " <TAB> " + translations[0].nbest_translations[0]
    t2 = str(translations[0].nbest_scores[1][0]) + " <TAB> " + translations[0].nbest_translations[1]
    t3 = str(translations[0].nbest_scores[2][0]) + " <TAB> " + translations[0].nbest_translations[2]
    t4 = str(translations[0].nbest_scores[3][0]) + " <TAB> " + translations[0].nbest_translations[3]
    t5 = str(translations[0].nbest_scores[4][0]) + " <TAB> " + translations[0].nbest_translations[4]

    ot_trans = t1 + " <SEP> " + t2 + " <SEP> " + t3 + " <SEP> " + t4 + " <SEP> " + t5
    
    ## return the translation
    return ot_trans

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

@app.get("/")
def se_translate():
    ##  nothing to return
    return ""

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

# source_seq = "<2sc> this is er@@ y@@ k ~~'s face ."
# ot_trans = se_translate(source_seq)
# print(ot_trans)

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
