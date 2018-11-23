;�ֲ�����
R_AD_SEG_S              equ  R_ALC_AD_S
R_AD_SUM_TIMES          equ  R_AD_SEG_S+0       ;�ۼ���ʹ���
R_AvgBufADLL            equ  R_AD_SEG_S+1       ;32λAD��ͻ���bit7~0
R_AvgBufADL             equ  R_AD_SEG_S+2       ;32λAD��ͻ���bit15~8
R_AvgBufADH             equ  R_AD_SEG_S+3       ;32λAD��ͻ���bit23~16
R_AvgBufADHH            equ  R_AD_SEG_S+4       ;32λAD��ͻ���bit31~24	
;============================================
; ��ȡ�ڲ��¶ȴ�������AD��ʼ��
;============================================
; ��ڱ�����
; ���ڱ�����
; �м������
; ��־λ��
; ʵ�ֵĹ��ܣ�
;
; ����˼·��
;   NOP
;============================================
F_AD_Temp_Init:
	btfsc	R_Temperature_Flag,B_AD_Temp_Flag
   	return
   	call		F_App_ShowNull
   	movlf		E5H,ANACFG
	movlf		80H,ADCFG
	movlf		0FH,ADCON
	movlf		00h,TEMPC
    bsf			INTE, GIE
    bsf			ANACFG,LDOEN    ;LDOʹ��
    bsf 		INTE,	ADIE    ;ʹ��AD�ж�
    bcf			ANACFG, BGR_ENB ;��bandgap
    bsf			ANACFG,ADEN    ;ADʹ��
	bsf			R_Temperature_Flag,B_AD_Temp_Flag
	return
;�¶ȼ�������	
F_Temp:
	btfss	R_Temperature_Flag,B_AD_Temp_Flag
   	return
   	call	F_AD_GetTempAd				;��ȡADֵ��ǰADֵ
   	call    F_Temp_Get_Delta            ;��ȡDeltaֵ
   	call	F_Temp_GetTemperature       ;���㵱ǰ�¶�
   	call	F_Temp_Data_TX				;���ڷ�������
   	return 
;============================================
; �ɼ��¶�AD����
;============================================
; ��ڱ�����
; ���ڱ�����
; �м������
; ��־λ��
; ʵ�ֵĹ��ܣ�
; ����˼·��
;============================================
C_LostTempADTimes       equ  3          ;����AD�ı���
C_TempSumTimes          equ  4          ;�¶Ȳɼ�AD���ۼӱ���
C_GetTempADTimes        equ  C_LostTempADTimes + C_TempSumTimes
                                        ;�ܹ��ɼ���AD����

F_AD_GetTempAd:
    bcf     R_AD_FLAG,B_AD_PRE_OK
    call    F_AD_ClrSumBuf
L_AD_GetTempAd_L1:
    bcf     R_AD_FLAG,B_INT_GetAdc
L_AD_GetTempAd_L2:
    halt
    nop
    nop
    btfss   R_AD_FLAG,B_INT_GetAdc
    goto    L_AD_GetTempAd_L2
    incf    R_AD_SUM_TIMES,f
    movlw   C_LostTempADTimes+1         ;����ǰ�����ɱ�����
    subwf   R_AD_SUM_TIMES,w
    btfss   STATUS,C
    goto    L_AD_GetTempAd_L1

    ;-------------------------
    ;  ȡR_OriginalADx�ۼ�
    ;-------------------------
    call    F_AD_GetOrigin
    call    F_AD_AddSum
 
    movlw   C_GetTempADTimes
    subwf   R_AD_SUM_TIMES,w
    btfss   STATUS,C 
    goto    L_AD_GetTempAd_L1

    movlw   C_LostTempADTimes
    subwf   R_AD_SUM_TIMES,f
    ;---------------     ----------
    ;  ��ƽ��
    ;-------------------------
    call    F_AD_GetAvgAD

L_AD_GetTempAd_Exit:
    return
    
;-------------------------
;  ��ȡAD
;-------------------------
F_AD_GetOrigin:
    movff3  R_AD_OriginalADL,R_SYS_A0
    return   
;-------------------------
;  ȡR_OriginalADx�ۼ�
;-------------------------
F_AD_AddSum:
    movfw   R_SYS_A0
    addwf   R_AvgBufADLL,f
    movfw   R_SYS_A1
    addwfc  R_AvgBufADL,f
    movfw   R_SYS_A2
    addwfc  R_AvgBufADH,f
    movlw   0
    addwfc  R_AvgBufADHH,f
    return    
 ;------------    -------------
;  ��ȡADƽ��ֵ
;-------------------------
F_AD_GetAvgAD:
    clrf    R_SYS_A5
    clrf    R_SYS_A4
    movff4  R_AvgBufADLL,R_SYS_A0
    clrf    R_SYS_B2
    clrf    R_SYS_B1
    movfw   R_AD_SUM_TIMES
    movwf   R_SYS_B0
    call    F_Div24U                ;C2~0=A5~0/B2~0
    movff3  R_SYS_C0,R_AD_AvgADL

F_AD_ClrSumBuf:
    clrf    R_AD_SUM_TIMES
    clrf    R_AvgBufADLL
    clrf    R_AvgBufADL
    clrf    R_AvgBufADH
    clrf    R_AvgBufADHH
    return 

