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

##  NOTE:  This script draws heavily from the tutorial by MXNet Gluon NLP
##    *  https://gluon-nlp.mxnet.io/examples/machine_translation/gnmt.html

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  load Gluon and MXNet

import warnings
warnings.filterwarnings('ignore')

import argparse
import time
import random
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

##  hyperparameters

##  previous parameters
#inparams = None
inparams = 'eryk-04_en-sc.params'

##  where to save log and parameters
paramfile = 'eryk-05_en-sc.params'
save_dir = 'gnmt_ensc_r05'

##  parameters for training
batch_size, test_batch_size = 10, 5
num_buckets = 40
epochs = 3
clip = 5
lr = 0.000729
lr_update_factor = 0.9
log_interval = 5

##  parameters for testing
beam_size = 4
lp_alpha = 1.0
lp_k = 5

##  seed and cpu
np.random.seed(100)
random.seed(100)
mx.random.seed(10000)
ctx = mx.cpu()

##  parameters for dataset
dataset = 'Sicilian'
src_lang, tgt_lang = 'en', 'sc'
src_max_len, tgt_max_len = 100, 100

##  parameters for model
num_hidden = 256
num_layers = 2
num_bi_layers = 1
dropout = 0.4

nmt.utils.logging_config(save_dir)

##  ##  ##  ##  ##  ##  ##  ##  ##  ##

## load and preprocess dataset

def cache_dataset(dataset, prefix):
    """Cache the processed npy dataset  the dataset into a npz

    Parameters
    ----------
    dataset : gluon.data.SimpleDataset
    file_path : str
    """
    if not os.path.exists(nmt._constants.CACHE_PATH):
        os.makedirs(nmt._constants.CACHE_PATH)
    src_data = np.concatenate([e[0] for e in dataset])
    tgt_data = np.concatenate([e[1] for e in dataset])
    src_cumlen = np.cumsum([0]+[len(e[0]) for e in dataset])
    tgt_cumlen = np.cumsum([0]+[len(e[1]) for e in dataset])
    np.savez(os.path.join(nmt._constants.CACHE_PATH, prefix + '.npz'),
             src_data=src_data, tgt_data=tgt_data,
             src_cumlen=src_cumlen, tgt_cumlen=tgt_cumlen)


def load_cached_dataset(prefix):
    cached_file_path = os.path.join(nmt._constants.CACHE_PATH, prefix + '.npz')
    if os.path.exists(cached_file_path):
        print('Load cached data from {}'.format(cached_file_path))
        npz_data = np.load(cached_file_path)
        src_data, tgt_data, src_cumlen, tgt_cumlen = [npz_data[n] for n in
                ['src_data', 'tgt_data', 'src_cumlen', 'tgt_cumlen']]
        src_data = np.array([src_data[low:high] for low, high in zip(src_cumlen[:-1], src_cumlen[1:])])
        tgt_data = np.array([tgt_data[low:high] for low, high in zip(tgt_cumlen[:-1], tgt_cumlen[1:])])
        return gluon.data.ArrayDataset(np.array(src_data), np.array(tgt_data))
    else:
        return None


class TrainValDataTransform(object):
    """Transform the machine translation dataset.

    Clip source and the target sentences to the maximum length. For the source sentence, append the
    EOS. For the target sentence, append BOS and EOS.

    Parameters
    ----------
    src_vocab : Vocab
    tgt_vocab : Vocab
    src_max_len : int
    tgt_max_len : int
    """
    def __init__(self, src_vocab, tgt_vocab, src_max_len, tgt_max_len):
        self._src_vocab = src_vocab
        self._tgt_vocab = tgt_vocab
        self._src_max_len = src_max_len
        self._tgt_max_len = tgt_max_len

    def __call__(self, src, tgt):
        if self._src_max_len > 0:
            src_sentence = self._src_vocab[src.split()[:self._src_max_len]]
        else:
            src_sentence = self._src_vocab[src.split()]
        if self._tgt_max_len > 0:
            tgt_sentence = self._tgt_vocab[tgt.split()[:self._tgt_max_len]]
        else:
            tgt_sentence = self._tgt_vocab[tgt.split()]
        src_sentence.append(self._src_vocab[self._src_vocab.eos_token])
        tgt_sentence.insert(0, self._tgt_vocab[self._tgt_vocab.bos_token])
        tgt_sentence.append(self._tgt_vocab[self._tgt_vocab.eos_token])
        src_npy = np.array(src_sentence, dtype=np.int32)
        tgt_npy = np.array(tgt_sentence, dtype=np.int32)
        return src_npy, tgt_npy


def process_dataset(dataset, src_vocab, tgt_vocab, src_max_len=-1, tgt_max_len=-1):
    start = time.time()
    dataset_processed = dataset.transform(TrainValDataTransform(src_vocab, tgt_vocab,
                                                                src_max_len,
                                                                tgt_max_len), lazy=False)
    end = time.time()
    print('Processing time spent: {}'.format(end - start))
    return dataset_processed


