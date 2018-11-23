/*-------------------------------------------
; Name    : F_Ble_SetAdvData
; Function: ���ù㲥����
; Input   : 
; Output  :
; Temp    :  
; Other   :
; log     :
--------------------------------------------*/
F_Ble_SetAdvData:
    call     F_Ble_UartEnable  
    movlw    C5h
    movwf    R_TxData1
    movlw    15
    movwf    R_TxData2
    movlw    SETADVCMD
    movwf    R_TxData3
    movlw    0ffh
    movwf    R_TxData4
    movlw    0f0h
    movwf    R_TxData5
    movlw    01h
    movwf    R_TxData6
    movfw    R_APP_McuFuntion             ;��Ϣ������
    movwf    R_TxData7   
    movfw    R_APP_WeightL                ;����L
    movwf    R_TxData8
    movfw    R_APP_WeightH
    movwf    R_TxData9                    ;����H
    movlw    01h
    movwf    R_TxData10                   ;��ƷID
    movlw    02h
    movwf    R_TxData11
    movlw    02h
    movwf    R_TxData12
    movlw    02h
    movwf    R_TxData13
    movlw    01h                         ;�����汾
    movwf    R_TxData14
    movlw    02h
    movwf    R_TxData15
    movlw    01h
    movwf    R_TxData16                  ;���㷨�汾
    movlw    02h
    movwf    R_TxData17
    movlw    17                  
    movwf    R_TxDataLength
    call     F_Uart_Send_NByte
    call     F_Ble_UartDisable
    return

/*-------------------------------------------
; Name    : 
; Function: 
; Input   : 
; Output  :
; Temp    :  
; Other   :
; log     :
--------------------------------------------*/
F_Ble_SendAppData:
    call    F_Ble_UartEnable  
    movlw   C5h
    movwf   R_TxData1
    movlw   23
    movwf   R_TxData2
    movlw   SENDAPPDATACMD              ;CMD
    movwf   R_TxData3
    
F_Ble_SendAppData_Lp:
	
    movlw   Low  HANDLE_FFF1            ;
    movwf   R_TxData4
    movlw   High HANDLE_FFF1
    movwf   R_TxData5
	 
F_Ble_SendAppData_Lp2:    
    movlw   06                          ;flag
    movwf   R_TxData6
    movlw   03h                         
    movwf   R_TxData7   
    movfw   R_Temp_OutH                 ;��
    movwf   R_TxData8
    movfw   R_Temp_OutL                         
    movwf   R_TxData9   
    movfw   00
    movwf   R_TxData10                  ;��
    movlw   00h 
    movwf   R_TxData11                  ;��
    movlw   00h 
    movwf   R_TxData12                  ;ʱ
    movlw   00h                          
    movwf   R_TxData13                  ;��
    movlw   00h 
    movwf   R_TxData14                  ;��
    movlw   00h 
    movwf   R_TxData15                  ;����ֵL
    movlw   00h 
    movwf   R_TxData16                  ;����ֵH
    movlw   00h		                   ;����L
    movwf   R_TxData17
    movlw   00h				              ;����H
    movwf   R_TxData18
    movlw   00h                         ;Ԥ��
    movwf   R_TxData19              
    movlw   00h                         ;Ԥ��
    movwf   R_TxData20    
    movlw   00h							;��Ϣ����
    movwf   R_TxData21
    movlw   00h                         ;Ԥ��
    movwf   R_TxData22              
    movlw   00h                         ;Ԥ��
    movwf   R_TxData23
    movlw   00h                         ;Ԥ��
    movwf   R_TxData24
    movlw   00h                         ;Ԥ��
    movwf   R_TxData25
    movlw   25  
    movwf   R_TxDataLength
    call    F_Uart_Send_NByte
    call    F_Ble_UartDisable
    return
   
    
