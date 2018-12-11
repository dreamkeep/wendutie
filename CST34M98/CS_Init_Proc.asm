;============================================
;                  ����
; �ó�������ο��������д�����©�� 
; о���Ƽ����޹�˾�Դ˲��е��κ����Ρ�
; (C)Shenzhen Chipsea Technologies Co.,Ltd
;============================================
; filename: F_PowerOn_Proc.asm
; chip    : CST34M97
; author  : CS0155
; date    : 2017-06-14
; v1.0
;============================================

;============================================
; �ϵ縴λ��ʼ������
;============================================
F_PowerOn_Proc:
	;-------------------------	
	;  ��ʼ��SOC
    ;-------------------------
	call	F_Init_SOC						;��ʼ��оƬ	
	call	Lvdcon_Init
	;bcf		R_Flag_Sys,B_LCD_En
	clrf	R_Data_Pointer
	
	return
	
	
;============================================
; ������λ��ʼ������
;============================================	
F_Standby_Proc:
	call	F_SOC_StandbyInit				;��ʼ��оƬ
	;bcf		R_Flag_Sys,B_LCD_En
	return
	

	
	
;========================================================	
	
;----------------------------------------------------------------------
;@fn		:f_waste_n_ad	
;@brief		:����work��AD
;@param		;work 
;@return	��
;@note      ;��������work ��������
;----------------------------------------------------------------------
f_waste_n_ad:
		movwf		R_TEMP0
	waste_n_ad:
		btfss		R_AD_FLAG,B_INT_GetAdc
		goto		$-1
		bcf			R_AD_FLAG,B_INT_GetAdc
		decfsz		R_TEMP0,1
		goto		waste_n_ad
		return
	
f_display_n_ad:
		movwf		R_TEMP0
	display_n_ad:
		btfss		R_AD_FLAG,B_INT_GetAdc
		goto		$-1
		bcf			R_AD_FLAG,B_INT_GetAdc
		decfsz		R_TEMP0,1
		goto		display_n_ad
		return
	return
	
	
;����������ڶ�
f_seneor_get_short_ad:
	call    F_Thmpsr_ADShort_Init
	movlw   3
	call    f_waste_n_ad
	movlw   4
	movwf   R_TEMP0
	clrf    r_sum_ad_hh
	clrf    r_sum_ad_h
	clrf    r_sum_ad_m
	clrf    r_sum_ad_l
 re_short:
	btfss	R_AD_FLAG,B_INT_GetAdc
	goto    $-1
	
	movfw   R_AD_OriginalADL
	addwf   r_sum_ad_l,1
	
	movfw   R_AD_OriginalADM
	addwfc  r_sum_ad_m,1
	
	movfw   R_AD_OriginalADH
	addwfc  r_sum_ad_h,1
	
	clrf    work
	addwfc  r_sum_ad_hh,1
	
	decfsz  R_TEMP0,1
	goto    re_short
	bcf     status,c
	rrf     r_sum_ad_hh,1
	rrf     r_sum_ad_h,1
	rrf     r_sum_ad_m,1
	rrf     r_sum_ad_l,1
	bcf     status,c
	rrf     r_sum_ad_hh,1
	rrf     r_sum_ad_h,1
	rrf     r_sum_ad_m,1
	rrf     r_sum_ad_l,1  ;/4
	
	movfw   r_sum_ad_h
	movwf   r_short_ad_h
	movfw   r_sum_ad_m
	movwf   r_short_ad_m	
	movfw   r_sum_ad_l
	movwf   r_short_ad_l	
	return
	
