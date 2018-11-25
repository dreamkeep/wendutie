F_Thmpsr_ADShort_Init:
;-----------------------------------------------------------------
	;AD内短只要设置为内短模即可
	;-----------------------------------------------------------------	
	;btfsc		R_Temperature_Flag,B_Thmpsr_ADShort_Flag
   	;return
   ;call		F_App_ShowNull
	bsf         ANACFG,1
	bcf         ANACFG,2
	;movlw		11100011b			;ANACFG:(上电默认值为:00000000)
	;movwf		ANACFG				;Bit7	LDOEN: LDO电源使能信号
									;	0 = LDO电源不使能
									;	1 = LDO电源使能*
									
									;Bit6-5	LDOS[1:0]: VS电压值选择
									;	00 = VS=3.3V
									;	01 = VS=3.0V
									;	10 = VS=2.45V
									;	11 = VS=2.35V*
									
									;Bit4	BGR_ENB: bandgap使能
									;	0 = 打开bandgap*
									;	1 = 关闭bandgap
									
									;Bit3	BGID: ADC模式选择，与METCH[3]控制ADC模式(Metch[3]默认值0)
									;	BGID=0/METCH[3]=x	低功耗模式*
									;	BGID=1/METCH[3]=0	高性能模式
									;	BGID=1/METCH[3]=1	加强高性能模式
	
									;Bit2-1	SINL[1:0]: ADC通道选择
									;	00 = 24bit-ADC输入端连接到AIN0和AIN1，AIN0为Vin+，AIN1为Vin-
									;	01 = 内短*
									;	10 = 24bit-ADC输入端连接到TEMP
									;	11 = 24bit-ADC输入端连接到AIN2和AIN3，AIN2为Vin+，AIN3为Vin-
	
									;Bit0	ADEN: 24Bit-ADC使能标志
									;	0 = 24bit-ADC不使能*
									;	1 = 24bit-ADC使能
   ;bsf			ANACFG,ADEN	  		;使能24bit-ADC
;	bsf			R_Temperature_Flag,B_Thmpsr_ADShort_Flag  ;初始化完成标志位
	return 
	
F_Thmpsr_AIN01_Init: ;AIN0为Vin+，AIN1为Vin-
	bcf      ANACFG,1
	bcf       ANACFG,2
	return

F_Thmpsr_AIN23_Init:  ;AIN2为Vin+，AIN3为Vin-
	bsf      ANACFG,1
	bsf       ANACFG,2
	return
	

;------------------------------------------
; Name    : F_TMSR_AD_Data_TX
; Function: 发送AD数据
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
	movlw	2									;<限定指针边界>
	subwf	R_Thmpsr_ADShort_Pointer,0
	btfsc	STATUS,C
	return
	movfw	R_Thmpsr_ADShort_Pointer				;跳转到相应的操作
	addpcw	
	goto	F_Thmpsr_ADShort_Data_TX1
	goto	F_Thmpsr_ADShort_Data_TX2
F_Thmpsr_ADShort_Data_TX1:
	movlw   DDH                     ;起始位
	movwf   R_0TxData1
    movlw   55H	         
    movwf   R_0TxData2 
    
    movfw	R_AD_OriginalADH					;电阻值高8位
    movwf   R_0TxData3
    movfw   R_AD_OriginalADM					;电阻值中间8位 
    movwf   R_0TxData4   
    movfw   R_AD_OriginalADL					;电阻值低8位  
    movwf   R_0TxData5  
    movlw   5                  
    movwf   R_0TxDataLength
    call    F_Uart0_Send_NByte
    incf	R_Thmpsr_ADShort_Pointer,1
    goto	F_TMSR_AD_Data_Exit
