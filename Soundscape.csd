;This scene is located in an enclosed environment. It is a wet and windy evening. 
;There is high gusts of wind and torrential rain pouring on to the window (0:00- 1:95). 
;Tension begins to build as the rain and wind intensifies (0:06-0:55). 
;Bill appears and is eager to get inside, however he does not seem to have his keys for the house. 
;He rings the doorbell but no one answers (0:07). At this point the rain is getting more violent and he is now soaking wet. 
;In a desperate attempt to get inside Bill rings the doorbell franticly, but is greeted with silence (0:20). 
;In frustration he begins to knock on the door aggressively (0:40). Time is ticking as Bill slowly becomes consumed by the weather. 
;Meanwhile his brother Tom is inside the warm comfortable house hearing all the commotion but ignores Bill’s cry for help.  
;In this scene you are listening from the perspective of Tom inside the house. 

<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
nchnls = 2
0dbfs = 1

instr 1 ; Tones Code
kVibDepth expseg  0.01, 0.3, 0.01, 1, 10, 1, 10 
kVib  lfo  kVibDepth, p6 ;need some vibrato 
aFreq expseg p5,p4, 200, p5,p4, 400, p4,p5, 500 ; different frequencies parameters with correspoding p field can be seen below. for p5 i alternated 500-850 and p4 changed from 10 to 25 throighout the duration of the piece
aAenv expsegr 0.001, 0.6, 0.5,0.3, 0.001 ; amplitude envolope is being altered as the poscil tone in engaged 
aSig poscil aAenv  , aFreq*cent(kVib) ;the different are being altered by an lfo    
kfreq  = 500
kcutoff = 15
kfeedback = 0.8
aW wguide1 aSig, kfreq, kcutoff, kfeedback
    aL,aR	pan2					aW, random(0,1)
       outs     	aL,aR
 						chnmix			aL*0.3, "SendL"
 						chnmix			aR*0.3, "SendR"
endin

instr 100; signal will be sent to a flanger
aIn     chnget   "SendL" ; signal is initialised here 
aTime   =        p3
kFB     =        p4 
aDelay  flanger  aIn, aTime, kFB, 1 
outs    aDelay, aDelay        
chnclear "SendL"        
endin

instr 101; signal will be sent to a flanger
aIn     chnget   "SendR" ; signal is initialised here 
aTime   =        p3
kFB     =        p4 
aDelay  flanger  aIn, aTime, kFB, 1 
outs    aDelay, aDelay        
chnclear "SendR"
endin


instr 2
; first half of the sound
kAmpEnv1  line    -18, 1.26, -30 
kAmpEnv2  line    -17, 0.32, -30
kAmpEnv3  line    -33, 0.45, -45
kAmpEnv4  line    -15, 0.25, -35
kAmpEnv5  line    -35, 0.08, -49
 
a1 poscil ampdbfs (kAmpEnv1), 735
a2 poscil ampdbfs (kAmpEnv2), 1991
a3 poscil ampdbfs (kAmpEnv3), 3890
a4 poscil ampdbfs (kAmpEnv4), 6550
a5 poscil ampdbfs (kAmpEnv5), 15560
; all values were obtained using sonic visulaiser 

; All the partials have to be mixed together
aMix						=							a1 + a2 + a3 + a4 + a5 
; The mix of all partials is sent to the output and scaled in amplitude to prevent distortion
 										outs					aMix*0.2,aMix*0.2 
endin

instr 3
;second half of the sound
kAmpEnv6  line    -14, 0.94, -24
kAmpEnv7  line    -19, 0.13 , -31
kAmpEnv8  line    -26,0.70, -33
kAmpEnv9  line    -21, 0.18, -37
kAmpEnv10  line    -22,0.15, -33
kAmpEnv11 line    -28,0.24, -36

a6  poscil ampdbfs (kAmpEnv6), 535
a7  poscil ampdbfs (kAmpEnv7), 1480
a8  poscil ampdbfs (kAmpEnv8), 1712
a9  poscil ampdbfs (kAmpEnv9), 2990
a10 poscil ampdbfs (kAmpEnv10), 5100
a11 poscil ampdbfs (kAmpEnv11), 5100
; all values were obtained using sonic visulaiser 

