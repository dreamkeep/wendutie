
;=============================================================================
;                  声明
; 该程序仅供参考若程序中存在疏漏， 
; 芯海科技有限公司对此不承担任何责任。
; (C)Shenzhen Chipsea Technologies Co.,Ltd
;=============================================================================
; filename: CS_MeasureVoltage.asm
; chip    : CSU18M88
; author  : CS0138
; date    : 2017-06-28
; v1.0
;=============================================================================

;-----------------------------------------------------------------------------	
; DEFINE SFR
;-----------------------------------------------------------------------------


;-----------------------------------------------------------------------------	
; DEFINE CONSTANCE
;-----------------------------------------------------------------------------


;-----------------------------------------------------------------------------
; DEFINE SRAM
;-----------------------------------------------------------------------------
	;-----------------------------------------------
	;System(Reuse)
	;-----------------------------------------------	

	;-----------------------------------------------
	;Global Variable
	;-----------------------------------------------
;	R_BSR								;BSR寄存器备份(定义PAGE0)
;	R_FSR0								;FSR0寄存器备份
;	R_FSR1								;FSR1寄存器备份


	;-----------------------------------------------
 	;Local Variable	
	;-----------------------------------------------	
R_BSR			equ  R_RAM_ALC_INT_S	;Bsr中断压栈备份寄存器
R_FSR0			equ  R_RAM_ALC_INT_S+1	;Fsr0中断压栈备份寄存器
R_FSR1			equ  R_RAM_ALC_INT_S+2	;Fsr1中断压栈备份寄存器


/*----------------------------------------------------------------------------
Function   : F_Interrupt
Description: 中断子函数
----------------------------------------------------------------------------*/
InterruptProc:
	push								;把WORK和STATUS寄存器入栈保护
		
	movfw		BSR
	bcf			BSR,PAGE0				;切换到PAGE0<取决于备份区域>
	bcf			BSR,PAGE1
	movwf		R_BSR					;备份BSR	
	movfw		FSR0
	movwf		R_FSR0					;备份FSR0 
	movfw		FSR1
	movwf		R_FSR1					;备份FSR1			

	;-----------------------------------
	;高频中断(按优先级排列)	
	btfsc		INTF2,UR1_RNIF			;UR0接收FIFO非空中断
	goto		INT_UR1_RN
	
	btfsc		INTF,ADIF				;24bit-ADC中断
	goto		INT_AD	
	
	btfsc		INTF,TM0IF		        ;Timer0中断
	goto		INT_TM0	
		
	btfsc		INTF,TM1IF				;Timer1中断
	goto		INT_TM1	

	btfsc		INTF3,TM3IF				;Timer3中断
	goto		INT_TM3	
	
	btfsc		INTF3,RTCIF				;RTC中断
	goto		INT_RTC		
	
	btfsc		INTF,E0IF				;外部中断0
	goto		INT_EXT0
	

	;	
	;	
	;
	;
		
	;-----------------------------------

;
;	BTFSC		INTF,E1IF				;外部中断1
;	GOTO		Ext_Int
;
;	BTFSC		INTF,ADIF				;24bit-ADC中断
;	GOTO		Ext_Int
;	
;	BTFSC		INTF,AD2IF				;10bit-ADC中断
;	GOTO		Ext_Int	
;	
;	BTFSC		INTF,TM0IF				;Timer0中断
;	GOTO		Ext_Int
;
;	BTFSC		INTF,TM1IF				;Timer1中断
;	GOTO		Ext_Int
;
;	BTFSC		INTF,TM2IF				;Timer2中断
;	GOTO		Ext_Int
			
	;-----------
;	BTFSC		INTF2,UR0_TEIF			;串口0发送FIFO空中断
;	GOTO		Ext_Int
;
;	BTFSC		INTF2,UR0_THIF			;串口0发送FIFO半空中断
;	GOTO		Ext_Int	
;	
;	BTFSC		INTF2,UR0_RNIF			;串口0接收FIFO非空中断
;	GOTO		Ext_Int	
;	
;	BTFSC		INTF2,UR0_RHIF			;串口0接收FIFO半满中断
;	GOTO		Ext_Int		
;	
;	BTFSC		INTF2,UR1_TEIF			;串口1发送FIFO空中断
;	GOTO		Ext_Int		
;	
;	BTFSC		INTF2,UR1_THIF			;串口1发送FIFO半空中断
;	GOTO		Ext_Int		
;	
;	BTFSC		INTF2,UR1_RNIF			;串口1接收FIFO非空中断
;	GOTO		Ext_Int		
;	
;	BTFSC		INTF2,UR1_RHIE			;串口1接收FIFO半满中断
;	GOTO		Ext_Int	
	
	;-----------	
