################################
#
# SoilTest2 for MAAT object functions
# 
# AWalker March 2017
#
################################


### FUNCTIONS
################################

# first order decomposition of fast pool 
f_c1dec_first <- function(.) {   
  .super$pars$k1 * .super$state$c1
}

# first order decomposition of slow pool
f_c2dec_first <- function(.) {
  .super$pars$k2 * .super$state$c2
}

# Constant CUE
f_cue_const <- function(.) {
  .super$pars$cue
}




### END ###
