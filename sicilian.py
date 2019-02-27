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
from gluonnlp.data.translation import _TranslationDataset, _get_pair_key, _get_home_dir
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
                                  ('sicilian.zip','938bccd3e56ce9298e9054aa895117f993284f76')}
        self._data_file = {_get_pair_key('sc', 'en'):
                               {'train_en': ('train.en','db0dff1d37ce57a87c90082de1a01618766699bd'),
                                'train_sc': ('train.sc','b16bd803a9617ba0cd165003c857a04d65b7b1d3'),
                                'val_en': ('valid.en','82069040a3bb6ea731773f34ceaf241cea6c86a8'),
                                'val_sc': ('valid.sc','7758212703a156f5b67488bb9a9a6312afa044f1'),
                                'test_en': ('test.en','01159cc655c0866654f0c1d7e81cdd7d29c402fe'),
                                'test_sc': ('test.sc','2b97ddd90127b5d4fb1e71b97c84883eb38698f4'),
                                'vocab_en': ('vocab.en.json','e90ecbb70c89714ddae8369ad024c640cbd18898'),
                                'vocab_sc': ('vocab.sc.json','2d8061919074baa90a1ddb3bd070970f880952be')}}
        super(scn, self).__init__('sicilian', segment=segment, src_lang=src_lang,
                                  tgt_lang=tgt_lang, root=root)
