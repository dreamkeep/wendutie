
;=============================================================================
;                  ����
; �ó�������ο��������д�����©�� 
; о���Ƽ����޹�˾�Դ˲��е��κ����Ρ�
; (C)Shenzhen Chipsea Technologies Co.,Ltd
;=============================================================================
; filename: CS_MeasureVoltage.asm
; chip    : CSU18M88
; author  :
; date    : 
; v1.0

;DEFINE			LED_IO		"PT2,1"				
;DEFINE			LED_EN		"PT2EN,1"
;DEFINE			LED_PU		"PT2PU,1"
DEFINE			LVD_LPD		"LVDCON,LBOUT"
;=============================================================================
R_Flag_DetVoltage		equ		R_Flag_Sys
/*----------------------------------------------------------------------------
�������ƣ�F_Judge_Volt
�����������жϵ�ǰ��ѹֵ�Ƿ�Ϊ�͵�ѹ
------------------------------------------------------------------------------

----------------------------------------------------------------------------*/
F_Judge_Volt:	
	btfsc		LVD_LPD				;�жϵ�ѹ�Ƿ�Ϊ�͵�ѹ
	goto		$+3
	bsf			R_Flag_DetVoltage,B_LowBat
	goto		F_Judge_Volt_Exit
	bcf			R_Flag_DetVoltage,B_LowBat
	bcf		    PTCON,BZEN
F_Judge_Volt_Exit:
	return	
Lvdcon_Init:
	bsf		LVDCON,LVDEN    ;ʹ�ܵ�ѹ���
	bcf		LVDCON,4
	bcf		LVDCON,3
	bcf		LVDCON,2
	return	
	

			
	
	
	

	
	
	
	