;���������AIN01 ʵʱ�¶�
f_seneor_get_ain01_ad:
	call    F_Thmpsr_AIN01_Init
	movlw   3
	call    f_waste_n_ad
	movlw   4
	movwf   R_TEMP0
	clrf    r_sum_ad_hh
	clrf    r_sum_ad_h
	clrf    r_sum_ad_m
	clrf    r_sum_ad_l
 re_ain01:
	btfss	R_AD_FLAG,B_INT_GetAdc
	goto    $-1
	
	movfw   R_AD_OriginalADL
	addwf   r_sum_ad_l,1
	
	movfw   R_AD_OriginalADM
	addwfc  r_sum_ad_m,1
	
	movfw   R_AD_OriginalADH
	addwfc  r_sum_ad_h,1

	clrf    work
	addwfc  r_sum_ad_hh,1
	
	decfsz  R_TEMP0,1
	goto    re_ain01
	bcf     status,c
	rrf     r_sum_ad_hh,1
	rrf     r_sum_ad_h,1
	rrf     r_sum_ad_m,1
	rrf     r_sum_ad_l,1
	bcf     status,c
	rrf     r_sum_ad_hh,1
	rrf     r_sum_ad_h,1
	rrf     r_sum_ad_m,1
	rrf     r_sum_ad_l,1  ;/4
	
	movfw   r_sum_ad_h
	movwf   r_ain01_ad_h
	movfw   r_sum_ad_m
	movwf   r_ain01_ad_m	
	movfw   r_sum_ad_l
	movwf   r_ain01_ad_l	
	return	
	
;���������AIN23 �߱��¶�
f_seneor_get_ain23_ad:
	call    F_Thmpsr_AIN23_Init
	movlw   3
	call    f_waste_n_ad
	movlw   4
	movwf   R_TEMP0
	clrf    r_sum_ad_hh
	clrf    r_sum_ad_h
	clrf    r_sum_ad_m
	clrf    r_sum_ad_l
 re_ain23:
	btfss	R_AD_FLAG,B_INT_GetAdc
	goto    $-1
	
	movfw   R_AD_OriginalADL
	addwf   r_sum_ad_l,1
	
	movfw   R_AD_OriginalADM
	addwfc  r_sum_ad_m,1
	
	movfw   R_AD_OriginalADH
	addwfc  r_sum_ad_h,1
	
	clrf    work
	addwfc  r_sum_ad_hh,1
	
	decfsz  R_TEMP0,1
	goto    re_ain23
	bcf     status,c
	rrf     r_sum_ad_hh,1
	rrf     r_sum_ad_h,1
	rrf     r_sum_ad_m,1
	rrf     r_sum_ad_l,1
	bcf     status,c
	rrf     r_sum_ad_hh,1
	rrf     r_sum_ad_h,1
	rrf     r_sum_ad_m,1
	rrf     r_sum_ad_l,1  ;/4
	
	movfw   r_sum_ad_h
	movwf   r_ain23_ad_h
	movfw   r_sum_ad_m
	movwf   r_ain23_ad_m	
	movfw   r_sum_ad_l
	movwf   r_ain23_ad_l	
	return		
	
f_sensor_err_check:
	bcf      R_Flag_Sys,B_Sensor_err
	;debug
;	movlw   0x5A
;    call    F_Uart0_Send_Byte
;    
;	movfw   r_short_ad_h
;    call    F_Uart0_Send_Byte
;	movfw   r_short_ad_m
;    call    F_Uart0_Send_Byte    
;	movfw   r_short_ad_l
;    call    F_Uart0_Send_Byte  
;    
;	movfw   r_ain23_ad_h
;    call    F_Uart0_Send_Byte
;	movfw   r_ain23_ad_m
;    call    F_Uart0_Send_Byte    
;	movfw   r_ain23_ad_l
;    call    F_Uart0_Send_Byte  
;    
;	movfw   r_ain01_ad_h
;    call    F_Uart0_Send_Byte
;	movfw   r_ain01_ad_m
;    call    F_Uart0_Send_Byte    
;	movfw   r_ain01_ad_l
;    call    F_Uart0_Send_Byte  
;    
; 	movlw   0xA5
;    call    F_Uart0_Send_Byte   
    ;debug
    
	movlw    0x10
	addwf    r_short_ad_l,0
	movwf    R_SYS_A0
	
	movlw    0x00
	addwfc   r_short_ad_m,0
	movwf    R_SYS_A1
	
	movlw    0x80
	addwfc   r_short_ad_h,0
	movwf    R_SYS_A2              ;R_SYS_A2/1/0 = r_short_ad_h/m/l + 0x800000 + ��
 
	movlw    0x00
	addwf    r_ain23_ad_l,0
	movwf    R_SYS_B0
	
	movlw    0x00
	addwfc   r_ain23_ad_m,0
	movwf    R_SYS_B1
	
	movlw    0x80
	addwfc   r_ain23_ad_h,0
	movwf    R_SYS_B2             ;R_SYS_B2/1/0 = r_ain23_ad_h/m/l + 0x800000
	
	movlw    0x00
	addwf    r_ain01_ad_l,0
	movwf    R_SYS_C0
	
	movlw    0x00
	addwfc   r_ain01_ad_m,0
	movwf    R_SYS_C1
	
	movlw    0x80
	addwfc   r_ain01_ad_h,0
	movwf    R_SYS_C2            ;R_SYS_C2/1/0 = r_ain01_ad_h/m/l + 0x800000
	
 check_ain23:	
	movfw    R_SYS_B0
	subwf    R_SYS_A0,0
	movfw    R_SYS_B1
	subwfc   R_SYS_A1,0
	movfw    R_SYS_B2
	subwfc   R_SYS_A2,0
	btfss    status,c           ;R_SYS_A2/1/0 - R_SYS_B2(ain23)
	goto     check_ain01
	bsf      R_Flag_Sys,B_Sensor_err
	return   

 check_ain01:
    movfw    R_SYS_C0
    subwf    R_SYS_A0,0
    movfw    R_SYS_C1
    subwfc   R_SYS_A1,0
    movfw    R_SYS_C2
    subwfc   R_SYS_A2,0           ;R_SYS_A2/1/0 - R_SYS_C2(ain01)
    btfsc    status,c
    bsf      R_Flag_Sys,B_Sensor_err
	return
	
	
	
	
	
