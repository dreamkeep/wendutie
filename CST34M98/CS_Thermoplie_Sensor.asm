F_Thmpsr_ADShort_Init:
;-----------------------------------------------------------------
	;AD�ڶ�ֻҪ����Ϊ�ڶ�ģ����
	;-----------------------------------------------------------------	
	;btfsc		R_Temperature_Flag,B_Thmpsr_ADShort_Flag
   	;return
   ;call		F_App_ShowNull
	bsf         ANACFG,1
	bcf         ANACFG,2
	;movlw		11100011b			;ANACFG:(�ϵ�Ĭ��ֵΪ:00000000)
	;movwf		ANACFG				;Bit7	LDOEN: LDO��Դʹ���ź�
									;	0 = LDO��Դ��ʹ��
									;	1 = LDO��Դʹ��*
									
									;Bit6-5	LDOS[1:0]: VS��ѹֵѡ��
									;	00 = VS=3.3V
									;	01 = VS=3.0V
									;	10 = VS=2.45V
									;	11 = VS=2.35V*
									
									;Bit4	BGR_ENB: bandgapʹ��
									;	0 = ��bandgap*
									;	1 = �ر�bandgap
									
									;Bit3	BGID: ADCģʽѡ����METCH[3]����ADCģʽ(Metch[3]Ĭ��ֵ0)
									;	BGID=0/METCH[3]=x	�͹���ģʽ*
									;	BGID=1/METCH[3]=0	������ģʽ
									;	BGID=1/METCH[3]=1	��ǿ������ģʽ
	
									;Bit2-1	SINL[1:0]: ADCͨ��ѡ��
									;	00 = 24bit-ADC��������ӵ�AIN0��AIN1��AIN0ΪVin+��AIN1ΪVin-
									;	01 = �ڶ�*
									;	10 = 24bit-ADC��������ӵ�TEMP
									;	11 = 24bit-ADC��������ӵ�AIN2��AIN3��AIN2ΪVin+��AIN3ΪVin-
	
									;Bit0	ADEN: 24Bit-ADCʹ�ܱ�־
									;	0 = 24bit-ADC��ʹ��*
									;	1 = 24bit-ADCʹ��
   ;bsf			ANACFG,ADEN	  		;ʹ��24bit-ADC
;	bsf			R_Temperature_Flag,B_Thmpsr_ADShort_Flag  ;��ʼ����ɱ�־λ
	return 
	
F_Thmpsr_AIN01_Init: ;AIN0ΪVin+��AIN1ΪVin-
	bcf      ANACFG,1
	bcf       ANACFG,2
	return

F_Thmpsr_AIN23_Init:  ;AIN2ΪVin+��AIN3ΪVin-
	bsf      ANACFG,1
	bsf       ANACFG,2
	return
	

;------------------------------------------
; Name    : F_TMSR_AD_Data_TX
; Function: ����AD����
; Input   : 
; Output  : 
; Temp    :  
; Other   :
; log     :
;------------------------------------------	
/*
F_Thmpsr_ADShort_Data_TX:
	btfss	R_Temperature_Flag,B_Thmpsr_ADShort_Flag
   	return
	btfss	R_Flag_Sys,B_AD_30MS
	return	
	movlw	2									;<�޶�ָ��߽�>
	subwf	R_Thmpsr_ADShort_Pointer,0
	btfsc	STATUS,C
	return
	movfw	R_Thmpsr_ADShort_Pointer				;��ת����Ӧ�Ĳ���
	addpcw	
	goto	F_Thmpsr_ADShort_Data_TX1
	goto	F_Thmpsr_ADShort_Data_TX2
F_Thmpsr_ADShort_Data_TX1:
	movlw   DDH                     ;��ʼλ
	movwf   R_0TxData1
    movlw   55H	         
    movwf   R_0TxData2 
    
    movfw	R_AD_OriginalADH					;����ֵ��8λ
    movwf   R_0TxData3
    movfw   R_AD_OriginalADM					;����ֵ�м�8λ 
    movwf   R_0TxData4   
    movfw   R_AD_OriginalADL					;����ֵ��8λ  
    movwf   R_0TxData5  
    movlw   5                  
    movwf   R_0TxDataLength
    call    F_Uart0_Send_NByte
    incf	R_Thmpsr_ADShort_Pointer,1
    goto	F_TMSR_AD_Data_Exit
F_Thmpsr_ADShort_Data_TX2:
	movfw	R_AD_OriginalADH					;����ֵ��8λ
    movwf   R_0TxData1
    movfw   R_AD_OriginalADM					;����ֵ�м�8λ 
    movwf   R_0TxData2  
    movfw   R_AD_OriginalADL					;����ֵ��8λ  
    movwf   R_0TxData3  	
    movlw   3                  
    movwf   R_0TxDataLength
    call    F_Uart0_Send_NByte
   	movlw	28									;����29��AD��ֵ
	subwf	R_Thmpsr_ADShort_Count,0
	btfsc	STATUS,C
	goto	$+3
	incf	R_Thmpsr_ADShort_Count,1
	goto	F_Thmpsr_ADShort_Data_Exit
	clrf	R_Thmpsr_ADShort_Pointer
	clrf	R_Thmpsr_ADShort_Count
	movlf	1,R_ST_Delay0		;��ʱ(@cpuclk=2MHz)
	call	F_delay_1mclk		;����ʱ��������ʾ�Ѿ�������һ������
	;����ʱ��������ʾ�Ѿ�������һ������
F_Thmpsr_ADShort_Data_Exit:      
;  	call	F_AD_Show
   	bcf		R_AD_FLAG,B_INT_GetAdc
    return */
