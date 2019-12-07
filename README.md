# Sicilian Translator

This repository contains scripts that I am using to create the neural machine translator at [_Napizia_](https://translate.napizia.com/).

It contains two models.  The first is the classic model with Recurrent Neural Networks as implemented by [MXNet Gluon NLP](https://gluon-nlp.mxnet.io/examples/machine_translation/gnmt.html), which I modified to incorporate dropout into the attention and embedding layers.  The second is the Transformer model as implemented by [Sockeye](https://awslabs.github.io/sockeye/).

Both models use [Sennrich et al's subword-nmt](https://github.com/rsennrich/subword-nmt).  And following the best practices of [Sennrich and Zhang (2019)](https://arxiv.org/abs/1905.11901), the networks are small and have fewer layers and the models were trained with small batch sizes and larger dropout parameters.

The Transformer model yields excellent results.  With only 7721 lines of parallel training data (containing 121,892 English words and 121,136 Sicilian words), the BLEU score on the English-to-Sicilian test was 11.4 and the BLEU score on the Sicilian-to-English test was 12.9.

Using the same training and test data, the classic RNN model only scored 1.5 on the English-to-Sicilian and 2.8 on the Sicilian-to-English.  Those scores are low, but it's a good comparison.  Perhaps more importantly, the simplicity of Gluon's framework makes it a great place to start, especially when you're still assembling data, as we are here.

And this repository also provides scripts to calculate the BLEU score on alternative test sets.  So for example, you can calculate one BLEU score for translations of poetry and another BLEU score for translations of prose.

Finally, the dataset of parallel text that we are assembling draws from issues of [_Arba Sicula_](http://www.arbasicula.org/) and from [Arthur Dieli](http://www.dieli.net/)'s translations of Giuseppe Pitrè's [_Folk Tales_](https://scn.wikipedia.org/wiki/F%C3%A0uli,_nueddi_e_cunti_pupulari_siciliani) and of Sicilian poetry and proverbs.  They gave us a very large amount of data to assemble, so we look forward to putting an even better quality translator online soon.

Thank you to [Prof. Dieli](http://www.dieli.net/) and [Prof. Gaetano Cipolla](http://www.arbasicula.org/) for contributing their translations to this project and for their good advice and encouragement.  Their work made this project possible and their suggestions have been invaluable.  _Grazzi!_

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

For more information, see my notes on [neural machine translation](https://www.doviak.net/pages/ml-sicilian/ml-scn_p03.shtml) and [subword splitting](https://www.doviak.net/pages/ml-sicilian/ml-scn_p04.shtml).  And check out the translator at [_Napizia_](https://translate.napizia.com/).