; ;----------------------------------------------
;;	����������ͷ
;;----------------------------------------------
;THERMOPLIE_HEAD_PART_1    equ   0xFA
;THERMOPLIE_HEAD_PART_2    equ   0xAA
;THERMOPLIE_HEAD_PART_3    equ   0xAA
;THERMOPLIE_HEAD_PART_4    equ   0xAF
;;----------------------------------------------
;;	����������β
;;----------------------------------------------
;THERMOPLIE_TAIL_PART_1    equ   0xF5
;THERMOPLIE_TAIL_PART_2    equ   0x5F
    
f_ble_ack_lock: ;Ӧ������
    call    F_Ble_UartEnable  
    movlw   C5h
    movwf   R_TxData1
    movlw   13
    movwf   R_TxData2
    movlw   SENDAPPDATACMD              ;CMD
    movwf   R_TxData3
    

	
    movlw   Low  HANDLE_FFF1      
    movwf   R_TxData4
    movlw   High HANDLE_FFF1
    movwf   R_TxData5
	 
    
    movlw   THERMOPLIE_HEAD_PART_1     
    movwf   R_TxData6
    
    movlw   THERMOPLIE_HEAD_PART_2                         
    movwf   R_TxData7   
    
    movlw   THERMOPLIE_HEAD_PART_3               
    movwf   R_TxData8
    
    movlw   THERMOPLIE_HEAD_PART_4                         
    movwf   R_TxData9   
    
    movfw   00
    movwf   R_TxData10                  
    movlw   0ch 
    movwf   R_TxData11 
    
    movlw   0x85 
    movwf   R_TxData12  
    
    movlw   0x91                          
    movwf   R_TxData13  
    
    movlw   THERMOPLIE_TAIL_PART_1 
    movwf   R_TxData14  
    
    movlw   THERMOPLIE_TAIL_PART_2 
    movwf   R_TxData15           

    movlw   15  
    movwf   R_TxDataLength
    call    F_Uart_Send_NByte
    call    F_Ble_UartDisable
	return
	
f_ble_ack_unlock: ;Ӧ�����
    call    F_Ble_UartEnable  
    movlw   C5h
    movwf   R_TxData1
    movlw   13
    movwf   R_TxData2
    movlw   SENDAPPDATACMD              ;CMD
    movwf   R_TxData3
    

	
    movlw   Low  HANDLE_FFF1      
    movwf   R_TxData4
    movlw   High HANDLE_FFF1
    movwf   R_TxData5
	 
    
    movlw   THERMOPLIE_HEAD_PART_1     
    movwf   R_TxData6
    
    movlw   THERMOPLIE_HEAD_PART_2                         
    movwf   R_TxData7   
    
    movlw   THERMOPLIE_HEAD_PART_3               
    movwf   R_TxData8
    
    movlw   THERMOPLIE_HEAD_PART_4                         
    movwf   R_TxData9   
    
    movfw   00
    movwf   R_TxData10                  
    movlw   0ch 
    movwf   R_TxData11 
    
    movlw   0x86 
    movwf   R_TxData12  
    
    movlw   0x92                          
    movwf   R_TxData13  
    
    movlw   THERMOPLIE_TAIL_PART_1 
    movwf   R_TxData14  
    
    movlw   THERMOPLIE_TAIL_PART_2 
    movwf   R_TxData15           

    movlw   15  
    movwf   R_TxDataLength
    call    F_Uart_Send_NByte
    call    F_Ble_UartDisable
	return	
	
	
