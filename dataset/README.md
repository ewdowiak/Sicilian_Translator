# Sicilian Translator / dataset

After collecting parallel text into CSV files, we edit it.  This, of course, ensures that the translations are precise, but another important purpose of the editing is to ensure that the Sicilian language text is "Standard Sicilian" -- i.e. it follows the conventions proposed in Prof. Cipolla's [_Learn Sicilian_](https://arbasicula.org/books/#!/26-Learn-Sicilian-Mparamu-lu-sicilianu-by-Gaetano-Cipolla/p/82865121) and [_Learn Sicilian Two_](https://arbasicula.org/books/#!/Learn-Sicilian-II/p/425419257) and in Dr. Bonner's [_Introduction_](https://arbasicula.org/books/#!/28-An-Introduction-to-Sicilian-Grammar-by-J-K-Kirk-Bonner-Edited-by-Gaetano-Cipolla/p/82865123).

Because the goal is consistency, [`00_standardization.md`](00_standardization.md) keeps a list of replacements made while assembling the parallel text.  And for reference, [`00_contractions.md`](00_contractions.md) provides a list of standard contracted forms.

After concatenating the files with `11c_concat-files.sh`, the `12a_tokenizer.pl` tokenization script further converts the text to ASCII both to reduce the vocabulary and because writers frequently omit accents.  And in a final effort to keep the Sicilian language consistent, the tokenization script uncontracts spoken forms to their literary equivalents.  For later reference, `92_get-vocab.py` creates a tilde-delimited file of the vocabulary and word frequencies.

The final step before training is [subword splitting](https://www.doviak.net/pages/ml-sicilian/ml-scn_p04.shtml), which replaces the fixed vocabulary with a vocabulary of "subword" units.  Here, we use small vocabularies (5000 subwords for Sicilian and Italian, 7500 for English) because we have a small dataset.

`13a_splitter_learn-only.sh` learns the subword vocabulary and `13b_splitter_apply-only.sh` applies the learned subword vocabulary to the data.

One innovation that greatly increased our BLEU scores was to bias the learned subword vocabulary towards the desinences one finds in a textbook.  Specifically, we added a unique list of words from the [_Dieli Dictionary_](https://www.napizia.com/cgi-bin/sicilian.pl) and the inflections of verbs, nouns and adjectives from [_Chiù dâ Palora_](https://www.napizia.com/cgi-bin/cchiu-da-palora.pl) to the Sicilian data.

Because each word was only added once, none of them affected the distribution of whole words.  But once the words were split, they greatly affected the distribution of subwords, filling it with stems and suffixes.  So the subword vocabulary that the machine learns is similar to the theoretical stems and desinences of a textbook.

Within a given dataset, pushing the subword distribution toward textbook desinences increased BLEU scores from 20.3 to 22.4 on English-to-Sicilian translation and from 21.4 to 24.1 on Sicilian-to-English translation.

We obtain that result, of course, in our next step.  Having split the tokens into subword units, our next step is to train a translation model and evaluate the trained model.
