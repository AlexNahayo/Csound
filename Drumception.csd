<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

;Kick drum
instr 1
;initial transtiins control of kick
kFreqA invalue "FreqA"                            ; Frequency ranges 100-300(Initial trascient).
kFreqS invalue "FreqSus"                          ; Sustain 0.1-0.5 (Main Body).
kFreqR invalue "FreqRel"                          ; release 1- 20 (tail).

; Output
klevel invalue "outs1"
; Disable instrument via button
kdisable1 invalue "disable1"                        ;disabale button is initialized.

kPan invalue "Pan1"                                ; Pan parameter correspondong with a knob.
printk2  kPan
aFreq  expseg i(kFreqA), i(kFreqS), i(kFreqR)     ; I added frequency.   
aEnv   expon   1, p3, 0.001                       ; p3 is in the properties in toggle.
aSig   poscil  aEnv*(1-kdisable1), aFreq           ; disable function kickin here. 
aSigL, aSigR pan2 aSig, kPan                      ; helps pan the left/right via a knob.
outs aSigL*klevel, aSigR*klevel
endin

;Clap
instr		2
kAttack invalue "ClapAtt"                         ; initial transcience .
kSustain invalue "ClapSus"                        ; main body.
kDecal invalue "ClapDec"                          ; tail of clap.

 ; Output.
klevel invalue "outs2"                             ; initialised here 
; Pan parameter. 
kPan2 invalue "Pan2"                                ; initialised here 
; Disable entire instrument via button. 
kdisable2 invalue "disable2"

; delay signal
kSendlevel invalue "delaylevel"                        ; signal is being send delay to inst 100
 
 ;i(kSustain)
idens  	=		8000
;														1st             2nd             3rd                4th
kenv			expseg				1,0.01,0.01, 0, 1,0.01,0.01, 0, 1,0.01,0.01, 0, 1, p3-(0.03), 0.00001
anoise	noise				kenv*(1-kdisable2), 0              ;here the disable is enabled 
kcf				expseg			i(kDecal), 0.03, i(kDecal), 0.07, 1700, 1, 800, 2,500 , 1, 500
aSig			butlp				anoise, kcf
aSig			buthp				aSig , kAttack
ares			butbp				aSig, kSustain , kSustain - 300   ;kDecal, kDecal - 300
aSig			=								((aSig) + (ares*6))
aSigL, aSigR pan2 aSig, kPan2                      ; helps pan the left/right via a knob.
	
outs aSigL*klevel,aSigR*klevel
chnmix   aSig*kSendlevel, "Send2"                  ; auxilary 
endin

instr 100
kFeedback invalue "DelayFeedB"                   ; feedback ratio 0.1-0.9%
kTime invalue "Delaytime"                        ; delay in seconds 0.1- 0.9 m/s


aIn     chnget    "Send2" 
aDelay   flanger  aIn, a(kTime) , kFeedback,1
        
outs      aDelay, aDelay        
chnclear  "Send2" 
endin

;Cowbell.
instr		3
;Output
klevel invalue "outs3"                            ; initialised here. 
;Pan parameter 
kPan3 invalue "Pan3"                               ; initialised here. 
;reverb signal
	kSendlevel invalue "reverbsend"                      ; signal is being send to instr 99. 
;frequency of waves.	
kpulsewavA invalue "PwavA"                       ; freqeuncy of pulse wave A.
kpulsewavB invalue "PwavB"                       ; freqeuncy of pulse wave B.
;pulse width of waves;
kPR invalue "pulserate" 
; Disable entire instrument via button.
kdisable invalue "disable3" 
	
aSqu1				vco2				1, kpulsewavA, 2, kPR									  ; create two square wave oscillators.
aSqu2				vco2				1, kpulsewavB, 2, kPR
aSquMix			=							(aSqu1 + aSqu2)*(1-kdisable)		 ; mix them together.
aBPF					butbp			aSquMix, 845, 25															 ; create a bandpass filtered version of the mix.
kEnv1				expseg		1, 0.015, 0.2, p3-0.015, 0.2			 ; create envelope 1.
aMix					=							(aBPF*kEnv1*4) + (aSquMix*0.04) ; mix the bandpass filtered and unfiltered sound together.
kEnv2				expseg		1, 0.05, 0.3, p3-0.05, 0.0001			; create envelope 2.
aMix1					=							aMix * kEnv2																		 ; apply envelope to the complete .
;pan 
aMixL,aMixR pan2 aMix1, kPan3                     ; helps pan the left/right via a knob.	
;output
outs aMixL*klevel,aMixR*klevel 

chnmix   aMix1*kSendlevel, "Send3" ;auxiliry 
endin


;reverb
instr 99
kFeedback invalue "RevFeedB"

aIn     chnget    "Send3" 
aL,aR   reverbsc  aIn, aIn, kFeedback, 7000
        