def load_translation_data(dataset, src_lang='en', tgt_lang='sc'):
    """Load translation dataset

    Parameters
    ----------
    dataset : str
    src_lang : str, default 'en'
    tgt_lang : str, default 'sc'

    Returns
    -------
    data_train_processed : Dataset
        The preprocessed training sentence pairs
    data_val_processed : Dataset
        The preprocessed validation sentence pairs
    data_test_processed : Dataset
        The preprocessed test sentence pairs
    val_tgt_sentences : list
        The target sentences in the validation set
    test_tgt_sentences : list
        The target sentences in the test set
    src_vocab : Vocab
        Vocabulary of the source language
    tgt_vocab : Vocab
        Vocabulary of the target language
    """

    #common_prefix = 'IWSLT2015_{}_{}_{}_{}'.format(src_lang, tgt_lang,
    #                                               src_max_len, tgt_max_len)
    #data_train = nlp.data.IWSLT2015('train', src_lang=src_lang, tgt_lang=tgt_lang)
    #data_val = nlp.data.IWSLT2015('val', src_lang=src_lang, tgt_lang=tgt_lang)
    #data_test = nlp.data.IWSLT2015('test', src_lang=src_lang, tgt_lang=tgt_lang)

    common_prefix = 'scn_{}_{}_{}_{}'.format(src_lang, tgt_lang, src_max_len, tgt_max_len)
    data_train = sicilian.scn('train', src_lang = src_lang, tgt_lang = tgt_lang)
    data_val = sicilian.scn('val', src_lang = src_lang, tgt_lang = tgt_lang)
    data_test = sicilian.scn('test', src_lang = src_lang, tgt_lang = tgt_lang)
    data_vocab = sicilian.scn('vocab', src_lang = src_lang, tgt_lang = tgt_lang)


    src_vocab, tgt_vocab = data_vocab.src_vocab, data_vocab.tgt_vocab
    data_train_processed = load_cached_dataset(common_prefix + '_train')
    if not data_train_processed:
        data_train_processed = process_dataset(data_train, src_vocab, tgt_vocab,
                                               src_max_len, tgt_max_len)
        cache_dataset(data_train_processed, common_prefix + '_train')
    data_val_processed = load_cached_dataset(common_prefix + '_val')
    if not data_val_processed:
        data_val_processed = process_dataset(data_val, src_vocab, tgt_vocab)
        cache_dataset(data_val_processed, common_prefix + '_val')
    data_test_processed = load_cached_dataset(common_prefix + '_test')
    if not data_test_processed:
        data_test_processed = process_dataset(data_test, src_vocab, tgt_vocab)
        cache_dataset(data_test_processed, common_prefix + '_test')
    fetch_tgt_sentence = lambda src, tgt: tgt.split()
    val_tgt_sentences = list(data_val.transform(fetch_tgt_sentence))
    test_tgt_sentences = list(data_test.transform(fetch_tgt_sentence))
    return data_train_processed, data_val_processed, data_test_processed, val_tgt_sentences, test_tgt_sentences, src_vocab, tgt_vocab


##  get lengths

def get_data_lengths(dataset):
    return list(dataset.transform(lambda srg, tgt: (len(srg), len(tgt))))

data_train, data_val, data_test, val_tgt_sentences, test_tgt_sentences, src_vocab, tgt_vocab = load_translation_data(
    dataset=dataset, src_lang=src_lang, tgt_lang=tgt_lang)
data_train_lengths = get_data_lengths(data_train)
data_val_lengths = get_data_lengths(data_val)
data_test_lengths = get_data_lengths(data_test)

with io.open(os.path.join(save_dir, 'val_gt.txt'), 'w', encoding='utf-8') as of:
    for ele in val_tgt_sentences:
        of.write(' '.join(ele) + '\n')

with io.open(os.path.join(save_dir, 'test_gt.txt'), 'w', encoding='utf-8') as of:
    for ele in test_tgt_sentences:
        of.write(' '.join(ele) + '\n')


data_train = data_train.transform(lambda src, tgt: (src, tgt, len(src), len(tgt)), lazy=False)
data_val = gluon.data.SimpleDataset([(ele[0], ele[1], len(ele[0]), len(ele[1]), i)
                                     for i, ele in enumerate(data_val)])
data_test = gluon.data.SimpleDataset([(ele[0], ele[1], len(ele[0]), len(ele[1]), i)
                                      for i, ele in enumerate(data_test)])


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  create sampler and data loader

train_batchify_fn = nlp.data.batchify.Tuple(nlp.data.batchify.Pad(),
                                            nlp.data.batchify.Pad(),
                                            nlp.data.batchify.Stack(dtype='float32'),
                                            nlp.data.batchify.Stack(dtype='float32'))
