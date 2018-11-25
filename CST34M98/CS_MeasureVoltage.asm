
;=============================================================================
;                  声明
; 该程序仅供参考若程序中存在疏漏， 
; 芯海科技有限公司对此不承担任何责任。
; (C)Shenzhen Chipsea Technologies Co.,Ltd
;=============================================================================
; filename: CS_MeasureVoltage.asm
; chip    : CSU18M88
; author  : CS0138
; date    : 2017-06-26
; v1.0
;=============================================================================

;-----------------------------------------------------------------------------	
; DEFINE SFR
;-----------------------------------------------------------------------------


;-----------------------------------------------------------------------------	
; DEFINE CONSTANCE
;-----------------------------------------------------------------------------
	;PE = Peripherals

	;-----------------------------------------------
	;VDD = 330		R1 = 100	R2 = 100
	;-----------------------------------------------
	;K = R2 / (R1 + R2)      Vad = Vx * K      AD / (2^10) = Vad / VDD      
	;-----------------------------------------------		
	;=> AD = Vx * K * (2^10) / VDD
	;=> Vx = AD * VDD / (K * (2^10)) = AD * Coef / (2^24)
	;=> Coef = (VDD / K) * (2^14)
	;		 = A50000H
	;-----------------------------------------------
	C_BS_VoltCoefH			equ		a5h				;注：需要根据实际情况调节系数
	C_BS_VoltCoefM			equ		00h
	C_BS_VoltCoefL			equ		00h


	

;-----------------------------------------------------------------------------
; DEFINE SRAM
;-----------------------------------------------------------------------------
	;-----------------------------------------------
	;System(Reuse)
	;-----------------------------------------------	
	;R_SYS_A0
	;R_SYS_A1
	;R_SYS_A2
	;
	;R_SYS_B0
	;R_SYS_B1
	;R_SYS_B2
	;
	;R_SYS_C0
	;R_SYS_C1
	;R_SYS_C2
	;R_SYS_C3
	;R_SYS_C4
	;R_SYS_C5
	;
	;R_TEMP1
	;R_TEMP2

	;-----------------------------------------------
	;Global Variable
	;-----------------------------------------------
	;R_VoltL
	;R_VoltH
	
	;-----------------------------------------------
 	;Local Variable	
	;-----------------------------------------------
	
	
