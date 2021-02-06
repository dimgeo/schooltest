# schooltest
Crude simulation of mass testing on schools given disease prevalence

COVID19 testing simulation for schools

Comparison between Blue and Red school given actual disease prevalence.


School Blue: 1000 children, 7 are sick (low prevalence)
School Red : 800 children, 48 are sick (high prevalence)

What are the results of mass testing assuming a test gives positive
95% of the times that a child is sick and gives negative 99.8% of the times
that a child is not sick? The sensitivity of 95% and the specificity of 99.8%
are based on actual values of the WHO's PCR assay released for COVID19


Examples:

simulate red         -- runs a test on all 'schoolchildren' of school red and returns the result for each candidate
          	     		    in a matrix with true positives, false negatives, true negatives and false positives
psim red	        	 -- returns the totals in a boxed frame
1001 ltest blue      -- runs a simulation of 1001 schools of the blue type (low prevalence)

1001 ltest blue
 ┌────┬───┬──────┬────┐
 
 │TP  │FN │TN    │FP  │
 
 ├────┼───┼──────┼────┤
 
 │6631│369│991969│1031│
 
 └────┴───┴──────┴────┘

