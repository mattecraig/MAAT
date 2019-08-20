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

#First-order decay of unprotected pool
f_12_k_none_ <- function(.) {
  .super$state$c1 * .super$pars$k1
}

#transfer from unprotected to maom pool based on corpse (modified by clay content)
f_13_k_clay_corpse <- function(.) {
  .super$state$c1 * .super$state_pars$q *.super$pars$t1
}

#zero transfer from unprotected to maom pool
f_13_none__mimics <- function(.) {
  0
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
  10^(0.59 * log10(.super$env$clay) + 2.32) / 10^(0.59 * log10(20) + 2.32)
}

### END ###



### FUNCTIONS to develop 
########################

#Hassink and Whitmore 1997
#Hassink1 MAOM saturation function
#C3max = max amount of MAOM-C storage
#C3max units = g C kg-1 soil
#21.1 + 0.0375*(percent Clay *10)

#Hassink and Whitmore 1997
#Hassink2 transfer from MBC to MAOM (some will also be lost as CO2 in this implicit-decay model)
#0.550 + 0.000447 * (percent Clay *10)

#Hassink and Whitmore 1997
#Hassink2 transfer from MBC to MAOM (some will also be lost as CO2 in this implicit-decay model)
#This coefficient represents the partioning of mbc turnover between non protected and protected SOM
#0.550 + 0.000447 * (percent Clay *10)

#Hassink and Whitmore 1997
#Hassink3 transfer from MBC to MAOM (some will also be lost as CO2 in this implicit-decay model)
#This coefficient represents the efficiency with which MBC turnover forms MAOM vs CO2 (i.e. MBC does not form POM as in Hassink2)
#0.471 - 0.000116 * (percent Clay *10)
#Note: Weird that this is a negative relationship after parameter estimation in this paper; They say it should be positive in the 
#model descriptions.


