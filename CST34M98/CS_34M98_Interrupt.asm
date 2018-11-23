
;=============================================================================
;                  ����
; �ó�������ο��������д�����©�� 
; о���Ƽ����޹�˾�Դ˲��е��κ����Ρ�
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
;	R_BSR								;BSR�Ĵ�������(����PAGE0)
;	R_FSR0								;FSR0�Ĵ�������
;	R_FSR1								;FSR1�Ĵ�������


	;-----------------------------------------------
 	;Local Variable	
	;-----------------------------------------------	
R_BSR			equ  R_RAM_ALC_INT_S	;Bsr�ж�ѹջ���ݼĴ���
R_FSR0			equ  R_RAM_ALC_INT_S+1	;Fsr0�ж�ѹջ���ݼĴ���
R_FSR1			equ  R_RAM_ALC_INT_S+2	;Fsr1�ж�ѹջ���ݼĴ���


/*----------------------------------------------------------------------------
Function   : F_Interrupt
Description: �ж��Ӻ���
----------------------------------------------------------------------------*/
InterruptProc:
	push								;��WORK��STATUS�Ĵ�����ջ����
		
	movfw		BSR
	bcf			BSR,PAGE0				;�л���PAGE0<ȡ���ڱ�������>
	bcf			BSR,PAGE1
	movwf		R_BSR					;����BSR	
	movfw		FSR0
	movwf		R_FSR0					;����FSR0 
	movfw		FSR1
	movwf		R_FSR1					;����FSR1			

	;-----------------------------------
	;��Ƶ�ж�(�����ȼ�����)	
	btfsc		INTF2,UR1_RNIF			;UR0����FIFO�ǿ��ж�
	goto		INT_UR1_RN
	
	btfsc		INTF,ADIF				;24bit-ADC�ж�
	goto		INT_AD	
	
	btfsc		INTF,TM0IF		        ;Timer0�ж�
	goto		INT_TM0	
		
	btfsc		INTF,TM1IF				;Timer1�ж�
	goto		INT_TM1	

	btfsc		INTF3,TM3IF				;Timer3�ж�
	goto		INT_TM3	
	
	btfsc		INTF3,RTCIF				;RTC�ж�
	goto		INT_RTC		
	
	btfsc		INTF,E0IF				;�ⲿ�ж�0
	goto		INT_EXT0
	

	;	
	;	
	;
	;
		
	;-----------------------------------

;
;	BTFSC		INTF,E1IF				;�ⲿ�ж�1
;	GOTO		Ext_Int
;
;	BTFSC		INTF,ADIF				;24bit-ADC�ж�
;	GOTO		Ext_Int
;	
;	BTFSC		INTF,AD2IF				;10bit-ADC�ж�
;	GOTO		Ext_Int	
;	
;	BTFSC		INTF,TM0IF				;Timer0�ж�
;	GOTO		Ext_Int
;
;	BTFSC		INTF,TM1IF				;Timer1�ж�
;	GOTO		Ext_Int
;
;	BTFSC		INTF,TM2IF				;Timer2�ж�
;	GOTO		Ext_Int
			
	;-----------
;	BTFSC		INTF2,UR0_TEIF			;����0����FIFO���ж�
;	GOTO		Ext_Int
;
;	BTFSC		INTF2,UR0_THIF			;����0����FIFO����ж�
;	GOTO		Ext_Int	
;	
;	BTFSC		INTF2,UR0_RNIF			;����0����FIFO�ǿ��ж�
;	GOTO		Ext_Int	
;	
;	BTFSC		INTF2,UR0_RHIF			;����0����FIFO�����ж�
;	GOTO		Ext_Int		
;	
;	BTFSC		INTF2,UR1_TEIF			;����1����FIFO���ж�
;	GOTO		Ext_Int		
;	
;	BTFSC		INTF2,UR1_THIF			;����1����FIFO����ж�
;	GOTO		Ext_Int		
;	
;	BTFSC		INTF2,UR1_RNIF			;����1����FIFO�ǿ��ж�
;	GOTO		Ext_Int		
;	
;	BTFSC		INTF2,UR1_RHIE			;����1����FIFO�����ж�
;	GOTO		Ext_Int	
	
	;-----------	
;	BTFSC		INTF3,SPIIF				;SPI�ж�
;	GOTO		Ext_Int	
;
;	BTFSC		INTF3,RTCIF				;RTC�ж�
;	GOTO		Ext_Int	
;	
;	BTFSC		INTF3,TM3IF				;Timer3�ж�
;	GOTO		Ext_Int	
;	
;	BTFSC		INTF3,UR0WK_IF			;UART0�����ж�
;	GOTO		Ext_Int
;
;	BTFSC		INTF3,UR1WK_IF			;UART1�����ж�
;	GOTO		Ext_Int	
;
;	BTFSC		INTF3,I2C_RIF			;I2C�ӻ������ж�
;	GOTO		Ext_Int		
;	
;	BTFSC		INTF3,I2C_TIF			;I2C�ӻ������ж�
;	GOTO		Ext_Int	
	
	;-----------	
	goto		Ext_Int

		
;---------------------------------------
;24bit-AD�ж�
;---------------------------------------	
INT_AD:	
	bcf		INTF,ADIF
	bsf		R_Flag_Sys,B_AD_30MS
	include CS_AD_Interrupt.asm	
	
	goto	Ext_Int2				;<ע����ֹ���������Ч�ж�>		
		
		

;---------------------------------------
;UR0����FIFO�ǿ��ж�
;---------------------------------------
INT_UR1_RN:
	bcf         INTF2,UR1_RNIF
	movfw		UR1_RX_REG
    movwf		R_RxSbuf
    ;bcf		R_BLE_Flag,1 
	call		F_Uart_Rx_NByte
	goto		Ext_Int2
	
;---------------------------------------	
;RTC�ж�
;---------------------------------------
INT_RTC:	
	bcf			INTF3,RTCIF
	;
	;
	;
	;
	goto		Ext_Int2	

;---------------------------------------
;INT0�ж�
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
	btfss   R_Flag_Sys,B_LED_R_G  ;0 �̵� 1���
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

	
	
;�˳��ж��ӳ���	
Ext_Int:
	clrf		INTF
	clrf		INTF2
	clrf		INTF3

Ext_Int2:
	;-----------	
	bcf			BSR,PAGE0				;�л���PAGE0
	bcf			BSR,PAGE1	
	movfw		R_FSR0					;�ָ�FSR0
	movwf		FSR0
	movfw		R_FSR1					;�ָ�FSR1
	movwf		FSR1	
	movfw		R_BSR					;�ָ�BSR
	movwf		BSR	

	;-----------
	pop									;��WORK��STATUS�Ĵ�����ջ����
	retfie 								;���жϷ���	



