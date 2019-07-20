# Sicilian Translator

This repository uses [MXNet Gluon NLP](https://gluon-nlp.mxnet.io/examples/machine_translation/gnmt.html) to create a machine translator for the Sicilian language.

We are still assembling a dataset for the project.  In the meantime, we trained a simple model on [Prof. Arthur Dieli](http://www.dieli.net/)'s translations of Giuseppe Pitrè's (1875) [_Sicilian Folk Tales_](https://scn.wikipedia.org/wiki/F%C3%A0uli,_nueddi_e_cunti_pupulari_siciliani).  The dataset was not large, so we had to overfit the model and the resulting translator is only useful for this demonstration, but it works!

```
>>> top_trans('The Neapolitan and the Sicilian', nu_trans=1)
The Neapolitan and the Sicilian
Lu Napulitanu e lu Sicilianu

>>> top_trans('The big hat pays for all', nu_trans=1)
The big hat pays for all
Cappiddazzu paga tuttu

>>> top_trans('it was the scissors', nu_trans=1)
it was the scissors
Fòrfici foru!

>>> top_trans('As a tree you never made pears', nu_trans=1)
As a tree you never made pears
Piru mai facisti pira,

>>> top_trans('Carinisi are dogs', nu_trans=1)
Carinisi are dogs
Cani Carinisi!
```

Special thanks to [Prof. Dieli](http://www.dieli.net/) for contributing his translations to the project and for his encouragement.  And a big thank you to Prof. Gaetano Cipolla of [Arba Sicula](http://www.arbasicula.org/) for his help and support.  Their work made this project possible and their suggestions have been invaluable.  _Grazzi!_

For more information, please see my notes at [doviak.net](https://www.doviak.net/pages/ml-sicilian/ml-scn_p03.shtml).