;============================================
; ��ڱ�����
; ���ڱ�����
; �м������
; ��־λ��
; ʵ�ֵĹ��ܣ���ȡADֵ���¶�ϵ��
; ����˼·��
;   NOP
;============================================    
F_Temp_GetDefaultDelta:
		movlw   1FH
		movwf   EADRH
		movlw   FAH
		movwf   EADRL		
		movp	
		movwf   Cali_T_adh
		
		movlw   1FH
		movwf   EADRH
		movlw   FBH
		movwf   EADRL	
		movp
		movwf   Cali_T_adll	
		movfw	EDAT
		movwf   Cali_T_adl
		
		movlw   1Fh
		movwf   EADRH
		movlw   FCh
		movwf   EADRL		
		movp
		movwf   Cali_temp_l	
		movfw	EDAT
		movwf   Cali_temp_h		
return

F_ADC:
	movlw	00h
	movwf	Cali_T_adhh
	movlw	3ah
	movwf	Cali_T_adh
	movlw	64h
	movwf	Cali_T_adl
	movlw	E2h
	movwf	Cali_T_adll
	movlw	CEh
	movwf   Cali_temp_l
	movlw	0Ah
	movwf   Cali_temp_h
	return
	
;============================================
; ����оƬ�ڲ��¶ȴ�����offset  
;============================================
; ��ڱ�����
; ���ڱ�����
; �м������
; ��־λ��
; ʵ�ֵĹ��ܣ�
;   Delta =(AD����<<8)/(T.00 + 27315)
; ����˼·��
;   NOP
;============================================
C_Temp_AbsTemp              equ     27315       ;0���϶ȶ�Ӧ�ľ����¶���273.15��
;--------------------------------------------
F_Temp_Get_Delta:
	call	F_Temp_GetDefaultDelta			;��ȡ�����ADֵ���¶�ϵ��
;	call	F_ADC
	call    F_CLR_SYS_ABC
	;Delta = AD<<8/(T+27315)
	movlw   LOW  C_Temp_AbsTemp
    addwf   Cali_temp_l,W
    movwf   R_SYS_B0
    movlw   HIGH C_Temp_AbsTemp
    addwfc  Cali_temp_h,W
    movwf   R_SYS_B1             
    clrf    WORK
    addwfc  R_SYS_B2,F
    ;//6A/B3
    movff3  Cali_T_adll,R_SYS_A1 ;//AD<<8
    call    F_Div24U
    ;---AD-
    movff3   R_SYS_C0, R_Temp_DeltaL
F_Temp_GetOffset_Exit:
    return   
   
;============================================
; ����оƬ�ڲ��¶�
;============================================
; ��ڱ�����
; ���ڱ�����
; �м������
; ��־λ��
; ʵ�ֵĹ��ܣ�
;   �¶�*100 =(AD����<<8)/Delta - 27315
; ����˼·��
;   NOP
;============================================
C_Temp_AbsTempDiv10         equ     27315        ;0���϶ȶ�Ӧ�ľ����¶���273.15��
;--------------------------------------------
F_Temp_GetTemperature:
    ;//(27315+T) = (AD<<8)/Delta
  	call    F_CLR_SYS_ABC
    movff3  R_AD_AvgADL,R_SYS_A1   
    movff3  R_Temp_DeltaL,R_SYS_B0
    ;//divide
    call    F_Div24U
    call    F_CLR_SYS_B
    movlw   LOW C_Temp_AbsTempDiv10
    movwf   R_SYS_B0
    movlw   HIGH  C_Temp_AbsTempDiv10
    movwf   R_SYS_B1
    call    F_ABS_24
    ;�������λ
    movff2  R_SYS_C0,R_Temp_OutL
F_ConverTempToBcd:
;    call  F_CLR_SYS_A
    movff   R_Temp_OutH,R_SYS_A1
    movff   R_Temp_OutL,R_SYS_A0
    call    F_Hex2BCD16
    movfw   R_SYS_C2
    movwf   R_BCD_TempH      ;
    movfw   R_SYS_C1
    movwf   R_BCD_TempL   
	return	    
F_Temp_Data_TX:
	movlw   FFH                     ;��ʼλ
	movwf   R_0TxData1
    movlw   55H	         
    movwf   R_0TxData2   
    movlw	00		
    movwf   R_0TxData3
    movfw   R_Temp_OutH                
    movwf   R_0TxData4 
    movfw   R_Temp_OutL               
    movwf   R_0TxData5 
    movlw   5                  
    movwf   R_0TxDataLength
    call    F_Uart0_Send_NByte
	return
;F_Temp_Data_TX1:
;	movlw   88H                     ;��ʼλ
;	movwf   R_0TxData1      
;    movfw	Cali_T_adhh		
;    movwf   R_0TxData2
;    movfw   Cali_T_adh                
;    movwf   R_0TxData3 
;    movfw   Cali_T_adl               
;    movwf   R_0TxData4 
;    movfw   Cali_T_adll               
;    movwf   R_0TxData5
;    movfw   Cali_temp_h               
;    movwf   R_0TxData6
;    movfw   Cali_temp_l              
;    movwf   R_0TxData7
;    movlw   7                  
;    movwf   R_0TxDataLength
;    call    F_Uart0_Send_NByte
;	return
