###########################
#
# som_thp for MAAT object unit testing
# 
# AWalker March 2017
#
###########################



### Load model scripts 
###############################

# som_thp
source('som_thp_object.R')
som_thp_object$.test()
som_thp_object$.test(verbose=T)

som_thp_object$.test_timestep()

som_thp_object$.test_thp_mm(som_thp.timestep = 1:36500, som_thp.cuec1 = .47, som_thp.cuec2 = .47, som_thp.cuec3 = .47, som_thp.vmax1_ref_MM = .2346, som_thp.km1_ref_MM = 101)
som_thp_object$.test_thp_rmm(som_thp.timestep = 1:36500)


som_thp_object$.test_change_env()

som_thp_object$.test_change_func()

som_thp_object$.test_change_pars()


som_thp_object$fnames
som_thp_object$fns
som_thp_object$state
som_thp_object$state_pars
som_thp_object$pars
som_thp_object$env



### END ###
