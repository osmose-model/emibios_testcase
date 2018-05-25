rm(list=ls())

library(osmose)

#runOsmose("osm_all-parameters.csv")
jarfile = '/home/nbarrier/Modeles/osmose/svn-osmose/trunk/dist/osmose-trunk.jar'
runOsmose("osm_all-parameters.csv", version=4, osmose=jarfile)

