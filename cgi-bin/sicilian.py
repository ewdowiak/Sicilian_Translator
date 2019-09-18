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
from gluonnlp.data.translation import get_home_dir as _get_home_dir
from gluonnlp.data.registry import register


@register(segment=['train', 'val', 'test', 'vocab'])
class scn(_TranslationDataset):
    """A Small Translation Dataset for Sicilian.

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
                 root=os.path.join(_get_home_dir(), 'datasets', 'sicilian')):
        self._supported_segments = ['train', 'val', 'test','vocab']
        self._archive_file = {_get_pair_key('sc', 'en'):
                                  ('sicilian.zip','f70b94995435e6021eec0e93dd571a6bfdf2af22')}
        self._data_file = {_get_pair_key('sc', 'en'):
                               {'train_en': ('train.en','e13c0f11168033b28dee07d821594f36363771bf'),
                                'train_sc': ('train.sc','872ecd39c8c933e651478c6d446d7a9eaf885c0a'),
                                'val_en': ('valid.en','7667cfc77987bdb4eba4a16f619952e6279f1bc1'),
                                'val_sc': ('valid.sc','666f1fac434a2447fb9c1fd9c811f315027b033f'),
                                'test_en': ('test.en','158cf3104fbc50c36ffdd290cd0bfaaa51315729'),
                                'test_sc': ('test.sc','11626c1b7c3004516a8f29bddaba43fba22b62e4'),
                                'vocab_en': ('vocab.en.json','b87b24ecf52dca62dfa6b8afbfd71e4e3e34b31c'),
                                'vocab_sc': ('vocab.sc.json','18344525cfebb06c42a25d890baa43b31ec7c5d0')}}
        super(scn, self).__init__('sicilian', segment=segment, src_lang=src_lang,
                                  tgt_lang=tgt_lang, root=root)

## 
##  sha1sum
##  
##  f70b94995435e6021eec0e93dd571a6bfdf2af22  sicilian.zip
##  158cf3104fbc50c36ffdd290cd0bfaaa51315729  test.en
##  11626c1b7c3004516a8f29bddaba43fba22b62e4  test.sc
##  e13c0f11168033b28dee07d821594f36363771bf  train.en
##  872ecd39c8c933e651478c6d446d7a9eaf885c0a  train.sc
##  7667cfc77987bdb4eba4a16f619952e6279f1bc1  valid.en
##  666f1fac434a2447fb9c1fd9c811f315027b033f  valid.sc
##  b87b24ecf52dca62dfa6b8afbfd71e4e3e34b31c  vocab.en.json
##  18344525cfebb06c42a25d890baa43b31ec7c5d0  vocab.sc.json
## 