f_ble_send_sensor_err: ;���ʹ�������λ��Ϣ��app
    call    F_Ble_UartEnable  
    movlw   C5h
    movwf   R_TxData1
    movlw   13
    movwf   R_TxData2
    movlw   SENDAPPDATACMD              ;CMD
    movwf   R_TxData3
    

	
    movlw   Low  HANDLE_FFF1      
    movwf   R_TxData4
    movlw   High HANDLE_FFF1
    movwf   R_TxData5
	 
    
    movlw   THERMOPLIE_HEAD_PART_1     
    movwf   R_TxData6
    
    movlw   THERMOPLIE_HEAD_PART_2                         
    movwf   R_TxData7   
    
    movlw   THERMOPLIE_HEAD_PART_3               
    movwf   R_TxData8
    
    movlw   THERMOPLIE_HEAD_PART_4                         
    movwf   R_TxData9   
    
    movfw   00
    movwf   R_TxData10                  
    movlw   0Ah 
    movwf   R_TxData11 
    
    movlw   0x08 
    movwf   R_TxData12  
    
    movlw   0x12                          
    movwf   R_TxData13  
    
    movlw   THERMOPLIE_TAIL_PART_1 
    movwf   R_TxData14  
    
    movlw   THERMOPLIE_TAIL_PART_2 
    movwf   R_TxData15           

    movlw   15  
    movwf   R_TxDataLength
    call    F_Uart_Send_NByte
    call    F_Ble_UartDisable
	return	

	
;--
f_ble_send_result_to_app: ;���ͽ����app
    call    F_Ble_UartEnable  
    movlw   C5h
    movwf   R_TxData1
    movlw   16
    movwf   R_TxData2
    movlw   SENDAPPDATACMD              ;CMD
    movwf   R_TxData3
    

	
    movlw   Low  HANDLE_FFF1      
    movwf   R_TxData4
    movlw   High HANDLE_FFF1
    movwf   R_TxData5
	 
    
    movlw   THERMOPLIE_HEAD_PART_1     
    movwf   R_TxData6
    
    movlw   THERMOPLIE_HEAD_PART_2                         
    movwf   R_TxData7   
    
    movlw   THERMOPLIE_HEAD_PART_3               
    movwf   R_TxData8
    
    movlw   THERMOPLIE_HEAD_PART_4                         
    movwf   R_TxData9   
    
    movfw   00
    movwf   R_TxData10                  
    movlw   0Dh 
    movwf   R_TxData11   ;����
    
    movlw   0x04 
    movwf   R_TxData12   ;������

    movfw   R_TEMP5 
    movwf   R_TxData13   ;����h
 
    movfw   R_TEMP4 
    movwf   R_TxData14   ;����m
 
    movfw   R_TEMP3 
    movwf   R_TxData15   ;����l
    
    clrf    R_TxData16    ;У��
    
    movfw   R_TxData10
    addwf   R_TxData16,1
    
    movfw   R_TxData11
    addwf   R_TxData16,1

    movfw   R_TxData12
    addwf   R_TxData16,1
 
    movfw   R_TxData13
    addwf   R_TxData16,1
    
    movfw   R_TxData14
    addwf   R_TxData16,1
    
    movfw   R_TxData15
    addwf   R_TxData16,1  ;У��
    
    movlw   THERMOPLIE_TAIL_PART_1 
    movwf   R_TxData17  
    
    movlw   THERMOPLIE_TAIL_PART_2 
    movwf   R_TxData18           

    movlw   18  
    movwf   R_TxDataLength
    call    F_Uart_Send_NByte
    call    F_Ble_UartDisable
	return	

;;----------------------------------------------
;;	����������β
;;----------------------------------------------
;THERMOPLIE_TAIL_PART_1    equ   0xF5
;THERMOPLIE_TAIL_PART_2    equ   0x5F
	
/*-------------------------------------------
; Name    : F_McuToBle1_Proc
; Function: 
; Input   : 
            R_APP_WeightL      
            R_APP_Weight 
            R_APP_RegierL      
            R_APP_Regier 
            R_APP_YearH       
            R_APP_YearL  
            R_APP_Month       
            R_APP_Day         
            R_APP_Hour        
            R_APP_Min         
            R_APP_Sec         
            R_APP_McuStatus     ;bit0   : ������λ��־
                                ;bit1   : ���ر�־
                                ;bit2   : ��ʾ���������־
                                ;bit3   : ��ʾ���ѱ�־
                                ;bit4   : ��ʾ�³�
                                ;bit5   : ��������
; Output  :R_BleStatus
; Temp    :  
; Other   :
; log     :
--------------------------------------------*/
F_McuToBle_Proc:
/*--------------------------------------------
;R_BleStatus-0x00:��λģʽ
----------------------------------------------*/
F_McuToBle_Proc0:
    movlw   BLESTATUS_REST
    xorwf   R_BleStatus,0
    btfss   status,z
    goto    F_McuToBle_Proc0_End      
    call    F_BLE_Init                   ;��ʼ��������downcode
