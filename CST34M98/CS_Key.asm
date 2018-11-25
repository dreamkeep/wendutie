;============================================
;                  ����
; �ó�������ο��������д�����©�� 
; о���Ƽ����޹�˾�Դ˲��е��κ����Ρ�
; (C)Shenzhen Chipsea Technologies Co.,Ltd
;============================================
; filename: CS_HW_Key.asm
; chip    : CST34M97
; author  : CS0155
; date    : 2017-06-30
; v1.0
;============================================
; ��������
;============================================
;---�����ӿڶ���---
DEFINE	P_KEY_PORT	"PT2,4"


	
;---����������---     
C_KEY_NAME          EQU     1         ;��������
C_KEY_LP_TL         EQU     10        ;����һ����ʱ
C_KEY_LP_TH         EQU     3		  ;����������ʱ
;============================================
; ������ַ����
;============================================		
;�ֲ�����
R_KEY_S				equ  R_ALC_KEY_S
R_KEY               equ  R_KEY_S+0       ;�洢������ֵ
R_KEY_TL            equ  R_KEY_S+1       ;����������ʱ
R_KEY_TH            equ  R_KEY_S+2       ;����������ʱ

;================================================
;����ɨ�账���� 
;================================================
;��ڱ�����û��
;���ڱ�����R_KEY_F
;�м������R_KEY��R_KEY_TL��R_KEY_TH
;ʵ�ֹ��ܣ�
;          ����IO�����Ӱ�����״̬�������״̬��
;          B_KEY_PRESS         ��������
;          B_KEY_LONGPRESS     ��������
;          B_KEY_PRESS_E       �����̰�����
;          B_KEY_LONGPRESS_E   ������������
;          (����ÿ20ms����һ��)    
;================================================
/*
F_Key_Scan:	
    btfss  P_KEY_PORT				  ;���������·�   
    goto   F_KEY_1                    ;���¾��������������µĴ���
    
    clrf   R_KEY                      ;��������״̬��ֵΪ0
    bcf	   R_KEY_F,B_KEY_PRESS_S	  ;�尴���հ��µı�־ 
    bcf	   R_KEY_F,B_KEY_PRESS_E      ;�尴�����º����־ 
    bcf	   R_KEY_F,B_KEY_LONGPRESS_S  ;�尴���ճ����µı�־ 
    bcf	   R_KEY_F,B_KEY_LONGPRESS_E  ;�尴�����������־  
    btfss  R_KEY_F,B_KEY_PRESS        ;�ж�֮ǰ�Ƿ��м�����
    goto   F_KEY_EE                   ;û������
                                      ;�н����ɿ������Ĵ���
    btfsc  R_KEY_F,B_KEY_LONGPRESS
    goto   F_KEY_LPE                  ;�������������� 
    goto   F_KEY_SPE                  ;�����̰�������
;-------------------------------    
;���´���  
;-------------------------------  
F_KEY_1:    
    movlw  C_KEY_NAME                 ;�����ļ�ֵ
    xorwf  R_KEY,0                    ;�жϺ���һ�εļ�ֵ�Ƿ�һ��
    movlw  C_KEY_NAME
    btfsc  status,z
    goto   F_KEY_2                    ;��ͬ��ת���������´���
    movwf  R_KEY                      ;��ͬ�洢��ֵ
    bcf    R_KEY_F,B_KEY_PRESS        ;����а������µı�־ 
    bcf    R_KEY_F,B_KEY_LONGPRESS    ;���������־   
    goto   F_KEY_EE                   ;�˳�����ɨ�� 
F_KEY_2:     
    btfsc  R_KEY_F,B_KEY_PRESS        ;���ΰ�������
    goto   F_KEY_LPS                  ;��ȥ�����ĳ�������
    
    bsf    R_KEY_F,B_KEY_PRESS        ;��������ʱ�Ĵ���
    bsf	   R_KEY_F,B_KEY_PRESS_S	  ;����հ��±�־
    clrf   R_KEY_TL                   ;�������µ�ʱ�����¼���
    clrf   R_KEY_TH

    goto   F_KEY_EE
    
;-------------------------------    
;��������  
;-------------------------------    
F_KEY_LPS: 
	bcf	   R_KEY_F,B_KEY_PRESS_S	   ;����հ��±�־
    movlw  C_KEY_LP_TL                 ;������ʱ����
    xorwf  R_KEY_TL,0                  ;�жϺ�L_KEY_LP_TL�Ƿ����
    btfss  status,z      
    goto   F_KEY_LPS1                  ;��ͬ��ת
    incf   R_KEY_TH,f                  ;��ͬ�����ӵڶ���������
    movlw  255
    movwf  R_KEY_TL
F_KEY_LPS1:
    incf   R_KEY_TL,f 
    movlw  C_KEY_LP_TH
    subwf  R_KEY_TH,w                  ;R_KEY_TH�Ƿ����L_KEY_LP_TH
    btfss  status,c                    ;������ʱC��־λΪ��
    goto   F_KEY_EE    
    
    decf   R_KEY_TH,f                  ;��ֹ�������  
    btfsc  R_KEY_F,B_KEY_LONGPRESS     ;����ֻ����һ�β����Ĵ���
    goto   F_KEY_LPS2
    bsf    R_KEY_F,B_KEY_LONGPRESS     ;����������־
    bsf	   R_KEY_F,B_KEY_LONGPRESS_S   ;�ճ����µı�־
    goto   F_KEY_EE 
F_KEY_LPS2:
	bcf	   R_KEY_F,B_KEY_LONGPRESS_S
	goto   F_KEY_EE
;-------------------------------    
;�̰�����  
;-------------------------------  
F_KEY_SPE:                        
    bcf    R_KEY_F,B_KEY_PRESS         ;����������±�־  
    bsf	   R_KEY_F,B_KEY_PRESS_E       ;���𰴼����º����־  
    goto   F_KEY_EE
;-------------------------------    
;��������  
;-------------------------------       
F_KEY_LPE:    
    bcf    R_KEY_F,B_KEY_PRESS          ;����������±�־
    bcf    R_KEY_F,B_KEY_LONGPRESS      ;���������־   
    bsf	   R_KEY_F,B_KEY_LONGPRESS_E    ;�ð������������־
    goto   F_KEY_EE    
;-------------------------------    
;�˳�����ɨ��  
;------------------------------- 
F_KEY_EE:   
    return
*/

