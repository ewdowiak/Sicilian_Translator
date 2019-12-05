#!/bin/bash

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

echo "subword splitting..."
./bleu-test-01_sbw-split.sh

echo "translating En->Sc..."
./bleu-test-02_tns_en-sc.py

echo "translating Sc->En..."
./bleu-test-02_tns_sc-en.py

echo "tokenizing..."
./bleu-test-03_tokenize.pl

echo "calculating BLEU scores..."
./bleu-test-04_calc_en-sc.py
./bleu-test-04_calc_sc-en.py
