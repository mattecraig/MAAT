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

##c1c2#########################

##1) MM decay of POM pool
f_c1c2_mm_none_li <- function(.) {
  (.super$state_pars$vmax1*.super$state$c2*.super$state$c1)/(.super$state_pars$km1+.super$state$c1)
}

##2) RMM decay of POM pool
f_c1c2_rmm_none_ <- function(.){
  (.super$state_pars$vmax1*.super$state$c2*.super$state$c1)/(.super$state_pars$km1+.super$state$c2)
} 

f_c1c2_0 <- function(.) {
  0
}

f_c1c2_1 <- function(.) {
  1
}
  
#) Reverse michaelis-Menton; CORPSE, controlled by temp and moisture
#f_12_rmm_tm_corpse <- function(.) {   
# # pwhc <- .super$env$moisture / .super$pars$whc  #percent water holding capacity
#  #c2c1 <- .super$state$c2 / .super$state$c1      #ratio of microbial biomass to unprotected carbon
 
          #calculate and return decomposition rate
#  .super$state_pars$vmax1 * pwhc^3 * (1-pwhc)^2.5 * .super$state$c1 * (c2c1/(c2c1 + .super$pars$km1))
#}

#) First-order decay of unprotected pool
#f_12_k_none_ <- function(.) {
#  .super$state$c1 * .super$pars$k1
#}

#) First-order decay of "non-protected" pool in Hassink1
#f_12_k_none_hassink1 <- function(.) {
#  .super$state$c1 * .super$pars$k12hassink
#}

##c1_c3#########################

#1) CORPSE, linear function of clay content
#f_c1c3_k_clay_corpse <- function(.) {
#  .super$state$c1 * .super$state_pars$q *.super$pars$t1
#}

#2) saturating adsorption function from Hassink1
f_c1c3_saturating_clay_hassink1 <- function(.){
  .super$pars$k13 * (1 - (.super$state$c3/.super$state_pars$maommax)) * .super$state$c1
}

#3) First-order decay of unprotected pool
f_c1c3_k_none_ <- function(.) {
  .super$state$c1 * .super$pars$k13
}

f_c1c3_0 <- function(.) {
  0
}

f_c1c3_1 <- function(.) {
  1
}

##c2_c1#########################

#1) Hassink1, second-order linear transfer
#.066 taken from Whitmore 1996 paper
#f_c2c1_k2__hassink1 <- function(.){
#  .super$state$c2^2 * .066 * .super$pars$k21hassink
#}

f_c2c1_0 <- function(.) {
  0
}

f_c2c1_1 <- function(.) {
  1
}

##c2_c3#########################

#1) First-order turnover of the microbial biomass pool
f_c2c3_k_none_li <- function(.){
  .super$state$c2*.super$pars$k23
}

#2) density-dependent turnover of the microbial biomass pool
f_c2c3_ndd_none_georgiou <- function(.){
  (.super$state$c2^.super$pars$ndd)*.super$pars$k23
}

f_c2c3_0 <- function(.) {
  0
}

f_c2c3_1 <- function(.) {
  1
}

#CORPSE, linear function of clay content
#f_c2c3_k_clay_corpse <- function(.) {
#  .super$state$c2 * .super$state_pars$q *.super$pars$t2
#}

##c3_c1#########################

#1) CORPSE linear transfer
#f_c3c1_k__corpse <- function(.) {
#  .super$state$c3 * .super$pars$t3
#}

#2) first-order decay of slow pool
f_c3c1_k_none_ <- function(.){
  .super$state$c3 * .super$pars$k31
}

f_c3c1_0 <- function(.) {
  0
}

f_c3c1_1 <- function(.) {
  1
}

##c3_c2#########################

##1) MM decay of MAOM pool
f_c3c2_mm_none_li <- function(.) {
  (.super$state_pars$vmax3*.super$state$c2*.super$state$c3)/(.super$state_pars$km3+.super$state$c3)
}

##2) RMM decay of MAOM pool
f_c3c2_rmm_none_ <- function(.) {
  (.super$state_pars$vmax3*.super$state$c2*.super$state$c3)/(.super$state_pars$km3+.super$state$c2)
}

f_c3c2_0 <- function(.) {
  0
}

f_c3c2_1 <- function(.) {
  1
}

##############################
#TRANSFER EFFICIENCY FUNCIONS#
##############################

##c1_c2eff#####################

#1) constant pom cue
f_c1c2eff_none_ <- function(.){
  .super$pars$cuec1
}

#2) Density-dependent POM CUE
f_c1c2eff_saturatingndd_ <- function(.){
  .super$pars$cuec1*(1-(.super$state$c2/.super$pars$mbcmax))
}


