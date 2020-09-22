#  Sicilian_Translator / extract-text

Our largest source of parallel text are issues of the literary journal [_Arba Sicula_](http://www.arbasicula.org/), a bilingual journal of Sicilian history, language, literature, art, folklore and cuisine.

The pages on the left are in Sicilian.  The pages on the right are in English.

It's an excellent source of parallel text, but first we have to extract it from the PDF files.  So in `01_extract-text.pl`, we select a set of pages to extract, separate those pages by odd (English) or even (Sicilian), crop off the headers and footers, write the cropped pages out to two **monolingual** PDF files and convert those two PDF files to text files.

Next, in `02_wrap_text.pl`, we parse the text and (attempt to) identify the component sentences in each file.  In `03_align.sh`, we use the [_hunalign_](https://github.com/danielvarga/hunalign) sentence aligner to (attempt to) identify pairs of translated sentences.  And in `04_sort-parallel-text.pl`, we select a set of pairs and set the rest aside for later.
