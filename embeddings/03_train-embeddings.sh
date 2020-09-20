#!/bin/bash

#TSV_DATA="dataset/train-mparamu_v3-lemmatized.sc.tsv"
TSV_DATA="dataset/train-mparamu_v3-lemmatized.en.tsv"

INPARAMS="logs/en-cbow-r3-e24.params"
BATCH_SIZE="128"
EPOCHS="25"

#MODEL="skipgram"
MODEL="cbow"

##  word2vec style training
NGRAM_BUCKETS="0"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

./train_sg_cbow.py --model ${MODEL} \
		   --ngram-buckets ${NGRAM_BUCKETS} \
		   --batch-size ${BATCH_SIZE} \
		   --epochs ${EPOCHS} \
		   --data ${TSV_DATA} \
		   --params ${INPARAMS}