f_c1c2eff_0 <- function(.){
  0
}

f_c1c2eff_1 <- function(.){
  1
}

##c1_c3eff#####################
#1) Hassink3; function of clay
#The original paper had very high efficiencies that are
#probably unrealistic for this structure (POM and MAOM pools only)
#so scaling original function to a reference clay content and using a lower
#cue (from ICBM paper)
##changing int and slope to values from CENTURY (hassink equation barely changes transfer as a function of clay)
f_c1c3eff_lin_clay_century <- function(.){
  cue <-   .super$pars$cuec1
  int <-   .super$pars$e13int
  slope <- .super$pars$e13slope
  clay <-  .super$env$clay
  clayref <- .super$pars$clay_ref
  ((int + slope * (clay*.01)) / (int + slope * (clayref*.01))) * cue
}

#2) Hassink1; constant value
f_c1c3eff_const__ <- function(.){
  .super$pars$cuec1
}

#3) saturating function of the humification constant Hassink
f_c1c3eff_saturating_clay_hassink1 <- function(.){
  .super$pars$cuec1 * (1 - (.super$state$c3/.super$state_pars$maommax))
}

f_c1c3eff_0 <- function(.){
  0
}

f_c1c3eff_1 <- function(.){
  1
}


##c2_c1eff#####################
#f_c2c1eff___hassink <- function(.){
#  .super$pars$cuec1
#}

f_c2c1eff_0 <- function(.){
  0
}

f_c2c1eff_1 <- function(.){
  1
}

##c2_c3eff#####################
#1) Hassink3; function of clay
#The original paper had very high efficiencies that are
#probably unrealistic for this structure (POM and MAOM pools only)
#so scaling original function to a reference clay content and using a lower
#cue (from ICBM paper)
##changing int and slope to values from CENTURY (hassink equation barely changes transfer as a function of clay)
f_c2c3eff_lin_clay_century <- function(.){
  cue <-   .super$pars$cuec2
  int <-   .super$pars$e13int     #using same value from 13eff
  slope <- .super$pars$e13slope   #using same value from 13eff
  clay <-  .super$env$clay
  clayref <- .super$pars$clay_ref
  ((int + slope * (clay*.01)) / (int + slope * (clayref*.01))) * cue
}

f_c2c3eff_0 <- function(.){
  0
}

f_c2c3eff_1 <- function(.){
  1
}
  

#f_c2c3eff___corpse <- function(.){
#  .super$pars$t23eff
#}

##c3_c1eff#####################

f_c3c1eff_0 <- function(.){
  0
}

f_c3c1eff_1 <- function(.){
  1
}

##c3_c2eff#####################
#1)constant maom CUE (same as POM cue for now)
f_c3c2eff_none_ <- function(.){
  .super$pars$cuec3
}

#2) Density-dependent MAOM CUE
f_c3c2eff_saturatingndd_ <- function(.){
  .super$pars$cuec3*(1-(.super$state$c2/.super$pars$mbcmax))
}

f_c3c2eff_0 <- function(.){
  0
}

f_c3c2eff_1 <- function(.){
  1
}


#State parameters
f_vmax1_constMM <- function(.){
  .super$pars$vmax1_ref_MM
}

f_km1_constMM <- function(.){
  .super$pars$km1_ref_MM
}

f_vmax3_constMM <- function(.){
  .super$pars$vmax3_ref_MM
}

f_km3_constMM <- function(.){
  .super$pars$km3_ref_MM
}

f_maommax_hassink <- function(.) {
  21.1 + 0.0375*(.super$env$clay)*10
}

f_vmax1_const_rmm <- function(.){
  .super$pars$vmax1_ref_rmm
}

f_km1_const_rmm <- function(.){
  .super$pars$km1_ref_rmm
}

f_vmax3_const_rmm <- function(.){
  .super$pars$vmax3_ref_rmm
}

f_km3_const_rmm <- function(.){
  .super$pars$km3_ref_rmm
}

f_vmax1_arrhenius <- function(.) {
  #This is what it says in Sulman et al 2014  
  #.super$pars$vmax_maxref_1 * exp(-.super$pars$ea1/(.super$pars$R * .super$env$temp))
  #This is the actual function I think (the other is a mistake)
.super$pars$vmax_maxref_1 * exp(-.super$pars$ea1*((1/(.super$pars$R * .super$env$temp))-(1/(.super$pars$R * 293.15))))
}

f_q_corpse <- function(.) {
  10^(0.59 * log10(.super$env$clay) + 2.32) / 10^(0.59 * log10(.super$pars$clay_ref) + 2.32)
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


