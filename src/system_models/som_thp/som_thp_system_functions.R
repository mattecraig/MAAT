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
.super$state_pars$maommax <- .$maommax()
.super$state_pars$vmax1 <- .$vmax1()
.super$state_pars$km1 <- .$km1()
.super$state_pars$vmax3 <- .$vmax3()
.super$state_pars$km3 <- .$km3()
  
#fluxes
.super$state$dc1 <- .super$env$i * .$i1eff() + .$c3c1() * .$c3c1eff() + .$c2c1() * .$c2c1eff() - .$c1c2() - .$c1c3() 
.super$state$dc2 <- .super$env$i * .$i2eff() + .$c1c2() * .$c1c2eff() + .$c3c2() * .$c3c2eff() - .$c2c1() - .$c2c3() 
.super$state$dc3 <- .super$env$i * .$i3eff() + .$c1c3() * .$c1c3eff() + .$c2c3() * .$c2c3eff() - .$c3c1() - .$c3c2() 
.super$state$dco2 <- .super$env$i * (1 -.$i1eff() - .$i2eff() -.$i3eff()) + .$c3c1() * (1 - .$c3c1eff()) + .$c2c1() * (1 - .$c2c1eff()) + .$c1c2() * (1- .$c1c2eff()) + .$c3c2() * (1 - .$c3c2eff()) + .$c1c3() * (1 - .$c1c3eff()) + .$c2c3() * (1 - .$c2c3eff())

#update states
.super$state$c1 <- .super$state$c1 + .super$state$dc1
.super$state$c2 <- .super$state$c2 + .super$state$dc2
.super$state$c3 <- .super$state$c3 + .super$state$dc3
.super$state$totc <- .super$state$c1 + .super$state$c2 + .super$state$c3
.super$state$co2 <- .super$state$co2 + .super$state$dco2
}


### END ###
