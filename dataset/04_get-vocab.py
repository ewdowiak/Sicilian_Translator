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

import mxnet as mx
import gluonnlp as nlp
import re

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

min_freq=1
indir='scn20191201-sw2000/'

scfile = indir + 'train.sc'
enfile = indir + 'train.en'
scvcbfile = indir + 'vocab.sc.json'
envcbfile = indir + 'vocab.en.json'

def simple_tkn( src_str , tkn_dlm=' ', seq_dlm='\n'):
    splt_str = re.split(tkn_dlm + '|' + seq_dlm, src_str)
    return filter(None, splt_str )


otopen = '{"eos_token": "<eos>", "unknown_token": "<unk>", "bos_token": "<bos>", "padding_token": "<pad>", "idx_to_token": ['
otmddl = '], "token_to_idx": {'
otclos = '}, "reserved_tokens": ["<eos>", "<bos>", "<pad>"]}'

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  retrieve Sicilian text
scstr = ""
with open(scfile,"r") as fh:
    for line in fh:
        scstr = scstr + line 
        
##  get Sicilian vocabulary
sccounter = nlp.data.count_tokens(simple_tkn(scstr))
scvocab = nlp.Vocab(sccounter,
                    unknown_token='<unk>' , padding_token='<pad>',
                    bos_token='<bos>', eos_token='<eos>',
                    min_freq=min_freq, max_size=None)

## counts, if you're curious
# scidx_to_counts = [sccounter[w] for w in scvocab.idx_to_token]

##  open Sicilian output file
scf = open(scvcbfile,'w')

##  print header
scf.write(otopen)

##  print vocab, last word without trailing comma
for i in scvocab.idx_to_token[0:len(scvocab.idx_to_token)-1]:
    word = i
    if (word == '"'):
        word = '\\"'
    if (word == '"@@'):
        word = '\\"@@'
    scf.write('"' + word + '", ',)
for i in scvocab.idx_to_token[len(scvocab.idx_to_token)-1:len(scvocab.idx_to_token)]:
    word = i
    if (word == '"'):
        word = '\\"'
    if (word == '"@@'):
        word = '\\"@@'
    scf.write('"' + word + '"',)

##  print middle
scf.write(otmddl)

##  print vocab and index
for i in scvocab.idx_to_token[0:len(scvocab.idx_to_token)-1]:
    word = i
    if (word == '"'):
        word = '\\"'
    if (word == '"@@'):
        word = '\\"@@'
    scf.write('"' + word + '": '+ str(scvocab.token_to_idx[i]) +', ',)
for i in scvocab.idx_to_token[len(scvocab.idx_to_token)-1:len(scvocab.idx_to_token)]:
    word = i
    if (word == '"'):
        word = '\\"'
    if (word == '"@@'):
        word = '\\"@@'
    scf.write('"' + word + '": '+ str(scvocab.token_to_idx[i]) ,)

##  print footer
scf.write(otclos)

##  close Sicilian output file
scf.close()


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  retrieve English text
enstr = ""
with open(enfile,"r") as fh:
    for line in fh:
        enstr = enstr + line 

##  get English vocabulary
encounter = nlp.data.count_tokens(simple_tkn(enstr))
envocab = nlp.Vocab(encounter,
                    unknown_token='<unk>' , padding_token='<pad>',
                    bos_token='<bos>', eos_token='<eos>',
                    min_freq=min_freq, max_size=None)

## counts, if you're curious
# enidx_to_counts = [encounter[w] for w in envocab.idx_to_token]


##  open English output file
enf = open(envcbfile,'w')

##  print header
enf.write(otopen)

##  print vocab, last word without trailing comma
for i in envocab.idx_to_token[0:len(envocab.idx_to_token)-1]:
    word = i
    if (word == '"'):
        word = '\\"'
    if (word == '"@@'):
        word = '\\"@@'
    enf.write('"' + word + '", ',)
for i in envocab.idx_to_token[len(envocab.idx_to_token)-1:len(envocab.idx_to_token)]:
    word = i
    if (word == '"'):
        word = '\\"'
    if (word == '"@@'):
        word = '\\"@@'
    enf.write('"' + word + '"',)

##  print middle
enf.write(otmddl)

##  print vocab and index
for i in envocab.idx_to_token[0:len(envocab.idx_to_token)-1]:
    word = i
    if (word == '"'):
        word = '\\"'
    if (word == '"@@'):
        word = '\\"@@'
    enf.write('"' + word + '": '+ str(envocab.token_to_idx[i]) +', ',)
for i in envocab.idx_to_token[len(envocab.idx_to_token)-1:len(envocab.idx_to_token)]:
    word = i
    if (word == '"'):
        word = '\\"'
    if (word == '"@@'):
        word = '\\"@@'
    enf.write('"' + word + '": '+ str(envocab.token_to_idx[i]) ,)

##  print footer
enf.write(otclos)

##  close English output file
enf.close()

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
