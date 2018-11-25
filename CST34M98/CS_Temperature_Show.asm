;------------------------------------------
; Name    : F_TEPture_Open
; Function: ��������
; Input   : 
; Output  : 
; Temp    :  
; Other   :
; log     :
;------------------------------------------	
/*
F_TEPture_Open:
	;ȫ��	
	movlw	08h				
	andlw	0fh
	movwf	R_DSP_BUFFER1
	
	movlw	08h					
	andlw	0fh
	movwf	R_DSP_BUFFER2
	movlw	08h					
	andlw	0fh
	movwf	R_DSP_BUFFER3
;	movlw	80h
;	IORWF	R_DSP_BUFFER9,1
	movlw	08h					
	andlw	0fh
	movwf	R_DSP_BUFFER4
	
;	movlw	08h					
;	andlw	0fh
;	movwf	R_DSP_BUFFER5	
;	
;	movlw	08h					
;	andlw	0fh
;	movwf	R_DSP_BUFFER6
;	
;	movlw	08h					
;	andlw	0fh
;	movwf	R_DSP_BUFFER7
	return
F_TMSR_Rest_Show:	
	;��ʾ
	clrf	R_DSP_BUFFER7
	movff3	R_RestL,R_SYS_A0
	call	F_Hex2BCD	
	movfw	R_SYS_C3			;��ʾC3�ĵ�4λ
	andlw	0fh
	movwf	R_DSP_BUFFER1
	
	swapf	R_SYS_C2,w			;��ʾC2�ĸ�4λ
	andlw	0fh
	movwf	R_DSP_BUFFER2
	movfw	R_SYS_C2			;��ʾC2�ĵ�4λ
	andlw	0fh
	movwf	R_DSP_BUFFER3
	movlw	80h
	IORWF	R_DSP_BUFFER9,1
	
	swapf	R_SYS_C1,w			;��ʾC1�ĸ�4λ
	andlw	0fh
	movwf	R_DSP_BUFFER4
	
	movfw	R_SYS_C1			;��ʾC1�ĵ�4λ
	andlw	0fh
	movwf	R_DSP_BUFFER5	
	
	swapf	R_SYS_C0,w			;��ʾC0�ĵ�4λ
	andlw	0fh
	movwf	R_DSP_BUFFER6
	
	movfw	R_SYS_C0			;��ʾC0�ĵ�4λ
	andlw	0fh
	movwf	R_DSP_BUFFER7
	return
	
F_Thermometer_AD_Show:	
	movff3	R_AD_OriginalADL,R_SYS_A0
	call	F_Hex2BCD	
	clrf	R_DSP_BUFFER9
	
	movfw	R_SYS_C3			;��ʾC3�ĵ�4λ
	andlw	0fh  
	movwf	R_DSP_BUFFER1
	
	swapf	R_SYS_C2,w			;��ʾC2�ĸ�4λ
	andlw	0fh
	movwf	R_DSP_BUFFER2
	
	movfw	R_SYS_C2			;��ʾC2�ĵ�4λ
	andlw	0fh
	movwf	R_DSP_BUFFER3	
	
	swapf	R_SYS_C1,w				;��ʾC1�ĵ�4λ
	andlw	0fh
	movwf	R_DSP_BUFFER4
	
	movfw	R_SYS_C1			;��ʾC1�ĵ�4λ
	andlw	0fh
	movwf	R_DSP_BUFFER5
	
	swapf	R_SYS_C0,w				;��ʾC0�ĵ�4λ
	andlw	0fh
	movwf	R_DSP_BUFFER6
	
	movfw	R_SYS_C0			;��ʾC0�ĵ�4λ
	andlw	0fh
	movwf	R_DSP_BUFFER7
	
	return	
	
	
F_AD_Temp_Show:	
	movff3	R_AD_AvgADL,R_SYS_A0
	call	F_Hex2BCD	
	clrf	R_DSP_BUFFER9
	movfw	R_SYS_C3			;��ʾC3�ĵ�4λ
	andlw	0fh  
	movwf	R_DSP_BUFFER1
	swapf	R_SYS_C2,w			;��ʾC2�ĸ�4λ
	andlw	0fh
	movwf	R_DSP_BUFFER2
	
	movfw	R_SYS_C2			;��ʾC2�ĵ�4λ
	andlw	0fh
	movwf	R_DSP_BUFFER3	
	
	swapf	R_SYS_C1,w				;��ʾC1�ĵ�4λ
	andlw	0fh
	movwf	R_DSP_BUFFER4
	
	movfw	R_SYS_C1			;��ʾC1�ĵ�4λ
	andlw	0fh
	movwf	R_DSP_BUFFER5
	
	swapf	R_SYS_C0,w			;��ʾC0�ĵ�4λ
	andlw	0fh
	movwf	R_DSP_BUFFER6
	
	movfw	R_SYS_C0			;��ʾC0�ĵ�4λ
	andlw	0fh
	movwf	R_DSP_BUFFER7
	return	
	
F_Temp_show:
	
	swapf	R_BCD_TempH,w		;��ʾC3�ĵ�4λ
	andlw	0fh  
	movwf	R_DSP_BUFFER1
	
	movfw	R_BCD_TempH			;��ʾC2�ĸ�4λ
	andlw	0fh
	movwf	R_DSP_BUFFER2
	
	swapf	R_BCD_TempL,w			;��ʾC3�ĵ�4λ
	andlw	0fh  
	movwf	R_DSP_BUFFER3
	
	movfw	R_BCD_TempL			;��ʾC2�ĸ�4λ
	andlw	0fh
	movwf	R_DSP_BUFFER4
	return
	
	
	
F_TEPture_Sleep_Show:
	;call    F_App_ShowNull
	movlw	00h				
	andlw	0fh
	movwf	R_DSP_BUFFER1
	
	movlw	0Fh					
	andlw	0fh
	movwf	R_DSP_BUFFER2
	movlw	0Fh					
	andlw	0fh
	movwf	R_DSP_BUFFER3
	return
	*/
	