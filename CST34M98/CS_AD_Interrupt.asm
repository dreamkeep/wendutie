;============================================
;                  声明
; 该程序仅供参考若程序中存在疏漏， 
; 芯海科技有限公司对此不承担任何责任。
; (C)Shenzhen Chipsea Technologies Co.,Ltd
;============================================
; filename: CS_BodyScale_Interrupt.asm
; author  : CS0155
; date    : 2017-06-29
; v1.0
;============================================
; 变量地址分配
;============================================


INT_BS_GET_AD_S:
	btfsc	R_AD_FLAG,B_INT_GetAdc			;置起AD采集完标志
	goto	INT_BS_GET_AD_E
		
	movfw	ADOH						;获取原始AD
	movwf	R_AD_OriginalADH
	movfw	ADOL
	movwf	R_AD_OriginalADM
	movfw	ADOLL
	movwf	R_AD_OriginalADL
		
;	movlw   0x80
;	addwf   R_AD_OriginalADH,1
;	
;	movlw   11111000b
;	andwf   R_AD_OriginalADL,1 ;clr  舍弃低3位
;		
;	bcf     status,c
;	rrf     R_AD_OriginalADH,1
;	rrf     R_AD_OriginalADM,1
;	rrf     R_AD_OriginalADL,1
;	bcf     status,c
;	rrf     R_AD_OriginalADH,1
;	rrf     R_AD_OriginalADM,1
;	rrf     R_AD_OriginalADL,1
;	bcf     status,c
;	rrf     R_AD_OriginalADH,1
;	rrf     R_AD_OriginalADM,1
;	rrf     R_AD_OriginalADL,1
	bsf		R_AD_FLAG,0	
INT_BS_GET_AD_E:
	
	
