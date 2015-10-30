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
    session = pymatlab.session_factory()
    session.run('cd ' + baseDir)
# Initialize Model
    session.run('UOLA_init(\''+modelDir+'\')')
# Model Update
    session.run('UOLA_learn(\'' + modelDir + '\',\'' + obsTrajCsvFile + '\')')
# Prediction
    session.run('UOLA_predict(\'' + modelDir + '\',\'' + testTrajCsvFile + '\',\'' + predTrajCsvFile +'\')' )
    print 'End Example'


