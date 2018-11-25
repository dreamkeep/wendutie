
;=============================================================================
;                  ����
; �ó�������ο��������д�����©�� 
; о���Ƽ����޹�˾�Դ˲��е��κ����Ρ�
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
	C_BS_VoltCoefH			equ		a5h				;ע����Ҫ����ʵ���������ϵ��
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
�������ƣ�F_Measure_Volt(1)
����������������ѹ
------------------------------------------------------------------------------
�м������
	R_SYS_A0/R_SYS_A1/R_SYS_A2: 
	R_SYS_B0/R_SYS_B1/R_SYS_B2: 
	R_SYS_C0/R_SYS_C1/R_SYS_C2/R_SYS_C3/R_SYS_C4/R_SYS_C5: 
	R_TEMP1: 
���������
	R_VoltH: ��ѹֵ��8λ
	R_VoltL: ��ѹֵ��8λ	
----------------------------------------------------------------------------*/
	/*
F_Measure_Volt:
	;-----------------------------------------------
	;Init 10bit-ADC
	bcf			PT2PU,0								;�ر�����
	bcf			PT2EN,0								;��Ϊ�����
	bcf			AIENB,5								;��Ϊģ���<�͵�ƽ��Ч>
	
	bcf			LVDCON,AD2_REF						;10bit-ADC�ο���ѹѡ��: DVDD	
	movlw		10010100b							;ʹ��10bit-ADC��ͨ��ѡ��PT2.0
	movwf		AD2OH	
	
	movlw		1									;��ʱ1ms @cpuclk=2MHz<ʹ10bit-ADC�ȶ�>
	call		F_Delay_Ms
	
	;-----------------------------------------------
	clrf		R_SYS_A0							;���R_SYS_A2~0	
	clrf		R_SYS_A1
	clrf		R_SYS_A2
	
	movlw		8
	movwf		R_TEMP1								;������ȡ8��ADֵ
	
L_Measure_AD_Loop0:
	bsf			AD2OH,AD2START						;����ADת��
	btfsc		AD2OH,AD2START						;�ȴ�ADֵ��ת����Ϻ�AD2START=0����Ҫ������1���ܿ�ʼ�µ�ת������
	goto		$ - 1			    				;$��ʾ��ǰPCֵ
	
	clrf		R_SYS_B2	
	movlw		00000011B							;<ȡ10bit-ADC���ݵĸ���λ>
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
	movlw		3									;����3λ<��Ч/8>
	movwf		R_TEMP1
	
L_Measure_AD_Loop1:	
	bcf			STATUS,C
	rrf			R_SYS_A2,1							;AD Avg(������)
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
	movlw		C_BS_VoltCoefH						;Coef(����)
	movwf		R_SYS_B2
	movlw		C_BS_VoltCoefM
	movwf		R_SYS_B1
	movlw		C_BS_VoltCoefL
	movwf		R_SYS_B0
	
	call		F_Mul24U							;R_SYS_C6~0 = R_SYS_A3~0 * R_SYS_B3~0 <AD * Coef>
		
	movfw		R_SYS_C2
	addwf		R_SYS_C2,0							;<��������>����
	movlw		00H
	addwfc		R_SYS_C3,0
	movwf		R_VoltL
	movlw		00H
	addwfc		R_SYS_C4,0
	movwf		R_VoltH						;10λAD���ݷ���
;		
;	movff2		R_VoltL,R_Math_A0
;	call		F_Hex2BCD16						;����ת��
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
	bcf			AD2OH,AD2EN							;��10bit-ADC
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
�������ƣ�F_Delay_Ms
������������ʱ�ӳ���(ms)����ָ������Ϊ8MHz/4(0.5us)ʱ��ԼΪ0.5ms
------------------------------------------------------------------------------
�м������
	R_TEMP1: ��ѭ��������
	R_TEMP2: ��ѭ�������� 
------------------------------------------------------------------------------
ʹ�÷�����
	�����ݷŵ�WORK�Ĵ����������ô˺���
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

			
	
	
	

	
	
	
	







