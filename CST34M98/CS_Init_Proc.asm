;============================================
;                  声明
; 该程序仅供参考若程序中存在疏漏， 
; 芯海科技有限公司对此不承担任何责任。
; (C)Shenzhen Chipsea Technologies Co.,Ltd
;============================================
; filename: F_PowerOn_Proc.asm
; chip    : CST34M97
; author  : CS0155
; date    : 2017-06-14
; v1.0
;============================================

;============================================
; 上电复位初始化函数
;============================================
F_PowerOn_Proc:
	;-------------------------	
	;  初始化SOC
    ;-------------------------
	call	F_Init_SOC						;初始化芯片	
	call	Lvdcon_Init
	;bcf		R_Flag_Sys,B_LCD_En
	clrf	R_Data_Pointer
	
	return
	
	
;============================================
; 待机复位初始化函数
;============================================	
F_Standby_Proc:
	call	F_SOC_StandbyInit				;初始化芯片
	;bcf		R_Flag_Sys,B_LCD_En
	return
	

	
	
;========================================================	
	
;----------------------------------------------------------------------
;@fn		:f_waste_n_ad	
;@brief		:丢掉work笔AD
;@param		;work 
;@return	；
;@note      ;立即数给work 立即调用
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
	
	
;传感器获得内短
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
	
;传感器获得AIN01 实时温度
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
	
;传感器获得AIN23 踢被温度
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
	
	movlw    0x60
	addwf    r_short_ad_l,0
	movwf    R_TEMP0
	movlw    0x00
	addwfc   r_short_ad_m,0
	movwf    R_TEMP1
	movlw    0x00
	addwfc   r_short_ad_h,0
	movwf    R_TEMP2              ;R_TEMP2/1/0 = r_short_ad_h/m/l + δ
 check_ain23:	
	movfw    r_ain23_ad_l
	subwf    R_TEMP0,0
	movfw    r_ain23_ad_m
	subwfc   R_TEMP1,0
	movfw    r_ain23_ad_h
	subwfc   R_TEMP2,0
	btfss    status,c           ;R_TEMP2/1/0 - ain23 
	goto     check_ain01
	bsf      R_Flag_Sys,B_Sensor_err
	return   
 check_ain01:
    movfw    r_ain01_ad_l
    subwf    R_TEMP0,0
    movfw    r_ain01_ad_m
    subwfc   R_TEMP1,0
    movfw    r_ain01_ad_h
    subwfc   R_TEMP2,0           ;R_TEMP2/1/0 - ain01
    btfsc    status,c
    bsf      R_Flag_Sys,B_Sensor_err
	return
	
	
	
	
;	call    F_Thmpsr_ADShort_Init
;	movlw   3
;	call    f_waste_n_ad
;	movlw   4
;	call    f_display_n_ad
;	
;    call    F_Thmpsr_AIN01_Init  ;AIN0为Vin+，AIN1为Vin-
;	movlw   3
;	call    f_waste_n_ad
;	movlw   8
;	call    f_display_n_ad
;	
;    call    F_Thmpsr_AIN23_Init   ;AIN2为Vin+，AIN3为Vin-
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
	
f_sleep_init:
        ;初始化外部中断
        clrf       ptint0
        clrf       ptint1
        ;关闭ADC LCD TIM VS  失能
        bcf        anacfg,ldoen  
		BCF			ANACFG,ADEN     ;adc  en
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
        ;关闭中断
        clrf       inte
        clrf       intf  
        clrf       inte2
        clrf       intf2               
        clrf       inte3
        clrf       intf3 	
return

