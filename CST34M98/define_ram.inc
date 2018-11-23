;============================================
;                  ����
; �ó�������ο��������д�����©�� 
; о���Ƽ����޹�˾�Դ˲��е��κ����Ρ�
; (C)Shenzhen Chipsea Technologies Co.,Ltd
;============================================
; filename: define_ram.asm
; author  : CS0155
; date    : 2017-06-14
; v1.0
;============================================

;============================================
; PAGE0	ǰ��128��RAM�ķֲ� 80H~FFH
;--------------------------------------------

;--------------------------------------------
;   �ж��õ��ı���
;--------------------------------------------
R_RAM_ALC_INT_S		equ  80h
R_RAM_ALC_INT_E		equ  R_RAM_ALC_INT_S+2

;--------------------------------------------
;   �ж��õ��ı���
;--------------------------------------------
R_Flag_Sys			equ	 83h
	B_Volt_En			equ		0
	B_LowBat			equ		1       ;�͵��־
	B_LED_R_G			equ		2		;0 �̵� 1���
	B_AD_30MS			equ		3       ;
	B_N_MS_TM           equ     4       ;0��ʱ��û�а��� 1 xxʱ���ڰ���
	B_Sensor_err        equ     5       ;0������ok 1����������
;--------------------------------------------
;   ��ʱ����
		
;--------------------------------------------

;--------------------------------------------
; ���䵽CS_HW_MeasureVoltage.asm��RAM��ַ�ʹ�С
;--------------------------------------------		
R_TEMP0				equ	 84h
R_TEMP1				equ	 85h
R_TEMP2				equ	 86h
R_TEMP3				equ	 87h
R_TEMP4				equ	 88h
R_TEMP5				equ	 89h

r_mid_l   equ  R_TEMP0
r_mid_h   equ  R_TEMP1
	
R_VoltL					equ		8ah
R_VoltH					equ		8bh
R_BS_VoltBatL			equ		8ch				
R_BS_VoltBatH			equ		8dh
;--------------------------------------------
	
;--------------------------------------------
;   ��ʾ�����õ��ı���
;--------------------------------------------	
;--------------------------------------------	
R_DSP_BUFFER1		equ  90h  		;����xx s��ʱ
R_DSP_BUFFER2		equ  91h  		;����xx s��ʱ
R_DSP_BUFFER3		equ  92h  		;��ʱ��t0 2s ʱ��
R_DSP_BUFFER4		equ  93h  		;��ʱ��t0 2s ����
R_DSP_BUFFER5		equ  94h  		;��ʱ��t1 2s ʱ��
R_DSP_BUFFER6		equ  95h        ;��ʱ��t1 2s ����

R_DSP_BUFFER7		equ  96h        ;16s
R_DSP_BUFFER8		equ  97h        ;16s

R_DSP_BUFFER9		equ  98h		;10min_l
R_DSP_BUFFER10		equ  99h        ;10min_h

R_DSP_BUFFER11		equ  9ah


;public
R_NTC_ADCacheL		equ	 a0h
R_NTC_ADCacheM		equ	 a1h
R_NTC_ADCacheH		equ	 a2h
R_NTC_ADCacheLLL	equ	 a3h
R_NTC_ADCacheLLM	equ	 a4h
R_NTC_ADCacheLMM	equ	 a5h
;R_NTC_ADCacheHMM	equ	 a6h
;R_NTC_ADCacheHHM	equ	 a7h
;R_NTC_ADCacheHHH	equ	 a8h
r_24bit_ad_temp_l_cur   equ  a6h
r_24bit_ad_temp_m_cur   equ  a7h
r_24bit_ad_temp_h_cur   equ  a8h ;��ǰ24bit ad�¶�

R_RestL				equ	 b0h
R_RestM				equ	 b1h
R_RestH				equ	 b2h
R_Data_Pointer		equ	 b3h
;--------------------------------------------
; ���䵽CS_HW_Key.asm��RAM��ַ�ʹ�С
;--------------------------------------------
;private
R_ALC_KEY_S				equ	  c0h
R_ALC_KEY_E				equ	  R_ALC_KEY_S+2
;public
R_KEY_F					equ   R_ALC_KEY_S+3     ;������־λ
	B_KEY_PRESS         equ     0				;������ס��־
	B_KEY_PRESS_S		equ		1				;�����հ��±�־
	B_KEY_PRESS_E       equ     2				;�����̰������־
	B_KEY_LONGPRESS     equ     3				;��������ס��־
	B_KEY_LONGPRESS_S   equ     4				;�����ճ����±�־
	B_KEY_LONGPRESS_E   equ     5				;�������������־