test_batchify_fn = nlp.data.batchify.Tuple(nlp.data.batchify.Pad(),
                                           nlp.data.batchify.Pad(),
                                           nlp.data.batchify.Stack(dtype='float32'),
                                           nlp.data.batchify.Stack(dtype='float32'),
                                           nlp.data.batchify.Stack())

##  construct bucket scheme

bucket_scheme = nlp.data.ExpWidthBucket(bucket_len_step=1.2)
train_batch_sampler = nlp.data.FixedBucketSampler(lengths=data_train_lengths,
                                                  batch_size=batch_size,
                                                  num_buckets=num_buckets,
                                                  shuffle=True,
                                                  bucket_scheme=bucket_scheme)
logging.info('Train Batch Sampler:\\n{}'.format(train_batch_sampler.stats()))
val_batch_sampler = nlp.data.FixedBucketSampler(lengths=data_val_lengths,
                                                batch_size=test_batch_size,
                                                num_buckets=num_buckets,
                                                shuffle=False)
logging.info('Valid Batch Sampler:\\n{}'.format(val_batch_sampler.stats()))
test_batch_sampler = nlp.data.FixedBucketSampler(lengths=data_test_lengths,
                                                 batch_size=test_batch_size,
                                                 num_buckets=num_buckets,
                                                 shuffle=False)
logging.info('Test Batch Sampler:\\n{}'.format(test_batch_sampler.stats()))

## create data loader which is iterable

train_data_loader = gluon.data.DataLoader(data_train,
                                          batch_sampler=train_batch_sampler,
                                          batchify_fn=train_batchify_fn,
                                          num_workers=4)
val_data_loader = gluon.data.DataLoader(data_val,
                                        batch_sampler=val_batch_sampler,
                                        batchify_fn=test_batchify_fn,
                                        num_workers=4)
test_data_loader = gluon.data.DataLoader(data_test,
                                         batch_sampler=test_batch_sampler,
                                         batchify_fn=test_batchify_fn,
                                         num_workers=4)

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  build GNMT model

encoder, decoder = nmt.gnmt.get_gnmt_encoder_decoder(hidden_size=num_hidden,
                                                     dropout=dropout,
                                                     num_layers=num_layers,
                                                     num_bi_layers=num_bi_layers)
model = nlp.model.translation.NMTModel(src_vocab=src_vocab, tgt_vocab=tgt_vocab, encoder=encoder,
                                       decoder=decoder, embed_size=num_hidden, prefix='gnmt_')
static_alloc = True

##  initialize or load parameters
if inparams == None:
    model.initialize(init=mx.init.Uniform(0.1), ctx=ctx)
    model.hybridize(static_alloc=static_alloc)
else:
    model.load_parameters(inparams)

##  print model
logging.info(model)


## Due to the paddings, we need to mask out the losses corresponding to padding tokens.
loss_function = nmt.loss.SoftmaxCEMaskedLoss()
loss_function.hybridize(static_alloc=static_alloc)

##  search translator

translator = nmt.translation.BeamSearchTranslator(model=model, beam_size=beam_size,
                                                  scorer=nlp.model.BeamSearchScorer(alpha=lp_alpha,
                                                                                    K=lp_k),
                                                  max_length=tgt_max_len + 100)
logging.info('Use beam_size={}, alpha={}, K={}'.format(beam_size, lp_alpha, lp_k))

##  define evaluation function

def evaluate(data_loader):
    """Evaluate given the data loader

    Parameters
    ----------
    data_loader : gluon.data.DataLoader

    Returns
    -------
    avg_loss : float
        Average loss
    real_translation_out : list of list of str
        The translation output
    """
    translation_out = []
    all_inst_ids = []
    avg_loss_denom = 0
    avg_loss = 0.0
    for _, (src_seq, tgt_seq, src_valid_length, tgt_valid_length, inst_ids) in enumerate(data_loader):
        src_seq = src_seq.as_in_context(ctx)
        tgt_seq = tgt_seq.as_in_context(ctx)
        src_valid_length = src_valid_length.as_in_context(ctx)
        tgt_valid_length = tgt_valid_length.as_in_context(ctx)
        # Calculating Loss
        out, _ = model(src_seq, tgt_seq[:, :-1], src_valid_length, tgt_valid_length - 1)
        loss = loss_function(out, tgt_seq[:, 1:], tgt_valid_length - 1).mean().asscalar()
        all_inst_ids.extend(inst_ids.asnumpy().astype(np.int32).tolist())
        avg_loss += loss * (tgt_seq.shape[1] - 1)
        avg_loss_denom += (tgt_seq.shape[1] - 1)
        # Translate
        samples, _, sample_valid_length = translator.translate(src_seq=src_seq, src_valid_length=src_valid_length)
        max_score_sample = samples[:, 0, :].asnumpy()
        sample_valid_length = sample_valid_length[:, 0].asnumpy()
        for i in range(max_score_sample.shape[0]):
            translation_out.append(
                [tgt_vocab.idx_to_token[ele] for ele in
                 max_score_sample[i][1:(sample_valid_length[i] - 1)]])
    avg_loss = avg_loss / avg_loss_denom
    real_translation_out = [None for _ in range(len(all_inst_ids))]
    for ind, sentence in zip(all_inst_ids, translation_out):
        real_translation_out[ind] = sentence
    return avg_loss, real_translation_out


