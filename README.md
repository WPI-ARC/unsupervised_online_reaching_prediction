# Unsupervised_online_reaching_prediction
Code for unsupervised online learning algorithm and two layer framework for human reaching motion recognition and early prediction.

#Instruction:
1. Make sure matlab is installed in the machine.

2. Install pymatlab using pip(according to https://pip.pypa.io/en/stable/installing/ and https://pypi.python.org/pypi/pymatlab).

      2.1 install pip if needed
      
      $sudo apt-get install python-pip
      
      2.2 install pymatlab by pip
      
      $sudo pip install pymatlab

      2.3 prepare to use pymatlab
      
      $ sudo apt-get install csh
  
      $export PATH=/YOUR/MATLAB/PATH/bin:$PATH

3. Run example_UOLA.py for a simple example. This example file will initialize the model and use the obsTraj.csv to update the model. It will take the testTraj.csv as the observation and write the prediction trajectory to predTraj.csv 

# Contents:
1. Matlab code for unsupervised online learning algorithm.

2. example_UOLA.py code for the example to use the matlab code in python in order to use in a realtime experiment.

3. setup.txt is the parameter setup file for the algorithm.

4. UOLA_init.m is the model initial function, the input is the path to save the model.

5. UOLA_learn.m is the learning function, the input is the path of the model and the path of the csv file that stores the observed entire trajectory.

6. UOLA_predict.m is the prediction function, the input is the path of the model, the path of the csv file that stores the observed beginning part of the trajectory, and the path of the csv file that stores the output predicted trajectory.

#Depandencies:

1. The interface between matlab and python is pymatlab package. Please refer to https://pypi.python.org/pypi/pymatlab

2. The matlab code is based on Incremental EM algorithm, GMM learning, GMR from Sylvain Calinon. Please refer to http://programming-by-demonstration.org/sourcecodes.php
  