;	call    F_Thmpsr_ADShort_Init
;	movlw   3
;	call    f_waste_n_ad
;	movlw   4
;	call    f_display_n_ad
;	
;    call    F_Thmpsr_AIN01_Init  ;AIN0ΪVin+��AIN1ΪVin-
;	movlw   3
;	call    f_waste_n_ad
;	movlw   8
;	call    f_display_n_ad
;	
;    call    F_Thmpsr_AIN23_Init   ;AIN2ΪVin+��AIN3ΪVin-
;	movlw   3
;	call    f_waste_n_ad
;	movlw   8
;	call    f_display_n_ad
	
	
	
	
	
f_open_int0:;2.4
	clrf   ptcon
	clrf   ptint0
	clrf   ptint1
	bsf    ptint0,6 ;pt2.4
	bsf    inte,E0IE ;enable int0 
	bsf    inte,GIE  ;enable GIE 
return

f_close_int0:
	clrf   ptcon
	clrf   ptint0
	clrf   ptint1
	bcf    inte,E0IE ;enable int0 
	bcf    inte,GIE  ;enable GIE 		
return
	
/*
pcl(gpio3) 2.5 pda(key) 2.4 
beep 2.1
mcu-rx 1.7 mcu-tx-1.6
mcu-wk 2.0
led 1.3 1.4
*/
f_sleep_init:
	    ;IO����
		movlw      10111111b
		movwf      pt1en

		movlw 	   00000000b  ;1.3 1.4 �Ͽ�������������ͣ�
		movwf 	   pt1pu

		clrf       pt1
		bsf        pt1,7  ;tx
		
		movlw      11001011b
		movwf      pt2en

		movlw      00110100b   ;2.2 2.4 ��������
		movwf      pt2pu
		
		movlw      00100001b
		movwf      pt2      ;2.5��Ӧble_status ����� 2.4�Ͽ���������� 2.0����� beep����
        
		movlw      0xff
		movwf      pt3en

		clrf       pt3pu
        clrf       pt3 

 		movlw      0xff
		movwf      pt4en

		clrf       pt4pu
        clrf       pt4 

    	movlw      00011111b
    	movwf	   pt5en

		clrf       pt5pu
        clrf       pt5 
        
        ;��ʼ���ⲿ�ж�
        clrf       ptint0
        clrf       ptint1
        ;�ر�ADC LCD TIM VS  ʧ��
        bcf        anacfg,ldoen  
		BCF			ANACFG,ADEN     ;adc  en
		bcf 	   lcdenr,lcden 
		bcf	       LCDENR,ENPMPL	;��pump
		bcf		   LVDCON,LVDEN
		bcf			tm0con,7
		bcf			tm1con,7
		bcf			tm2con,7
		bcf			tm3con,7        ;tim  en
		bcf         UR1_CR1,0       ;uart en
		BCF			INTE,ADIE 	    ;adc  isr
		bCf			inte,TM0IE
		bcf			inte,TM1IE
		bcf			INTE3,TM3IE	    ;tim  isr
		bcf			inte2,UR1_RNIE	;uart isr
        ;�ر��ж�
        clrf       inte
        clrf       intf  
        clrf       inte2
        clrf       intf2               
        clrf       inte3
        clrf       intf3 	
