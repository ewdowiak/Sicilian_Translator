# Sicilian Translator

With 14,494 translated sentence pairs containing 196,911 Sicilian words and 202,652 English words, our [_Tradutturi Sicilianu_](https://translate.napizia.com/) achieved a BLEU score of 22.5 on English-to-Sicilian translation and 25.2 on Sicilian-to-English.

This repository documents our work and provides the recipes needed to reproduce it.  We also hope our work will enable others to perform natural language processing tasks with Sicilian language data.

##  What is the Sicilian language?

It's the language spoken by the people of Sicily, Calabria and Puglia.  It's the language that they speak at home, with family and friends.  It's the language that the Sicilian School of Poets recited at the imperial court of Frederick II in the 13th century.  And it's a language spoken here in Brooklyn.

###  How is Sicilian different from Italian?

Comparing Sicilian to Italian is like comparing Australian rules football to American football.  They have different sets of rules.  Both football codes trace their origins to 19th-century games played at English public schools, but they have different sets of rules.

Both Sicilian and Italian trace their origins to the Latin language of Ancient Rome, but they have different sets of rules.  Like French, Spanish, Catalan, Portuguese, Romanian and Neapolitan, they're Romance languages.  Most of their vocabularies and grammars come from Latin, but they evolved separately, so they each have their own set of rules.

###  Can you help me learn Sicilian?

Yes.  That's our goal.  We hope that the [_Dieli Dictionary_](https://www.napizia.com/cgi-bin/sicilian.pl) will help you learn vocabulary, that [_Chiù dâ Palora_](https://www.napizia.com/cgi-bin/cchiu-da-palora.pl) will help you learn grammar and that [_Tradutturi Sicilianu_](https://translate.napizia.com/) will help you write in Sicilian.

One of the best sources of information and learning materials is [_Arba Sicula_](http://www.arbasicula.org/).  For over 40 years, they have been publishing books and journals about Sicilian history, language, literature, art, folklore and cuisine. And the _Mparamu lu sicilianu_ textbook by its editor, [Gaetano Cipolla](https://en.wikipedia.org/wiki/Gaetano_Cipolla), is more than just a grammar book.  It's a complete introduction to Sicily, its language, culture and people.


##  What's in this repository?

This repository documents the individual steps and provides the code necessary to reproduce them.  Separately, the "[With Patience and Dedication](https://www.doviak.net/pages/ml-sicilian/index.shtml)" introduction provides a broader overview.  And the ["Just Split, Dropout and Pay Attention"](https://www.doviak.net/pages/ml-sicilian/ml-scn_p05.shtml) article explains why the method works.

Here in this repository, the `extract-text` directory contains the scripts that we used to collect parallel text from issues of _Arba Sicula_ (which are in PDF format).  The `dataset` directory contains the scripts that we used to prepare the data for training, while its subdirectory `sockeye_n30_sw3000` contains the scripts that we'll use to train the models.

The `perl-module/Napizia` directory provides a Perl module with tokenization and detokenization subroutines.  The `cgi-bin` directory contains scripts to put the translator on a website.

And the `embeddings` directory contains some experimental work, where we lemmatize the text of both languages and train word embedding models.  By computing the matrix of cosine similarity from the embeddings, we can create lists of context similar words and include them in our dictionary one day.


##  Data Sources

Our largest source of parallel text are issues of the literary journal [_Arba Sicula_](http://www.arbasicula.org/), so this repository includes scripts that extract the parallel text from the PDF files.  We mixed that data with [Arthur Dieli](http://www.dieli.net/)'s translations of poetry, proverbs and Giuseppe Pitrè's [_Folk Tales_](https://scn.wikipedia.org/wiki/F%C3%A0uli,_nueddi_e_cunti_pupulari_siciliani).  And to "learn" Sicilian, we also collected parallel text from the _Mparamu lu sicilianu_ textbook by [Gaetano Cipolla](https://en.wikipedia.org/wiki/Gaetano_Cipolla) (2013) and from Kirk Bonner's _Introduction to Sicilian Grammar_ (2001).


##  Translation Models and Practices

To translate, we use [Sockeye](https://awslabs.github.io/sockeye/)'s implementation of [Vaswani et al's (2017)](https://arxiv.org/abs/1706.03762) Transformer model along with [Sennrich et al's subword-nmt](https://github.com/rsennrich/subword-nmt).  And following the best practices of [Sennrich and Zhang (2019)](https://arxiv.org/abs/1905.11901), the networks are small and have fewer layers and the models were trained with small batch sizes and larger dropout parameters.


##  Where can I find the _Tradutturi Sicilianu_?

At [_Napizia_](https://translate.napizia.com/).  Come visit us there.  And join us in our study of the Sicilian language!
