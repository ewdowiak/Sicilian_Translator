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

SETRANS="/home/soul/.local/bin/sockeye-translate"
MODEL="/home/soul/sockeye_n20_sw2000/tnf_ensc_r01"

SRC=('the neapolitan and the sicilian'
     'the large hat p@@ ays for all .'
     'car@@ in@@ isi are dogs !'
     'it was the sc@@ iss@@ ors !'
     'he who ser@@ ves god , fe@@ ars nothing .')

/bin/echo
for (( i = 0 ; i < ${#SRC[@]} ; i++ )) ; do
	/bin/echo ${SRC[$i]} | sed -r 's/(@@ )|(@@ ?$)//g'
	/bin/echo ${SRC[$i]} | $SETRANS --models $MODEL --use-cpu 2> /dev/null | sed -r 's/(@@ )|(@@ ?$)//g'
	/bin/echo
done
