;============================================
;                  ����
; �ó�������ο��������д�����©�� 
; о���Ƽ����޹�˾�Դ˲��е��κ����Ρ�
; (C)Shenzhen Chipsea Technologies Co.,Ltd
;============================================
; filename: main.asm
; chip    : CST18M88
; author  : CS0155
; date    : 2017-06-14
; v1.0
; �����ܣ����readme.txt�ĵ�
; ������ʷ�����history.txt�ĵ�
;============================================
include CST34M98.inc
include	define_ram.inc
include CS_Macro.inc
include bt_config.inc
;============================================
; program start
;============================================
	org		00h
   	dw		ffffh
	dw		ffffh
	goto	reset
	goto	reset
	org		04h
	goto	InterruptProc	
;============================================
; program body
;============================================
DEFINE			POWER_ON_KEY	"PT2,4"
DEFINE			MODE_KEY		"PT3,1"
DEFINE			RED_LED		    "PT1,4"
DEFINE			GREEN_LED		"PT1,3"
DEFINE			BLE_STATUS	    "PT2,5" ;0 ������  1 û��
TABLE_ADDR_START    Equ    0ED0H
TABLE_ADDR_SIZE     equ    03E8H
	
include		CS_LIB_Math.asm
include		CS_LIB_Time.asm
include		CS_APP_BLE.asm
include		CS_UART0.asm
include		CS_34M98_initialization.asm
include		CS_34M98_Interrupt.asm
include		CS_34M98_Peripheral.asm
include 	CS_Init_Proc.asm 
;include		CS_Key.asm
include		CS_LVD.asm
;include		CS_MeasureVoltage.asm
;include		CS_LCD.asm
include		CS_Thermistor.asm
include		CS_Thermoplie_Sensor.asm
;include		CS_Temperature_Show.asm
;include		CS_Inside_Thermometer.asm
;include		CS_Application_Proc.asm


C_CAL_TEMP_USED_N_AD equ 1  ;����һ���¶�����ҪAD����
C_GREATER_THAN_32C_16S_TO_AD_L equ 0xE5 
C_GREATER_THAN_32C_16S_TO_AD_H  equ 0x01  ;485 *3ms = 16s

;============================================
; system reset
;============================================
reset:
	movlw		01001010B
	movwf		mck
	nop
	nop     
    call        F_PowerOn_Proc
	call        f_res_to_temp
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

    call	    F_Ble_Proc
	btfsc       POWER_ON_KEY
	;goto        l_sleep_no_beep;��ʱ
    goto 	    main_pre
;============================================
; main program
;============================================ 
main_pre:
    call    F_TMSR_Init
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
;	   call     f_seneor_get_ain01_ad;;�ɼ�24bitAD
;	   bcf      R_thermometer_FLAG,b_temp_mode
;	   movff3	r_ain01_ad_l,R_NTC_ADCacheL	;����AD 
;	   movff3	r_ain01_ad_l,R_SYS_A0
;	   call     F_TMSR_Rest_Count     ;;�����¶�,���ü��������� R_RestL/m/h
	   	
	;call	F_PowerOn_Proc			;��ʼ��
	call    f_beep_work_150_ms		;����150ms
    call    F_Judge_Volt			;�жϵ͵�
    btfss   R_Flag_DetVoltage,B_LowBat
    goto    l_higbat
    goto    l_lowbat
 l_lowbat:
    call    f_led_red		;���
    movlw   0x27
    movwf   R_DSP_BUFFER1
    movlw   0x10
    movwf   R_DSP_BUFFER2 
    call    f_sleep_n_ms_or_key_press ;10000ms timeout
    goto    l_sleep_work_beep
    
 l_higbat:  
    movlw   0x07
    movwf   R_DSP_BUFFER1
    movlw   0xD0
    movwf   R_DSP_BUFFER2 
    call    f_green_n_ms_or_key_press ;2000ms timeout
	btfsc   R_Flag_Sys,B_N_MS_TM
	goto    l_sleep_work_beep
	
	btfsc   MODE_KEY        ;У��ģʽ�ж�
	goto    no_cal_temp_mode;-----
	movlw   20
	call    F_delay_1ms
	btfsc   MODE_KEY
	goto    no_cal_temp_mode;-----
	goto    cal_temp_mode
	
  cal_temp_mode:	
    ;����дУ��ģʽ�������sleep������������������������������������������������
    goto    l_sleep_work_beep
	
  no_cal_temp_mode:
    call     f_seneor_get_short_ad;�жϴ�������·����· f_...
    call     f_seneor_get_ain01_ad
    call     f_seneor_get_ain23_ad
    call     f_sensor_err_check   
	btfss    R_Flag_Sys,B_Sensor_err
	goto     banding_func_judge
	goto     l_lowbat
	
 banding_func_judge:   ;�󶨹��ܼ��
    bcf      tm0con,T0EN
 	bsf      R_Flag_Sys,B_LED_R_G ;���
 	call     f_led_red
 	clrf     R_DSP_BUFFER3		  ;��ʱ��t0 2s ʱ��
    clrf     R_DSP_BUFFER4		  ;��ʱ��t0 2s ����
    bsf      tm0con,T0EN  
	
 banding_func_judge_lp:
	btfsc    MODE_KEY        ;�󶨹��ܼ���ж�
	goto     test_temp_pre   ;����ģʽǰ׼��
	movlw    20
	call     F_delay_1ms
	btfsc    MODE_KEY
	goto     test_temp_pre
	goto     banding_func
	
 banding_func:
	;banging func,���sleep������������������������������������������������������������
	goto     l_sleep_work_beep
	
 test_temp_pre:
    call     F_Ble_Proc
	btfss    BLE_STATUS  ;0 ������  1 û��
	goto     test_temp_pre_pre ;0 ������
	btfss    POWER_ON_KEY      ;1 û��
	goto     l_sleep_work_beep
	movlw    15
	subwf    R_DSP_BUFFER4,0	  ;��ʱ��t0 2s ���� R_DSP_BUFFER4 -15
    btfss    status,c
	goto     banding_func_judge_lp
	bcf      tm0con,T0EN
	goto     l_sleep_work_beep
	
	