/*----------------------------------------------------------------------------
函数名称：F_Measure_Volt(1)
具体描述：测量电压
------------------------------------------------------------------------------
中间变量：
	R_SYS_A0/R_SYS_A1/R_SYS_A2: 
	R_SYS_B0/R_SYS_B1/R_SYS_B2: 
	R_SYS_C0/R_SYS_C1/R_SYS_C2/R_SYS_C3/R_SYS_C4/R_SYS_C5: 
	R_TEMP1: 
输出变量：
	R_VoltH: 电压值高8位
	R_VoltL: 电压值低8位	
----------------------------------------------------------------------------*/
	/*
F_Measure_Volt:
	;-----------------------------------------------
	;Init 10bit-ADC
	bcf			PT2PU,0								;关闭上拉
	bcf			PT2EN,0								;设为输入口
	bcf			AIENB,5								;设为模拟口<低电平有效>
	
	bcf			LVDCON,AD2_REF						;10bit-ADC参考电压选择: DVDD	
	movlw		10010100b							;使能10bit-ADC，通道选择PT2.0
	movwf		AD2OH	
	
	movlw		1									;延时1ms @cpuclk=2MHz<使10bit-ADC稳定>
	call		F_Delay_Ms
	
	;-----------------------------------------------
	clrf		R_SYS_A0							;清空R_SYS_A2~0	
	clrf		R_SYS_A1
	clrf		R_SYS_A2
	
	movlw		8
	movwf		R_TEMP1								;连续读取8次AD值
	
L_Measure_AD_Loop0:
	bsf			AD2OH,AD2START						;开启AD转换
	btfsc		AD2OH,AD2START						;等待AD值，转换完毕后AD2START=0，需要重新置1才能开始新的转换操作
	goto		$ - 1			    				;$表示当前PC值
	
	clrf		R_SYS_B2	
	movlw		00000011B							;<取10bit-ADC数据的高两位>
	andwf		AD2OH,0
	movwf		R_SYS_B1	
	movfw		AD2OL
	movwf		R_SYS_B0

	movfw		R_SYS_B0							;R_SYS_A2~0 = R_SYS_A2~0 + R_SYS_B2~0
	addwf		R_SYS_A0,1
	movfw		R_SYS_B1
	addwfc		R_SYS_A1,1	
	movfw		R_SYS_B2
	addwfc		R_SYS_A2,1
	
	decfsz		R_TEMP1,1							;R_TEMP1 = R_TEMP1 - 1
	goto		L_Measure_AD_Loop0
	
	;-----------
	movlw		3									;右移3位<等效/8>
	movwf		R_TEMP1
	
L_Measure_AD_Loop1:	
	bcf			STATUS,C
	rrf			R_SYS_A2,1							;AD Avg(被乘数)
	rrf			R_SYS_A1,1	
	rrf			R_SYS_A0,1
	
	decfsz		R_TEMP1,1
	goto		L_Measure_AD_Loop1
	
	;-----------------------------------------------
	;	VDD = 330     
	;	R1  = 100
	;	R2  = 100	
	;-----------------------------------------------
	;	K = R2 / (R1 + R2)      
	;	Vad = Vx * K      
	;	AD / (2^10) = Vad / VDD      
	;----------------------------------------------- 		
	;=> AD = Vx * K * (2^10) / VDD
	;=> Vx = AD * VDD / (K * (2^10)) = AD * Coef / (2^24),  Coef = (VDD / K) * (2^14) 
	;-----------------------------------------------
	movlw		C_BS_VoltCoefH						;Coef(乘数)
	movwf		R_SYS_B2
	movlw		C_BS_VoltCoefM
	movwf		R_SYS_B1
	movlw		C_BS_VoltCoefL
	movwf		R_SYS_B0
	
	call		F_Mul24U							;R_SYS_C6~0 = R_SYS_A3~0 * R_SYS_B3~0 <AD * Coef>
		
	movfw		R_SYS_C2
	addwf		R_SYS_C2,0							;<四舍五入>处理
	movlw		00H
	addwfc		R_SYS_C3,0
	movwf		R_VoltL
	movlw		00H
	addwfc		R_SYS_C4,0
	movwf		R_VoltH						;10位AD数据发送
;		
;	movff2		R_VoltL,R_Math_A0
;	call		F_Hex2BCD16						;进制转换
;		
;	movfw		R_SYS_C1			
;	andlw		0fh
;	movwf		R_DSP_BUFFER1
;
;	swapf		R_SYS_C0,w			
;	andlw		0fh
;	movwf		R_DSP_BUFFER2
;	
;	movfw		R_SYS_C0			
;	andlw		0fh
;	movwf		R_DSP_BUFFER3
	
L_Measure_Volt_End:
	bcf			AD2OH,AD2EN							;关10bit-ADC
	return
	
L_TEN_ADTX:	
	movlw		00H	 
	movwf		R_0TxData1
    movlw		55H	         
    movwf		R_0TxData2 
    
    movfw		00h					;
    movwf		R_0TxData3
    movfw		R_VoltH					
    movwf		R_0TxData4   
    movfw		R_VoltL					;
    movwf		R_0TxData5  
    movlw		5                  
    movwf		R_0TxDataLength
  	call		F_Uart0_Send_NByte
  	return */
/*----------------------------------------------------------------------------
函数名称：F_Delay_Ms
具体描述：延时子程序(ms)，当指令周期为8MHz/4(0.5us)时，约为0.5ms
------------------------------------------------------------------------------
中间变量：
	R_TEMP1: 外循环计数器
	R_TEMP2: 内循环计数器 
------------------------------------------------------------------------------
使用方法：
	把数据放到WORK寄存器立即调用此函数
----------------------------------------------------------------------------*/	
  	/*
F_Delay_Ms:
	movwf		R_TEMP1
L_Delay_Ms_Loop0:
	movlw		fah
	movwf		R_TEMP2
L_Delay_Ms_Loop1:
	nop
	nop
	decfsz		R_TEMP2,1
	goto		L_Delay_Ms_Loop1
	decfsz		R_TEMP1,1
	goto		L_Delay_Ms_Loop0
	return		*/

			
	
	
	

	
	
	
	