;    call    F_SendMacCmd                 ;����MAC��ַ
    call    F_Ble_StartAdvCmd            ;�����㲥  
	movlw	250
	call	F_Delay_1ms	   
    movlw   BLESTATUS_STANDY
    movwf   R_BleStatus     
F_McuToBle_Proc0_End:
/*--------------------------------------------
;R_BleStatus-0x02:����ģʽ 
----------------------------------------------*/
F_McuToBle_Proc2:
    movlw   BLESTATUS_STANDY
    xorwf   R_BleStatus,0
    btfss   status,z
    goto    F_McuToBle_Proc2_End 
    call    F_Ble_StartAdvCmd              ;�����㲥
    movlw   BLESTATUS_ADV
    movwf   R_BleStatus
F_McuToBle_Proc2_End:
/*--------------------------------------------
;R_BleStatus-0x03:�㲥ģʽ 
----------------------------------------------*/
;F_McuToBle_Proc3:    
;    movlw   BLESTATUS_ADV
;    xorwf   R_BleStatus,0
;    btfss   status,z
;    goto    F_McuToBle_Proc3_End 
;    call    F_Ble_SetAdvData               ;���ù㲥����
;	call    F_Ble_SendAppData
;;��������״̬���
;    bcf     BLESTATUSPINEN
;    bsf     BLESTATUSPINPU
;    btfsc   BLESTATUSPIN
;    goto    F_McuToBle_Proc3_End
;    movlw   BLESTATUS_CONNECT
;    movwf   R_BleStatus
;F_McuToBle_Proc3_End:
F_McuToBle_Proc3:    
    movlw   BLESTATUS_ADV
    xorwf   R_BleStatus,0
    btfss   status,z
    goto    F_McuToBle_Proc3_End 
    movfw	R_Delay_Num	
	andlw	0fh
	addpcw
	goto	L_McuToBle_Proc3_0
;	nop
;	nop
;	nop
	goto	L_McuToBle_Proc3_1
	goto	L_McuToBle_Proc3_2
;	nop
;	nop
;	nop
	goto	L_McuToBle_Proc3_1
	goto	L_McuToBle_Proc3_3	
L_McuToBle_Proc3_0:
    call    F_Ble_SetAdvData               ;���ù㲥����
    incf	R_Delay_Num,1
    goto    F_McuToBle_Proc_End   
    
L_McuToBle_Proc3_1: 
	incf	R_Delay_Num,1
    goto    F_McuToBle_Proc_End   
    
L_McuToBle_Proc3_2:    
    call    F_Ble_SendAppData
	incf	R_Delay_Num,1
    goto    F_McuToBle_Proc_End 
    
L_McuToBle_Proc3_3:  
	clrf	R_Delay_Num
;��������״̬���
    bcf     BLESTATUSPINEN
    bsf     BLESTATUSPINPU
    btfsc   BLESTATUSPIN
    goto    F_McuToBle_Proc3_End
    movlw   BLESTATUS_CONNECT
    movwf   R_BleStatus
F_McuToBle_Proc3_End:
;-------------------------------------------
/*--------------------------------------------
;R_BleStatus-0x04:����ģʽ   
----------------------------------------------*/
F_McuToBle_Proc4:    
    movlw   BLESTATUS_CONNECT
    xorwf   R_BleStatus,0
    btfss   status,z
    goto    F_McuToBle_Proc4_End 
    call    F_Ble_SendAppData               ;�������ݸ�APP
