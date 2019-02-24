# Sicilian Translator

This repository uses [MXNet Gluon NLP](https://gluon-nlp.mxnet.io/examples/machine_translation/gnmt.html) to create a machine translator for the Sicilian language.

We are still assembling a dataset for the project.  In the meantime, we trained a simple model on some of [Arthur Dieli](http://www.dieli.net/)'s translations of Giuseppe Pitrè's (1875) [_Sicilian Folk Tales_](https://scn.wikipedia.org/wiki/F%C3%A0uli,_nueddi_e_cunti_pupulari_siciliani).  The dataset was not large, so the resulting translator is not very useful, but it works (a little):

```
>>> top_trans('Once upon a time , there was a peasant who had a goat .')
Once upon a time , there was a peasant who had a goat .

Cc'era'na vota un viddanu chi navicavanu.
'Na vota cc'eranu'na vota un viddanu chi navicavanu.
Cc'era'na vota un viddanu chi avia'na vota un Napulitanu.
Cc'era'na vota un viddanu chi avia'na pocu'n testa.
Cc'era'na vota un viddanu chi avia'na vota un genti.
```

For more information, please visit [Napizia](https://www.napizia.com/pages/ml-sicilian/ml-scn_p03.shtml).  We look forward to seeing you there!
