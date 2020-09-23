# Sicilian_Translator / perl-module


#### `use Napizia::Translator;`

This module tokenizes and detokenizes Sicilian and English text.  We use it to prepare parallel text for training and to provide capitalization and contraction subroutines for the translator.


#### `use Napizia::HtmlIndex;`
#### `use Napizia::HtmlDarreri;`

These modules contain HTML subroutines for the website interface to the translator.


#### `use Napizia::Utilities;`

This module contains a set of utilities to perform a quick and dirty lemmatization of Sicilian language text.  These utilities are not used at all in translation.  Instead, we plan to use them to train word embeddings and develop lists of context similar words for our online dictionary, [_Chiù dâ Palora_](https://www.napizia.com/cgi-bin/cchiu-da-palora.pl).

