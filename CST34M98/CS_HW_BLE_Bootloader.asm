/*-------------------------------------------
; Name    : F_Ble_Init
; Function: 
; Input   : 
; Output  :
; Temp    :  
; Other   :
; log     :
--------------------------------------------*/
F_Ble_Init:
    bcf         INTE,GIE                ;ʹ�����ж�
;-----------------����GPIO5 100ms��λ------------------------------------------
	bsf		    BLEWAKEUPPINEN
	bcf		    BLEWAKEUPPINPU
	bcf		    BLEWAKEUPPIN   
    movlw	    100
	call   	    F_delay_1ms   	
	bsf		    BLEWAKEUPPINEN
	bcf		    BLEWAKEUPPINPU
	bsf		    BLEWAKEUPPIN 	
    movlw	    70
	call   	    F_delay_1ms  
;-----------------���͡�04 01 00 FC 00��ָ��------------------------------------	
F_BleSend040100FC:
    call        F_Uart_RxFlag_Clear
	call		F_Ble_CheckCmd
    movlw		20
	call   		F_Delay_1ms   
	btfss		UARTFLAGCHECK
	goto		F_BleSend040100FC_Err
	goto		F_DowncodeStart
F_BleSend040100FC_Err:					
    incf		R_SendTime,1
	movlw		3
	subwf		R_SendTime,0
	btfss		status,c
   	goto		F_BleSend040100FC
	clrf		R_SendTime
	CALL		F_Ble_RestCmd
    movlw		20
	call   		F_delay_1ms 	
   	goto		F_Ble_Init
;------------��ȡ������bin�ļ�������CODE�������ں�--------------------------   	
F_DowncodeStart:	
	 MOVLW		1FH   	 
 	 movwf		R_BleCodeEndAddH
	 movlw		FAh
	 movwf		R_BleCodeEndAddL	 	
   	 MOVLW		F9H
   	 MOVWF		EADRL
   	 MOVLW		1FH
   	 MOVWF		EADRH  	
   	 nop		
   	 movp
   	 XORLW		FFH
	 BTFSS		STATUS,Z 	 
   	 GOTO		$+3
   	 MOVLW		F9H
   	 MOVWF		R_BleCodeEndAddL
	 movlw		LOW	    3FFBH
	 MOVWF		R_BleCodeStartAddL
	 movlw		HIGH	3FFBH
	 movwf		R_BleCodeStartAddH
   	 movlw		LOW	    BT_PATCH_BIN_SIZE		;Э����ʼ��ַ��Address=BT_PATCH_BIN_SIZE/2+1
   	 subwf		R_BleCodeStartAddL,1
   	 MOVLW		HIGH	BT_PATCH_BIN_SIZE
   	 subwfc		R_BleCodeStartAddH,1   	 
   	 BCF		STATUS,C
   	 RRF		R_BleCodeStartAddH,1
   	 RRF		R_BleCodeStartAddL,1   	    	   	  	    	 
   	 MOVFW		R_BleCodeStartAddL
   	 MOVWF		EADRL
   	 MOVFW		R_BleCodeStartAddH
   	 MOVWF		EADRH  	 	 
   	 movp
   	 nop		
   	 movwf		R_PathBufLength  	    
F_DowncodeStart_Lp1:    
     call       F_Uart_RxFlag_Clear       
     movfw		R_BleCodeEndAddL    
   	 subwf		EADRL,0
     btfss		status,z
     goto		F_DowncodeStart_LP2
     movfw		R_BleCodeEndAddH
     subwf		EADRH,0
     btfss		status,z
     goto		F_DowncodeStart_LP2
     goto		F_Downcode_End
F_DowncodeStart_LP2:
     incfsz		EADRL,1
     goto		$+3
     clrf	    EADRL				         ;��ܱ�������һ����
     incf      	EADRH,1
     movp
     nop	    	
     movwf		R_FlashSave				     ;�ݴ��λ
     movfw	    EDAT
     call       F_Uart_Send_Byte    
     decfsz		R_PathBufLength,1
     goto		$+2
     goto		F_DowncodeStart_LP3 
F_DowncodeStart_LP22:    
     movfw		R_FlashSave
   	 call       F_Uart_Send_Byte				 ;���͵�λ
    
     decfsz		R_PathBufLength,1
     goto		F_DowncodeStart_LP2    
     goto		F_DowncodeStart_LP4
