# Sicilian Translator

This repository uses [MXNet Gluon NLP](https://gluon-nlp.mxnet.io/examples/machine_translation/gnmt.html) and [Sennrich et al's subword-nmt](https://github.com/rsennrich/subword-nmt) to create the neural machine translator at [_Napizia_](https://translate.napizia-translator.com/).

It does not produce good translations yet because the model was only trained on parallel text with 40,000 English words and 37,000 Sicilian words.  With a subword vocabulary of 1500 words, the BLEU scores were 3.47 on the English-to-Sicilian task and 4.78 on the Sicilian-to-English task.  After we assemble more parallel text, the translation quality will improve.

The dataset of parallel text that we are assembling draws from issues of [_Arba Sicula_](http://www.arbasicula.org/) and from [Arthur Dieli](http://www.dieli.net/)'s translations of Giuseppe Pitrè's [_Folk Tales_](https://scn.wikipedia.org/wiki/F%C3%A0uli,_nueddi_e_cunti_pupulari_siciliani) and Sicilian proverbs.  They gave us a very large amount of data to assemble, so we look forward to putting a better quality translator online soon.

Thank you to [Prof. Dieli](http://www.dieli.net/) and [Prof. Gaetano Cipolla](http://www.arbasicula.org/) for contributing their translations to this project and for their good advice and encouragement.  Their work made this project possible and their suggestions have been invaluable.  _Grazzi!_

Even though the translation quality leaves a lot to be desired, the trained model gets a few things right.  Below are a few examples:

```
>>> top_trans('the neapolitan and the sicilian', nu_trans=1)
the neapolitan and the sicilian
lu napulitanu e lu sicilianu

>>> top_trans('the large hat pays for all .', nu_trans=1)
the large hat pays for all .
cappiddazzu paga tuttu.

>>> top_trans('car@@ in@@ isi are dogs !', nu_trans=1)
car@@ in@@ isi are dogs !
cani carinisi!

>>> top_trans('it was the scissors !', nu_trans=1)
it was the scissors !
forfici foru!
```

For more information, see my notes on [neural machine translation](https://www.doviak.net/pages/ml-sicilian/ml-scn_p03.shtml) and [subword splitting](https://www.doviak.net/pages/ml-sicilian/ml-scn_p04.shtml).  And check out the translator at [_Napizia_](https://translate.napizia-translator.com/).