return

f_wake_up_init:	
	    bcf         pt2en,5 ;ble_status
	    
	    
		bsf 	    anacfg,ldoen
		BSF			ANACFG,ADEN     ;adc  en
	    bsf		    LVDCON,LVDEN
		bcf			tm0con,7
		bcf			tm1con,7
		bcf			tm2con,7
		bcf			tm3con,7        ;tim  en
		bsf         UR1_CR1,0       ;uart en
		BSF			INTE,ADIE 	    ;adc  isr
		bsf			inte,TM0IE
		bsf			inte,TM1IE
		bsf			INTE3,TM3IE	    ;tim  isr
		bsf			inte2,UR1_RNIE	;uart isr
		BSF			INTE,GIE        ;gie  
		clrf    R_DSP_BUFFER1
		clrf    R_DSP_BUFFER2  ;��ʱ
		clrf    R_DSP_BUFFER3
		clrf    R_DSP_BUFFER4  ;t0 ���̼��2s
		clrf    R_DSP_BUFFER5
		clrf    R_DSP_BUFFER6  ;t1 ʵʱģʽ�¼��30s�����¶�
		clrf    R_DSP_BUFFER7
		clrf    R_DSP_BUFFER8  ;�ۼ�16s �¶��ȶ��ж�
		clrf    R_DSP_BUFFER9
		clrf    R_DSP_BUFFER10 ;t3 10min��ʱ	
		clrf    R_DSP_BUFFER11
return
	
	

f_beep_work_150_ms:
	bsf		    PTCON,BZEN
    movlw	    150
	call   	    F_delay_1ms
	bcf		    PTCON,BZEN
	return
	
	
;[in] R_DSP_BUFFER1 R_DSP_BUFFER2
f_sleep_n_ms_or_key_press:
l_sleep_n_ms_or_key_press:
;	btfsc       R_thermometer_FLAG,b_key_lock
;	return
	btfss       POWER_ON_KEY
	return
	
    movlw	    1
	call   	    F_delay_1ms	
	
	movlw       1
	subwf       R_DSP_BUFFER2,1
	movlw       0
	subwfc      R_DSP_BUFFER1,1
	btfsc       status,c
	goto        l_sleep_n_ms_or_key_press
	return
	
;[in]  R_DSP_BUFFER1 R_DSP_BUFFER2
;key press  B_N_MS_TM =1
;timeout    B_N_MS_TM =0
f_green_n_ms_or_key_press:
	bcf         R_Flag_Sys,B_N_MS_TM
    call        f_led_green
l_green_n_ms_or_key_press:
;	btfsc       R_thermometer_FLAG,b_key_lock
;	return
	btfsc       POWER_ON_KEY
	goto        l_green_n_ms_or_key_press_l1
	bsf         R_Flag_Sys,B_N_MS_TM
	return
l_green_n_ms_or_key_press_l1:	
	call        f_led_green
    movlw	    1
	call   	    F_delay_1ms	
	
	movlw       1
	subwf       R_DSP_BUFFER2,1
	movlw       0
	subwfc      R_DSP_BUFFER1,1
	btfsc       status,c
	goto        l_green_n_ms_or_key_press
	call        f_no_led
	bcf         R_Flag_Sys,B_N_MS_TM
	return	
	
;[in]  R_DSP_BUFFER1 R_DSP_BUFFER2
;key press  B_N_MS_TM =1
;timeout    B_N_MS_TM =0
f_red_n_ms_or_key_press:
	bcf         R_Flag_Sys,B_N_MS_TM
    call        f_led_red
l_red_n_ms_or_key_press:
;	btfsc       R_thermometer_FLAG,b_key_lock
;	return
	btfsc       POWER_ON_KEY
	goto        l_red_n_ms_or_key_press_l1
	bsf         R_Flag_Sys,B_N_MS_TM
	return