;--------------------------------------------
; ���䵽CS_Application_Proc.asm��RAM��ַ�ʹ�С
;--------------------------------------------
; private
R_ALC_Application_S		equ	  d0h
R_ALC_Application_E		equ	  R_ALC_Application_S+9
;--------------------------------------------
; ���䵽�¶Ȳ������ֵ�RAM��ַ�ʹ�С
;--------------------------------------------
R_Thermistor_Pointer		equ	  E0h
R_Thermistor_Count			equ   E1h
R_TMSR_ADShort_Pointer		equ	  E2h
R_TMSR_ADShort_Count		equ	  E3h
R_Thermoplie_Pointer		equ	  E4h
R_Thermoplie_Count			equ	  E5h
R_Thmpsr_ADShort_Pointer	equ	  E6h
R_Thmpsr_ADShort_Count		equ	  E7h
R_Thermometer_Pointer		equ   E8h
R_Temp_Sleep_Count			equ   E9h
R_Temp_Rest_Count			equ   EAh
R_Temperature_Flag			equ   EBh
	B_TMSR_ADShort_Flag		equ   0
	B_Thmpsr_ADShort_Flag	equ	  1
	B_Thermistor_Flag		equ   2
	B_Thermoplie_Flag		equ	  3	
	B_AD_Temp_Flag			equ	  4
	
	
Cali_T_adll					equ	  F0h
Cali_T_adl					equ	  F1h
Cali_T_adh					equ	  F2h
Cali_T_adhh					equ	  F3h
Cali_temp_l					equ	  F4h
Cali_temp_h					equ	  F5h
R_Temp_DeltaL               equ   F6h
R_Temp_DeltaM               equ   F7h
R_Temp_DeltaH               equ   F8h

R_Temp_OutL					equ	  F9h
R_Temp_OutH					equ	  FAh
R_BCD_TempL					equ	  FBh
R_Temp_OutHH                equ   R_BCD_TempL

R_BCD_TempH					equ   FCh

R_thermometer_FLAG                 equ   FDh 
                b_key_lock    equ  0  ;����������־ 
                b_rt_measure  equ  1  ;ʵʱ���±�־
                b_avoid_quilt equ  2  ;���߱���־
                b_app_unlock  equ  3  ;app�·�����ָ��
				b_temp_std    equ  4  ;�¶��Ѿ��ȶ���
				b_critical_temp equ 5 ;�ٽ��¶ȱ�־
				b_temp_mode     equ 6 ;0 24bit�����¶� 1���߱��¶� Ĭ����0
;--------------------------------------------
;   PAGE0	����256��RAM�ķֲ� 100H~1FFH
;--------------------100h--------------------
;--------------------------------------------
; A��B��C�����RAM��ַ�����⣩
;--------------------------------------------
; �����ǹ���������
; �ñ���Ӧ�õĺ�����Χ����ײ㺯�����Ҳ������жϱ�����
; �ñ����������ж�ʹ��
R_SYS_ABC_S			equ  100h
R_SYS_A_S			equ	 R_SYS_ABC_S+0
R_SYS_A0			equ	 R_SYS_ABC_S+0
R_SYS_A1			equ  R_SYS_ABC_S+1
R_SYS_A2			equ  R_SYS_ABC_S+2
R_SYS_A3			equ	 R_SYS_ABC_S+3
R_SYS_A4			equ  R_SYS_ABC_S+4
R_SYS_A5			equ  R_SYS_ABC_S+5

R_SYS_B_S			equ	 R_SYS_ABC_S+6
R_SYS_B0			equ	 R_SYS_ABC_S+6
R_SYS_B1			equ  R_SYS_ABC_S+7
R_SYS_B2			equ  R_SYS_ABC_S+8

R_SYS_C_S			equ	 R_SYS_ABC_S+9
R_SYS_C0			equ	 R_SYS_ABC_S+9
R_SYS_C1			equ  R_SYS_ABC_S+10
R_SYS_C2			equ  R_SYS_ABC_S+11
R_SYS_C3			equ	 R_SYS_ABC_S+12
R_SYS_C4			equ  R_SYS_ABC_S+13
R_SYS_C5			equ  R_SYS_ABC_S+14

