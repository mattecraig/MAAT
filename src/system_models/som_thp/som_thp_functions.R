################################
#
# MAAT som_thp process representation functions (PRFs)
# 
# MAAT model: AWalker November 2017
# SOM model: MCraig August 2019
################################


### FUNCTIONS
################################

# Reverse michaelis-Menton 
f_12_rmm_tm_corpse <- function(.) {   
  pwhc <- .super$env$moisture / .super$pars$whc  #percent water holding capacity
  c2c1 <- .super$state$c2 / .super$state$c1      #ratio of microbial biomass to unprotected carbon
 
  #calculate and return decomposition rate
  .super$state_pars$vmax1 * pwhc^3 * (1-pwhc)^2.5 * .super$state$c1 * (c2c1/(c2c1 + .super$pars$km1))
}

#transfer from unprotected to maom pool based on corpse (modified by clay content)
f_13_k_clay_corpse <- function(.) {
  .super$state$c1 * .super$state_pars$q *.super$pars$t1
}

#transfer from maom back to unprotected pool based on corpse (turnover independent of microbial activity)
f_31_k__corpse <- function(.) {
  .super$state$c3 * .super$pars$t3
}

#transfer from maom back to microbial biomass
f_32_none__corpse <- function(.) {
  0
}

#transfer from microbial biomass to maom pool based on corpse (modified by clay content)
f_23_k_clay_corpse <- function(.) {
  .super$state$c2 * .super$state_pars$q *.super$pars$t2
}


#State parameters
f_vmax1_arrhenius <- function(.) {
  #This is what it says in Sulman et al 2014  
  #.super$pars$vmax_maxref_1 * exp(-.super$pars$ea1/(.super$pars$R * .super$env$temp))
  #This is the actual function I think (the other is a mistake)
.super$pars$vmax_maxref_1 * exp(-.super$pars$ea1*((1/(.super$pars$R * .super$env$temp))-(1/(.super$pars$R * 293.15))))
}

f_q_corpse <- function(.) {
  0.59 * log(.super$env$clay) + 2.32
}

### END ###