l_red_n_ms_or_key_press_l1:	
	call        f_led_red
    movlw	    1
	call   	    F_delay_1ms	
	
	movlw       1
	subwf       R_DSP_BUFFER2,1
	movlw       0
	subwfc      R_DSP_BUFFER1,1
	btfsc       status,c
	goto        l_red_n_ms_or_key_press
	call        f_no_red
	bcf         R_Flag_Sys,B_N_MS_TM
	return		
	
	
f_led_red:;�����
	bsf     RED_LED		
f_no_green:;�̵���
	bcf		GREEN_LED
    return
   
f_led_green:;�̵���
	bsf		GREEN_LED
f_no_red:;�����
	bcf     RED_LED		
	return

f_no_led:;ȫ��
	bcf     RED_LED		
	bcf		GREEN_LED
	return
	
	
;�����
;[in] ���EADRH EADRL ������������TABLE_ADDR_START��ƫ�Ƶ�ַ
;[out]���R_TEMP5 R_TEMP4 R_TEMP3 h/m/l
f_get_table_data:
	movfw   EADRL
	addwf   EADRL,1
	movfw   EADRH
	addwfc  EADRH,1  ;x2
	
	movlw	low   TABLE_ADDR_START
	addwf	EADRL,1	
	movlw	high  TABLE_ADDR_START
	addwfc	EADRH,1                       ;+offset

	movp
	movwf   R_TEMP5
	
	movlw	1
	addwf	EADRL,1
	clrf	work
	addwfc	EADRH,1 ;+1
	movp
	movwf   R_TEMP3 
	movfw   EDAT
	movwf   R_TEMP4
return
	
	
;r_table_res_l   equ  1C0H  ;����table
;r_table_res_m   equ  1C1H
;r_table_res_h   equ  1C2H
;

;
;r_table_from_l   equ  1C5H  ;table from ���
;r_table_from_h   equ  1C6H  ;table from ���
;
;r_table_to_l   equ  1C7H   ;table to ���
;r_table_to_h   equ  1C8H   ;table to ���
	
;[in]R_RestL				equ	 b0h
;R_RestM				equ	 b1h
;R_RestH				equ	 b2h
;[out]
;r_table_temp_l   equ  1C3H  ;�¶�table
;r_table_temp_h   equ  1C4H	
	