; All the partials have to be mixed together
aMix						=						 a6 + a7 + a8 + a9+ a10 + a11 
; The mix of all partials is sent to the output and scaled in amplitude to prevent distortion
 										outs					aMix*0.2,aMix*0.2  
endin
; Door banging code
instr 4;main body 
aFreq  expseg  p4, 0.04, 20
aEnv   expon   p5, 0.3, 0.01 
aSig1   poscil  aEnv, aFreq 
aSig1 butlp aSig1 , 3000 ;as the knock changed in frequency i didn't want the knocks to sound bright  
outs aSig1, aSig1
chnmix   aSig1, "Send"  
endin

instr 5 ;initial click 
kEnv expon 1,0.001,0.4
aSig  noise  kEnv, 0
aSig butlp aSig , 1000
outs aSig, aSig
chnmix   aSig, "Send2"  
endin

instr     102 ; main body  
aIn     chnget    "Send" 
aL,aR   reverbsc  aIn, aIn, p4, 1000        
outs      aL, aR        
chnclear  "Send"       
endin 


instr 6 
imethod  =         p4 ; read panning method variable from score (p4)
;the sound source
aSig   pinkish   0.6          ; pink noise
iError random  0, 1
aSig   reson  aSig, 500, 100, p4     ;bandpass filtered asig, cf, bd, itype 
aPan   lfo       0.5, p7 , 1      ; panning controlled by an lfo
aPan     =         aPan +p5    ; offset shifted +0.5
aPanL    =         aPan
aPanR    =         p6- aPan
outs    aSig*aPanL, aSig*aPanR ; audio sent to outputs*/
;out aSig
endin

instr 7; Rain
 aSig		dust2				10, p4	
 aSig  butlp aSig, p5;cut off all high frequency 
 outs  aSig, aSig 
 chnmix aSig, "Send" 
endin

instr 103; Reverb send 
aIn   chnget    "Send"
aIn butlp aIn, 2500
aL,aR reverbsc aIn, aIn, p4, 1000
outs aL,aR
chnclear "Send" 
endin

instr	8 ; filtered dust sound
aSig								dust2				10, 5																																
kCFoct							randomi			 5, 10, 25																														
aSig								reson				aSig, cpsoct(kCFoct), cpsoct(kCFoct)*0.06, 1		
outs aSig,aSig
chnmix  aSig, "Send"         												
endin

instr 104 ; flanger send
aSig chnget "Send"
aTime = 0.3
kFB   = 0.3
aDelay flanger aSig, aTime,kFB, 1
outs aDelay, aDelay
chnclear "Send"
endin 

instr 9 ;clock tick code. 
kEnv expseg  0.01, 0.01, 1, 0.01, 0.01, 0.01, 0.01 , 0.001, 0.0001; closest i got to a clock tick  
aSig  noise  kEnv, 0
aSig butlp aSig , 10000 ;three filters needed 
aSig buthp aSig , 5000 
kFreq = p4  ;variation of each tick 
kGain =      ampdbfs(10) 
kQ    =      0.0625 ; 1+1/2 semitones
aSig  pareq  aSig, kFreq, kGain, kQ; this helped sharpen the sound 

out aSig; tick on the is panned left
chnmix   aSig, "SendL" ; reverb link 
endin

instr 105 ; the reverb itself will be 
aSig  chnget "SendL" 
aSigL,aSigR  reverbsc  aSig, aSig, 0.85,500    
outs    aSigL,aSigR        
chnclear  "SendL"        
endin