F_Thmpsr_ADShort_Data_TX2:
	movfw	R_AD_OriginalADH					;电阻值高8位
    movwf   R_0TxData1
    movfw   R_AD_OriginalADM					;电阻值中间8位 
    movwf   R_0TxData2  
    movfw   R_AD_OriginalADL					;电阻值低8位  
    movwf   R_0TxData3  	
    movlw   3                  
    movwf   R_0TxDataLength
    call    F_Uart0_Send_NByte
   	movlw	28									;发送29个AD码值
	subwf	R_Thmpsr_ADShort_Count,0
	btfsc	STATUS,C
	goto	$+3
	incf	R_Thmpsr_ADShort_Count,1
	goto	F_Thmpsr_ADShort_Data_Exit
	clrf	R_Thmpsr_ADShort_Pointer
	clrf	R_Thmpsr_ADShort_Count
	movlf	1,R_ST_Delay0		;延时(@cpuclk=2MHz)
	call	F_delay_1mclk		;加延时函数，表示已经发送完一组数据
	;加延时函数，表示已经发送完一组数据
F_Thmpsr_ADShort_Data_Exit:      
;  	call	F_AD_Show
   	bcf		R_AD_FLAG,B_INT_GetAdc
    return */
/*  
F_Thmpsr_Init:
;-----------------------------------------------------------------
	;设置24bit-ADC
	;b、c参考电压2.35；
	;c、分压电阻：30K；
	;d、AD Gain=25；
	;e、主频8MHZ，采样频率250KHZ；
	;f、AD输出频率为30.5HZ；
	;-----------------------------------------------------------------
	;btfsc		R_Temperature_Flag,B_Thermoplie_Flag
   	;return	
   	;call		F_App_ShowNull
	movlw		11100000b			;ANACFG:(上电默认值为:00000000)
	movwf		ANACFG				;Bit7	LDOEN: LDO电源使能信号
									;	0 = LDO电源不使能
									;	1 = LDO电源使能*
									
									;Bit6-5	LDOS[1:0]: VS电压值选择
									;	00 = VS=3.3V
									;	01 = VS=3.0V
									;	10 = VS=2.45V
									;	11 = VS=2.35V*
									
									;Bit4	BGR_ENB: bandgap使能
									;	0 = 打开bandgap*
									;	1 = 关闭bandgap
									
									;Bit3	BGID: ADC模式选择，与METCH[3]控制ADC模式(Metch[3]默认值0)
									;	BGID=0/METCH[3]=x	低功耗模式*
									;	BGID=1/METCH[3]=0	高性能模式
									;	BGID=1/METCH[3]=1	加强高性能模式
	
									;Bit2-1	SINL[1:0]: ADC通道选择
									;	00 = 24bit-ADC输入端连接到AIN0和AIN1，AIN0为Vin+，AIN1为Vin-*
									;	01 = 内短
									;	10 = 24bit-ADC输入端连接到TEMP
									;	11 = 24bit-ADC输入端连接到AIN2和AIN3，AIN2为Vin+，AIN3为Vin-
	
									;Bit0	ADEN: 24Bit-ADC使能标志
									;	0 = 24bit-ADC不使能*
									;	1 = 24bit-ADC使能

	bcf			ADCON,7				;	1'b1 = <关闭>加强高性能模式
	
	bsf			ADCON,3				;	4'b1101 = CK_SMP/8192 = 30.5Hz<详见Datasheet>
	bsf			ADCON,2
	bcf			ADCON,1
	bsf			ADCON,0

	movlw		10100100b			;ADCFG:(上电默认值为:00000000)
	movwf		ADCFG				;Bit7-5	ADSC/F_GAIN[1:0]: ADC的采样时钟频率选择(CK_SMP)
									;	0/00 = ICK/4/8
									;	0/01 = ICK/4/8
									;	0/10 = ICK/4/12
									;	0/11 = ICK/4/16
									;	1/00 = ICK/2/8
									;	1/01 = ICK/2/8
									;	1/10 = ICK/2/12
									;	1/11 = ICK/2/16* --> CK_SMP = 8MHz/2/16 = 250KHz
	
									;Bit4-2	S_GAIN[1:0]/R_GAIN:

									;ADC的PGA选择: F_GAIN[1:0]/R_GAIN/S_GAIN[1:0]
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

									;Bit1-0	CHOPM[1:0]: 24bit-ADC斩波选择
									;	00 = 斩波频率设置为采样频率的1/32*
									;	01 = 关闭斩波
									;	10 = 斩波频率设置为采样频率的1/256
									;	11 = 关闭斩波

	;<整机测试后在确定参数>
	movlw		01000000b			;TEMPC:(上电默认值为:00000000)
	movwf		TEMPC				;Bit7-4	TEMPC[7:4]: 增益温度特性补偿(ppm)@2.4V
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
	
									;Bit3-1	TEMPC[3:1]: 24bit-ADC模拟输入滤波器电阻阻值配置
									;	000 = 0.25k//0.25k//0.25k
									;	001 = 0.25k//0.25k
									;	010 = 0.25k//0.25k
									;	011 = 0.25k
									;	100 = 0.25k//0.25k
									;	101 = 0.25k
									;	110 = 0.25k
									;	111 = 0.25k
									
									;Bit0	NC
	
	movlf		10,R_ST_Delay0		;延时5ms(@cpuclk=2MHz)
	call		F_delay_1kclk	

	bsf			ANACFG,ADEN			;使能24bit-ADC
		
	;bsf			R_Temperature_Flag,B_Thermoplie_Flag   ;初始化完成标志位	
	return 
	*/
