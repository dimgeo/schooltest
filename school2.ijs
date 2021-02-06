NB. minimalistic covid19 mass testing simulator
load 'viewmat'
load 'plot'


NB. -------------------- setup PCR simulation parameters and initial prevalence

spec=: 0.998
sens=: 0.95
prev=: 0.007



NB. -------------------- Consolidation filter to move TP and FP to quarantine (1,4->0) and FN to TP (2->1)

filter=: (- =&2) @ (] * 1 i. ]) ] * 4 i. ]    


NB. -------------------- Report results.
NB. -------------------- Usage: 1 2 3 4 rap"0 2 testround allschools, or 1 3 rap"0 2 for true, 2 4 for false results.
NB. 			 Utility function for reporting

rap=: 4 : '+/+/x = y'           
nnrap =: 3 : '0 1 2 3 4 rap"0 2  y'   NB. easy full report version


NB. -------------------- matrix of 1000 schools x 1000 pupils, healty=3, sick=1

allschools =: (?1000#1000)|."0 1  (1 ((prev*1000)? 1000)}"1 1  ( 1000 1000 $ 3))

NB.            ^^^ random position ^^^^^ 7% of 3's -> 1         ^^ 1000x1000 matrix with 3's


NB. -------------------- PCR simulator
NB.                      postest returns true positive depending on sens setting
NB.			 negtest returns true positive depending on spec setting
			 

postest=:  3 : '1:`2: @. (=&1)" 0 (?1000) > (sens * 1000)'    NB. 1: TP 2:FN 3:TN 4:
negtest=:  3 : '3:`4: @. (=&1)"0 (?1000) > (spec *1000 )'

NB. -------------------- Test 1000000 school children
NB. 			 Usage: testround allschools 
NB.			 Gerund function, visits each matrix cell, checks wether in quarantaine, tp, fn, tn, fp
NB. 			 If tp(1) or tn(3) (posterior, after quarantaine and consolidation) runs tests, or else returns input

testround=:  0:`(postest)`(])`(negtest)`(])  @. (])"0                                     


NB. -------------------- Experiment
NB.                      First testround, without consolidation

NB. newmat=: testround allschools    	  NB. Runs full test
NB. 
NB. nnrap filter newmat               	  NB. reports consolidated totals
NB. nnrap filter testround allschools 	  NB. reports consolidated totals on new test
NB. 
NB. filter testround allschools  		  NB. returns complete matrix (not very informative)
NB. 
NB. filter testround  ^:20 allschools	  NB. does 10 consolidated test rounds on entire population
NB.        		       			  NB. This basically simulates 10 rounds of mass testing of 1000000 schoolchildren


NB. -------------------- Full simulation
NB.                      Usage: n bigtest allschools
NB.                      Returns lines with quarantine, true positives, false negatives, true negatives, false positives

bigtest=: dyad define
i=. >:x
a=.y
while. i > 1 do.
b=. testround a
a=. filter b
i=.i-1
nnrap b
end.

)