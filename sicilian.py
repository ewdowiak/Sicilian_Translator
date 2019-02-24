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
                                  ('sicilian.zip','add0ca221678b034dab4ca73fde31d3cd9624a44')}
        self._data_file = {_get_pair_key('sc', 'en'):
                               {'train_en': ('train.en','8c8ff696339b43562b9cea65539b4e7ea83dc988'),
                                'train_sc': ('train.sc','8eae9a783f6f20654a96d6281a7458af1539ab6c'),
                                'val_en': ('valid.en','5ec0559d89b8256e1925fb928adef4b3f8b3b507'),
                                'val_sc': ('valid.sc','a9a4bb7024e890f9e5077e5cbd80060546577179'),
                                'test_en': ('test.en','2301644ff25b60a1699e79297fb19f5e80451341'),
                                'test_sc': ('test.sc','7d18757122d83cceff035ba04deb8edcf89075c4'),
                                'vocab_en': ('vocab.en.json','5a3ec646f27fa3751264351fc35a695bca2c7b65'),
                                'vocab_sc': ('vocab.sc.json','7de434c11bdfc537642a65d66ca228e0b61e45c1')}}
        super(scn, self).__init__('sicilian', segment=segment, src_lang=src_lang,
                                  tgt_lang=tgt_lang, root=root)