;------------------------------------------
; Name    : F_TMSR_AD_Data_TX
; Function: 发送AD数据
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
	movlw	2									;<限定指针边界>
	subwf	R_Thermoplie_Pointer,0
	btfsc	STATUS,C
	return
	movfw	R_Thermoplie_Pointer				;跳转到相应的操作
	addpcw	
	goto	F_Thmpsr_AD_Data_TX1
	goto	F_Thmpsr_AD_Data_TX2
F_Thmpsr_AD_Data_TX1:
	movlw   EEH                     ;起始位
	movwf   R_0TxData1
    movlw   55H	         
    movwf   R_0TxData2 
    
    movfw	R_AD_OriginalADH					;电阻值高8位
    movwf   R_0TxData3
    movfw   R_AD_OriginalADM					;电阻值中间8位 
    movwf   R_0TxData4   
    movfw   R_AD_OriginalADL					;电阻值低8位  
    movwf   R_0TxData5  
    movlw   5                  
    movwf   R_0TxDataLength
    call    F_Uart0_Send_NByte
    incf	R_Thermoplie_Pointer,1  
    goto	F_TMSR_AD_Data_TX_Exit
F_Thmpsr_AD_Data_TX2:
	movfw	R_AD_OriginalADH					;电阻值高8位
    movwf   R_0TxData1
    movfw   R_AD_OriginalADM					;电阻值中间8位 
    movwf   R_0TxData2  
    movfw   R_AD_OriginalADL					;电阻值低8位  
    movwf   R_0TxData3  	
    movlw   3                  
    movwf   R_0TxDataLength
    call    F_Uart0_Send_NByte
   	movlw	28									;发送29个AD码值
	subwf	R_Thermoplie_Count,0
	btfsc	STATUS,C
	goto	$+3
	incf	R_Thermoplie_Count,1
	goto	F_TMSR_AD_Data_TX_Exit
	clrf	R_Thermoplie_Pointer
	clrf	R_Thermoplie_Count
	movlf	1,R_ST_Delay0		;延时(@cpuclk=2MHz)
	call	F_delay_1mclk		;加延时函数，表示已经发送完一组数据
F_TMSR_AD_Data_TX_Exit:      
;  	call	F_AD_Show
   	bcf		R_AD_FLAG,B_INT_GetAdc
    return	   */