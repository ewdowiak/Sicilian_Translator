#!/bin/bash

##  bash script to run the "hunalign" sentence alignment tool

##  dictionary of Sicilian to English translations
SCEN="aligner/dieli-scen-dict.txt"

##  run hunalign and output parallel text to CSV files
for i in {27..31}; do
    hunalign $SCEN wrapped/as${i}_sc-wrap.txt wrapped/as${i}_en-wrap.txt -text > aligned/as${i}_ha.csv
done
