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
  sys       = 'f_sys_thp',                     # three pool model with a POM, MB, and MAOM pool
  c1_c2     = 'f_0',                           # transfer from pom(1) to mb(2)
  c1_c3     = 'f_13_k_none_',                  # transfer from pom to maom(3)
  c3_c1     = 'f_31_k_none_',                  # transfer from maom to pom
  c3_c2     = 'f_0',                           # transfer from maom to mb
  c2_c3     = 'f_0',                           # transfer from mb to maom
  c2_c1     = 'f_0',                           # transfer from mb to pom
  
  i1eff     = 'f_1',                           #fraction of inputs to pom
  i2eff     = 'f_0',                           #fraction of inputs to mb
  i3eff     = 'f_0',                           #fraction of inputs to maom
  c1_c2eff     = 'f_1',                        #fraction of pom decay that enters mb
  c1_c3eff     = 'f_13eff_lin_clay_century',   #fraction of pom decay that enters maom
  c3_c1eff     = 'f_0',                        #fraction of maom decay that enters pom      
  c3_c2eff     = 'f_1',                        #fraction of maom decay that enters mb     
  c2_c3eff     = 'f_1',                        #fraction of mb decay that enters maom     
  c2_c1eff     = 'f_1',                        #fraction of mb decay that enters pom    
  
  vmax1        =  'f_vmax1_constMM',
  km1          =  'f_km1_constMM',
  vmax3        =  'f_vmax3_constMM',
  km3          =  'f_km3_constMM',
  maommax      = 'f_maommax_hassink'
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
  c1    = 3.556,
  c2     =0.0001,
  c3   = 13.835,
  totc = numeric(1),
  co2 = numeric(1)
)


# state parameters (i.e. calculated parameters)
####################################
som_thp_object$state_pars <- list(
 vmax1    =  numeric(1), #michaelis-menton vmax for decay of pool 1
 km1      =  numeric(1),
 vmax3    =  numeric(1),
 km3      =  numeric(1),
 maommax  =  numeric(1),  #determines max maom capacity
 q        =  numeric(1)  #modifies transfer into maom 

)


