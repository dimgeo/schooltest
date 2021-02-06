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

NB. > 1000 ltest blue
NB. ┌────┬───┬──────┬────┐
NB. │TP  │FN │TN    │FP  │
NB. ├────┼───┼──────┼────┤
NB. │6631│369│991969│1031│
NB. └────┴───┴──────┴────┘



NB. ----------- setup

blue=: 1 (7 ? 1000) } 1000 # 0    NB. a list of 1000 zeros with 7 1's at random positions
red=: 1 (48 ? 800) } 800  # 0     NB. a list of 800 zeros with 48 1's at random positions

sens=: 0.95
spec=: 0.998


NB. ----------- define test_school function
NB. ----------- explicit conditionals for readability


test_school =: monad define
if. y = 1 do.
pn=. 0 0
sensprob=: ? 1000
if. sensprob < (sens*1000) do.
pp=. 1 0      NB. true positive
else.
pp=. 0 1      NB. false negative
end.
end.

if. y = 0) do.
pp =. 0 0
specprob=: ? 1000
if. (specprob > (spec*1000)) do.
pn=. 0 1     NB. false positive
else.
pn=. 1 0     NB. true negative
end.
end.
pp,  pn
)

simulate=: test_school"0			NB. use rank 0


NB. ------------------- experiments

NB. What are the results you can expect when testing 5000 schools of the 'red' kind?
NB. Run 5000 ltest red


ltest=: dyad define
times=. >:x
school=. y
bigarray=.  ((#school),4) $ 0
while. times > 1 do.
bigarray=. bigarray, simulate school
times=. times -1
end.
header=. 'TP'; 'FN'; 'TN'; 'FP'
header,: <"0 +/bigarray
)




NB. ------------------- sample output functions (todo)

psim=: monad define				NB. print totals (new simulation)				    
header=. 'TP';'FN';'TN';'FP'
tests=. simulate y
totals=. +/tests
totbox=. <"0 totals
data=: <"0 tests,totals
header,:totbox
)


