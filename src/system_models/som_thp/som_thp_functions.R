################################
#
# MAAT som_thp process representation functions (PRFs)
# 
# MAAT model: AWalker November 2017
# SOM model: MCraig August 2019
################################


### FUNCTIONS
################################

#########################
#DECOMPOSITION FUNCTIONS#
#########################

##c1_c2#########################

#1) Reverse michaelis-Menton; CORPSE, controlled by temp and moisture
f_12_rmm_tm_corpse <- function(.) {   
  pwhc <- .super$env$moisture / .super$pars$whc  #percent water holding capacity
  c2c1 <- .super$state$c2 / .super$state$c1      #ratio of microbial biomass to unprotected carbon
 
          #calculate and return decomposition rate
  .super$state_pars$vmax1 * pwhc^3 * (1-pwhc)^2.5 * .super$state$c1 * (c2c1/(c2c1 + .super$pars$km1))
}

#2) First-order decay of unprotected pool
f_12_k_none_ <- function(.) {
  .super$state$c1 * .super$pars$k1
}

#3) First-order decay of "non-protected" pool in Hassink1
f_12_k_none_hassink1 <- function(.) {
  .super$state$c1 * .super$pars$k12hassink
}

##c1_c3#########################

#1) CORPSE, linear function of clay content
f_13_k_clay_corpse <- function(.) {
  .super$state$c1 * .super$state_pars$q *.super$pars$t1
}

#2) zero transfer from unprotected to maom pool
f_13_none__mimics <- function(.) {
  0
}

#3) saturating adsorption function from Hassink1
  #### maom max function is not currently working and I'm not sure why, currently have replaced with "28"
  #.super$state_pars$maommax
f_13_saturating_clay_hassink1 <- function(.){
  .super$pars$k13hassink * (1 - .super$state$c3/28) * .super$state$c1
}

##c2_c1#########################

#1) Hassink1, second-order linear transfer
#.066 taken from Whitmore 1996 paper
f_21_k2__hassink1 <- function(.){
  .super$state$c2^2 * .066 * .super$pars$k21hassink
}

##c2_c3#########################

#CORPSE, linear function of clay content
f_23_k_clay_corpse <- function(.) {
  .super$state$c2 * .super$state_pars$q *.super$pars$t2
}

##c3_c1#########################

#CORPSE linear transfer
f_31_k__corpse <- function(.) {
  .super$state$c3 * .super$pars$t3
}

#Hassink1, linear transfer (desorption)
f_31_k__hassink1 <- function(.){
  .super$state$c3 * .super$pars$k31hassink
}

##c3_c2#########################

#1) no transfer

##############################
#TRANSFER EFFICIENCY FUNCIONS#
##############################

##c1_c2eff#####################

#constant pom cue
f_1cue_none_ <- function(.){
  .super$pars$cuec1
}

##c1_c3eff#####################

##c2_c1eff#####################
f_21eff___hassink <- function(.){
  .super$pars$cuec1
}

##c2_c3eff#####################
f_23eff___corpse <- function(.){
  .super$pars$t23eff
}

##c3_c1eff#####################

##c3_c2eff#####################



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

f_maommax_hassink1 <- function(.){
  21.1 + 0.0375*(.super$env$clay*10)
}

#generic function
f_0 <- function(.){
  0
}

f_1 <- function(.){
  1
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


