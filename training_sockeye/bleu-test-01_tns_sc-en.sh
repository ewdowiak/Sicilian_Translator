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
MDL_SCEN="/home/soul/sockeye_n20_sw2000/tnf_scen_r01"

INPUT_SC="/home/soul/sockeye_n20_sw2000/test-data/test-data_AS38-AS39_v2-sbw.sc"
OTPUT_EN="/home/soul/sockeye_n20_sw2000/test-data/test-data_AS38-AS39_v4-tns.en"

${SETRANS} --models ${MDL_SCEN} --input ${INPUT_SC} --output ${OTPUT_EN} --use-cpu 2> /dev/null
/bin/sed -i -r 's/(@@ )|(@@ ?$)//g' ${OTPUT_EN}
