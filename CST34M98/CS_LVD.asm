
;=============================================================================
;                  声明
; 该程序仅供参考若程序中存在疏漏， 
; 芯海科技有限公司对此不承担任何责任。
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
函数名称：F_Judge_Volt
具体描述：判断当前电压值是否为低电压
------------------------------------------------------------------------------

----------------------------------------------------------------------------*/
F_Judge_Volt:	
	btfsc		LVD_LPD				;判断电压是否为低电压
	goto		$+3
	bsf			R_Flag_DetVoltage,B_LowBat
	goto		F_Judge_Volt_Exit
	bcf			R_Flag_DetVoltage,B_LowBat
	bcf		    PTCON,BZEN
F_Judge_Volt_Exit:
	return	
Lvdcon_Init:
	bsf		LVDCON,LVDEN    ;使能低压检测
	bcf		LVDCON,4
	bcf		LVDCON,3
	bcf		LVDCON,2
	return	
	

			
	
	
	

	
	
	
	