;data С-->��
;R_TEMP3				equ	 87h l
;R_TEMP4				equ	 88h m
;R_TEMP5				equ	 89h h
f_res_to_temp: ;����ת�����¶�
	
	;R_RestH/m/l - data[0]   
	clrf    EADRL
	clrf    EADRH
	
	call    f_get_table_data
	
	movfw   R_TEMP3
	subwf   R_RestL,0
	movfw   R_TEMP4
	subwfc  R_RestM,0
	movfw   R_TEMP5
	subwfc  R_RestH,0
	btfss   status,c ;R_RestH/m/l < data[0]   R_RestH/m/l - ���ĵ���
	goto    end_check
 res_err_exit_check:  ;�ж��Ƿ���0��
    movfw   R_TEMP3
	xorwf   R_RestL,0
	btfss   status,z
	goto    res_err_exit1
	movfw   R_TEMP4
	xorwf   R_RestM,0
	btfss   status,z
	goto    res_err_exit1
	movfw   R_TEMP5
	xorwf   R_RestH,0
	btfss   status,z
	goto    res_err_exit1
	clrf    r_table_temp_l
	clrf    r_table_temp_h ;0��
	return
 res_err_exit1:	 ;table ֮�ⱨ��
	movlw   0xff
	movwf   r_table_temp_l
	movwf   r_table_temp_h
	return	
 res_err_exit:	 ;table ֮�ⱨ��
	movlw   0xf0
	movwf   r_table_temp_l
	movwf   r_table_temp_h
	return
 end_check:         ;����Ƿ����50��	
	
	movlw   low TABLE_ADDR_SIZE
	movwf   EADRL
	movlw   high TABLE_ADDR_SIZE
	movwf   EADRH	
	
	call    f_get_table_data
    
	movfw   R_TEMP3
	subwf   R_RestL,0
	movfw   R_TEMP4
	subwfc  R_RestM,0
	movfw   R_TEMP5
	subwfc  R_RestH,0
	btfss   status,c ;R_RestH/m/l >data[500]
    goto    res_err_exit    ;С��50�ȵ���֮�ⱨ�� 
	goto    res_check_50000
 res_check_50000:  ;�ж��Ƿ���50��
    movfw   R_TEMP3
	xorwf   R_RestL,0
	btfss   status,z
	goto    check_not_50000
    movfw   R_TEMP4
	xorwf   R_RestM,0
	btfss   status,z	
	goto    check_not_50000
    movfw   R_TEMP5
	xorwf   R_RestH,0
	btfss   status,z
	goto    check_not_50000
	movlw   low 500
	movwf   r_table_temp_l
	movlw   high 500
	movwf   r_table_temp_h  ;����50��
	return
	
 check_not_50000:    ;0~50��֮�䣬��ʼ�� left right ���
    clrf    r_table_left_l   ;table to ���
    clrf    r_table_left_h   ;table to ���   
    movlw   low  500
    movwf   r_table_right_l  ;table from ���   
    movlw   high 500
    movwf   r_table_right_h  ;table from ���  1������3�ֽڴ������Ҫռ��2��
   
  left_right_while:
    movfw   r_table_left_l
    subwf   r_table_right_l,0
    movfw   r_table_left_h
    subwfc  r_table_right_h,0  ; r_table_right_h/l - r_table_left_h/l
    btfss   status,c
    goto    find_from_to_lp
   
    movfw   r_table_left_l ;r_table_mid_h/l
    addwf   r_table_right_l,0
    movwf   r_table_mid_l
    
    movfw   r_table_left_h
    addwfc  r_table_right_h,0
    movwf   r_table_mid_h
    
    bcf     status,c
    rrf     r_table_mid_h,1
    rrf     r_table_mid_l,1

    movfw   r_table_mid_l
    movwf   EADRL
    movfw   r_table_mid_h
    movwf   EADRH
	
    call    f_get_table_data;���R_TEMP5 R_TEMP4 R_TEMP3 h/m/l	
    
	movfw   R_RestL
	subwf   R_TEMP3,0
	movfw   R_RestM
	subwfc  R_TEMP4,0
	movfw   R_RestH
	subwfc  R_TEMP5,0
	btfss   status,c  ;R_TEMP5/4/3 - R_RestH/M/L
    goto    data_mid_less_aim
	goto    data_mid_greater_or_equ_aim
 data_mid_greater_or_equ_aim:
    movfw   R_TEMP3
	xorwf   R_RestL,0
	btfss   status,z
    goto    data_mid_greater_aim	
    movfw   R_TEMP4
	xorwf   R_RestM,0
	btfss   status,z
    goto    data_mid_greater_aim	
    movfw   R_TEMP5
	xorwf   R_RestH,0
	btfss   status,z
    goto    data_mid_greater_aim	
    goto    data_mid_equ_aim
 data_mid_equ_aim:
