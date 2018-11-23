;============================================
;                  ����
; �ó�������ο��������д�����©�� 
; о���Ƽ����޹�˾�Դ˲��е��κ����Ρ�
; (C)Shenzhen Chipsea Technologies Co.,Ltd
;============================================
; filename: CS_APP_Key.asm
; chip    : CST34M97
; author  : CS0155
; date    : 2017-07-01
; v1.0
;============================================
; ��������
;============================================
C_Key_ShortPressTime		    equ		25		;15*30ms�ڸ�ʱ������Ϊ�Ƕ̰�
C_Key_PressKeyTimes				equ		3		;�̰�����
;============================================
; ������ַ����
;============================================		
;�ֲ�����
R_Key_ShortPressCount			equ		R_APP_KEY_S+0	;�̰���ʱ����
R_Key_ShortPressTimes			equ		R_APP_KEY_S+1	;�����̰�����ͳ��

;ȫ�ֱ���

;============================================
; ���������߼�
;============================================
; ��ڱ�����
; ���ڱ�����  
; �м������
; ��־λ��  
; ʵ�ֵĹ��ܣ�
;     
; ����˼·��
;   NOP    
;============================================
F_APP_KeyProc:	
	movlw	ffh
	subwf	R_Key_ShortPressCount,w
	btfss	STATUS,C
	incf	R_Key_ShortPressCount,f
	
	btfsc	R_KEY_F,B_KEY_PRESS_S
	goto	F_APP_KeyProc_L1			;�����հ��´���
	btfsc	R_KEY_F,B_KEY_LONGPRESS_S
	goto	F_APP_KeyProc_L2			;�����ճ����´���
	btfsc	R_KEY_F,B_KEY_PRESS_E		
	goto	F_APP_KeyProc_L3			;�̰�������
	btfsc	R_KEY_F,B_KEY_LONGPRESS_E
	goto	L_APP_KeyProc_Exit			;��������������
L_APP_KeyProc_Exit:
	return
	
;--- �����հ��´���		
F_APP_KeyProc_L1:
	incf	R_Thermometer_Pointer,1
	movlw	9
	subwf	R_Thermometer_Pointer,0
	btfsc	status,c
	clrf	R_Data_Pointer
	movlw	C_Key_ShortPressTime
	subwf	R_Key_ShortPressCount,w
	btfsc	STATUS,C
	clrf	R_Key_ShortPressTimes
	clrf	R_Key_ShortPressCount
	goto	L_APP_KeyProc_Exit

	
;---�����ճ����´���
F_APP_KeyProc_L2:		
	movlw	C_Key_PressKeyTimes			;�Ƿ񾭹����ɴζ̰�
	xorwf	R_Key_ShortPressTimes,w
	btfss	STATUS,Z
	goto	F_APP_KeyProc_L2_1
	
		
F_APP_KeyProc_L2_1:	
	clrf	R_Key_ShortPressTimes
	clrf	R_Key_ShortPressCount
	
	goto	L_APP_KeyProc_Exit
	
;---�����̰��µ�����	
F_APP_KeyProc_L3:	
	clrf	R_Key_ShortPressCount
	movlw	C_Key_ShortPressTime
	subwf	R_Key_ShortPressCount,w
	btfss	STATUS,C
	goto	F_APP_KeyProc_L3_1
	clrf	R_Key_ShortPressTimes	
	goto	L_APP_KeyProc_Exit	
F_APP_KeyProc_L3_1:	
	incf	R_Key_ShortPressTimes,f
	goto	L_APP_KeyProc_Exit
	
	
	