# parameters (everything on year time scale currently)
####################################
som_thp_object$pars   <- list(
  #two-pool params
  cuec1           = .13,        #CURRENTLY humification value from ICBM bare-fallow), will also use this param as CUE of microbes growing on POM pool in 3-pool model 
  e13int          = .003,       #intercept from CENTURY (Parton et al. 1993)
  e13slope        = .032,       #slope from CENTURY (Parton et al. 1993)
  k13             = .00108,    #first-order decay of POM pool (value from Balesdent 1996; weigh00ed average of >50um fraction including >2mm /365)
  k31             = .00004349,    #first-order decay of MAOM pool (value from Balesdent 1996/365 = .00004349) 
  clay_ref        = 15,         #Reference clay for scaling functions. could set to center of dataset
  
  #three-pool params
  vmax1_ref_MM       = 1.93,     #see "parameterization_notes.doc" 
  km1_ref_MM         = 50,       #see "parameterization_notes.doc" 
  vmax3_ref_MM       = .0777,    #see "parameterization_notes.doc" 
  km3_ref_MM         = 250,      #see "parameterization_notes.doc" 
  k23                = .00672,    #turnover rate of microbial biomass from Li paper... might be too slow
  cuec3              = .31,       #general CUE from Li et al. 
  cuec2              = .6,        #Proportion of microbial turnover products that are retained rather than respired (Value of carbon eff of mic turnover from CORPSE)
  
  #old params to get rid of...
  ea1             = 47000,   #J/mol (average of three pools in CORPSE)
  vmax_maxref_1   = 1.37,    #d^-1 (values for mbc in CORPSE; 500/y *1/365d)
  R               = 8.31,    #J K^-1 mol^-1 (ideal gas constant)
  whc             = 0.54,     #m^3 m^-3 (soil water holding capacity from CORPSE)
  km1             = 0.01,     #dimensionless (from CORPSE)
  t1              = 0.0000274,       #d^-1 (.01 yearly POM -> MAOM; .1/365)
  t3              = .0000609,      #d^-1 turnover rate of MAOM from CORPSE; (1/45*1/365)
  t2              = .03030,       #d^-1 turnover of MB (1/33 days)
  fmaom           = 0.0,        #fracton of inputs to MAOM pool
  t23eff           = .6,        #efficiency with which microbial turnover converted to maom vs respired (value from CORPSE)
  k1              = .00274,        #first-order decay of POM pool (1/365 days)
  k12hassink       = .001161644,     #first-order decay of non-protected pool in hassink 1997
  k13hassink      = .003041096,      #adsorption rate hassink1
  k21hassink      = .000526027,      #second order microbial turnover rate hassink1
  k31hassink      = .000039726       #desorption rate hassink1
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



som_thp_object$.test_change_func <- function(., som_thp.timestep=1:36500, som_thp.dummy = 1, 
                                             verbose=F,
                                             som_thp.c1_c3eff='f_13eff_saturating_clay_hassink1',
                                             som_thp.cuec1 = 0.305
                                             ) {
  if(verbose) str(.)
  .$build(switches=c(F,verbose,F))
  
  .$fnames$c1_c3eff   <- som_thp.c1_c3eff
  .$pars$cuec1 <- som_thp.cuec1
  
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


som_thp_object$.test_change_pars <- function(., som_thp.timestep=1:365, som_thp.dummy = 1, 
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


som_thp_object$.test_thp <- function(., som_thp.timestep=1:365, som_thp.dummy = 1, 
                                             verbose=F,
                                     som_thp.c1_c2     = 'f_12_mm_none_li',                           # transfer from pom(1) to mb(2)
                                     som_thp.c1_c3     = 'f_0',                  # transfer from pom to maom(3)
                                     som_thp.c3_c1     = 'f_0',                  # transfer from maom to pom
                                     som_thp.c3_c2     = 'f_32_mm_none_li',                           # transfer from maom to mb
                                     som_thp.c2_c3     = 'f_23_k_none_li',                           # transfer from mb to maom
                                     som_thp.c2_c1     = 'f_0',                           # transfer from mb to pom
                                     som_thp.c1_c2eff     = 'f_1cue_none_',                        #fraction of pom decay that enters mb
                                     som_thp.c1_c3eff     = 'f_1',  #fraction of pom decay that enters maom
                                     som_thp.c3_c1eff     = 'f_0',                        #fraction of maom decay that enters pom      
                                     som_thp.c3_c2eff     = 'f_3cue_none_',                        #fraction of maom decay that enters mb     
                                     som_thp.c2_c3eff     = 'f_23eff_lin_clay_century',                        #TRYING THIS HERE ASSUMING CUE IS AT THE NEW HIGHER RATE; fraction of mb decay that enters maom     
                                     som_thp.c2_c1eff     = 'f_1',                        #fraction of mb decay that enters pom    
                                     som_thp.cuec1          = 0.31,
                                     som_thp.vmax1_ref_MM       = 1.93,     #see "parameterization_notes.doc" 
                                     som_thp.km1_ref_MM         = 50,       #see "parameterization_notes.doc" 
                                     som_thp.vmax3_ref_MM       = .0777,    #see "parameterization_notes.doc" 
                                     som_thp.km3_ref_MM         = 250,
                                     som_thp.c2                 = 0.326,
                                     som_thp.cuec2              = 0.6,
                                     som_thp.cuec3              = 0.31
) {
  if(verbose) str(.)
  .$build(switches=c(F,verbose,F))
  
  .$fnames$c1_c2   <- som_thp.c1_c2                          
  .$fnames$c1_c3  <- som_thp.c1_c3                    
  .$fnames$c3_c1 <- som_thp.c3_c1                    
  .$fnames$c3_c2 <- som_thp.c3_c2                            
  .$fnames$c2_c3 <- som_thp.c2_c3                            
  .$fnames$c2_c1 <- som_thp.c2_c1           
  .$fnames$c1_c2eff <- som_thp.c1_c2eff                    
  .$fnames$c1_c3eff <- som_thp.c1_c3eff    
  .$fnames$c3_c1eff <- som_thp.c3_c1eff                      
  .$fnames$c3_c2eff <- som_thp.c3_c2eff                       
  .$fnames$c2_c3eff <- som_thp.c2_c3eff                
  .$fnames$c2_c1eff <- som_thp.c2_c1eff                       
  
  .$pars$cuec1 <- som_thp.cuec1
  .$pars$vmax1_ref_MM <- som_thp.vmax1_ref_MM
  .$pars$km1_ref_MM <- som_thp.km1_ref_MM
  .$pars$vmax3_ref_MM  <- som_thp.vmax3_ref_MM 
  .$pars$km3_ref_MM <- som_thp.km3_ref_MM
  .$pars$cuec2 <- som_thp.cuec2
  .$pars$cuec3 <- som_thp.cuec3
  
  .$state$c2 <- som_thp.c2
  
  
  
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


### END ###
