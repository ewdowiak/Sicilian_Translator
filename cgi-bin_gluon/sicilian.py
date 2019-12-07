# coding: utf-8

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

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  This is a modified version of the "dataset.py" script by MXNet Gluon NLP.
##    *  https://gluon-nlp.mxnet.io/_downloads/machine_translation.zip

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

"""Translation datasets."""


__all__ = ['scn']

import os
from gluonnlp.data.translation import _TranslationDataset, _get_pair_key
#from gluonnlp.data.translation import get_home_dir as _get_home_dir
from gluonnlp.data.translation import _get_home_dir
from gluonnlp.data.registry import register


@register(segment=['train', 'val', 'test', 'vocab'])
class scn(_TranslationDataset):
    """A Translation Dataset for Sicilian.

    Parameters
    ----------
    segment : str or list of str, default 'train'
        Dataset segment. Options are 'train', 'val', 'test' or their combinations.
    src_lang : str, default 'en'
        The source language. Option for source and target languages are 'en' <-> 'sc'
    tgt_lang : str, default 'sc'
        The target language. Option for source and target languages are 'en' <-> 'sc'
    root : str, default '$MXNET_HOME/datasets/sicilian'
        Path to temp folder for storing data.
        MXNET_HOME defaults to '~/.mxnet'.
    """
    def __init__(self, segment='train', src_lang='en', tgt_lang='sc',
                 root=os.path.join(_get_home_dir(), 'datasets', 'scn20191201-sw2000')):
        self._supported_segments = ['train', 'val', 'test','vocab']
        self._archive_file = {_get_pair_key('sc', 'en'):
                                  ('scn20191201-sw2000.zip','3a81126d985d38a22d0367a81fc7d71d30bb4fd8')}
        self._data_file = {_get_pair_key('sc', 'en'):
                               {'train_en': ('train.en','1b38eb5f6e721e8fb9b1f7c50131f6c23026e590'),
                                'train_sc': ('train.sc','94c0b28e522a66e7ff273d3603ca4499b3bb55d8'),
                                'val_en': ('valid.en','6ca090e4c583b5e48db41e40b0339a9763322e67'),
                                'val_sc': ('valid.sc','bd55ca5950b505feeaceea568ccf64609666898a'),
                                'test_en': ('test.en','c77d8c515b21804c3add32275a1633a65096aaf3'),
                                'test_sc': ('test.sc','aba76d2a124fd251dfb484be50b09bd53f9efee2'),
                                'vocab_en': ('vocab.en.json','c4f27c601705fc9b2f1c55ab6b40b303724a6740'),
                                'vocab_sc': ('vocab.sc.json','5dc5d4c7d1dec2b1c44cec23ed460015e0fbb636')}}
        super(scn, self).__init__('sicilian', segment=segment, src_lang=src_lang,
                                  tgt_lang=tgt_lang, root=root)

##
##  sha1sum
##
##  3a81126d985d38a22d0367a81fc7d71d30bb4fd8  scn20191201-sw2000.zip
##  1b38eb5f6e721e8fb9b1f7c50131f6c23026e590  train.en
##  94c0b28e522a66e7ff273d3603ca4499b3bb55d8  train.sc
##  6ca090e4c583b5e48db41e40b0339a9763322e67  valid.en
##  bd55ca5950b505feeaceea568ccf64609666898a  valid.sc
##  c77d8c515b21804c3add32275a1633a65096aaf3  test.en
##  aba76d2a124fd251dfb484be50b09bd53f9efee2  test.sc
##  c4f27c601705fc9b2f1c55ab6b40b303724a6740  vocab.en.json
##  5dc5d4c7d1dec2b1c44cec23ed460015e0fbb636  vocab.sc.json
##
