#!/usr/bin/python3

import argparse
import bleu

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

score, _, _, _, _ = bleu.compute_bleu([ref_list], cnd_list)

print("%.3f " % (100*score))