;��������״̬���
    bcf     BLESTATUSPINEN
    bsf     BLESTATUSPINPU
    btfsc   BLESTATUSPIN
    goto    F_McuToBle_Proc4_End
    movlw   BLESTATUS_ADV
    movwf   R_BleStatus     
F_McuToBle_Proc4_End:
/*--------------------------------------------
;R_BleStatus-0x04:˯��ģʽ    
----------------------------------------------*/
F_McuToBle_Proc5:    
    movlw   BLESTATUS_SLEEP
    xorwf   R_BleStatus,0
    btfsc   status,z
    goto    F_McuToBle_Proc5_End 
    btfss   R_BS_Scale_Flag,B_BS_Sleep
    goto    F_McuToBle_Proc5_End
    
    bsf		R_BLE_Flag,1   
    call    F_Ble_SleepCmd                  ;����˯�ߺ���
    movlw   BLESTATUS_SLEEP
    movwf   R_BleStatus 
    
	movlw	100
	call	F_Delay_1ms		               
  	btfss	R_BLE_Flag,1				;INTF2,URRIF    �Ƿ���Ӧ
  	goto	F_McuToBle_Proc5_End
  	call    F_BLE_Init                   ;��ʼ��������downcode
;    call    F_SendMacCmd                 ;����MAC��ַ
    call    F_Ble_StartAdvCmd            ;�����㲥  
	movlw	250
	call	F_Delay_1ms	
	movlw	150
	call	F_Delay_1ms		
    call    F_Ble_SleepCmd                  ;����˯�ߺ���
    	
F_McuToBle_Proc5_End:
	btfsc   R_BS_Scale_Flag,B_BS_Sleep	
	return
    movlw   BLESTATUS_ADV                   ;�Ƴ�˯��״̬����������
    movwf   R_BleStatus 
	call	F_Ble_UartEnable    
	call	F_Ble_UartDisable
F_McuToBle_Proc_End:
    return
/*-------------------------------------------
; Name    : F_McuToBle_Proc
; Function: UART�ڽ���Э��
; Input   : 
; Output  :
; Temp    :  
; Other   :
; log     :
--------------------------------------------*/
F_BleToMcu_Proc:
    btfsc       R_RxQueue_Flag,RxQueueFlagDataFininsh
    goto        F_BleToMcu_DataCmd
    btfsc       R_RxQueue_Flag,RxQueueFlagAckFininsh
    goto        F_BleToMcu_AckCmd   
F_BleToMcu_AckCmd:
    BCF         R_RxQueue_Flag,RxQueueFlagAckFininsh      ;�������ɱ�־λ
;����У����  
    movfw       R_RxACK2
    xorwf       R_RxACK1,1
    movlw       R_RxACK2
    movwf       FSR1
F_BleToMcu_AckCsum:
    incf        FSR1,1
    movfw       IND1
    xorwf       R_RxACK1,1
    decfsz      R_RxACK2,1
    goto        F_BleToMcu_AckCsum
    INCF        FSR1,1
    MOVFW       IND1
    XORWF       R_RxACK1,0
    BTFSS       STATUS,Z
    goto        F_BleToMcu_Csum_Err
    goto        F_McuToBle_Proc_End
F_BleToMcu_DataCmd: 
    BCF         R_RxQueue_Flag,RxQueueFlagDataFininsh     ;�������ɱ�־λ
;����У����  
    movfw       R_RxData2
    xorwf       R_RxData1,1
    movlw       R_RxData2
    movwf       FSR1
F_BleToMcu_DataCsum:
    incf        FSR1,1
    movfw       IND1
    xorwf       R_RxData1,1
    decfsz      R_RxData2,1
    goto        F_BleToMcu_AckCsum
    INCF        FSR1,1
    MOVFW       IND1
    XORWF       R_RxData1,0
    BTFSS       STATUS,Z
    goto        F_BleToMcu_Csum_Err 
    goto        F_BleToMcu_Proc_End 
F_BleToMcu_Csum_Err:                          ;У�������
F_BleToMcu_Proc_End:
    return
    
    
    