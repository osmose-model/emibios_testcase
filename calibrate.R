rm(list=ls())
require("osmose")
require("calibrar")

setwd("/home/nbarrier/Modeles/osmose/git-applis/emibios_testcase")

source("runModel.R")

# creates a user defined likelyhood function
minmaxt = function(obs, sim) {
    output = -1e+6*sum(log(pmin((sim+1)/(obs[, 1]+1), 1)), na.rm=TRUE) + 
              1e+6*sum(log(pmax((sim+1)/(obs[, 2]+1), 1)), na.rm=TRUE)
    return(output)
}

# reads calibration informations
calInfo = getCalibrationInfo(path=".", file="calibration_settings.csv")

# loads the observed data (path is the data directory path, 
# data.folder is the data directory name)
# todo: merge data.folder and path
observed = getObservedData(calInfo, path=".", data.folder="DATA")

# load calibration parameters
calibData = read.csv(file="parameters_to_calib.csv", 
                     header=TRUE, 
                     sep=",", 
                     row.names=1)

# create an objective function
# additional arguments to the runModel function
# are provided here.
objfn = createObjectiveFunction(runModel=runModel, 
                                info=calInfo, 
                                observed=observed, 
                                aggFn=calibrar:::.weighted.sum,
                                aggregate=FALSE,
                                names=row.names(calibData))

control = list()
control$maxgen = c(150, 200, 250, 300)   # maximum number of generations (former gen.max parameter)
control$master = "master/"   # directory that will be copied
control$run = "RUN"   # run directory
control$restart.file = "./calib_restart"   # name of the restart file
control$REPORT = 1    # number of generations to run before saving a restart
control$parallel = FALSE
#control$nCores = 5
control$maxgen = 10   # maximum number of generations (former gen.max parameter)
control$popsize = 15   # population  size (former seed parameter)

cal1 = calibrate(calibData['paropt'], fn=objfn, method='default',
                 lower=calibData['parmin'], upper=calibData['parmax'], 
                 phases=calibData['parphase'], control=control, replicates=2)