/*  
F_Thmpsr_Init:
;-----------------------------------------------------------------
	;����24bit-ADC
	;b��c�ο���ѹ2.35��
	;c����ѹ���裺30K��
	;d��AD Gain=25��
	;e����Ƶ8MHZ������Ƶ��250KHZ��
	;f��AD���Ƶ��Ϊ30.5HZ��
	;-----------------------------------------------------------------
	;btfsc		R_Temperature_Flag,B_Thermoplie_Flag
   	;return	
   	;call		F_App_ShowNull
	movlw		11100000b			;ANACFG:(�ϵ�Ĭ��ֵΪ:00000000)
	movwf		ANACFG				;Bit7	LDOEN: LDO��Դʹ���ź�
									;	0 = LDO��Դ��ʹ��
									;	1 = LDO��Դʹ��*
									
									;Bit6-5	LDOS[1:0]: VS��ѹֵѡ��
									;	00 = VS=3.3V
									;	01 = VS=3.0V
									;	10 = VS=2.45V
									;	11 = VS=2.35V*
									
									;Bit4	BGR_ENB: bandgapʹ��
									;	0 = ��bandgap*
									;	1 = �ر�bandgap
									
									;Bit3	BGID: ADCģʽѡ����METCH[3]����ADCģʽ(Metch[3]Ĭ��ֵ0)
									;	BGID=0/METCH[3]=x	�͹���ģʽ*
									;	BGID=1/METCH[3]=0	������ģʽ
									;	BGID=1/METCH[3]=1	��ǿ������ģʽ
	
									;Bit2-1	SINL[1:0]: ADCͨ��ѡ��
									;	00 = 24bit-ADC��������ӵ�AIN0��AIN1��AIN0ΪVin+��AIN1ΪVin-*
									;	01 = �ڶ�
									;	10 = 24bit-ADC��������ӵ�TEMP
									;	11 = 24bit-ADC��������ӵ�AIN2��AIN3��AIN2ΪVin+��AIN3ΪVin-
	
									;Bit0	ADEN: 24Bit-ADCʹ�ܱ�־
									;	0 = 24bit-ADC��ʹ��*
									;	1 = 24bit-ADCʹ��

	bcf			ADCON,7				;	1'b1 = <�ر�>��ǿ������ģʽ
	
	bsf			ADCON,3				;	4'b1101 = CK_SMP/8192 = 30.5Hz<���Datasheet>
	bsf			ADCON,2
	bcf			ADCON,1
	bsf			ADCON,0

	movlw		10100100b			;ADCFG:(�ϵ�Ĭ��ֵΪ:00000000)
	movwf		ADCFG				;Bit7-5	ADSC/F_GAIN[1:0]: ADC�Ĳ���ʱ��Ƶ��ѡ��(CK_SMP)
									;	0/00 = ICK/4/8
									;	0/01 = ICK/4/8
									;	0/10 = ICK/4/12
									;	0/11 = ICK/4/16
									;	1/00 = ICK/2/8
									;	1/01 = ICK/2/8
									;	1/10 = ICK/2/12
									;	1/11 = ICK/2/16* --> CK_SMP = 8MHz/2/16 = 250KHz
	
									;Bit4-2	S_GAIN[1:0]/R_GAIN:

									;ADC��PGAѡ��: F_GAIN[1:0]/R_GAIN/S_GAIN[1:0]
									;	00/0/00 = Gain = 1
									;	00/0/01 = Gain = 10
									;	00/0/10 = Gain = 20
									;	00/0/11 = Gain = 21
									;	00/1/00 = Gain = 2.5
									;	00/1/01 = Gain = 25
									;	00/1/10 = Gain = 50
									;	00/1/11 = Gain = 52.5
	
									;	01/0/00 = Gain = 8
									;	01/0/01 = Gain = 80
									;	01/0/10 = Gain = 160
									;	01/0/11 = Gain = 168
									;	01/1/00 = Gain = 20
									;	01/1/01 = Gain = 200
									;	01/1/10 = Gain = 400
									;	01/1/11 = Gain = 420	

									;	10/0/00 = Gain = 12
									;	10/0/01 = Gain = 120
									;	10/0/10 = Gain = 240
									;	10/0/11 = Gain = 252
									;	10/1/00 = Gain = 30
									;	10/1/01 = Gain = 300
									;	10/1/10 = Gain = 600
									;	10/1/11 = Gain = 630
	
									;	11/0/00 = Gain = 16 
									;	11/0/01 = Gain = 160
									;	11/0/10 = Gain = 320
									;	11/0/11 = Gain = 336
									;	11/1/00 = Gain = 40*
									;	11/1/01 = Gain = 400 
									;	11/1/10 = Gain = 800 
									;	11/1/11 = Gain = 840	

									;Bit1-0	CHOPM[1:0]: 24bit-ADCն��ѡ��
									;	00 = ն��Ƶ������Ϊ����Ƶ�ʵ�1/32*
									;	01 = �ر�ն��
									;	10 = ն��Ƶ������Ϊ����Ƶ�ʵ�1/256
									;	11 = �ر�ն��

	;<�������Ժ���ȷ������>
	movlw		01000000b			;TEMPC:(�ϵ�Ĭ��ֵΪ:00000000)
	movwf		TEMPC				;Bit7-4	TEMPC[7:4]: �����¶����Բ���(ppm)@2.4V
									;	011/0 = -130
									;	010/0 = -90*
									;	001/0 = -45
									;	000/0 = 0
									;	100/0 = 0
									;	101/0 = 45
									;	110/0 = 90
									;	111/0 = 130
									;	011/1 = -13
									;	010/1 =	-9
									;	001/1 = -4
									;	000/1 = 0
									;	100/1 = 0
									;	101/1 = 4
									;	110/1 = 9
									;	111/1 = 13
	
									;Bit3-1	TEMPC[3:1]: 24bit-ADCģ�������˲���������ֵ����
									;	000 = 0.25k//0.25k//0.25k
									;	001 = 0.25k//0.25k
									;	010 = 0.25k//0.25k
									;	011 = 0.25k
									;	100 = 0.25k//0.25k
									;	101 = 0.25k
									;	110 = 0.25k
									;	111 = 0.25k
									
									;Bit0	NC
	
	movlf		10,R_ST_Delay0		;��ʱ5ms(@cpuclk=2MHz)
	call		F_delay_1kclk	

	bsf			ANACFG,ADEN			;ʹ��24bit-ADC
		
	;bsf			R_Temperature_Flag,B_Thermoplie_Flag   ;��ʼ����ɱ�־λ	
	return 
	*/
