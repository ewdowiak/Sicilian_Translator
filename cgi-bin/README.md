# Sicilian_Translator / cgi-bin

Having trained a pair of translation models, we want to share them.  The `index.pl` script creates our interactive translation webpage, [_Tradutturi Sicilianu_](https://translate.napizia.com/cgi-bin/index.pl).  It's a simple page, but also includes a feature that toggles between the literary and spoken forms.

The `darreri.pl` script provides a [_Behind the Curtain_](https://translate.napizia.com/cgi-bin/darreri.pl) look at the tokenization of the input sentence and its subword splitting.  And it returns the Top 5 translations, displaying them in detokenized form along with the translation score.
