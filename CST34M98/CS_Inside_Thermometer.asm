;局部变量
R_AD_SEG_S              equ  R_ALC_AD_S
R_AD_SUM_TIMES          equ  R_AD_SEG_S+0       ;累计求和次数
R_AvgBufADLL            equ  R_AD_SEG_S+1       ;32位AD求和缓存bit7~0
R_AvgBufADL             equ  R_AD_SEG_S+2       ;32位AD求和缓存bit15~8
R_AvgBufADH             equ  R_AD_SEG_S+3       ;32位AD求和缓存bit23~16
R_AvgBufADHH            equ  R_AD_SEG_S+4       ;32位AD求和缓存bit31~24	
;============================================
; 读取内部温度传感器的AD初始化
;============================================
; 入口变量：
; 出口变量：
; 中间变量：
; 标志位：
; 实现的功能：
;
; 程序思路：
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
    bsf			ANACFG,LDOEN    ;LDO使能
    bsf 		INTE,	ADIE    ;使能AD中断
    bcf			ANACFG, BGR_ENB ;打开bandgap
    bsf			ANACFG,ADEN    ;AD使能
	bsf			R_Temperature_Flag,B_AD_Temp_Flag
	return
;温度计算流程	
F_Temp:
	btfss	R_Temperature_Flag,B_AD_Temp_Flag
   	return
   	call	F_AD_GetTempAd				;获取AD值当前AD值
   	call    F_Temp_Get_Delta            ;获取Delta值
   	call	F_Temp_GetTemperature       ;计算当前温度
   	call	F_Temp_Data_TX				;串口发送数据
   	return 
;============================================
; 采集温度AD函数
;============================================
; 入口变量：
; 出口变量：
; 中间变量：
; 标志位：
; 实现的功能：
; 程序思路：
;============================================
C_LostTempADTimes       equ  3          ;丢弃AD的笔数
C_TempSumTimes          equ  4          ;温度采集AD的累加笔数
C_GetTempADTimes        equ  C_LostTempADTimes + C_TempSumTimes
                                        ;总共采集的AD笔数

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
    movlw   C_LostTempADTimes+1         ;抛弃前面若干笔数据
    subwf   R_AD_SUM_TIMES,w
    btfss   STATUS,C
    goto    L_AD_GetTempAd_L1

    ;-------------------------
    ;  取R_OriginalADx累加
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
    ;  求平均
    ;-------------------------
    call    F_AD_GetAvgAD

L_AD_GetTempAd_Exit:
    return
    
;-------------------------
;  获取AD
;-------------------------
F_AD_GetOrigin:
    movff3  R_AD_OriginalADL,R_SYS_A0
    return   
;-------------------------
;  取R_OriginalADx累加
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
;  获取AD平均值
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
; 入口变量：
; 出口变量：
; 中间变量：
; 标志位：
; 实现的功能：获取AD值与温度系数
; 程序思路：
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
; 计算芯片内部温度传感器offset  
;============================================
; 入口变量：
; 出口变量：
; 中间变量：
; 标志位：
; 实现的功能：
;   Delta =(AD内码<<8)/(T.00 + 27315)
; 程序思路：
;   NOP
;============================================
C_Temp_AbsTemp              equ     27315       ;0摄氏度对应的绝对温度是273.15℃
;--------------------------------------------
F_Temp_Get_Delta:
	call	F_Temp_GetDefaultDelta			;获取保存的AD值与温度系数
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
; 计算芯片内部温度
;============================================
; 入口变量：
; 出口变量：
; 中间变量：
; 标志位：
; 实现的功能：
;   温度*100 =(AD内码<<8)/Delta - 27315
; 程序思路：
;   NOP
;============================================
C_Temp_AbsTempDiv10         equ     27315        ;0摄氏度对应的绝对温度是273.15℃
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
    ;处理符号位
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
	movlw   FFH                     ;起始位
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
;	movlw   88H                     ;起始位
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