test_temp_pre_pre:
	bcf      tm0con,T0EN
	bcf      R_Flag_Sys,B_LED_R_G ;�̵�
 	call     f_led_green
 	clrf     R_DSP_BUFFER3		  ;��ʱ��t0 2s ʱ��
    clrf     R_DSP_BUFFER4		  ;��ʱ��t0 2s ����
    bsf      tm0con,T0EN
    
	btfsc    MODE_KEY        ;�жϰ��� ``````````
    goto     test_temp_pre_pre_pre_again
	movlw    20
	call     F_delay_1ms
	btfsc    MODE_KEY
	goto     test_temp_pre_pre_pre_again
	goto     l_sleep_work_beep
 
 test_temp_pre_pre_pre_again:
     btfsc    MODE_KEY        ;�жϰ��� `````````
	 goto     test_temp_pre_pre_pre
	 movlw    20
	 call     F_delay_1ms
	 btfsc    MODE_KEY
	 goto     test_temp_pre_pre_pre
	 goto     l_sleep_work_beep
	
 test_temp_pre_pre_pre:
    bcf      tm3con,T0EN  
    clrf     R_DSP_BUFFER9
    clrf     R_DSP_BUFFER10
    bsf      tm3con,T0EN   ;��10min��ʱ
  test_temp_mode_start:  	
    call	 F_Ble_Proc;----------------------------------
    call  	 F_BleToMcu_Proc	;���н���
	movlw    50
	movwf    R_DSP_BUFFER1	  ;50 ��200ms
 test_temp_pre_pre_pre_pre_loop:
    call     f_seneor_get_short_ad;�жϴ�������·����· f_...
    call     f_seneor_get_ain01_ad
    call     f_seneor_get_ain23_ad
    call     f_sensor_err_check
	btfss    R_Flag_Sys,B_Sensor_err
	goto     test_temp_pre_pre_pre_pre
	;bcf      tm0con,T0EN   
	call     f_ble_send_sensor_err;f���ʹ�����Ϣ��app
	call     f_led_red 
	movlw    200
	call     F_delay_1ms
	movlw    1
	subwf    R_DSP_BUFFER1,1
	btfss    status,c      ;R_DSP_BUFFER1 -1
	goto     l_sleep_work_beep
	btfsc    POWER_ON_KEY
	goto     test_temp_pre_pre_pre_pre_loop
	goto     l_sleep_work_beep
	
test_temp_pre_pre_pre_pre:
 	;clrf     R_DSP_BUFFER3		  ;��ʱ��t0 2s ʱ��-----
  ble_conn_check_lp:
	btfss    BLE_STATUS  ;0 ������  1 û��
	goto     ble_conn_ok  ;0 ������
	call     f_no_green
	goto     ble_conn_fail;�Ͽ�
  ble_conn_fail:         
 	bsf      R_Flag_Sys,B_LED_R_G ;���
 	
    clrf     R_DSP_BUFFER4		  ;��ʱ��t0 2s ����
    bsf      tm0con,T0EN  
	btfsc    POWER_ON_KEY
	goto     ble_conn_check_lp
	bcf      tm0con,T0EN
	goto     l_sleep_work_beep
  ble_conn_ok:
    ;clrf     R_DSP_BUFFER3		  ;��ʱ��t0 2s ʱ��----
 	bcf      R_Flag_Sys,B_LED_R_G ;�̵�
 	call     f_no_red
	
 	btfsc    R_thermometer_FLAG,b_key_lock ;����������־
 	goto     ble_conn_check_end
 	btfsc    POWER_ON_KEY
 	goto     ble_conn_check_end
 	movlw    20
 	call     F_delay_1ms
 	btfsc    POWER_ON_KEY
 	goto     ble_conn_check_end
 	goto     l_sleep_work_beep
 
  ble_conn_check_end:
  realtime_measure_lp:
     btfss    R_thermometer_FLAG,b_rt_measure ;ʵʱ���±�־
	 goto     realtime_measure_end
	 
	 call     f_seneor_get_ain01_ad;;�ɼ�24bitAD
	 bcf      R_thermometer_FLAG,b_temp_mode
	 movff3	  r_ain01_ad_l,R_NTC_ADCacheL	;����AD 
     movff3	  r_ain01_ad_l,R_SYS_A0
     call     F_TMSR_Rest_Count     ;;�����¶�,���ü��������� R_RestL/m/h
	 call     f_res_to_temp         ;����ת���ɵ�ǰ�¶�
  realtime_measure_avoid_quilt_com:
	 btfss    R_thermometer_FLAG,b_app_unlock ;�ж�app���ͽ�������
	 goto     app_lock_key_lp
	 bcf      R_thermometer_FLAG,b_app_unlock
	 bcf      R_thermometer_FLAG,b_key_lock;�������������־
	 call     f_ble_ack_unlock	;;Ӧ��app��������
	 goto     update_thermometer_30s_app
 app_lock_key_lp:
      bsf      R_thermometer_FLAG,b_key_lock
 update_thermometer_30s_app:
      movlw    15
      subwf    R_DSP_BUFFER6,0 ;R_DSP_BUFFER6 - 15
      btfss    status,c
      goto     test_temp_pre_pre_pre
	  clrf     R_DSP_BUFFER6
	  
	  movfw    r_table_temp_l
	  movwf    R_TEMP3
	  movfw    r_table_temp_h
	  movwf    R_TEMP4
	  clrf     R_TEMP5  ;;�����¶ȵ�app �÷��͵������R_RestL --> R_TEMP3
	  call     f_ble_send_result_to_app
	  
      goto     test_temp_pre_pre_pre
	  
 realtime_measure_end:
 avoid_quilt_lp:
       btfss    R_thermometer_FLAG,b_avoid_quilt
	   goto     avoid_quilt_end
	   
	   call     f_seneor_get_ain23_ad;;�ɼ�12bitAD
	   bsf      R_thermometer_FLAG,b_temp_mode
	   movff3	r_ain23_ad_l,R_NTC_ADCacheL	;����AD  ;;�����¶�
       movff3	r_ain23_ad_l,R_SYS_A0
       call     F_TMSR_Rest_Count     ;;�����¶�,���ü���������R_RestL/m/h
	   call     f_res_to_temp        ;����ת�����߱��¶�
	   goto     realtime_measure_avoid_quilt_com
	   
 avoid_quilt_end:
       bcf      R_thermometer_FLAG,b_key_lock
	   btfsc    POWER_ON_KEY
	   goto     unrealtime_measure
	   movlw    20
	   call     F_delay_1ms
	   btfsc    POWER_ON_KEY
	   goto     unrealtime_measure
	   goto     l_sleep_work_beep
	   
 unrealtime_measure:
 
	   call     f_seneor_get_ain01_ad;;�ɼ�24bitAD
	   bcf      R_thermometer_FLAG,b_temp_mode
	   movff3	r_ain01_ad_l,R_NTC_ADCacheL	;����AD 
	   movff3	r_ain01_ad_l,R_SYS_A0
	   call     F_TMSR_Rest_Count     ;;�����¶�,���ü��������� R_RestL/m/h
	   call     f_res_to_temp  ;����ת���ɵ�ǰ�¶�

       btfsc   R_thermometer_FLAG,b_temp_std ;�¶��Ѿ��ȶ�����
       goto    redy_temp_std_lp
	   goto    un_temp_std_lp
  un_temp_std_lp:  
	   bcf     R_thermometer_FLAG,b_critical_temp ;;�ж��Ƿ�����ٽ��¶�
       movlw   low 32000
	   subwf   r_table_temp_l,0
	   movlw   high 32000
	   subwfc  r_table_temp_h,0
	   btfsc   status,c    
	   bsf     R_thermometer_FLAG,b_critical_temp
	   
	   btfss   R_thermometer_FLAG,b_critical_temp ;�жϴ����ٽ��¶�
	   goto    less_critical_temp_lp
	   movlw   C_CAL_TEMP_USED_N_AD
	   addwf   R_DSP_BUFFER7,1
	   clrf    work
	   addwfc  R_DSP_BUFFER8,1  ;����ʱ��
	   
	   movlw   C_GREATER_THAN_32C_16S_TO_AD_L
	   subwf   R_DSP_BUFFER7,0
	   movlw   C_GREATER_THAN_32C_16S_TO_AD_H
	   subwfc  R_DSP_BUFFER8,0              
	   btfss   status,c                     ;R_DSP_BUFFER8/7 - 16s
	   goto    less_critical_temp_lp
	   bsf     R_thermometer_FLAG,b_critical_temp;�¶��Ѿ��ȶ���
	   clrf    R_DSP_BUFFER7
	   clrf    R_DSP_BUFFER8
	   
	   btfsc   BLE_STATUS	    ;0 ������  1 �Ͽ�
	   goto    less_critical_temp_lp_pre
	   
	   movfw    r_table_temp_l
	   movwf    R_TEMP3
	   movfw    r_table_temp_h  ;;�����¶����ݵ�app   
	   movwf    R_TEMP4
	   clrf     R_TEMP5 
	   call     f_ble_send_result_to_app

	   goto     less_critical_temp_lp
	   
  less_critical_temp_lp_pre:
		bsf      R_Flag_Sys,B_LED_R_G ;���
		call     f_led_red
		bsf      tm0con,T0EN  
		
  less_critical_temp_lp:
 	    clrf     R_DSP_BUFFER7
	    clrf     R_DSP_BUFFER8
	    btfsc    POWER_ON_KEY
		goto     time_10min_lp
		movlw    20
		call     F_delay_1ms
		btfsc    POWER_ON_KEY
		goto     time_10min_lp
		goto     l_sleep_work_beep
		
   time_10min_lp:
        movlw    150                ;150 *4s = 10min
		subwf    R_DSP_BUFFER10,0  ;R_DSP_BUFFER10 - 150
		btfss    status,c
		goto     test_temp_mode_start
		goto     l_sleep_work_beep
	
   redy_temp_std_lp:
        movlw     1
		addwf     R_DSP_BUFFER11,1
		
		movlw     255
		subwf     R_DSP_BUFFER11,0
		btfss     status,c      ;R_DSP_BUFFER11 - 255
		goto      less_critical_temp_lp
		
		;�����¶Ȳ��ж��¶��Ƿ��и���
        goto      less_critical_temp_lp
	
l_sleep_work_beep:
       call      f_beep_work_150_ms
l_sleep_no_beep:
	   call      f_sleep_init  ;˯�߳�ʼ��
	   call      f_open_int0
	   nop
	   nop
	   nop
	   sleep
	   nop
	   nop
	   nop
	   call      f_close_int0
	   call      f_wake_up_init    ;���ѳ�ʼ��  
	   goto      reset
include 	cs_table.asm 	   
end
;============================================




;R_thermometer_FLAG                 equ   FDh 
;                b_key_lock    equ  0  ;����������־ 
;                b_rt_measure  equ  1  ;ʵʱ���±�־
;                b_avoid_quilt equ  2  ;���߱���־
;                b_app_unlock  equ  3  ;app�·�����ָ��
;				b_temp_std    equ  4  ;�¶��Ѿ��ȶ���
;				b_critical_temp equ 5 ;�ٽ��¶ȱ�־


;reset:
;	btfss	status,to
;	goto	poweron_reset
;	goto	standby_reset
;poweron_reset:
;    call	F_PowerOn_Proc
;    goto	main
;standby_reset:
;	call	F_Standby_Proc
;    goto 	main
;;============================================
;; main program
;;============================================ 
;main:
;	btfss	R_Flag_Sys,B_AD_30MS
;   	goto	main
;	call	F_Key_Scan	
;	call	F_Judge_Volt
;	call	F_Application_Proc
;	call	F_LCD_Proc
;	
;	call	F_Ble_Proc
;main_end:
;	bcf		R_Flag_Sys,B_AD_30MS	
;    goto 	main
;
;
;end
;============================================










