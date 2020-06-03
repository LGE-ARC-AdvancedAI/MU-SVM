**MUSVM**: Multiclass Learning from Contradictions
================================================================================
This is the accompanying code for the paper published in NeurIPS 2019. In this work  we introduce the notion of learning from contradictions, a.k.a Universum learning, for multiclass problems and propose a novel formulation for multiclass universum SVM (MU-SVM). We show that learning from contradictions (using MU-SVM) incurs lower sample complexity compared to multiclass SVM (M-SVM) by deriving the Natarajan dimension for sample complexity for PAC-learnability of MU-SVM. We also propose an analytic span bound for MU-SVM and demonstrate its utility for model selection resulting in ∼ 2 − 4× faster computation times than standard resampling techniques. We empirically demonstrate the efficacy of MU-SVM on several real world datasets achieving > 20% improvement in test accuracies compared to M-SVM. Insights into the underlying behavior of MU-SVM using a
histograms-of-projections method are also provided.

If you find this work useful please cite,

```
@incollection{NIPS2019_9048,
title = {Multiclass Learning from Contradictions},
author = {Dhar, Sauptik and Cherkassky, Vladimir and Shah, Mohak},
booktitle = {Advances in Neural Information Processing Systems 32},
editor = {H. Wallach and H. Larochelle and A. Beygelzimer and F. d\textquotesingle Alch\'{e}-Buc and E. Fox and R. Garnett},
pages = {8400--8410},
year = {2019},
publisher = {Curran Associates, Inc.},
url = {http://papers.nips.cc/paper/9048-multiclass-learning-from-contradictions.pdf}
}
```


Installation and Configuration
------------------------------

Dependencies:

* MATLAB's builtin quadprog package 
* SVM-KM package available at:- http://asi.insa-rouen.fr/enseignants/~arakoto/toolbox/


Running the Codes:

To reproduce the results in Tables 2
1. Go to Folder Examples -> Table2
2. Run the experiment for the specified data.

To reproduce the results in Tables 3
1. Go to Folder Examples -> Table3
2. Run the experiment for the specified data.

License
--------
MUSVM is open-sourced under the Apache-2.0 license. See the `LICENSE <LICENSE>`_ file for details.


Contact
-------
Sauptik Dhar <sauptik.dhar@lge.com>
