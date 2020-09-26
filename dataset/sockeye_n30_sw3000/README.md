# Sicilian Translator / dataset / sockeye_n30_sw3000

Having split our tokenized text into subwords, we train our translation models with [Sockeye](https://awslabs.github.io/sockeye/).  The `prep-ensc.sh` and `prep-scen.sh` scripts prepare the data, saving it to disk.  Then the `train-tnf_ensc_c01.sh` and `train-tnf_scen_c01.sh` scripts train a pair of [Transformer](https://arxiv.org/abs/1706.03762) models.

As discussed in the ["Just Split, Dropout and Pay Attention"](https://www.doviak.net/pages/ml-sicilian/ml-scn_p05.shtml) article, we train a smaller network on our smaller dataset.  Specifically, we use a small [subword](https://www.doviak.net/pages/ml-sicilian/ml-scn_p04.shtml) vocabulary, small embedding layers, small hidden layers, few attention heads and few attention layers.

And to further prevent the model from becoming over-fit, we train the models with high dropout parameters, which (by randomly shutting off some units during training) prevents the units from learning to adapt to each other.  Each unit in the network therefore learns to predict independently of the other units.

Using high dropout to train a small, self-attentional Transformer model yields a translation model that makes relatively good predictions despite having been trained with relatively little parallel text.
