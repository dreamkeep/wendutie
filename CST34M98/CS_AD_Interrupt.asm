;============================================
;                  ����
; �ó�������ο��������д�����©�� 
; о���Ƽ����޹�˾�Դ˲��е��κ����Ρ�
; (C)Shenzhen Chipsea Technologies Co.,Ltd
;============================================
; filename: CS_BodyScale_Interrupt.asm
; author  : CS0155
; date    : 2017-06-29
; v1.0
;============================================
; ������ַ����
;============================================


INT_BS_GET_AD_S:
	btfsc	R_AD_FLAG,B_INT_GetAdc			;����AD�ɼ����־
	goto	INT_BS_GET_AD_E
		
	movfw	ADOH						;��ȡԭʼAD
	movwf	R_AD_OriginalADH
	movfw	ADOL
	movwf	R_AD_OriginalADM
	movfw	ADOLL
	movwf	R_AD_OriginalADL
		
;	movlw   0x80
;	addwf   R_AD_OriginalADH,1
;	
;	movlw   11111000b
;	andwf   R_AD_OriginalADL,1 ;clr  ������3λ
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
	
	
