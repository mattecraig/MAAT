################################
#
# SoilTest2 for MAAT object functions 
#
# AWalker November 2017; MCraig July 2019
#
################################

library(proto)
source('SoilTest2_functions.R')
source('SoilTest2_system_functions.R')



# SoilTest2 OBJECT
###############################################################################

# use generic SoilTest2
setwd('..')
source('generic_model_object.R')
SoilTest2_object <- as.proto( system_model_object$as.list() )
rm(system_model_object)
setwd('SoilTest2')



# assign object functions
###########################################################################
SoilTest2_object$name <- 'SoilTest2'




# assign unique run function
###########################################################################
# if run function needs to be modified - add new function here



# functions unique to object that do not live in fnames/fns, i.e. do not vary ever
###########################################################################
# add structural functions (i.e not alternative process functions)  unique to model object here



# assign object variables 
###########################################################################

# function names
####################################
SoilTest2_object$fnames <- list(
  sys          = 'f_sys_1',
  c1_dec       = 'f_c1dec_first',
  c2_dec       = 'f_c2dec_first',
  cue          = 'f_cue_const'
)


# environment
####################################
SoilTest2_object$env <- list(
  i = 200              #Input rate for each timestep (units arbitrary)
)


# state
####################################
SoilTest2_object$state <- list(
  #Fluxes
  dc1    = numeric(1),     # Change in fast carbon pool
  dc2    = numeric(1),     # Change in slow carbon pool
  #Pools
  c1     = numeric(1),
  c2     = numeric(1)
)


# state parameters (i.e. calculated parameters)
####################################
SoilTest2_object$state_pars <- list(
  none    = numeric(0)   
)


# parameters
####################################
SoilTest2_object$pars   <- list(
  k1  = .5,           
  k2  = .05,
  cue = .05
)


# run control parameters
####################################
SoilTest2_object$cpars <- list(
  verbose  = F,          # write diagnostic output during runtime 
  cverbose = F,          # write diagnostic output from configure function 
  output   = 'run'       # type of output from run function
)



# output functions
#######################################################################        

f_output_SoilTest2_run <- function(.) {
  unlist(.$state)
}

f_output_SoilTest2_state <- function(.) {
  unlist(.$state)
}

f_outp_SoilTest2_full <- function(.) {
  c(unlist(.$state),unlist(.$statei_pars))
}



# test functions
#######################################################################        

SoilTest2_object$.test <- function(., verbose=F) {
  if(verbose) str(.)
  .$build(switches=c(F,verbose,F))

  .$run()
}

#changes input rates as run proceeds
SoilTest2_object$.test_c1_i <- function(., SoilTest2.i=seq(50, 500, 50), SoilTest2.dummy = 1, 
                                  verbose=F, cverbose=F, diag=F) {
  
  if(verbose) str(.)
  .$build(switches=c(diag,verbose,cverbose) )

  
  # configure met data and run
  .$dataf     <- list()
  .$dataf$met <-  expand.grid(mget(c('SoilTest2.i', 'SoilTest2.dummy')))   
  .$dataf$out <- data.frame(do.call(rbind,lapply(1:length(.$dataf$met[,1]),.$run_met)))
  
  print(cbind(.$dataf$met,.$dataf$out))
  p1 <- plot(.$dataf$met$SoilTest2.i, .$dataf$out$c1)
  
  print(p1)
  
}

#run with defaults over timestep
SoilTest2_object$.test_timestep <- function(., SoilTest2.timestep=1:50, SoilTest2.dummy = 1, 
                                        verbose=F, cverbose=F, diag=F) {
  
  if(verbose) str(.)
  .$build(switches=c(diag,verbose,cverbose) )
  
  
  # configure met data and run
  .$dataf     <- list()
  .$dataf$met <-  expand.grid(mget(c('SoilTest2.timestep', 'SoilTest2.dummy')))   
  .$dataf$out <- data.frame(do.call(rbind,lapply(1:length(.$dataf$met[,1]),.$run_met)))
  
  print(cbind(.$dataf$met,.$dataf$out))
  par(mfrow = c(2,2))
  plot(.$dataf$met$SoilTest2.timestep, .$dataf$out$c1)
  plot(.$dataf$met$SoilTest2.timestep, .$dataf$out$c2)
  plot(.$dataf$met$SoilTest2.timestep, .$dataf$out$dc1)
  plot(.$dataf$met$SoilTest2.timestep, .$dataf$out$dc2)
  
  
}


### END ###
