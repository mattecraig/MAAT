################################
#
# SoilTest2 for MAAT object system functions
# 
# AWalker February 2018
#
################################



################################
# SoilTest2 system function one

f_sys_1 <- function(.) {

  # define fluxes
  .super$state$dc1    <- .super$env$i - .$c1_dec()
  .super$state$dc2 <- .$c1_dec() * .$cue() - .$c2_dec()

  #Calculate pools
  .super$state$c1 <- .super$state$c1 + .super$state$dc1
  .super$state$c2 <- .super$state$c2 + .super$state$dc2
  
  # call print function
  #.$print_out()  
  
}



### END ###
