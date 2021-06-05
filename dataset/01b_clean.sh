#!/bin/bash

##  Copyright 2021 Eryk Wdowiak
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

OTDIR="./se33_multi"

PREPENSC="data-prep-ensc"
PREPSCEN="data-prep-scen"
DATARAW="data-raw"
DATASBW="data-sbw"
DATATKN="data-tkn"
DATAM2M="data-m2m"
SUBWORDS="subwords"
PIECES="data-sbw/pieces"

rm -rf ${OTDIR}/${PREPENSC}
rm -rf ${OTDIR}/${PREPSCEN}
rm -rf ${OTDIR}/${DATARAW}
rm -rf ${OTDIR}/${DATASBW}
rm -rf ${OTDIR}/${DATATKN}
rm -rf ${OTDIR}/${DATAM2M}
#rm -rf ${OTDIR}/${SUBWORDS}
#rm -rf ${OTDIR}/${PIECES}

mkdir ${OTDIR}/${PREPENSC}
mkdir ${OTDIR}/${PREPSCEN}
mkdir ${OTDIR}/${DATARAW}
mkdir ${OTDIR}/${DATASBW}
mkdir ${OTDIR}/${DATATKN}
#mkdir ${OTDIR}/${DATAM2M}
#mkdir ${OTDIR}/${SUBWORDS}
mkdir ${OTDIR}/${PIECES}
