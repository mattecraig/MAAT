################################
#
# MAAT som_thp system representation functions (SRFs) 
# 
# MAAT model: AWalker November 2017
# SOM model: MCraig August 2019
################################



################################
# som_thp system function one

f_sys_thp <- function(.) {

#calculate state parameters
.super$state_pars$vmax1 <- .$vmax1() 
.super$state_pars$q     <- .$q()
  
#fluxes
.super$state$dc1 <- .super$env$i * (1-.super$pars$fmaom) + .$c3_c1() - .$c1_c2() - .$c1_c3()
.super$state$dc2 <- .$c1_c2() * .super$pars$cuec1 + .$c3_c2() - .$c2_c3()
.super$state$dc3 <- .super$env$i * .super$pars$fmaom + .$c1_c3() + .$c2_c3() * .super$pars$t2eff - .$c3_c1() - .$c3_c2()

#update states
.super$state$c1 <- .super$state$c1 + .super$state$dc1
.super$state$c2 <- .super$state$c2 + .super$state$dc2
.super$state$c3 <- .super$state$c3 + .super$state$dc3
}



### END ###
