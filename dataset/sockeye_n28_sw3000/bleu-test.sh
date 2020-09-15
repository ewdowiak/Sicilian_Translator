#!/bin/bash

echo "translating En->Sc ..."
./bleu-test-01_tns_en-sc.sh

echo "translating Sc->En ..."
./bleu-test-01_tns_sc-en.sh

echo "calculating BLEU scores ..."
./bleu-test-02_calc_en-sc.py
./bleu-test-02_calc_sc-en.py