def write_sentences(sentences, file_path):
    with io.open(file_path, 'w', encoding='utf-8') as of:
        for sent in sentences:
            of.write(' '.join(sent) + '\n')

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  training epochs

trainer = gluon.Trainer(model.collect_params(), 'adam', {'learning_rate': lr})

##  write training loop

best_valid_bleu = 0.0
for epoch_id in range(epochs):
    log_avg_loss = 0
    log_avg_gnorm = 0
    log_wc = 0
    log_start_time = time.time()
    for batch_id, (src_seq, tgt_seq, src_valid_length, tgt_valid_length) in enumerate(train_data_loader):
        # logging.info(src_seq.context) Context suddenly becomes GPU.
        src_seq = src_seq.as_in_context(ctx)
        tgt_seq = tgt_seq.as_in_context(ctx)
        src_valid_length = src_valid_length.as_in_context(ctx)
        tgt_valid_length = tgt_valid_length.as_in_context(ctx)
        with mx.autograd.record():
            out, _ = model(src_seq, tgt_seq[:, :-1], src_valid_length, tgt_valid_length - 1)
            loss = loss_function(out, tgt_seq[:, 1:], tgt_valid_length - 1).mean()
            loss = loss * (tgt_seq.shape[1] - 1) / (tgt_valid_length - 1).mean()
            loss.backward()
        grads = [p.grad(ctx) for p in model.collect_params().values()]
        gnorm = gluon.utils.clip_global_norm(grads, clip)
        trainer.step(1)
        src_wc = src_valid_length.sum().asscalar()
        tgt_wc = (tgt_valid_length - 1).sum().asscalar()
        step_loss = loss.asscalar()
        log_avg_loss += step_loss
        log_avg_gnorm += gnorm
        log_wc += src_wc + tgt_wc
        if (batch_id + 1) % log_interval == 0:
            wps = log_wc / (time.time() - log_start_time)
            logging.info('[Epoch {} Batch {}/{}] loss={:.4f}, ppl={:.4f}, gnorm={:.4f}, '
                         'throughput={:.2f}K wps, wc={:.2f}K'
                         .format(epoch_id, batch_id + 1, len(train_data_loader),
                                 log_avg_loss / log_interval,
                                 np.exp(log_avg_loss / log_interval),
                                 log_avg_gnorm / log_interval,
                                 wps / 1000, log_wc / 1000))
            log_start_time = time.time()
            log_avg_loss = 0
            log_avg_gnorm = 0
            log_wc = 0
    valid_loss, valid_translation_out = evaluate(val_data_loader)
    valid_bleu_score, _, _, _, _ = nmt.bleu.compute_bleu([val_tgt_sentences], valid_translation_out)
    logging.info('[Epoch {}] valid Loss={:.4f}, valid ppl={:.4f}, valid bleu={:.2f}'
                 .format(epoch_id, valid_loss, np.exp(valid_loss), valid_bleu_score * 100))
    test_loss, test_translation_out = evaluate(test_data_loader)
    test_bleu_score, _, _, _, _ = nmt.bleu.compute_bleu([test_tgt_sentences], test_translation_out)
    logging.info('[Epoch {}] test Loss={:.4f}, test ppl={:.4f}, test bleu={:.2f}'
                 .format(epoch_id, test_loss, np.exp(test_loss), test_bleu_score * 100))
    write_sentences(valid_translation_out,
                    os.path.join(save_dir, 'epoch{:d}_valid_out.txt').format(epoch_id))
    write_sentences(test_translation_out,
                    os.path.join(save_dir, 'epoch{:d}_test_out.txt').format(epoch_id))
    if valid_bleu_score > best_valid_bleu:
        best_valid_bleu = valid_bleu_score
        save_path = os.path.join(save_dir, 'valid_best.params')
        logging.info('Save best parameters to {}'.format(save_path))
        model.save_parameters(save_path)
    if epoch_id + 1 >= (epochs * 2) // 3:
        new_lr = trainer.learning_rate * lr_update_factor
        logging.info('Learning rate change to {}'.format(new_lr))
        trainer.set_learning_rate(new_lr)


##  save the parameters
model.save_parameters(paramfile)

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