;------------------------------------------
; Name    : F_TMSR_AD_Data_TX
; Function: ����AD����
; Input   : 
; Output  : 
; Temp    :  
; Other   :
; log     :
;------------------------------------------	
	/*
F_Thmpsr_AD_Data_TX:
	btfss	R_Temperature_Flag,B_Thermoplie_Flag
   	return
	btfss	R_Flag_Sys,B_AD_30MS
	return	
	movlw	2									;<�޶�ָ��߽�>
	subwf	R_Thermoplie_Pointer,0
	btfsc	STATUS,C
	return
	movfw	R_Thermoplie_Pointer				;��ת����Ӧ�Ĳ���
	addpcw	
	goto	F_Thmpsr_AD_Data_TX1
	goto	F_Thmpsr_AD_Data_TX2
F_Thmpsr_AD_Data_TX1:
	movlw   EEH                     ;��ʼλ
	movwf   R_0TxData1
    movlw   55H	         
    movwf   R_0TxData2 
    
    movfw	R_AD_OriginalADH					;����ֵ��8λ
    movwf   R_0TxData3
    movfw   R_AD_OriginalADM					;����ֵ�м�8λ 
    movwf   R_0TxData4   
    movfw   R_AD_OriginalADL					;����ֵ��8λ  
    movwf   R_0TxData5  
    movlw   5                  
    movwf   R_0TxDataLength
    call    F_Uart0_Send_NByte
    incf	R_Thermoplie_Pointer,1  
    goto	F_TMSR_AD_Data_TX_Exit
F_Thmpsr_AD_Data_TX2:
	movfw	R_AD_OriginalADH					;����ֵ��8λ
    movwf   R_0TxData1
    movfw   R_AD_OriginalADM					;����ֵ�м�8λ 
    movwf   R_0TxData2  
    movfw   R_AD_OriginalADL					;����ֵ��8λ  
    movwf   R_0TxData3  	
    movlw   3                  
    movwf   R_0TxDataLength
    call    F_Uart0_Send_NByte
   	movlw	28									;����29��AD��ֵ
	subwf	R_Thermoplie_Count,0
	btfsc	STATUS,C
	goto	$+3
	incf	R_Thermoplie_Count,1
	goto	F_TMSR_AD_Data_TX_Exit
	clrf	R_Thermoplie_Pointer
	clrf	R_Thermoplie_Count
	movlf	1,R_ST_Delay0		;��ʱ(@cpuclk=2MHz)
	call	F_delay_1mclk		;����ʱ��������ʾ�Ѿ�������һ������
F_TMSR_AD_Data_TX_Exit:      
;  	call	F_AD_Show
   	bcf		R_AD_FLAG,B_INT_GetAdc
    return	   */