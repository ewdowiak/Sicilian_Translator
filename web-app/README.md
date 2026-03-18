# Sicilian Translator / web-app

Having trained a translation model, we want to share it.  The [`Translate.pm`](lib/Tradutturi/Controller/Translate.pm) module creates our interactive translation webpage, [_Tradutturi Sicilianu_](https://translate.napizia.com/cgi-bin/index.pl).  It's a simple page, but also includes a feature that toggles between the literary and spoken forms.

The [`Darreri.pm`](lib/Tradutturi/Controller/Darreri.pm) module provides a [_Behind the Curtain_](https://translate.napizia.com/cgi-bin/darreri.pl) look at the tokenization of the input sentence and its subword splitting.  And it returns the Top 5 translations, displaying them in detokenized form along with the translation score.

And the [`Api.pm`](lib/Tradutturi/Controller/Api.pm) module provides a [Lingva-compatible API](https://github.com/ewdowiak/napizia-api) for our translation model.
