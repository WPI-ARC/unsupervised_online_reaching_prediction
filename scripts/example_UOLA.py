import pymatlab


if __name__ == '__main__':
    print 'Start Example'
    numTraj = 0
    numPrediction = 0
    baseDir = "./"
    obsTrajCsvFile = baseDir + "csvFiles/obsTraj.csv"
    predTrajCsvFile = baseDir + "csvFiles/predTraj.csv"
    testTrajCsvFile = baseDir + "csvFiles/testTraj.csv"
    modelDir = baseDir + "TRO_model.mat"
# Initialize Matlab
    print 'Loading MATLAB.'
    session = pymatlab.session_factory()
    print 'Finish loading MATLAB.'
    session.run('cd ' + baseDir)
# Initialize Model
    print 'Start Initializing the model.'
    session.run('UOLA_init(\''+modelDir+'\')')
    print 'Finish Initializing the model'
# Model Update
    print 'Start Updating the model using one trajectory'
    session.run('UOLA_learn(\'' + modelDir + '\',\'' + obsTrajCsvFile + '\')')
    print 'Finish Updating the model using one trajectory'
# Prediction
    print 'Start Predicting the given trajectory.'
    session.run('UOLA_predict(\'' + modelDir + '\',\'' + testTrajCsvFile + '\',\'' + predTrajCsvFile +'\')' )
    print 'Finish Predicting the given trajectory.'
    print 'End Example'


