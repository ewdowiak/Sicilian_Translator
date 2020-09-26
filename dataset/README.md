# Sicilian Translator / dataset

After collecting parallel text into CSV files, we edit it.  This, of course, ensures that the translations are precise, but another important purpose of the editing is to ensure that the Sicilian language text is "Standard Sicilian" -- i.e. it follows the conventions proposed in Cipolla's [_Mparamu_](http://www.arbasicula.org/LegasOnlineStore.html#!/26-Learn-Sicilian-Mparamu-lu-sicilianu-by-Gaetano-Cipolla/p/82865121/category=0), Bonner's [_Introduction_](http://www.arbasicula.org/LegasOnlineStore.html#!/28-An-Introduction-to-Sicilian-Grammar-by-J-K-Kirk-Bonner-Edited-by-Gaetano-Cipolla/p/82865123/category=0) or [Sicilian Wikipedia](https://scn.wikipedia.org/wiki/Wikipedia:Cumpenniu_Stil%C3%ACsticu).

Because the goal is consistency, [`00_standardization.md`](00_standardization.md) keeps a list of replacements made while assembling the parallel text.  And for reference, [`00_contractions.md`](00_contractions.md) provides a list of standard contracted forms.

After concatenating the files with `01_concat-files.sh`, the `02_tokenizer.pl` tokenization script further converts the text to ASCII both to reduce the vocabulary and because writers frequently omit accents.  And in a final effort to keep the Sicilian language consistent, the tokenization script uncontracts spoken forms to their literary equivalents.  For later reference, `92_get-vocab.py` creates a tilde-delimited file of the vocabulary and word frequencies.

The final step before training is [subword splitting](https://www.doviak.net/pages/ml-sicilian/ml-scn_p04.shtml), which replaces the fixed vocabulary with a vocabulary of "subword" units.  Here, we use a small vocabulary (3000 subwords) because we have a small dataset.

Here, `03a_splitter_learn-apply.sh` learns the subword vocabulary and then applies it to the data, but usually we wish to further train an existing model so `03b_splitter_apply-only.sh` just applies a previous subword vocabulary.

One innovation that greatly increased our BLEU scores was to bias the learned subword vocabulary towards the desinences one finds in a textbook.  Specifically, we added a unique list of words from the [_Dieli Dictionary_](https://www.napizia.com/cgi-bin/sicilian.pl) and the inflections of verbs, nouns and adjectives from [_Chiù dâ Palora_](https://www.napizia.com/cgi-bin/cchiu-da-palora.pl) to the Sicilian data.

Because each word was only added once, none of them affected the distribution of whole words.  But once the words were split, they greatly affected the distribution of subwords, filling it with stems and suffixes.  So the subword vocabulary that the machine learns is similar to the theoretical stems and desinences of a textbook.

Having split the tokens into subword units, our next step is to train a pair of translation models in the `sockeye_n30_sw3000` directory.