F_DowncodeStart_LP4: 						 ;ż��
     incfsz		EADRL,1
     goto		$+3
     clrf		EADRL					     ;��ܱ�������һ����
     incf		EADRH,1
     movp
     nop		
     movwf		R_FlashSave				     ;�ݴ��λ
     movfw		EDAT
	 movwf		R_PathBufLength				 ;Ҫ����buf���� 

     movlw      1
     call       F_delay_1ms             
     btfsc      UARTFLAGCHECK                ;INTF2,URRIF    �Ƿ���Ӧ��
     goto       F_DowncodeStart_LP5
     movlw      3
     call       F_delay_1ms             
     btfsc      UARTFLAGCHECK                ;INTF2,URRIF    �Ƿ���Ӧ��
     goto       F_DowncodeStart_LP5
     movlw      3
     call       F_delay_1ms             
     btfsc      UARTFLAGCHECK                ;INTF2,URRIF    �Ƿ���Ӧ��
     goto       F_DowncodeStart_LP5
     goto       F_Ble_Init                   ;downcodeʧ�ܣ����¿�ʼ���������ȴ�����
F_DowncodeStart_LP5:  
     call       F_Uart_RxFlag_Clear  	
     movfw		R_BleCodeEndAddL    
     subwf		EADRL,0
     btfss	    status,z
     goto		F_DowncodeStart_LP22
     movfw		R_BleCodeEndAddH
     subwf	    EADRH,0
     btfss		status,z
     goto		F_DowncodeStart_LP22
     goto		F_Downcode_End	
F_DowncodeStart_LP3:    					 ;����
	 movfw	    R_FlashSave
	 movwf	    R_PathBufLength			     ;Ҫ����buf����
     movlw      1
     call       F_delay_1ms             
     btfsc      UARTFLAGCHECK                ;INTF2,URRIF   �Ƿ���Ӧ��
     goto       F_DowncodeStart_Lp1
     movlw      3
     call       F_delay_1ms             
     btfsc      UARTFLAGCHECK                ;INTF2,URRIF     �Ƿ���Ӧ��
     goto       F_DowncodeStart_Lp1
     movlw      3
     call       F_delay_1ms             
     btfsc      UARTFLAGCHECK                ;INTF2,URRIF     �Ƿ���Ӧ��
     goto       F_DowncodeStart_Lp1
     goto       F_Ble_Init           
F_Downcode_End:
	 movlw		100
	 call  		F_Delay_1ms 	
     bsf        INTE,GIE                     ;ʹ�����ж� 
     call		F_Ble_New_Name
    return  
  
  /*-------------------------------------------
; Name    : F_Ble_New_Name
; Function: ��������
; Input   : 
; Output  :
; Temp    :  
; Other   :
; log     :
--------------------------------------------*/    
F_Ble_New_Name:
    call        F_Ble_UartEnable  
    movlw       C5h
    call        F_Uart_Send_Byte  
    movlw       03h
    call        F_Uart_Send_Byte  
    movlw       2ah
    call        F_Uart_Send_Byte  
    movlw       58h
    call        F_Uart_Send_Byte
    movlw       59h
    call        F_Uart_Send_Byte
    movlw       edh
    call        F_Uart_Send_Byte 
    call        F_Ble_UartDisable
    return  
    
    
/*-------------------------------------------
; Name    : F_Ble_CheckCmd
; Function: ���BLE���ں���״̬
; Input   : 
; Output  :
; Temp    :  
; Other   :
; log     :
--------------------------------------------*/
F_Ble_CheckCmd:
    movlw       01H 
    call        F_Uart_Send_Byte
    movlw       00H
    call        F_Uart_Send_Byte   
    movlw       FCH
    call        F_Uart_Send_Byte   
    movlw       0x00
    call        F_Uart_Send_Byte
    return 
/*-------------------------------------------  
; Name    : F_Ble_RestCmd
; Function: ����������λ������BLE code������bootloade
; Input   : 
; Output  :
; Temp    :  
; Other   :
; log     :
--------------------------------------------*/
F_Ble_RestCmd:
    call        F_Ble_UartEnable  
    movlw       C5h
    call        F_Uart_Send_Byte  
    movlw       01h
    call        F_Uart_Send_Byte  
    movlw       2ch
    call        F_Uart_Send_Byte  
    movlw       e8h
    call        F_Uart_Send_Byte  
    call        F_Ble_UartDisable
    return   
/*-------------------------------------------
; Name    : F_Ble_UartEnable
; Function: ����GPIO5��UART��������ǰ���ã�����UART�����ݶ���
; Input   : 
; Output  :
; Temp    :  
; Other   :
; log     :
--------------------------------------------*/
F_Ble_UartEnable:
    bsf         BLEWAKEUPPINEN
    bcf         BLEWAKEUPPINPU
    bcf         BLEWAKEUPPIN   
    movlw       7
    call        F_delay_1ms   
    return 

