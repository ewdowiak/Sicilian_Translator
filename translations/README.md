# Sicilian Translator / translations

Here we set aside a hand-selected set of translated sentences for validation and testing.  And we record our BLEU and ChrF scores at each training stage.

To implement our ["Reverse Training Strategy"](https://www.doviak.net/pages/ml-sicilian/ml-scn_p07.shtml), we follow the same sequence of steps that [Radford et al. (2018)](https://cdn.openai.com/research-covers/language-unsupervised/language_understanding_paper.pdf) proposed -- pre-training then fine-tuning.  The difference is that we think about the steps in reverse order.

First, we develop the dataset that we'll use for fine-tuning and we train an initial model on that dataset. Then we pre-train a model that will provide a good starting point for the subsequent fine-tuning.

Our scores at each stage are recorded in the `bleu-chrf_se37a0[123]-ckpt*.txt` files.
