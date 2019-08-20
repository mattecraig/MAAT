################################
#
# MAAT som_thp model object 
#
# MAAT model: AWalker November 2017
# SOM model: MCraig August 2019
################################

library(proto)
source('som_thp_functions.R')
source('som_thp_system_functions.R')



# som_thp OBJECT
###############################################################################

# use generic som_thp
setwd('..')
source('generic_model_object.R')
som_thp_object <- as.proto( system_model_object$as.list() )
rm(system_model_object)
setwd('som_thp')



# assign object functions
###########################################################################
som_thp_object$name <- 'som_thp'



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

#Defaults set for CORPSE representation
som_thp_object$fnames <- list(
  sys       = 'f_sys_thp',           # three pool model with a POM, MB, and MAOM pool
  c1_c2     = 'f_12_k_none_',     # transfer from pom(1) to mb(2)
  c1_c3     = 'f_13_k_clay_corpse',         # transfer from pom to maom(3)
  c3_c1     = 'f_31_k__corpse',             # transfer from maom to pom
  c3_c2     = 'f_32_none__corpse',           # transfer from maom to mb
  c2_c3     = 'f_23_k_clay_corpse',         # transfer from mb to maom
  vmax1     = 'f_vmax1_arrhenius',           # modifies vmax for decomp of pool1
  q         = 'f_q_corpse'                   #modifies formation rate of maom
)


# environment
####################################
som_thp_object$env <- list(
  i = .00384,         #input rate (mgC gsoil^-1; from Wang et al. 2013)
  clay = 20,       #clay content (percent)
  temp = 290,      #temp (K)
  moisture = .25   #volumetric soil water content
)


# state
####################################
som_thp_object$state <- list(
  #Fluxes
  dc1   = numeric(1),
  dc2    = numeric(1),
  dc3  = numeric(1),
  dco2 = numeric(1),
  
  #Pools
  c1    = 1,
  c2     =1,
  c3   = 1,
  co2 = numeric(1)
)


# state parameters (i.e. calculated parameters)
####################################
som_thp_object$state_pars <- list(
 vmax1    =  numeric(1), #michaelis-menton vmax for decay of pool 1
 q        =  numeric(1)  #modifies transfer into maom 
)


# parameters (everything on year time scale currently)
####################################
som_thp_object$pars   <- list(
  ea1             = 47000,   #J/mol (average of three pools in CORPSE)
  vmax_maxref_1   = 1.37,    #d^-1 (values for mbc in CORPSE; 500/y *1/365d)
  R               = 8.31,    #J K^-1 mol^-1 (ideal gas constant)
  whc             = 0.54,     #m^3 m^-3 (soil water holding capacity from CORPSE)
  km1             = 0.01,     #dimensionless (from CORPSE)
  t1              = 0.000274,       #d^-1 (.1 yearly POM -> MAOM; .1/365)
  t3              = .0000609,      #d^-1 turnover rate of MAOM from CORPSE; (1/45*1/365)
  t2              = .03030,       #d^-1 turnover of MB (1/33 days)
  fmaom           = 0.0,        #fracton of inputs to MAOM pool
  cuec1           = .5,        #CUE of microbes growing on POM pool (arbitrary value for now)
  t2eff           = .6,        #efficiency with which microbial turnover converted to maom vs respired (value from CORPSE)
  k1              = .00274        #first-order decay of POM pool (1/365 days)
)


# run control parameters
####################################
som_thp_object$cpars <- list(
  verbose  = F,          # write diagnostic output during runtime 
  cverbose = F,          # write diagnostic output from configure function 
  output   = 'run'       # type of output from run function
)



# output functions
#######################################################################        

f_output_som_thp_run <- function(.) {
  unlist(.$state)
}

f_output_som_thp_state <- function(.) {
  unlist(.$state)
}

f_output_som_thp_full <- function(.) {
  c(unlist(.$state),unlist(.$statei_pars))
}



# test functions
#######################################################################        

som_thp_object$.test <- function(., verbose=F) {
  if(verbose) str(.)
  .$build(switches=c(F,verbose,F))

  .$run()
}

som_thp_object$.test_change_env <- function(., verbose=F) {
  if(verbose) str(.)
  .$build(switches=c(F,verbose,F))
  
  .$env$i <- 2000
  
  .$run()
}

#run with defaults over timestep
som_thp_object$.test_timestep <- function(., som_thp.timestep=1:3650, som_thp.dummy = 1, 
                                            verbose=F, cverbose=F, diag=F) {
  
  if(verbose) str(.)
  .$build(switches=c(diag,verbose,cverbose) )
  
  
  # configure met data and run
  .$dataf     <- list()
  .$dataf$met <-  expand.grid(mget(c('som_thp.timestep', 'som_thp.dummy')))   
  .$dataf$out <- data.frame(do.call(rbind,lapply(1:length(.$dataf$met[,1]),.$run_met)))
  
  print(cbind(.$dataf$met,.$dataf$out))
  par(mfrow = c(2,2))
  plot(.$dataf$met$som_thp.timestep, .$dataf$out$c1)
  plot(.$dataf$met$som_thp.timestep, .$dataf$out$c2)
  plot(.$dataf$met$som_thp.timestep, .$dataf$out$c3)
  plot(.$dataf$met$som_thp.timestep, .$dataf$out$co2)
  
}



som_thp_object$.test_change_func <- function(., som_thp.timestep=1:365, som_thp.dummy = 1, 
                                             verbose=F,
                                             som_thp.c1_c2='f_12_rmm_tm_corpse',
                                             som_thp.c1_c3='f_13_none__mimics'
                                             ) {
  if(verbose) str(.)
  .$build(switches=c(F,verbose,F))
  
  .$fnames$c1_c2      <- som_thp.c1_c2
  .$fnames$c1_c3      <- som_thp.c1_c3
  
  .$configure_test()  

  .$dataf     <- list()
  .$dataf$met <-  expand.grid(mget(c('som_thp.timestep', 'som_thp.dummy')))   
  .$dataf$out <- data.frame(do.call(rbind,lapply(1:length(.$dataf$met[,1]),.$run_met)))
  
  print(cbind(.$dataf$met,.$dataf$out))
  par(mfrow = c(2,2))
  plot(.$dataf$met$som_thp.timestep, .$dataf$out$c1)
  plot(.$dataf$met$som_thp.timestep, .$dataf$out$c2)
  plot(.$dataf$met$som_thp.timestep, .$dataf$out$c3)

}


som_thp_object$.test_change_pars <- function(., som_thp.timestep=1:3650, som_thp.dummy = 1, 
                                             verbose=F,
                                              som_thp.k1 = .000205) {
  if(verbose) str(.)
  .$build(switches=c(F,verbose,F))

  .$pars$k1 <- som_thp.k1
  
  .$dataf     <- list()
  .$dataf$met <-  expand.grid(mget(c('som_thp.timestep', 'som_thp.dummy')))   
  .$dataf$out <- data.frame(do.call(rbind,lapply(1:length(.$dataf$met[,1]),.$run_met)))
  
  print(cbind(.$dataf$met,.$dataf$out))
  par(mfrow = c(2,2))
  plot(.$dataf$met$som_thp.timestep, .$dataf$out$c1)
  plot(.$dataf$met$som_thp.timestep, .$dataf$out$c2)
  plot(.$dataf$met$som_thp.timestep, .$dataf$out$c3)
}




### END ###
