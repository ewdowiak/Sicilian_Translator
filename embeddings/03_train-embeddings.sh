#!/bin/bash

TSV_DATA="dataset/train-mparamu_v3-lemmatized.sc.tsv"
#TSV_DATA="dataset/train-mparamu_v3-lemmatized.en.tsv"

#INPARAMS="logs/previously-saved.params"
BATCH_SIZE="128"
EPOCHS="35"

MODEL="skipgram"
ODEL="cbow"

##  word2vec style training
NGRAM_BUCKETS="0"

##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##

./train_sg_cbow.py --model ${MODEL} \
		   --ngram-buckets ${NGRAM_BUCKETS} \
		   --batch-size ${BATCH_SIZE} \
		   --epochs ${EPOCHS} \
		   --data ${TSV_DATA} #\
#		   --params ${INPARAMS}
