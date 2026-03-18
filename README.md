# Sicilian Translator

This repository documents our [_Tradutturi Sicilianu_](https://translate.napizia.com/), the first neural machine translator for the Sicilian language.  It documents our work and the steps to reproduce it.  We hope it opens the door to natural language processing for the Sicilian language.


##  What is the Sicilian language?

It's the language spoken by the people of Sicily, Calabria and Puglia.  It's the language that they speak at home, with family and friends.  It's the language that the Sicilian School of Poets recited at the imperial court of Frederick II in the 13th century.  And it's a language spoken here in Brooklyn, NY.

###  How is Sicilian different from Italian?

Comparing Sicilian to Italian is like comparing American football to Australian rules football. Both football codes trace their origins to 19th-century England, but they evolved separately and have different sets of rules. Analogously, both Sicilian and Italian are Romance languages. Most of their vocabularies and grammars come from Latin, but they evolved separately and have different sets of rules.

But they have (of course) influenced each other.  Sicilian poetry inspired Dante, the "father of the Italian language," to write poetry in his native Florentine.  And this influence on Dante reveals Sicilian's cultural importance:  Sicilian had emerged as a literary language long before Italian.

###  Can you help me learn Sicilian?

Yes.  That's our goal.  We hope that the [_Dieli Dictionary_](https://dizziunariu.napizia.com/dieli/) will help you learn vocabulary, that [_Chiù dâ Palora_](https://dizziunariu.napizia.com/chiu/) will help you learn grammar and that [_Tradutturi Sicilianu_](https://translate.napizia.com/) will help you write in Sicilian.

One of the best sources of information and learning materials is [Arba Sicula](https://arbasicula.org/).  For over 40 years, they have been publishing books and journals about Sicilian history, language, literature, art, folklore and cuisine. And the [_Learn Sicilian_](https://arbasicula.org/books/#!/26-Learn-Sicilian-Mparamu-lu-sicilianu-by-Gaetano-Cipolla/p/82865121) and [_Learn Sicilian Two_](https://arbasicula.org/books/#!/Learn-Sicilian-II/p/425419257) textbooks by its editor, [Gaetano Cipolla](https://en.wikipedia.org/wiki/Gaetano_Cipolla), provide more than a grammar book.  They're a complete introduction to Sicily, its language, culture and people.


##  What's in this repository?

This repository documents the individual steps that we took to create a neural machine translator and provides the code necessary to reproduce them.  Separately, the "[With Patience and Dedication](https://www.doviak.net/pages/ml-sicilian/index.shtml)" introduction provides a broader overview.

Here in this repository, the [extract-text](extract-text/) directory contains the scripts that we used to collect parallel text from issues of [_Arba Sicula_](http://www.arbasicula.org/) (which are in PDF format).  The [dataset](dataset/) directory contains the scripts that we used to prepare the data for training. The  [training](training/) directory contains the scripts that we'll use to train the models.  And the [translations](translations/) directory contains scripts to score our models.

The [perl-module](perl-module/) directory provides a Perl module with tokenization and detokenization subroutines.  The [web-app](web-app/) directory contains a [Mojolicious](https://mojolicious.org/) application to put the translator on a website.  And the [fastapi](fastapi/) directory contains a rewritten version of [Sockeye](https://awslabs.github.io/sockeye/)'s `translate.py`, which we use with [FastAPI](https://fastapi.tiangolo.com/) to load the translations model's parameters and keep them ready for translation.


##  Data Sources

Our largest source of parallel text are issues of the literary journal [_Arba Sicula_](http://www.arbasicula.org/).  We mixed that data with [Arthur Dieli](http://www.dieli.net/)'s translations of poetry, proverbs and Giuseppe Pitrè's [_Folk Tales_](https://scn.wikipedia.org/wiki/F%C3%A0uli,_nueddi_e_cunti_pupulari_siciliani).  And to "learn" Sicilian, we also collected text from Gaetano Cipolla's [_Learn Sicilian_](https://arbasicula.org/books/#!/26-Learn-Sicilian-Mparamu-lu-sicilianu-by-Gaetano-Cipolla/p/82865121) and [_Learn Sicilian Two_](https://arbasicula.org/books/#!/Learn-Sicilian-II/p/425419257) textbooks and from Kirk Bonner's [_Introduction to Sicilian Grammar_](https://arbasicula.org/books/#!/28-An-Introduction-to-Sicilian-Grammar-by-J-K-Kirk-Bonner-Edited-by-Gaetano-Cipolla/p/82865123).

The ["Developing a Parallel Corpus"](https://www.doviak.net/pages/ml-sicilian/ml-scn_p03.shtml) article provides a longer discussion of our data sources and introduces the question of how much parallel text is needed to create a good translator.


##  Translation Models and Practices

To translate, we use [Sockeye](https://awslabs.github.io/sockeye/)'s implementation of [Vaswani et al's (2017)](https://arxiv.org/abs/1706.03762) Transformer model along with [Sennrich et al's subword-nmt](https://github.com/rsennrich/subword-nmt).  And following the best practices of [Sennrich and Zhang (2019)](https://arxiv.org/abs/1905.11901), the networks are small and have fewer layers and the models were trained with small batch sizes and larger dropout parameters.

The ["Just Split, Dropout and Pay Attention"](https://www.doviak.net/pages/ml-sicilian/ml-scn_p05.shtml) article explains why the method works.  In short:  we need a smaller model for our smaller dataset.

To shrink our model, we also use small subword vocabularies. And, as explained in the ["Subword Splitting"](https://www.doviak.net/pages/ml-sicilian/ml-scn_p04.shtml) article, we bias the learned subword vocabulary towards the desinences one finds in a textbook.

The ["Multilingual Translation"](https://www.doviak.net/pages/ml-sicilian/ml-scn_p06.shtml) article explains how we can train a single model to translate between multiple languages, including some for which there is little or no parallel text.

Finally, the ["Reverse Training Strategy"](https://www.doviak.net/pages/ml-sicilian/ml-scn_p07.shtml) article reverses the order in which we _think_ about the training stages.  First, we think about the fine-tuning stage (last stage).  Then, we think backwards through the stages, so that we pre-train a model which will provide a good starting point for the subsequent fine-tuning.


##  Unni si trova stu [_Tradutturi Sicilianu_](https://translate.napizia.com/)_?_

_A_ [_Napizia_](https://www.napizia.com/)_!_  Come visit us there.  Come [_Behind the Curtain_](https://translate.napizia.com/cgi-bin/darreri.pl).  And come join us in our study of the Sicilian language!
