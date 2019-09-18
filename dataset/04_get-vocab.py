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
scfile = 'sicilian/train.sc'
enfile = 'sicilian/train.en'
scvcbfile = 'sicilian/vocab.sc.json'
envcbfile = 'sicilian/vocab.en.json'


def simple_tkn( src_str , tkn_dlm=' ', seq_dlm='\n'):
    splt_str = re.split(tkn_dlm + '|' + seq_dlm, src_str)
    return filter(None, splt_str )


otopen = '{"eos_token": "<eos>", "unknown_token": "<unk>", "bos_token": "<bos>", "padding_token": "<pad>", "idx_to_token": ['
otmddl = '], "token_to_idx": {'
otclos = '}, "reserved_tokens": ["<eos>", "<bos>", "<pad>"]}'

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  get Sicilian vocabulary
scstr = ""
with open(scfile,"r") as fh:
    for line in fh:
        scstr = scstr + line 
        
sccounter = nlp.data.count_tokens(simple_tkn(scstr))
scvocab = nlp.Vocab(sccounter,
                    unknown_token='<unk>' , padding_token='<pad>',
                    bos_token='<bos>', eos_token='<eos>',
                    min_freq=min_freq, max_size=None)
scidx_to_counts = [sccounter[w] for w in scvocab.idx_to_token]


scf = open(scvcbfile,'w')
scf.write(otopen)
for i in scvocab.idx_to_token:
    word = i
    if (word == '"'):
        word = '\\"'
    scf.write('"' + word + '", ',)
scf.write(otmddl)
for i in scvocab.idx_to_token:
    word = i
    if (word == '"'):
        word = '\\"'
    scf.write('"' + word + '": '+ str(scvocab.token_to_idx[i]) +', ',)
scf.write(otclos)
scf.close()


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  

##  get the English vocabulary
enstr = ""
with open(enfile,"r") as fh:
    for line in fh:
        enstr = enstr + line 
        
encounter = nlp.data.count_tokens(simple_tkn(enstr))
envocab = nlp.Vocab(encounter,
                    unknown_token='<unk>' , padding_token='<pad>',
                    bos_token='<bos>', eos_token='<eos>',
                    min_freq=min_freq, max_size=None)
enidx_to_counts = [encounter[w] for w in envocab.idx_to_token]

enf = open(envcbfile,'w')
enf.write(otopen)
for i in envocab.idx_to_token:
    word = i
    if (word == '"'):
        word = '\\"'
    enf.write('"' + word + '", ',)
enf.write(otmddl)
for i in envocab.idx_to_token:
    word = i
    if (word == '"'):
        word = '\\"'
    enf.write('"' + word + '": '+ str(envocab.token_to_idx[i]) +', ',)
enf.write(otclos)
enf.close()


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
