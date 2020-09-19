#!/bin/bash

##  bash script to run the "hunalign" sentence alignment tool

SCEN="../../../../aligner/mk_dict/dieli-scen-dict.txt"

for i in {27..31} 39b ; do
    hunalign $SCEN wrapped/as${i}_sc-wrap.txt wrapped/as${i}_en-wrap.txt -text > aligned/as${i}_ha.csv
done