/*-------------------------------------------
; Name    : F_Ble_UartDisable
; Function: ����GPIO5��UART�������ǰ���ã����͹���
; Input   : 
; Output  :
; Temp    :  
; Other   :
; log     :
--------------------------------------------*/
F_Ble_UartDisable:
    movlw       1
    call        F_delay_1ms     
    bsf         BLEWAKEUPPINEN
    bcf         BLEWAKEUPPINPU
    bsf         BLEWAKEUPPIN    
    return 
/*-------------------------------------------
; Name    : F_Ble_StartAdvCmd
; Function: ���������㲥����������������㲥
; Input   : 
; Output  :
; Temp    :  
; Other   :
; log     :
--------------------------------------------*/
F_Ble_StartAdvCmd:
    call    F_Ble_UartEnable  
    movlw   C5h
    CALL    F_Uart_Send_Byte  
    movlw   02h
    CALL    F_Uart_Send_Byte  
    movlw   26h
    CALL    F_Uart_Send_Byte  
    movlw   01h
    CALL    F_Uart_Send_Byte  
    movlw   E0h
    CALL    F_Uart_Send_Byte    
    call    F_Ble_UartDisable
    return      
/*-------------------------------------------
; Name    : F_Ble_SleepCmd
; Function: ����˯�������
; Input   : 
; Output  :
; Temp    :  
; Other   :
; log     :
--------------------------------------------*/
F_Ble_SleepCmd:
    call    F_Ble_UartEnable 
    movlw   C5h
    call    F_Uart_Send_Byte  
    movlw   02h
    call    F_Uart_Send_Byte  
    movlw   20h
    call    F_Uart_Send_Byte  
    movlw   00h
    call    F_Uart_Send_Byte  
    movlw   E7h
    call    F_Uart_Send_Byte  
    call    F_Ble_UartDisable   
    return    
/*-------------------------------------------
; Name    : F_Send_MacCmd
; Function: ����MAC��ַ
; Input   : 
; Output  :
; Temp    :  
; Other   :
; log     : ��������1FFDH~1FFFH�������ֽڵ�MAC��ַ����BLE
--------------------------------------------*/
F_SendMacCmd:
    call        F_Ble_UartEnable
	clrf		R_Checksum
	movlw		C5h
	xorwf		R_Checksum,1
	call		F_Uart_Send_Byte	
	movlw		07h
	xorwf		R_Checksum,1	
	call		F_Uart_Send_Byte
	movlw		2bh
	xorwf		R_Checksum,1	
	call		F_Uart_Send_Byte	
	movlw       1fH	             ;MAC��ַ�洢��ʼ��ַ	
	movwf		EADRH	
	movlw       ffH		
	movwf		EADRL
	nop
	movp
	xorwf		R_Checksum,1	
	call		F_Uart_Send_Byte
	movfw		EDAT	
	xorwf		R_Checksum,1	
	call		F_Uart_Send_Byte	
	decf		EADRL,1
	nop
	movp	
	xorwf		R_Checksum,1	
	call		F_Uart_Send_Byte
	movfw		EDAT	
	xorwf		R_Checksum,1	
	call		F_Uart_Send_Byte	
	decf		EADRL,1
	nop
	movp	
	xorwf		R_Checksum,1	
	call		F_Uart_Send_Byte
	movfw		EDAT	
	xorwf		R_Checksum,1	
	call		F_Uart_Send_Byte	
	movfw		R_Checksum                      ;У��
	call		F_Uart_Send_Byte									
	bsf		    BLEWAKEUPPIN 	
    call        F_Ble_UartDisable   					
	return		    
/*-------------------------------------------
; Name    : F_delay_1ms
; Function: �����ʱ1ms
; Input   : work
; Output  :
; Temp    :  
; Other   :
; log     :
--------------------------------------------*/
F_delay_1ms:
	    movwf	R_Ble_A0
F_delay_1ms_L0:
		movlw	2
		movwf   R_Ble_A1
F_delay_1ms_L1:
		movlw	249
		movwf   R_Ble_A2		
F_delay_1ms_L2:
		nop
		decfsz  R_Ble_A2,f
		goto    F_delay_1ms_L2
		decfsz  R_Ble_A1,f
		goto    F_delay_1ms_L1
		decfsz  R_Ble_A0,f
		goto    F_delay_1ms_L0		
		return        