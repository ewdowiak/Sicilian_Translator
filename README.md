# Sicilian Translator

This repository contains the scripts that we're using to develop the neural machine translator at [_Napizia_](https://translate.napizia.com/).  We use [Sockeye](https://awslabs.github.io/sockeye/) to implement [Vaswani et al's (2017)](https://arxiv.org/abs/1706.03762) Transformer model with [Sennrich et al's subword-nmt](https://github.com/rsennrich/subword-nmt).

Following the best practices of [Sennrich and Zhang (2019)](https://arxiv.org/abs/1905.11901), the networks are small and have fewer layers and the models were trained with small batch sizes and larger dropout parameters.

The dataset of parallel text that we are assembling draws from issues of [_Arba Sicula_](http://www.arbasicula.org/) and from [Arthur Dieli](http://www.dieli.net/)'s translations of Giuseppe Pitrè's [_Folk Tales_](https://scn.wikipedia.org/wiki/F%C3%A0uli,_nueddi_e_cunti_pupulari_siciliani) and of Sicilian poetry and proverbs.  Thank you to [Prof. Dieli](http://www.dieli.net/) and [Prof. Gaetano Cipolla](http://www.arbasicula.org/) for contributing their translations to this project and for their good advice and encouragement.

For more information, see my notes on [neural machine translation](https://www.doviak.net/pages/ml-sicilian/ml-scn_p03.shtml), [subword splitting](https://www.doviak.net/pages/ml-sicilian/ml-scn_p04.shtml) and [low-resource NMT](https://www.doviak.net/pages/ml-sicilian/ml-scn_p05.shtml).  And check out the translator at [_Napizia_](https://translate.napizia.com/).
