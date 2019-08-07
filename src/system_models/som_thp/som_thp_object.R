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
  c1_c2     = 'f_12_rmm_tm_corpse',     # transfer from pom(1) to mb(2)
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
  i = 200,         #input rate ()
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
  #Pools
  c1    = 1,
  c2     = 1,
  c3   = 1 
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
  vmax_maxref_1   = 500,    #year^-1 (values for mbc in CORPSE)
  R               = 8.31,    #J K^-1 mol^-1 (ideal gas constant)
  whc             = 0.54,     #m^3 m^-3 (soil water holding capacity from CORPSE)
  km1             = 0.01,     #dimensionless (from CORPSE)
  t1              = 0.5,       #year^-1 (average of two plant pools in CORPSE)
  t3              = .02222222,      #year^-1 turnover rate of MAOM from CORPSE
  t2              = 1,       #year^-1 transfer of MB to MAOM from CORPSE
  fmaom           = 0.0        #fracton of inputs to MAOM pool
  
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


som_thp_object$.test_change_func <- function(., verbose=F,
                                              som_thp.text='f_text_combine',
                                              som_thp.calcval='f_calcval_product',
                                              som_thp.print_out='f_print_out_textonly' ) {
  if(verbose) str(.)
  .$build(switches=c(F,verbose,F))
  
  .$fnames$text      <- som_thp.text
  .$fnames$calcval   <- som_thp.calcval
  .$fnames$print_out <- som_thp.print_out

  # configure_test must be called if any variables in the fnames lista re reassigned
  .$configure_test()  
  .$run()
}


som_thp_object$.test_change_pars <- function(., verbose=F,
                                              som_thp.text1='hello',
                                              som_thp.text2='world' ) {
  if(verbose) str(.)
  .$build(switches=c(F,verbose,F))

  .$pars$text1 <- som_thp.text1
  .$run()
}



### END ###
