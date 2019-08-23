###########################
#
# SoilTest2 for MAAT object unit testing
# 
# AWalker March 2017; MCraig July 2019
#
###########################



### Load model scripts 
###############################

# SoilTest2
source('SoilTest2_object.R')
SoilTest2_object$.test()

source('SoilTest2_object.R')
SoilTest2_object$.test_c1_i()

source('SoilTest2_object.R')
SoilTest2_object$.test_timestep()

source('SoilTest2_object.R')
SoilTest2_object$fnames
SoilTest2_object$fns
SoilTest2_object$state
SoilTest2_object$state_pars
SoilTest2_object$pars
SoilTest2_object$env



### END ###