;	BTFSC		INTF3,SPIIF				;SPI中断
;	GOTO		Ext_Int	
;
;	BTFSC		INTF3,RTCIF				;RTC中断
;	GOTO		Ext_Int	
;	
;	BTFSC		INTF3,TM3IF				;Timer3中断
;	GOTO		Ext_Int	
;	
;	BTFSC		INTF3,UR0WK_IF			;UART0唤醒中断
;	GOTO		Ext_Int
;
;	BTFSC		INTF3,UR1WK_IF			;UART1唤醒中断
;	GOTO		Ext_Int	
;
;	BTFSC		INTF3,I2C_RIF			;I2C从机接收中断
;	GOTO		Ext_Int		
;	
;	BTFSC		INTF3,I2C_TIF			;I2C从机发送中断
;	GOTO		Ext_Int	
	
	;-----------	
	goto		Ext_Int

		
;---------------------------------------
;24bit-AD中断
;---------------------------------------	
INT_AD:	
	bcf		INTF,ADIF
	bsf		R_Flag_Sys,B_AD_30MS
	include CS_AD_Interrupt.asm	
	
	goto	Ext_Int2				;<注：防止清除其它有效中断>		
		
		

;---------------------------------------
;UR0接收FIFO非空中断
;---------------------------------------
INT_UR1_RN:
	bcf         INTF2,UR1_RNIF
	movfw		UR1_RX_REG
    movwf		R_RxSbuf
    ;bcf		R_BLE_Flag,1 
	call		F_Uart_Rx_NByte
	goto		Ext_Int2
	
;---------------------------------------	
;RTC中断
;---------------------------------------
INT_RTC:	
	bcf			INTF3,RTCIF
	;
	;
	;
	;
	goto		Ext_Int2	

;---------------------------------------
;INT0中断
;---------------------------------------
INT_EXT0:
	bcf			INTF,E0IF
	goto		Ext_Int2;	incf	R_Body_TimeOUut,1
;-----------------------------------------
;-----------------------------------------
INT_TM0:	
	bcf		INTF,TM0IF
	incf    R_DSP_BUFFER3,1
	movlw   125
	subwf   R_DSP_BUFFER3,0  ;125*16ms = 2s   R_DSP_BUFFER3 - 125
	btfss   status,c
	goto	Ext_Int2
	
	clrf    R_DSP_BUFFER3
	incf    R_DSP_BUFFER4,1
	btfss   R_Flag_Sys,B_LED_R_G  ;0 绿灯 1红灯
	goto    isr_green_lp
	goto    isr_red_lp
	
 isr_green_lp:		
	btfss   GREEN_LED
	goto    isr_green_lp_pos
	bcf     GREEN_LED
	goto    Ext_Int2
 isr_green_lp_pos:
	bsf     GREEN_LED
	goto    Ext_Int2 
	
 isr_red_lp:
	btfss   RED_LED
	goto    isr_red_lp_pos
	bcf     RED_LED
	goto    Ext_Int2
 isr_red_lp_pos:
    bsf     RED_LED
	goto	Ext_Int2	
;---------------------------------------
INT_TM1:
	bcf     INTF,TM1IF
	incf    R_DSP_BUFFER5,1
	movlw   125
	subwf   R_DSP_BUFFER5,0  ;125*16ms = 2s   R_DSP_BUFFER5 - 125
	btfss   status,c
	goto	Ext_Int2
	
	clrf    R_DSP_BUFFER5
	incf    R_DSP_BUFFER6,1

	goto	Ext_Int2	
;---------------------------------------
INT_TM3:
    bcf     INTF3,TM3IF	
    incf    R_DSP_BUFFER9,1
    movlw   250
    subwf   R_DSP_BUFFER9,0 ;250*16ms = 4s   R_DSP_BUFFER9 - 250
    btfss   status,c
    goto	Ext_Int2
    
	clrf    R_DSP_BUFFER9
	incf    R_DSP_BUFFER10,1

	goto	Ext_Int2	

	
	
;退出中断子程序	
Ext_Int:
	clrf		INTF
	clrf		INTF2
	clrf		INTF3

Ext_Int2:
	;-----------	
	bcf			BSR,PAGE0				;切换到PAGE0
	bcf			BSR,PAGE1	
	movfw		R_FSR0					;恢复FSR0
	movwf		FSR0
	movfw		R_FSR1					;恢复FSR1
	movwf		FSR1	
	movfw		R_BSR					;恢复BSR
	movwf		BSR	

	;-----------
	pop									;把WORK和STATUS寄存器出栈处理
	retfie 								;从中断返回	



