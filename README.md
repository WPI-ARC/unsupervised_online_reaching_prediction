# Unsupervised Online Reaching Prediction
Code for [A Framework for Unsupervised Online Human Reaching Motion Recognition and Early Prediction](http://arc.wpi.edu/download.php?p=44)

#Instructions:
1. Make sure MATLAB is installed in the machine.

2. Install pymatlab (https://pypi.python.org/pypi/pymatlab)
      (We suggest using pip https://pip.pypa.io/en/stable/installing/)

      2.1 install pip if needed
      
            $sudo apt-get install python-pip
      
      2.2 install pymatlab by pip
      
            $sudo pip install pymatlab

      2.3 Install pymatlab dependencies
      
            $ sudo apt-get install csh
  
      2.4 Add MATLAB directory to $PATH
      
            $export PATH=/YOUR/MATLAB/PATH/bin:$PATH

3. Run example_UOLA.py for a simple example. This example file will initialize the model and use a prerecorded trajectory (obsTraj.csv) in order to update the model. It will take another trajectory (testTraj.csv) as the observation and write the predicted trajectory to output file predTraj.csv 

# Contents:
1. Matlab code for unsupervised online learning algorithm.

2. example_UOLA.py Example python code which initializes a model, updates the model with a single trajectory and performs prediction on a second  trajectory.

3. setup.txt is a parameter setup file listing parameters required by the algorithm.

4. UOLA_init.m is the model initialization function.  The function takes an output path as a parameter.

5. UOLA_learn.m is the learning function.  It's inputs are the path to a previously initialized or trained model as well as a csv file which describes a reaching trajectory to train the model with.

6. UOLA_predict.m is the prediction function. It's inputs are the path of the model, the path of the csv file that stores the observed portion of a trajectory, and the path of the csv file that stores the output predicted trajectory.

#Depandencies:

1. The interface between matlab and python is the pymatlab package. Please refer to https://pypi.python.org/pypi/pymatlab

2. The matlab code is based on Incremental EM algorithm, GMM learning, GMR from Sylvain Calinon. Please refer to http://programming-by-demonstration.org/sourcecodes.php
