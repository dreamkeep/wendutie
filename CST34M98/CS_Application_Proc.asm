 ;============================================
;                  ����
; �ó�������ο��������д�����©�� 
; о���Ƽ����޹�˾�Դ˲��е��κ����Ρ�
; (C)Shenzhen Chipsea Technologies Co.,Ltd
;============================================
; filename: CS_Application_Proc.asm
; chip    : CST34M97
; author  : CS0155
; date    : 2017-06-22
; v1.0
;============================================
; ��������
;============================================

;============================================
; ������ַ����
;============================================		
;�ֲ�����
R_Application_SEG_S		equ		R_ALC_Application_S


;---CS_APP_Display.asm������ַ����
R_APP_Display_S			equ		R_Application_SEG_S+0
R_APP_Display_E			equ		R_APP_Display_S+7

;---CS_APP_Key.asm������ַ����
R_APP_KEY_S				equ		R_Application_SEG_S+8
R_APP_KEY_E				equ		R_APP_KEY_S+1

;ȫ�ֱ���

 

;============================================
; �ӳ���ΰ���
;============================================
;include		CS_APP_Key.asm
;============================================
; Ӧ��������
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
;F_Application_Proc:
;	
;L_Application_Run:
;	btfss	R_Flag_DetVoltage,B_LowBat
;	goto	$+3
;	bsf		PTCON,BZEN
;	goto	L_Application_Proc_Exit 
;	call	F_APP_KeyProc	
;	
;	movlw	9									;<�޶�ָ��߽�>
;	subwf	R_Thermometer_Pointer,0
;	btfsc	STATUS,C
;	return
;	movfw	R_Thermometer_Pointer				;��ת����Ӧ�Ĳ���
;	addpcw	
;	goto	L_Thermometer_Open
;	goto	L_TMSR_ADShort
;	goto	L_TMSR_AD_Data
;	goto	L_TMSR_Rest_Data
;	goto	L_Thmpsr_ADShort
;	goto	L_Thmpsr_AD_Data
;	goto	L_Thermometer_Data
;	goto	L_TEN_AD_Data
;	goto	L_Thermometer_Close
;L_Thermometer_Open:
;	call	F_TEPture_Open		
;	goto	L_Application_Proc_Exit 
;L_TMSR_ADShort:
;	call	F_TMSR_ADShort_Init
;	movlw	01h					
;	andlw	0fh
;	movwf	R_DSP_BUFFER2
;	call	F_TMSR_ADShort_Data_TX
;;	call	F_Thermometer_AD_Show
;	goto	L_Application_Proc_Exit		
;L_TMSR_AD_Data:
;	call	F_TMSR_Init
;	movlw	02h					
;	andlw	0fh
;	movwf	R_DSP_BUFFER2
;	call	F_TMSR_AD_Data_TX
;;	call	F_Thermometer_AD_Show
;	goto	L_Application_Proc_Exit	
;L_TMSR_Rest_Data:
;	call	F_TMSR_Rest_TX
;	movlw	03h					
;	andlw	0fh
;	movwf	R_DSP_BUFFER2
;;	call	F_TMSR_Rest_Show
;	goto	L_Application_Proc_Exit
;L_Thmpsr_ADShort:
;	call	F_Thmpsr_ADShort_Init
;	movlw	04h					
;	andlw	0fh
;	movwf	R_DSP_BUFFER2
;	call	F_Thmpsr_ADShort_Data_TX
;;	call	F_Thermometer_AD_Show
;	goto	L_Application_Proc_Exit
;L_Thmpsr_AD_Data:
;	call	F_Thmpsr_Init
;	movlw	05h					
;	andlw	0fh
;	movwf	R_DSP_BUFFER2
;	call	F_Thmpsr_AD_Data_TX
;;	call	F_Thermometer_AD_Show
;	goto	L_Application_Proc_Exit
;L_Thermometer_Data:
;	call	F_AD_Temp_Init
;	movlw	06h					
;	andlw	0fh
;	movwf	R_DSP_BUFFER2
;	call	F_Temp
;;	call	F_Temp_show
;	goto	L_Application_Proc_Exit	
;L_TEN_AD_Data:
;	call	F_Measure_Volt
;	movlw	07h					
;	andlw	0fh
;	movwf	R_DSP_BUFFER2
;	call	L_TEN_ADTX
;	goto	L_Application_Proc_Exit	
;L_Thermometer_Close:
;	call	F_TEPture_Sleep_Show
;	incf	R_Temp_Sleep_Count,f
;	movlw	150
;	subwf	R_Temp_Sleep_Count,0
;	btfss	status,c
;	goto	L_Application_Proc_Exit	
;	call	F_SOC_Sleep
;	call	F_TEPture_Clrf
;L_Application_Proc_Exit:	
;	return
;
;F_TEPture_Clrf:
;	clrf	R_Thermometer_Pointer
;	clrf	R_Temperature_Flag
;	return 
	
	
;============================================
; Ϩ��
;============================================	
;F_App_ShowNull:
;	movlw	C_Ch_null
;	movwf	R_DSP_BUFFER1
;	movwf	R_DSP_BUFFER2
;	movwf	R_DSP_BUFFER3
;	movwf	R_DSP_BUFFER4
;	movwf	R_DSP_BUFFER5
;	movwf	R_DSP_BUFFER6
;	movwf	R_DSP_BUFFER7	
;	
;	clrf	R_DSP_BUFFER9
;L_App_ShowNull_Exit:
;	return	

	
	
	