outs      aL, aR        
chnclear  "Send3"        
endin


;Dish
instr		4
;phasor is initialised here.
kfreq invalue "phaserFreq"                       ; Have it between 1000-10000hz.
kfilt invalue "phaserFilt"                       ;	Range from 50-3000 first order filters.
kfeed invalue "phaserFeed"                       ; Feedback will range from (-0.9 - 0.9.) 
;Pan
kPan4 invalue "Pan4"                               ; Initialised here. 
; Output
klevel invalue "outs4"
;Disable entire instrument via button.
kdisable invalue "disable4"

 iEnd					=				-90													          ; 'End' decibel value is being changed for each envelope.
                                         ;  An envelope is defined for each partial based on data from the spectrogram.
                                         ;  For each partial we use: 'starting dB', 'Time to reach final dB. 
                                         ;  The envelopes start from lowest partial to highest partial.  
 kAmpEnv1			line				-19, 2.40, iEnd  
 kAmpEnv2			line				-14, 1.8, iEnd
 kAmpEnv3			line				-15, 1.2, iEnd
 kAmpEnv4			line				-13, 1.1, iEnd
 kAmpEnv5			line				-16, 1.0, iEnd
 kAmpEnv6			line				-20, 0.8, iEnd
 kAmpEnv7			line				-13, 0.7, iEnd
 kAmpEnv8			line				-13, 0.6, iEnd
 kAmpEnv9			line				-18, 0.63, iEnd
 kAmpEnv10		line				-17, 0.4, iEnd
 kAmpEnv11		line				-16, 0.5, iEnd
 kAmpEnv12		line				-22, 0.35, iEnd
 kAmpEnv13		line				-22, 0.32, iEnd
 kAmpEnv14		line				-24, 0.28, iEnd
 kAmpEnv15		line				-22, 0.20, iEnd
 kAmpEnv16		line				-26, 0.23, iEnd
 kAmpEnv17		line				-22, 0.22, iEnd
 kAmpEnv18		line				-23, 0.20, iEnd
 kAmpEnv19		line				-24, 0.19, iEnd
 kAmpEnv20		line				-33, 0.14, iEnd
 kAmpEnv21		line				-30, 0.11, iEnd
 kAmpEnv22		line				-26, 0.08, iEnd
 kAmpEnv23		line				-28, 0.05, iEnd																		

                                          ; An oscillator is created for each partial.
                                          ; Notice how the envelopes - expressing values in dB - have to be converted to amplitude.
 a1								poscil		ampdbfs(kAmpEnv1), 415
 a2								poscil		ampdbfs(kAmpEnv2), 840
 a3								poscil		ampdbfs(kAmpEnv3), 1311
 a4								poscil		ampdbfs(kAmpEnv4), 1490
 a5								poscil		ampdbfs(kAmpEnv5), 1855
 a6								poscil		ampdbfs(kAmpEnv6), 2312
 a7								poscil		ampdbfs(kAmpEnv7), 2467
 a8								poscil		ampdbfs(kAmpEnv8), 3157
 a9								poscil		ampdbfs(kAmpEnv9), 3342
 a10							poscil		ampdbfs(kAmpEnv10), 3612
 a11							poscil		ampdbfs(kAmpEnv11), 3920
 a12							poscil		ampdbfs(kAmpEnv12), 4452
 a13							poscil		ampdbfs(kAmpEnv13), 4761
 a14							poscil		ampdbfs(kAmpEnv14), 5140
 a15							poscil		ampdbfs(kAmpEnv15), 5695
 a16							poscil		ampdbfs(kAmpEnv16), 6295
 a17							poscil		ampdbfs(kAmpEnv17), 6675
 a18							poscil		ampdbfs(kAmpEnv18), 6820
 a19							poscil		ampdbfs(kAmpEnv19), 7740
 a20							poscil		ampdbfs(kAmpEnv20), 8870
 a21							poscil		ampdbfs(kAmpEnv21), 8885
 a22							poscil		ampdbfs(kAmpEnv22), 9420
 a23							poscil		ampdbfs(kAmpEnv23), 10093
 
; All the partials have to be mixed together.
aMix						=							a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9 + a10 + a11 + a12 + a13 + a14 + a15 + a16 + a17 + a18 + a19 + a20 + a21 + a22 + a23 
; phasor1 is added here
ares phaser1 aMix, kfreq, kfilt, kfeed
; The mix of all partials is sent to the output and scaled in amplitude to prevent distortion.
aMixL, aMixR pan2 ares*(1-kdisable), kPan4  ; helps pan the left/right via a knob.
outs					aMixL*klevel,aMixR*klevel										
endin

</CsInstruments>
<CsScore>
i 99 0 3600   ;Reverb aux 
i 100 0 3600  ;Delay aux
</CsScore>
</CsoundSynthesizer>
