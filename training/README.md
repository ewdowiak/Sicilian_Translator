# Sicilian Translator / training

Having split our tokenized text into subwords, we train our translation models with [Sockeye](https://awslabs.github.io/sockeye/).  The `prep-m2m.sh` script prepares the data, saving it to disk.  Then the `train_se37a0[123].sh` scripts implement a ["Reverse Training Strategy"](https://www.doviak.net/pages/ml-sicilian/ml-scn_p07.shtml) to train a many-to-many [Transformer](https://arxiv.org/abs/1706.03762) translation model.

We follow the same sequence of steps that [Radford et al. (2018)](https://cdn.openai.com/research-covers/language-unsupervised/language_understanding_paper.pdf) proposed -- pre-training then fine-tuning.  The difference is that we think about the steps in reverse order.

First, we develop the dataset that we'll use for fine-tuning and we train an initial model on that dataset. Then we pre-train a model that will provide a good starting point for the subsequent fine-tuning.

As discussed in the ["Just Split, Dropout and Pay Attention"](https://www.doviak.net/pages/ml-sicilian/ml-scn_p05.shtml) article, we train a smaller network on our smaller dataset.  Specifically, we use a small [subword](https://www.doviak.net/pages/ml-sicilian/ml-scn_p04.shtml) vocabulary, small embedding layers, small hidden layers, few attention heads and few attention layers.

And to further prevent the model from becoming over-fit, we train the models with high dropout parameters, which (by randomly shutting off some units during training) prevents the units from learning to adapt to each other.  Each unit in the network therefore learns to predict independently of the other units.

Using high dropout to train a small, self-attentional Transformer model yields a translation model that makes relatively good predictions despite having been trained with relatively little parallel text.