;    movfw   r_table_left_l ;1000*100/2=1000*50=50000
;	movwf   R_SYS_A0
;	movfw   r_table_left_h
;	movwf   R_SYS_A1
;	clrf    R_SYS_A2
;	movlw   low  50
;	movwf   R_SYS_B0
;	movlw   high 50
;	movwf   R_SYS_B1
;	clrf    R_SYS_B2
;	call    F_Mul24U
;	movfw   R_SYS_C0
;	movwf   r_table_temp_l
;	movfw   R_SYS_C1
;	movwf   r_table_temp_h  ;���¶�
    movfw   r_table_left_l ;
	movwf   r_table_temp_l
	movfw   r_table_left_h
	movwf   r_table_temp_h  ;���¶�
	return
  data_mid_greater_aim:
    movlw   1
    addwf   r_table_mid_l,0
    movwf   r_table_left_l
    clrf    work	
	addwfc  r_table_mid_h,0
	movwf   r_table_left_h
	goto    left_right_while
 
  data_mid_less_aim:
    movlw   1
	subwf   r_table_mid_l,0
	movwf   r_table_right_l
	clrf    work
	subwfc  r_table_mid_h,0
	movwf   r_table_right_h
	goto    left_right_while
    /* r_table_left_l   ;table to ���
	   r_table_right_l  ;table from ���   
	t = temp[to] + (temp[from] - temp[to])*(aim - data[to])
	                                     /(data[from] - data[to]);
	  temp[to] = r_table_left_l
	  temp[from] = r_table_right_l
	  (temp[from] - temp[to]) = -1
	  
	*/
 find_from_to_lp:
    movfw   r_table_left_l ;
	movwf   r_table_temp_l
	movfw   r_table_left_h
	movwf   r_table_temp_h  ;���¶�
	return
   /*
	movfw   r_table_left_l
	movwf   EADRL
	movfw   r_table_left_h
	movwf   EADRH                 ;data[to]
       
	call    f_get_table_data;���R_TEMP5 R_TEMP4 R_TEMP3 h/m/l	
	
	movfw   R_TEMP3
	subwf   R_RestL,0
	movwf   R_SYS_A0
	
	movfw   R_TEMP4
	subwfc  R_RestM,0
	movwf   R_SYS_A1
	
	movfw   R_TEMP5
	subwfc  R_RestH,0
	movwf   R_SYS_A2  ; R_SYS_A2 = (aim - data[to])
	
	movlw   low 100
	movwf   R_SYS_B0
	movlw   high 100
	movwf   R_SYS_B1
	clrf    R_SYS_B2  ; |(temp[from] - temp[to])| = 100
	call    F_Mul24U  ; C = |(temp[from] - temp[to])| * (aim - data[to])        

	movfw   r_table_right_l
	movwf   EADRL
	movfw   r_table_right_h
	movwf   EADRH                 ;data[from]
	
	call    f_get_table_data;���R_TEMP5 R_TEMP4 R_TEMP3 h/m/l	
	
	movfw   R_TEMP3
    movwf   R_SYS_A0
	movfw   R_TEMP4
	movwf   R_SYS_A1
	movfw   R_TEMP5
	movwf   R_SYS_A2   ;R_SYS_A2 = data[from]           
	        
	movfw   r_table_left_l
	movwf   EADRL
	movfw   r_table_left_h
	movwf   EADRH                  ;data[to]
	
	call    f_get_table_data;���R_TEMP5 R_TEMP4 R_TEMP3 h/m/l	

	movfw   R_TEMP3
	subwf   R_SYS_A0,1
	
	movfw   R_TEMP4
	subwfc  R_SYS_A1,1
	
	movfw   R_TEMP5
	subwfc  R_SYS_A2,1	;R_SYS_A3 = data[from] - data[to]
	clrf    R_SYS_A3
	clrf    R_SYS_A4
	clrf    R_SYS_A5
	                    
	movfw   R_SYS_C0
	movwf   R_SYS_B0
	movfw   R_SYS_C1
	movwf   R_SYS_B1
	movfw   R_SYS_C2
	movwf   R_SYS_B2   ; R_SYS_B2 = |(temp[from] - temp[to])| * (aim - data[to]) 
	
	call    F_Div24U  ;R_SYS_C0
	
	movfw   R_SYS_C0
	movwf   R_SYS_B0
	movfw   R_SYS_C1
	movwf   R_SYS_B1
	movfw   R_SYS_C2 
	movwf   R_SYS_B2  ;;R_SYS_B0 = R_SYS_C0
	
	movlw   low 100
	movwf   R_SYS_A0
	movlw   high 100
	movwf   R_SYS_A1
	clrf    R_SYS_A2  ; 100/R_SYS_B2
	clrf    R_SYS_A3
	clrf    R_SYS_A4
	clrf    R_SYS_A5
	call    F_Div24U  ;R_SYS_C0
	
	movfw   R_SYS_C0
	movwf   R_TEMP3
	movfw   R_SYS_C1
	movwf   R_TEMP4
	movfw   R_SYS_C2
	movwf   R_TEMP5
	   ;temp[to] = [ r_table_left_l ]*10 = r_table_left_l*50
	movfw   r_table_left_l
	movwf   R_SYS_A0
	movfw   r_table_left_h
	movwf   R_SYS_A1
    clrf    R_SYS_A2
    
    movlw   low 100
    movwf   R_SYS_B0	
	movlw   high 100
	movwf   R_SYS_B1
	clrf    R_SYS_B2
	call    F_Mul24U
	
	movfw   R_TEMP3
	subwf   R_SYS_C0,0
	movwf   r_table_temp_l
	
	movfw   R_TEMP4
	subwfc  R_SYS_C1,0
	movwf   r_table_temp_h
	
	movfw   r_table_temp_l
	movwf   R_SYS_A0
	movfw   r_table_temp_h
	movwf   R_SYS_A1
	clrf    R_SYS_A2
	clrf    R_SYS_A3
	clrf    R_SYS_A4
	clrf    R_SYS_A5
	movlw   low 100
	movwf   R_SYS_B0
	clrf    R_SYS_B1
	clrf    R_SYS_B2
	call    F_Div24U
	movfw   R_SYS_C0
	movwf   r_table_temp_l
	movfw   R_SYS_C1
	movwf   r_table_temp_h*/