</CsInstruments>
<CsScore>

 ;TONE score event 
 i  1  5  50     10       500    2 ; layered the the different frequencies
 i  1  5  50     10       650    2
 i  1  5  50     10       750    2
 i  1  5  50     10       850    2
  
 i  1  10 50     25       950    5
 i  1  10 50     25       750    5
 i  1  10 50     25       650    5
 i  1  10 50     25       500    5
 
 ;Flanger on the left channel 
 i  100 5  25  0.001  0.005
 i  100 10 35  0.01   0.03
 i  100 25 45  0.02   0.04
 i  100 30 55  0.03   0.05
 i  100 45 65  0.05   0.05
 i  100 50 75  0.3    0.5
 
; Delay on the Right channel  
 i  101 5  25  0.001  0.005
 i  101 10 35  <      <
 i  101 25 45  <      <
 i  101 30 55  <      <
 i  101 45 65  <      <
 i  101 50 75  0.2    0.7
 
 ;Door Bell Score event 
i 2 10 2
i 2 18 2
i 2 30 2
i 2 32 2
i 2 31 2
i 2 32 2
i 2 33 2


; first half      
; second half
i 3 10.320 2
i 3 18.320 2
i 3 30.320 2
i 3 31.320 2
i 3 32.320 2
i 3 33.320 2


; Banging on the door score event    
i 4   34     5    350  0.4  
i 4   34.172 5    360  0.5  
i 4   34.351 5    380  0.7  
i 4   34.539 5    400  1  

i 4   35     5     355  0.7  
i 4   35.172 5    360  0.6   
i 4   35.351 5    375  0.8 
i 4   35.727 5    390  0.9
i 4   35.915 5    395  1

i 4   37     5    350  1  
i 4   37.172 5    360  0.4    
i 4   37.351 5    370  1  
i 4   37.727 5    395  0.3 
i 4   37.915 5    400  1

i 4   38     5    340  1
i 4   38.172 5    360  0.4
i 4   38.351 5    360  0.9
i 4   38.915 5    375  1
i 4   39.479 5    400  0.7
i 4   39.479 5    400  1

;initial transcient 
i 5   34     5    
i 5   34.172 .    
i 5   34.351 .    
i 5   34.539 .
i 5   35     .     
i 5   35.172 .    
i 5   35.351 .    
i 5   35.727 .    
i 5   35.915 . 
i 5   37     .     
i 5   37.172 .    
i 5   37.351 .    
i 5   37.727 .    
i 5   37.915 .   
  

i 102  34     15    0.3
i 102  34.172  .    0.45
i 102  34.351  .    0.4
i 102  34.539  .    0.6
i 102  35      .    0.3
i 102  35.172  .    0.45
i 102  35.351  .    0.7
i 102  35.727  .    0.9
i 102  35.915  .    0.55
i 102  37      .    0.3
i 102  37.172  .    0.55
i 102  37.351  .    0.65
i 102  37.727  .    0.39
i 102  37.915  .    0.75

;Outdoors sounds 
;Wind 
i 6  0   16   1    0.5     1     0.3
i 6  15  31  1    0.25    0.75  0.4
i 6  30  46  1.25 0.5     1     0.5
i 6  45  61  1    0.25    0.75  0.3
i 6  55  65  1    0.5     0.75  0.1

;i 4  10  25  1
;Rain 
i 7 0  22 50 250
i 7 20 31 75 400
i 7 30 41 80 450
i 7 45 65 90 425
;Reverb send  
i 103 0  21 0.3
i 103 20 31 0.5
i 103 30 41 0.7
i 103 40 51 0.5
i 103 50 61 0.5
i 103 60 61 0.5

;Rain Drops 
i 8 0 65
;flanger send
i 104 0 65

;clock tick upcode 
i 9 40 1  11000
i . +  .  <
i . +  .  <
i . +  .  <
i . +  .  <
i . +  .  <
i . +  .  <
i . +  .  <
i . +  .  <
i . +  .  12500
i . +  .  <
i . +  .  <
i . +  .  <
i . +  .  <
i . +  .  <
i . +  .  < 
i . +  .  < 
i . +  .  < 
i . +  .  < 
i . +  .  < 
i . +  .  11150  
;reverb send for clock tick.
i 105 40 60
</CsScore>
</CsoundSynthesizer>