R_SYS_RET			equ	 R_SYS_ABC_S+15
R_SYS_ABC_E			equ	 10fh
;--------------------------------------------
; ���䵽CS_HW_AD_.asm��RAM��ַ�ʹ�С
;--------------------------------------------
;private
R_ALC_AD_S				equ		110h
;ԭʼAD
R_AD_OriginalADL		equ		R_ALC_AD_S+6		;�жϲɼ�������ԭʼADֵ��8λ
R_AD_OriginalADM		equ		R_ALC_AD_S+7		;�жϲɼ�������ԭʼADֵ��8λ
R_AD_OriginalADH		equ		R_ALC_AD_S+8		;�жϲɼ�������ԭʼADֵ��8λ
;��ƽ�������
R_AD_AvgADL				equ		R_ALC_AD_S+9		;��ƽ�����AD��8λ
R_AD_AvgADM				equ		R_ALC_AD_S+10		;��ƽ�����AD��8λ
R_AD_AvgADH				equ		R_ALC_AD_S+11		;��ƽ�����AD��8λ
;�˲������
R_AD_FLAG				equ		R_ALC_AD_S+12		;ADC�ı�־λ
	B_INT_GetAdc		equ		0					;�жϲɼ���һ��AD�ı�־�����ڲ�ѯ��
	B_AD_PRE_OK			equ		1					;׼����һ��AD�ı�־
;	B_AD_30MS			equ		3					;30ms AD�жϱ�־
R_BS_Scale_Flag			equ		R_ALC_AD_S+13	;����ӱ�־λ
	B_BS_Sleep			equ		2						;��ʾ���������־
R_ALC_AD_EE				equ		11Dh


;UART0�ڷ��ͻ����� 32���ֽ�
;--------------------------------------------
R_ALC_UARRX0_S	EQU		120h
R_ALC_UARRX0_E	EQU		R_ALC_UARRX0_S+8
;--------------------------------------------
;UART�ڷ��ͻ����� 32���ֽ�  �ڶ�ҳSRAM
;--------------------------------------------
R_ALC_UARTX0_S	EQU		R_ALC_UARRX0_E+1
R_ALC_UARTX0_E	EQU		R_ALC_UARTX0_S+10
;--------------------------------------------
;UART�ڷ��ͻ����� 32���ֽ�
;--------------------------------------------
R_ALC_UARRX_S	EQU	140h
R_ALC_UARRX_E	equ	16Eh

;--------------------------------------------
;UART�ڷ��ͻ����� 32���ֽ�
;--------------------------------------------
R_ALC_UARTX_S	EQU	170h
R_ALC_UARTX_E	equ	18Fh
;--------------------------------------------
;������ַ����
;--------------------------------------------
R_ALC_BLE_S	    EQU	190h
R_ALC_BLE_E	    equ	1Afh

r_sum_ad_l      equ    1B0H
r_sum_ad_m       equ	1B1h	
r_sum_ad_h       equ    1B2H
r_sum_ad_hh       equ    1B3H

r_left_l     equ  r_sum_ad_l
r_left_h      equ  r_sum_ad_m

r_right_l     equ  r_sum_ad_h
r_right_h      equ  r_sum_ad_hh
	

r_ain01_ad_l     equ    1B4H
r_ain01_ad_m	 equ    1B5H	   
r_ain01_ad_h	 equ    1B6H
	
r_ain23_ad_l     equ    1B7H
r_ain23_ad_m	 equ    1B8H	   
r_ain23_ad_h	 equ    1B9H

r_short_ad_l     equ    1BAH
r_short_ad_m     equ    1BBH
r_short_ad_h     equ    1BCH


r_24bit_ad_temp_l_pre   equ  1BDh
r_24bit_ad_temp_m_pre   equ  1BEh
r_24bit_ad_temp_h_pre   equ  1BFh ;�ϴ�24bit ad�¶�
	
r_table_res_l   equ  1C0H  ;����table
r_table_res_m   equ  1C1H
r_table_res_h   equ  1C2H

r_table_temp_l   equ  1C3H  ;�¶�table
r_table_temp_h   equ  1C4H

r_table_from_l   equ  1C5H  ;table from ���
r_table_from_h   equ  1C6H  ;table from ���

r_table_to_l   equ  1C7H   ;table to ���
r_table_to_h   equ  1C8H   ;table to ���