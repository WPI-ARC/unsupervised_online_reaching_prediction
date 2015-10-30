# unsupervised_online_reaching_prediction
Code for unsupervised online learning algorithm and two layer framework for human reaching motion recognition and early prediction.
1. Matlab code for unsupervised online learning algorithm.
2. example_UOLA.py code for the example to use the matlab code in python in order to use in a realtime experiment.
3. setup.txt is the parameter setup file for the algorithm.
4. UOLA_init.m is the model initial function, the input is the directory to save the model.
5. UOLA_learn.m is the learning function, the input is the directory of the model and the directory of the csv file that stores the observed entire trajectory.
6. UOLA_predict.m is the prediction function, the input is the directory of the model, the directory of the csv file that stores the observed beginning part of the trajectory, and the directory of the csv file that stores the output predicted trajectory.

Depandencies:
1. The interface between matlab and python is pymatlab package. Please refer to https://pypi.python.org/pypi/pymatlab
2. The matlab code is based on Incremental EM algorithm, GMM learning, GMR from Sylvain Calinon. Please refer to http://programming-by-demonstration.org/sourcecodes.php
  

