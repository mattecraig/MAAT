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

  #get a list of initial state values, parameters
  state <- c(c1 = .super$state$c1, 
             c2 = .super$state$c2
         )
  times <- c(0,1)
  parms <- c(k1 = .super$pars$k1,
             k2 = .super$pars$k2,
             cue = .super$pars$cue,
             i = .super$env$i
  )

  #express fluxes as function for input to rk solver
  fluxes <- function(t,state,parms){
    with(as.list(c(state,parms)),{
      dc1 <- i - k1*c1
      dc2 <- k1*c1 * cue - k2*c2
      list(c(dc1, dc2))
    })
  }
  
  #Calculate pools
  out <- rk4(state, times, fluxes, parms)
  
  #output pool values
  .super$state$c1 <- unname(out[2,2])
  .super$state$c2 <- unname(out[2,3])
  .super$state$dc1 <- .super$state$c1 - unname(out[1,2])
  .super$state$dc2 <-  .super$state$c2 - unname(out[1,3])
  
  # call print function
  #.$print_out()  
  
}



##1st attempt at using solver/MAAT interface
f_sys_2 <- function(.) {
  
  #get a list of initial state values, parameters
  y <- c(.super$state$c1, .super$state$c2)
  times <- seq(0,1, by=1)
  parms <- c(.super$pars, .super$state_pars, .super$env)
  
  # define fluxes
  
  #express fluxes as function for input to rk solver
  fluxes <- function(t,y,parms){
    with(as.list(c(y,parms)),{
      .super$state$dc1    <- .super$env$i - .$c1_dec()
      .super$state$dc2 <- .$c1_dec() * .$cue() - .$c2_dec()
      
      list(c(.super$state$dc1, .super$state$dc2))
    })
  }
  
  #Calculate pools
  out <- rk(y, times, fluxes, parms)
  
  #output pool values
  .super$state$c1 <- unname(out[2,2])
  .super$state$c2 <- unname(out[2,3])
  
  # call print function
  #.$print_out()  
  
}



### END ###


