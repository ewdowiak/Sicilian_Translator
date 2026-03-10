# Sicilian Translator / perl-module


#### [`use Napizia::Translator;`](Napizia/Translator.pm)

This module tokenizes and detokenizes Sicilian and English text.  We use it to prepare parallel text for training and to provide capitalization and contraction subroutines for the translator.


#### [`use Napizia::HtmlIndex;`](Napizia/HtmlIndex.pm)
#### [`use Napizia::HtmlDarreri;`](Napizia/HtmlDarreri.pm)

These modules contain HTML subroutines for the website interface to the translator.


#### [`use Napizia::English.pm;`](Napizia/English.pm)
#### [`use Napizia::Italian.pm;`](Napizia/Italian.pm)
#### [`use Napizia::SicilianLS2.pm;`](Napizia/SicilianLS2.pm)

These modules contain language-specific tokenizers, detokenizers and capitalizers.

The name _SicilianLS2_ is a reference to Prof. Cipolla's [_Learn Sicilian Two_](https://arbasicula.org/books/#!/Learn-Sicilian-II/p/425419257), the first grammar written entirely in Sicilian.  

An important feature of _Learn Sicilian Two_ is its study of how Sicilian words are formed.  Learning how to use prefixes, suffixes and recognizing how English word endings correspond with Sicilian endings helps students to add hundreds of words to their vocabulary.  They can apply these rules to understand words that they have never seen before. 

To help our translation model learn to form words, we incorporated Prof. Cipolla's ideas into our training strategy because a translation model learns like a human learns.  (We incorporated his ideas into our _training strategy_, not just this Perl module).

Humans (and translation models) who wish to learn Sicilian should also study his first book, [_Learn Sicilian_](https://arbasicula.org/books/#!/26-Learn-Sicilian-Mparamu-lu-sicilianu-by-Gaetano-Cipolla/p/82865121), which was the first comprehensive, interactive grammar of Sicilian.
