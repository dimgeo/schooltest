NB. minimalistic covid19 mass testing simulator
load 'viewmat'
load 'plot'

NB. -------------------- setup PCR simulation parameters and initial prevalence

9!:43 (4)

spec=: 0.998
sens=: 0.95
prev=: 0.007
R=: 0.3
quarantine_days=. 10

testing_freq=: 2

NB. -------------------- Color stuff

red=: 255 0 0
green =: 0 255 0
gray=: 200 200 200
blue=: 0 0 255
bla=: 0 127 127
blo=: 127 127 0
black=: 0 0 0


col=: 5 3 $ blue, black, green, gray,red

makeRGB=: 0&$: : (($,)~ ,&3)
fillRGB=: makeRGB }:@$
setPixels=: (1&{::@[)`(<"1@(0&{::@[))`]}
getPixels=: <"1@[ { ]
viewRGB=: [: viewrgb 256&#.


writeppm =: dyad define
   header =. 'P6',LF,(":1 0{$x),LF,'255',LF
  (header,,x{a.) fwrite y
)


NB. -------------------- Consolidation filter to move TP and FP to quarantine (1,4->0) and FN to TP (2->1)

filter=: (- =&2) @ (] * 1 i. ]) ] * 4 i. ]




NB. -------------------- Report results.
NB. -------------------- Usage: 1 2 3 4 rap"0 2 testround allschools, or 1 3 rap"0 2 for true, 2 4 for false results.
NB. 			 Utility function for reporting

rap=: 4 : '+/+/x = y'           
nnrap =: 3 : '0 1 2 3 4 rap"0 2  y'   NB. easy full report version


NB. -------------------- Infection factor from false negatives


infie=: 3 : '($ y ) $ 1 (((>. R * 1 rap"0 2 y) ? # s) { (s=: I. (,y=3))) } ,y'

NB. -------------------- matrix of 1000 schools x 1000 pupils, healty=3, sick=1

allschools =: (? 1000#1000)|."0 1  (1 ((prev*1000)? 1000)}"1 1  ( 1000 1000 $ 3))

NB.            ^^^ random position ^^^^^ 7% of 3's -> 1         ^^ 1000x1000 matrix with 3's


NB. -------------------- PCR simulator
NB.                      postest returns true positive depending on sens setting
NB.			 negtest returns true positive depending on spec setting
			 

postest=:  3 : '1:`2: @. (=&1)" 0 (? 100000) >: (sens * 100000)'    NB. 1: TP 2:FN 3:TN 4:
negtest=:  3 : '3:`4: @. (=&1)"0 (? 100000) >: (spec *100000 )'

NB. -------------------- Test 1000000 school children
NB. 			 Usage: testround allschools 
NB.			 Gerund function, visits each matrix cell, checks wether in quarantaine, tp, fn, tn, fp
NB. 			 If tp(1) or tn(3) (posterior, after quarantaine and consolidation) runs tests, or else returns input

testround=:  (])`(postest)`(])`(negtest)`(])  @. (])"0                                     


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
quar=. 1000 1000 $ quarantine_days
test_days=. x
i=. 0
z=. 0 0 0 0 0
a=.y
for_i. i. test_days do.
a=. (1000 1000) $ 3 (back=.I. (,quar)<0) }  (,a)
quar=. (1000 1000) $  quarantine_days (back) } ,quar
if. 0=testing_freq|i do.
b=. testround a
a=. filter b
r=. 200 200 {. a
(r{col) writeppm <'/home/dg/px/', (": i ), '.ppm'
z=. z, nnrap b
smoutput i
smoutput nnrap b
end.
quar=. quar - (a=0)
a=. infie a
end.
1}. ((>.test_days%testing_freq) , 5) $ z
)

NB. -------------------- plots

cap1=: 'Initial test group prevalence= ', (": 100 * prev ), ' %'
cap2=: 'Spec ', (": spec),', Sens ' ,(":sens)
cap3=: 'Test group size 1 million'
plotme=: verb define
pd 'reset'
pd 'title COVID19 pre-emptive testing, large scale implementation'
pd 'xcaption Number of test runs'
pd 'ycaption People in Q or tested TP, FN, FP'
pd 'keypos bre'
pd 'text 550 600 ', cap2
pd 'text 550 550 ', cap1
pd 'text 550 500 ', cap3
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
zz=:  y bigtest allschools
)


NB. -------------------- Dutch report code
 
rapport=: monad define
header=: 'testronde';'quarantaine';'juist positief';'fout negatief';'juist negatief';'fout positief';'% fout positief';'gemiste schooldagen qrc';'ouders qrc'
NB. header=: 'testronde';'juist positief';'fout negatief';'juist negatief';'fout positief'
rapzz=. y
smoutput kt=. +/\ quarantine_days * 4{"1 rapzz 
smoutput qt=. +/\2 * quarantine_days * 4{"1 rapzz 
fapo=.  >. 100 * (4{"1 rapzz) % (4{"1 rapzz + 1{"1 rapzz)

rapzz=. ((rapzz,.fapo),.kt),.qt
boxed=. <"0 (i. #rapzz) ,"0 1 rapzz

smoutput ''
smoutput ''
smoutput 'Testpopulatie 1 miljoen VO leerlingen'
smoutput 'Testfrequentie: ', (": testing_freq) ,' dagen'
smoutput 'Specificiteit: ',": spec
smoutput 'Sensitiviteit: ', ":sens
smoutput 'Startprevalentie: ' ,": prev
smoutput 'gemiste schooldagen qrc: ten onrechte gemiste schooldagen (cumulatief)'
smoutput 'ouders qrc: 2 ouders, ',( ": quarantine_days) , ' dagen ten onrechte in quarantaine (cumulatief)'
smoutput '            op basis van fout positieve uitslag kind'

header, boxed
)

test=: monad define
for_i. i. 10 do.
smoutput i
end.
)