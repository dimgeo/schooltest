# schooltest
Crude simulation of mass testing on schools given disease prevalence
NB. Testing simulation for schools
NB. Comparison between Blue and Red school given actual disease prevalence.
NB.
NB.
NB. School Blue: 1000 children, 7 are sick (low prevalence)
NB. School Red : 800 children, 48 are sick (high prevalence)
NB.
NB. What are the results of mass testing assuming a test gives positive
NB. 95% of the times that a child is sick and gives negative 99.8% of the times
NB. that a child is not sick? The sensitivity of 95% and the specificity of 99.8%
NB. are based on actual values of the WHO's PCR assay released for COVID19
NB.
NB.
NB. Examples:
NB. simulate red         -- runs a test on all 'schoolchildren' of school red and returns the result for each candidate
NB.    	     		    in a matrix with true positives, false negatives, true negatives and false positives
NB. psim red		 -- returns the totals in a boxed frame
NB. 1001 ltest blue      -- runs a simulation of 1001 schools of the blue type (low prevalence)

NB. > 1001 ltest blue
NB. ┌────┬───┬──────┬────┐
NB. │TP  │FN │TN    │FP  │
NB. ├────┼───┼──────┼────┤
NB. │6631│369│991969│1031│
NB. └────┴───┴──────┴────┘

