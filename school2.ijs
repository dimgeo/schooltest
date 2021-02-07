NB. minimalistic covid19 mass testing simulator
load 'viewmat'
load 'plot'
load 'color16'

NB. -------------------- setup PCR simulation parameters and initial prevalence

spec=: 0.998
sens=: 0.95
prev=: 0.007
R=: 10        NB. No, not that R



NB. -------------------- Consolidation filter to move TP and FP to quarantine (1,4->0) and FN to TP (2->1)

filter=: (- =&2) @ (] * 1 i. ]) ] * 4 i. ]






NB. -------------------- Report results.
NB. -------------------- Usage: 1 2 3 4 rap"0 2 testround allschools, or 1 3 rap"0 2 for true, 2 4 for false results.
NB. 			 Utility function for reporting

rap=: 4 : '+/+/x = y'           
nnrap =: 3 : '0 1 2 3 4 rap"0 2  y'   NB. easy full report version


NB. -------------------- Infection factor from false negatives


infie=: 3 : '(1000, 1000) $ 1 ((>. R * 1 rap"0 2 y) {. (I. (,y=3))) } ,y'


NB. -------------------- matrix of 1000 schools x 1000 pupils, healthy=3, sick=1

allschools =: (?1000#1000)|."0 1  (1 ((prev*1000)? 1000)}"1 1  ( 1000 1000 $ 3))

NB.            ^^^ random position ^^^^^ 7% of 3's -> 1         ^^ 1000x1000 matrix with 3's


NB. -------------------- PCR simulator
NB.                      postest returns true positive depending on sens setting
NB.			 negtest returns true positive depending on spec setting
			 

postest=:  3 : '1:`2: @. (=&1)" 0 (?1000) > (sens * 1000)'    NB. 1: TP 2:FN 3:TN 4:
negtest=:  3 : '3:`4: @. (=&1)"0 (?1000) > (spec *1000 )'

NB. -------------------- Test 1000000 school children
NB. 			 Usage: testround allschools 
NB.			 Gerund function, visits each matrix cell, checks wether in quarantine, tp, fn, tn, fp
NB. 			 If tp(1) or tn(3) (posterior, after quarantine and consolidation) runs tests, or else returns input

testround=:  0:`(postest)`(])`(negtest)`(])  @. (])"0                                     


NB. -------------------- Experiment
NB.                      First testround, without consolidation

 newmat=: testround allschools    	  NB. Runs full test
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
quar=. 1000 1000 $ 13
i=. >:x
z=. 0 0 0 0 0
a=.y
while. i > 1 do.
b=. testround a
a=. filter b
quar=. quar - 3*(a=0)
a=.3 (<"0 quar < 0) } a
quar=. 13 (<"0 quar < 0) } quar
a=. infie a
z=. z, nnrap b
i=.i-1
end.
1}. (x , 5) $ z
)

NB. -------------------- plots

cap1=: 'Initial test group prevalence= ', (": 100 * prev ), ' %'
cap2=: 'Spec ', (": spec),', Sens ' ,(":sens)
cap3=: 'Test group size 1 million'
plotme=: verb define
pd 'reset'
pd 'title COVID19 mass testing implications'
pd 'xcaption Full population test runs'
pd 'ycaption People in Q or tested TP, FN, FP'

pd 'text 500 600 ', cap2
pd 'text 500 550 ', cap1
pd 'text 500 500 ', cap3
pd 'key "Quarantine" "True Positives" "False Negatives" "False Positives" "True negatives"  '
pd 'pensize 4'
lows=:  0 1 2 4 { |: zz
highs=:   3{|:zz
pd (i. #zz);lows
pd 'y2axis'
pd 'ycaption People tested TN'
pd (i. #zz);highs
 pd 'show'
)

NB. --------------------  Convenience function
runsim=: monad define
zz=: y bigtest allschools
)
