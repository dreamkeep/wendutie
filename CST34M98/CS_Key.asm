;============================================
;                  声明
; 该程序仅供参考若程序中存在疏漏， 
; 芯海科技有限公司对此不承担任何责任。
; (C)Shenzhen Chipsea Technologies Co.,Ltd
;============================================
; filename: CS_HW_Key.asm
; chip    : CST34M97
; author  : CS0155
; date    : 2017-06-30
; v1.0
;============================================
; 常量定义
;============================================
;---按键接口定义---
DEFINE	P_KEY_PORT	"PT2,4"


	
;---立即数定义---     
C_KEY_NAME          EQU     1         ;按键键名
C_KEY_LP_TL         EQU     10        ;长按一级计时
C_KEY_LP_TH         EQU     3		  ;长按二级计时
;============================================
; 变量地址分配
;============================================		
;局部变量
R_KEY_S				equ  R_ALC_KEY_S
R_KEY               equ  R_KEY_S+0       ;存储按键键值
R_KEY_TL            equ  R_KEY_S+1       ;按键长按计时
R_KEY_TH            equ  R_KEY_S+2       ;按键长按计时

;================================================
;按键扫描处理函数 
;================================================
;入口变量：没有
;出口变量：R_KEY_F
;中间变量：R_KEY，R_KEY_TL，R_KEY_TH
;实现功能：
;          根据IO口所接按键的状态输出四种状态：
;          B_KEY_PRESS         按键按下
;          B_KEY_LONGPRESS     按键长按
;          B_KEY_PRESS_E       按键短按弹起
;          B_KEY_LONGPRESS_E   按键长按弹起
;          (函数每20ms调用一次)    
;================================================
/*
F_Key_Scan:	
    btfss  P_KEY_PORT				  ;按键被按下否   
    goto   F_KEY_1                    ;按下就跳到按键被按下的处理
    
    clrf   R_KEY                      ;按键弹起状态键值为0
    bcf	   R_KEY_F,B_KEY_PRESS_S	  ;清按键刚按下的标志 
    bcf	   R_KEY_F,B_KEY_PRESS_E      ;清按键按下后弹起标志 
    bcf	   R_KEY_F,B_KEY_LONGPRESS_S  ;清按键刚长按下的标志 
    bcf	   R_KEY_F,B_KEY_LONGPRESS_E  ;清按键长按弹起标志  
    btfss  R_KEY_F,B_KEY_PRESS        ;判断之前是否有键按下
    goto   F_KEY_EE                   ;没有跳走
                                      ;有进行松开按键的处理
    btfsc  R_KEY_F,B_KEY_LONGPRESS
    goto   F_KEY_LPE                  ;按键长按后弹起处理 
    goto   F_KEY_SPE                  ;按键短按后弹起处理
;-------------------------------    
;按下处理  
;-------------------------------  
F_KEY_1:    
    movlw  C_KEY_NAME                 ;按键的键值
    xorwf  R_KEY,0                    ;判断和上一次的键值是否一样
    movlw  C_KEY_NAME
    btfsc  status,z
    goto   F_KEY_2                    ;相同跳转到按键按下处理
    movwf  R_KEY                      ;不同存储键值
    bcf    R_KEY_F,B_KEY_PRESS        ;清除有按键按下的标志 
    bcf    R_KEY_F,B_KEY_LONGPRESS    ;清除长按标志   
    goto   F_KEY_EE                   ;退出按键扫描 
F_KEY_2:     
    btfsc  R_KEY_F,B_KEY_PRESS        ;单次按键处理
    goto   F_KEY_LPS                  ;跳去按键的长按处理
    
    bsf    R_KEY_F,B_KEY_PRESS        ;按键按下时的处理
    bsf	   R_KEY_F,B_KEY_PRESS_S	  ;置起刚按下标志
    clrf   R_KEY_TL                   ;按键按下的时间重新计算
    clrf   R_KEY_TH

    goto   F_KEY_EE
    
;-------------------------------    
;长按处理  
;-------------------------------    
F_KEY_LPS: 
	bcf	   R_KEY_F,B_KEY_PRESS_S	   ;清起刚按下标志
    movlw  C_KEY_LP_TL                 ;长按定时处理
    xorwf  R_KEY_TL,0                  ;判断和L_KEY_LP_TL是否相等
    btfss  status,z      
    goto   F_KEY_LPS1                  ;不同跳转
    incf   R_KEY_TH,f                  ;相同则增加第二个计数器
    movlw  255
    movwf  R_KEY_TL
F_KEY_LPS1:
    incf   R_KEY_TL,f 
    movlw  C_KEY_LP_TH
    subwf  R_KEY_TH,w                  ;R_KEY_TH是否大于L_KEY_LP_TH
    btfss  status,c                    ;不够减时C标志位为零
    goto   F_KEY_EE    
    
    decf   R_KEY_TH,f                  ;防止溢出处理  
    btfsc  R_KEY_F,B_KEY_LONGPRESS     ;长按只进行一次操作的处理
    goto   F_KEY_LPS2
    bsf    R_KEY_F,B_KEY_LONGPRESS     ;产生长按标志
    bsf	   R_KEY_F,B_KEY_LONGPRESS_S   ;刚长按下的标志
    goto   F_KEY_EE 
F_KEY_LPS2:
	bcf	   R_KEY_F,B_KEY_LONGPRESS_S
	goto   F_KEY_EE
;-------------------------------    
;短按后处理  
;-------------------------------  
F_KEY_SPE:                        
    bcf    R_KEY_F,B_KEY_PRESS         ;清除按键按下标志  
    bsf	   R_KEY_F,B_KEY_PRESS_E       ;置起按键按下后弹起标志  
    goto   F_KEY_EE
;-------------------------------    
;长按后处理  
;-------------------------------       
F_KEY_LPE:    
    bcf    R_KEY_F,B_KEY_PRESS          ;清除按键按下标志
    bcf    R_KEY_F,B_KEY_LONGPRESS      ;清除长按标志   
    bsf	   R_KEY_F,B_KEY_LONGPRESS_E    ;置按键长按弹起标志
    goto   F_KEY_EE    
;-------------------------------    
;退出按键扫描  
;------------------------------- 
F_KEY_EE:   
    return
*/

