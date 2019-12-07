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

import argparse
import nmt

import warnings
warnings.filterwarnings('ignore')

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  default files
ref_file = 'test-data/test-data_AS38-AS39_v4-dtk.sc'
cnd_file = 'test-data/test-data_AS38-AS39_v4-tns.sc'

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

def argparser():
    Argparser = argparse.ArgumentParser()
    Argparser.add_argument('--ref', type=str, default = ref_file , help='Reference File')
    Argparser.add_argument('--cnd', type=str, default = cnd_file , help='Candidate File')

    args = Argparser.parse_args()
    return args

args = argparser()

reference = open(args.ref, 'r').readlines()
candidate = open(args.cnd, 'r').readlines()

if len(reference) != len(candidate):
    raise ValueError('The number of sentences in both files do not match.')

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

ref_list = [ 0 for _ in range(len(reference)) ]
cnd_list = [ 0 for _ in range(len(candidate)) ]

for i in range(len(reference)):
    sentence = reference[i].strip().split()
    ref_list[i] = sentence

for i in range(len(candidate)):
    sentence = candidate[i].strip().split()
    cnd_list[i] = sentence

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

score, _, _, _, _ = nmt.bleu.compute_bleu([ref_list], cnd_list)

print("En->Sc bleu:  %.2f " % (100*score))