f_wake_up_init:	
		bsf 	    anacfg,ldoen
		BSF			ANACFG,ADEN     ;adc  en
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
		clrf    R_DSP_BUFFER2  ;临时
		clrf    R_DSP_BUFFER3
		clrf    R_DSP_BUFFER4  ;t0 红绿间隔2s
		clrf    R_DSP_BUFFER5
		clrf    R_DSP_BUFFER6  ;t1 实时模式下间隔30s发送温度
		clrf    R_DSP_BUFFER7
		clrf    R_DSP_BUFFER8  ;累计16s 温度稳定判断
		clrf    R_DSP_BUFFER9
		clrf    R_DSP_BUFFER10 ;t3 10min计时	
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
	
	
f_led_red:;红灯亮
	bsf     RED_LED		
f_no_green:;绿灯灭
	bcf		GREEN_LED
    return
   
f_led_green:;绿灯亮
	bsf		GREEN_LED
f_no_red:;红灯灭
	bcf     RED_LED		
	return

f_no_led:;全灭
	bcf     RED_LED		
	bcf		GREEN_LED
	return
	
	
;电阻表

	
	
	
;r_table_res_l   equ  1C0H  ;电阻table
;r_table_res_m   equ  1C1H
;r_table_res_h   equ  1C2H
;

;
;r_table_from_l   equ  1C5H  ;table from 标号
;r_table_from_h   equ  1C6H  ;table from 标号
;
;r_table_to_l   equ  1C7H   ;table to 标号
;r_table_to_h   equ  1C8H   ;table to 标号
	
;[in]R_RestL				equ	 b0h
;R_RestM				equ	 b1h
;R_RestH				equ	 b2h
;[out]
;r_table_temp_l   equ  1C3H  ;温度table
;r_table_temp_h   equ  1C4H	
	
;data 小-->大
;R_TEMP3				equ	 87h l
;R_TEMP4				equ	 88h m
;R_TEMP5				equ	 89h h
f_res_to_temp: ;电阻转换成温度
	;R_RestH/m/l - data[0]   
	movlw	high  TABLE_ADDR_START
	movwf	EADRH
	movlw	low   TABLE_ADDR_START
	movwf	EADRL
	
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
	
	movfw   R_TEMP3
	subwf   R_RestL,0
	movfw   R_TEMP4
	subwfc  R_RestM,0
	movfw   R_TEMP5
	subwfc  R_RestH,0
	btfss   status,c ;R_RestH/m/l < data[0]
	goto    end_check
 res_err_exit:
	movlw   0xff
	movwf   r_table_temp_l
	movwf   r_table_temp_h
	return
 end_check:
	movlw	high  TABLE_ADDR_START
	movwf	EADRH
	movlw	low   TABLE_ADDR_START
	movwf	EADRL
	
	movlw   low TABLE_ADDR_SIZE
	addwf   EADRL,1
	movlw   high TABLE_ADDR_SIZE
	addwfc  EADRH,1	
	
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
    
	movfw   R_TEMP3
	subwf   R_RestL,0
	movfw   R_TEMP4
	subwfc  R_RestM,0
	movfw   R_TEMP5
	subwfc  R_RestH,0
	btfss   status,c ;R_RestH/m/l >data[500]
    goto    res_err_exit
 
    clrf    r_table_from_l   ;table from 标号
    clrf    r_table_from_h   ;table from 标号   
    movlw   low  500
    movwf   r_table_to_l   ;table to 标号   
    movlw   high 500
    movwf   r_table_from_h
    
    movfw   r_table_from_l
    subwf   r_table_to_l,0
    movfw   r_table_from_h
    subwfc  r_table_to_h,0  ; r_table_to_h/l - r_table_from_h/l
    btfss   status,c
    goto    
    
    movfw   r_table_from_l
    addwf   r_table_to_l,0
    movwf   r_mid_l
    
    movfw   r_table_from_h
    addwf   r_table_to_h,0
    movwf   r_mid_h
    
    bcf     status,c
    rrf     r_table_to_h,1
    rrf     r_table_to_l,1
    
    

    
    
return
	
	
;TABLE_ADDR_START    Equ    0ED0H
;TABLE_ADDR_SIZE     equ    03EAH
	
	
	

	
	
	
	
	