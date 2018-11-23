

;--------------------------------
;;; Move #data to ram     
;--------------------------------
movlf	macro	d1,f1
	movlw	d1
	movwf	f1
	endm
;--------------------------------
; Move ram to ram        
;--------------------------------	
movff	macro	f1,f2
	movfw	f1
	movwf	f2
	endm
	
movff2	macro	f1,f2	
	movff	f1,f2
	movff	f1+1,f2+1
	endm
			
movff3	macro	f1,f2
	movff2	f1,f2
	movff	f1+2,f2+2
	endm

movff4	macro	f1,f2
	movff3  f1,f2
	movff   f1+3,f2+3
	endm

movff5	macro	f1,f2
	movff4  f1,f2
	movff   f1+4,f2+4
	endm

movff6	macro	f1,f2
	movff5  f1,f2
	movff   f1+5,f2+5
	endm


;;;****************************************
;;;    f1 = f1 / 2   ???  notece  cy  ?????
;;;****************************************
rrf4b	macro	f1
	rrf	f1,1
	rrf	f1-1,1
	rrf	f1-2,1
	rrf	f1-3,1
	endm








    
    