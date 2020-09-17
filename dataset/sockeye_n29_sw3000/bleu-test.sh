#!/bin/bash

echo "translating En->Sc ..."
./bleu-test-01_tns_en-sc.sh

echo "translating Sc->En ..."
./bleu-test-01_tns_sc-en.sh

echo "calculating BLEU scores ..."
printf 'En-Sc bleu:  '
./bleu-test-02_calc_score.py --ref 'test-data/test-data_AS38-AS39_v4-dtk.sc' --cnd 'test-data/test-data_AS38-AS39_v4-tns.sc'
printf 'Sc->En bleu:  '
./bleu-test-02_calc_score.py --ref 'test-data/test-data_AS38-AS39_v4-dtk.en' --cnd 'test-data/test-data_AS38-AS39_v4-tns.en'
