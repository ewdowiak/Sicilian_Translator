#!/usr/bin/python3

##  Copyright 2019 Eryk Wdowiak
##
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##
##      http://www.apache.org/licenses/LICENSE-2.0
##
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  NOTE:  Parts of this script draw on the "Machine Translation with
##         Transformer" tutorial by MXNet Gluon NLP.
##  https://gluon-nlp.mxnet.io/examples/machine_translation/transformer.html

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

import warnings

import argparse
import time
import os
import io
import logging
import numpy as np
import mxnet as mx
from mxnet import gluon
import gluonnlp as nlp

import nmt
import sicilian

##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  parameters of trained model
paramfile = 'eryk-03e05_en-sc.params'

##  hyperparameters
ctx = mx.cpu()

##  parameters for dataset
dataset = 'Sicilian'
src_lang, tgt_lang = 'en', 'sc'
src_max_len, tgt_max_len = -1, -1

##  parameters for model
num_hidden = 256
num_layers = 2
num_bi_layers = 1
dropout = 0.30
embed_dropout = 0.50
att_dropout = 0.20

##  parameters for testing
beam_size = 5
lp_alpha = 1.0
lp_k = 5


##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  load the data
data_train = sicilian.scn('train', src_lang = src_lang, tgt_lang = tgt_lang)
data_val = sicilian.scn('val', src_lang = src_lang, tgt_lang = tgt_lang)
data_test = sicilian.scn('test', src_lang = src_lang, tgt_lang = tgt_lang)
data_vocab = sicilian.scn('vocab', src_lang = src_lang, tgt_lang = tgt_lang)

##  get source and target vocabularies
src_vocab, tgt_vocab = data_vocab.src_vocab, data_vocab.tgt_vocab

##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  load GNMT model
encoder, decoder = nmt.gnmt.get_gnmt_encoder_decoder(hidden_size=num_hidden,
                                                     dropout=dropout, att_dropout=att_dropout,
                                                     num_layers=num_layers,
                                                     num_bi_layers=num_bi_layers)
model = nlp.model.translation.NMTModel(src_vocab=src_vocab, tgt_vocab=tgt_vocab, encoder=encoder, embed_dropout=embed_dropout,
                                       decoder=decoder, embed_size=num_hidden, prefix='gnmt_')
##  load the parameters
model.load_parameters(paramfile)


##  search translator
translator = nmt.translation.BeamSearchTranslator(model=model, beam_size=beam_size,
                                                  scorer=nlp.model.BeamSearchScorer(alpha=lp_alpha,
                                                                                    K=lp_k),
                                                  max_length=tgt_max_len + 100)
##  detokenizer
detokenizer = nlp.data.SacreMosesDetokenizer()


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  retrieve the top five translations
def top_trans( src_seq , nu_trans = beam_size ):

    src_sentence = src_vocab[src_seq.split()]
    src_sentence.append(src_vocab[src_vocab.eos_token])
    src_npy = np.array(src_sentence, dtype=np.int32)
    src_nd = mx.nd.array(src_npy)
    src_nd = src_nd.reshape((1, -1)).as_in_context(ctx)
    src_valid_length = mx.nd.array([src_nd.shape[1]]).as_in_context(ctx)
    samples, _, sample_valid_length = translator.translate(src_seq=src_nd, src_valid_length=src_valid_length)
    
    translation_out = []
    for t in range(0,nu_trans):
        score_sample = samples[:, t, :].asnumpy()
        svl = sample_valid_length[:, t].asnumpy()
        
        for i in range(score_sample.shape[0]):
            translation_out.append(
                [tgt_vocab.idx_to_token[ele] for ele in
                 score_sample[i][1:(svl[i] - 1)]])
    
    real_translation_out = [None for _ in range(len(translation_out))]
    for ind, sentence in enumerate(translation_out):
        real_translation_out[ind] = detokenizer(nmt.bleu._bpe_to_words(sentence),
                                                return_str=True)
    
    #print('')
    print(src_seq)
    #print('')
    for t in range(0,nu_trans):
        print(real_translation_out[t])
    print('')

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  print some translations
top_trans('the neapolitan and the sicilian', nu_trans=1)
top_trans('the large hat p@@ ays for all .', nu_trans=1)
top_trans('car@@ in@@ isi are dogs !', nu_trans=1)
top_trans('it was the sc@@ iss@@ ors !', nu_trans=1)
top_trans('he who ser@@ ves god , fe@@ ars nothing .', nu_trans=1)