return
	
	
f_cur_pre_temp_judge_update:
	movfw     r_table_temp_pre_l
	subwf     r_table_temp_l,0
	movwf     R_TEMP3
	
	movfw     r_table_temp_pre_h
	subwfc    r_table_temp_h,0
	movwf     R_TEMP4
	btfss     status,c          ;r_table_temp_h - r_table_temp_pre_h
	goto      cur_less_pre
	goto      cur_grater_pre
 cur_less_pre:
     movfw    r_table_temp_l
	 subwf    r_table_temp_pre_l,0
	 movwf    R_TEMP3
	 
     movfw    r_table_temp_h
	 subwf    r_table_temp_pre_h,0
	 movwf    R_TEMP4             ;r_table_temp_h - r_table_temp_pre_h    
 cur_grater_pre:
    movlw     low   1
	subwf     R_TEMP3,1
	movlw     high  1
	subwfc    R_TEMP4,1        ;|r_table_temp_h - r_table_temp_pre_h| - 1
return
	
f_load_mtp_data:
	call     f_e2p_read_data_from_rom
	movlw    0xff
	xorwf    r_ad_cal_h,0
	btfsc    status,z
	goto     clr_cal_exit
	movlw    0xff
	xorwf    r_ad_cal_m,0
	btfsc    status,z
	goto     clr_cal_exit
	movlw    0xff
	xorwf    r_ad_cal_l,0
	btfsc    status,z
	goto     clr_cal_exit
	
	btfsc    r_ad_cal_h,7
	goto     neg_load
	goto     pos_load 
	
 neg_load:
    bcf      r_ad_cal_h,7 
    movlw    C_37_1_36_9_Max_L
    subwf    r_ad_cal_l,0
    movlw    C_37_1_36_9_Max_M
    subwfc   r_ad_cal_m,0
    movlw    C_37_1_36_9_Max_H
    subwfc   r_ad_cal_h,0
    btfss    status,c
    goto     neg_load_exit
   clr_cal_exit:
    clrf     r_ad_cal_l
    clrf     r_ad_cal_m
    clrf     r_ad_cal_h
    return
 neg_load_exit:
    bsf      r_ad_cal_h,7
    return  
 pos_load:
    movlw    C_37_1_36_9_Max_L
    subwf    r_ad_cal_l,0
    movlw    C_37_1_36_9_Max_M
    subwfc   r_ad_cal_m,0
    movlw    C_37_1_36_9_Max_H
    subwfc   r_ad_cal_h,0
    btfss    status,c
	return
	goto     clr_cal_exit
	

	
	
f_adjust_measyre_res:
	btfsc    r_ad_cal_h,7
	goto     neg_adjust
	goto     pos_adjust
neg_adjust:;��������
	bcf      r_ad_cal_h,7
	movfw    r_ad_cal_l
	addwf    R_RestL,1
	movfw    r_ad_cal_m
	addwfc   R_RestM,1
	movfw    r_ad_cal_h
	addwfc   R_RestH,1
	bsf      r_ad_cal_h,7
	return
pos_adjust:;��������
	movfw    r_ad_cal_l
	subwf    R_RestL,1
	movfw    r_ad_cal_m
	subwfc   R_RestM,1
	movfw    r_ad_cal_h
	subwfc   R_RestH,1
	return
;TABLE_ADDR_START    Equ    0ED0H
;TABLE_ADDR_SIZE     equ    03EAH
	
	
	

	
	
	
	
	