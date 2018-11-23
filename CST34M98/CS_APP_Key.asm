;============================================
;                  声明
; 该程序仅供参考若程序中存在疏漏， 
; 芯海科技有限公司对此不承担任何责任。
; (C)Shenzhen Chipsea Technologies Co.,Ltd
;============================================
; filename: CS_APP_Key.asm
; chip    : CST34M97
; author  : CS0155
; date    : 2017-07-01
; v1.0
;============================================
; 常量定义
;============================================
C_Key_ShortPressTime		    equ		25		;15*30ms在该时间内认为是短按
C_Key_PressKeyTimes				equ		3		;短按次数
;============================================
; 变量地址分配
;============================================		
;局部变量
R_Key_ShortPressCount			equ		R_APP_KEY_S+0	;短按计时变量
R_Key_ShortPressTimes			equ		R_APP_KEY_S+1	;按键短按次数统计

;全局变量

;============================================
; 按键交互逻辑
;============================================
; 入口变量：
; 出口变量：  
; 中间变量：
; 标志位：  
; 实现的功能：
;     
; 程序思路：
;   NOP    
;============================================
F_APP_KeyProc:	
	movlw	ffh
	subwf	R_Key_ShortPressCount,w
	btfss	STATUS,C
	incf	R_Key_ShortPressCount,f
	
	btfsc	R_KEY_F,B_KEY_PRESS_S
	goto	F_APP_KeyProc_L1			;按键刚按下处理
	btfsc	R_KEY_F,B_KEY_LONGPRESS_S
	goto	F_APP_KeyProc_L2			;按键刚长按下处理
	btfsc	R_KEY_F,B_KEY_PRESS_E		
	goto	F_APP_KeyProc_L3			;短按弹起处理
	btfsc	R_KEY_F,B_KEY_LONGPRESS_E
	goto	L_APP_KeyProc_Exit			;按键长按弹起处理
L_APP_KeyProc_Exit:
	return
	
;--- 按键刚按下处理		
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

	
;---按键刚长按下处理
F_APP_KeyProc_L2:		
	movlw	C_Key_PressKeyTimes			;是否经过若干次短按
	xorwf	R_Key_ShortPressTimes,w
	btfss	STATUS,Z
	goto	F_APP_KeyProc_L2_1
	
		
F_APP_KeyProc_L2_1:	
	clrf	R_Key_ShortPressTimes
	clrf	R_Key_ShortPressCount
	
	goto	L_APP_KeyProc_Exit
	
;---按键短按下弹起处理	
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
	
	
	



