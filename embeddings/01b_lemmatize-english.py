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

##  script to:  tokenize, remove stopwords and lemmatize

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

import pandas as pd
import string
import nltk
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from nltk.corpus import wordnet as wn
from nltk.stem.wordnet import WordNetLemmatizer

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  input and output files
infile = '../dataset/sockeye_n30_sw3000/parallels-raw/train-mparamu_v1-tkn.en'
otfile = 'dataset/train-mparamu_v2-lemmatized.en'

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

# list of stop words to remove
stopwords_list = stopwords.words('english')
stopwords_list += list(string.punctuation)
stopwords_list += ['``','~~',"'s"]

##  function to process each line
def process_line(text):

    ##  get the lemmatizer
    wnl = WordNetLemmatizer()

    ##  holder for list of lemmas
    lemmas = []

    ##  replace "n't" with "not"
    text = text.replace("n't",'not')

    ##  get word and part of speech tags
    tokens = word_tokenize(text)
    tagged_words = nltk.pos_tag(tokens)

    ##  lemmatize based on part of speech
    for word,tag in tagged_words:
        
        if tag.startswith('J'):
            lemma = wnl.lemmatize(word,'a')  ## adjective
            
        elif tag.startswith('V'):
            lemma = wnl.lemmatize(word,'v')  ## verb
            
        elif tag.startswith('N'):
            lemma = wnl.lemmatize(word,'n')  ## noun

        elif tag.startswith('R'):
            lemma = wnl.lemmatize(word,'r')  ## adverb

        else:
            lemma = wnl.lemmatize(word)  ## other

        ##  append lowercase if not in stopwords list
        if lemma.lower() not in stopwords_list:
            lemmas.append( lemma.lower() )

    ##  join them together and return
    ot_string = ' '.join(lemmas)
    return ot_string


##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

##  open files
otopen = open(otfile, "w")
inopen = open(infile, "r")

##  process each line
for line in inopen:
    otline = process_line(line) + "\n"
    otopen.write(otline)
    
##  close files
inopen.close()
otopen.close()

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
