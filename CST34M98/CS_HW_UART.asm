;--------------------------------------------
;                  ���� 
; �ó�������ο�������оƬ�������������¶���
; ���м򵥵Ĺ��ܲ��ԡ��������д�����©��о��
; �Ƽ�(����)�ɷ����޹�˾�Դ˲��е��κ����Ρ�
;   (C)Shenzhen Chipsea Technologies Co.,Ltd
;--------------------------------------------
; filename: CS_HW_UART.ASM
; author  : 
; date    : 2017-7-20
; function:UART��������
;--------------------------------------------
/*---------------------------------------------
;�궨��
-----------------------------------------------*/
ACK_LENGTH              EQU      10             ;ѭ���б��ܳ���
CMD_LENGTH              EQU      25             ;���������
R_UARTX_SEG_S           EQU      R_ALC_UARTX_S
R_UARRX_SEG_S           EQU      R_ALC_UARRX_S
/*--------------------------------------------
;�Ĵ�������
----------------------------------------------*/
R_TxData1               EQU      R_UARTX_SEG_S+0
R_TxData2               EQU      R_UARTX_SEG_S+1
R_TxData3               EQU      R_UARTX_SEG_S+2
R_TxData4               EQU      R_UARTX_SEG_S+3
R_TxData5               EQU      R_UARTX_SEG_S+4
R_TxData6               EQU      R_UARTX_SEG_S+5
R_TxData7               EQU      R_UARTX_SEG_S+6
R_TxData8               EQU      R_UARTX_SEG_S+7
R_TxData9               EQU      R_UARTX_SEG_S+8
R_TxData10              EQU      R_UARTX_SEG_S+9
R_TxData11              EQU      R_UARTX_SEG_S+10
R_TxData12              EQU      R_UARTX_SEG_S+11
R_TxData13              EQU      R_UARTX_SEG_S+12
R_TxData14              EQU      R_UARTX_SEG_S+13
R_TxData15              EQU      R_UARTX_SEG_S+14
R_TxData16              EQU      R_UARTX_SEG_S+15
R_TxData17              EQU      R_UARTX_SEG_S+16
R_TxData18              EQU      R_UARTX_SEG_S+17
R_TxData19              EQU      R_UARTX_SEG_S+18
R_TxData20              EQU      R_UARTX_SEG_S+19
R_TxData21              EQU      R_UARTX_SEG_S+20
R_TxData22              EQU      R_UARTX_SEG_S+21
R_TxData23              EQU      R_UARTX_SEG_S+22
R_TxData24              EQU      R_UARTX_SEG_S+23
R_TxData25              EQU      R_UARTX_SEG_S+24
R_TxData26              EQU      R_UARTX_SEG_S+25
R_TxData27              EQU      R_UARTX_SEG_S+26
R_TxData28              EQU      R_UARTX_SEG_S+27
R_TxData29              EQU      R_UARTX_SEG_S+28
R_TxData30              EQU      R_UARTX_SEG_S+29
R_TxDataLength          EQU      R_UARTX_SEG_S+30
R_TxDataChecksum        EQU      R_UARTX_SEG_S+31

R_RxACK1                EQU      R_ALC_UARRX_S+0
R_RxACK2                EQU      R_ALC_UARRX_S+1
R_RxACK3                EQU      R_ALC_UARRX_S+2
R_RxACK4                EQU      R_ALC_UARRX_S+3
R_RxACK5                EQU      R_ALC_UARRX_S+4
R_RxACK6                EQU      R_ALC_UARRX_S+5
R_RxACK7                EQU      R_ALC_UARRX_S+6
R_RxACK8                EQU      R_ALC_UARRX_S+7
R_RxACK9                EQU      R_ALC_UARRX_S+8
R_RxACK10               EQU      R_ALC_UARRX_S+9
R_RxData1               EQU      R_ALC_UARRX_S+10
R_RxData2               EQU      R_ALC_UARRX_S+11
R_RxData3               EQU      R_ALC_UARRX_S+12
R_RxData4               EQU      R_ALC_UARRX_S+13
R_RxData5               EQU      R_ALC_UARRX_S+14
R_RxData6               EQU      R_ALC_UARRX_S+15
R_RxData7               EQU      R_ALC_UARRX_S+16
R_RxData8               EQU      R_ALC_UARRX_S+17
R_RxData9               EQU      R_ALC_UARRX_S+18
R_RxData10              EQU      R_ALC_UARRX_S+19
R_RxData11              EQU      R_ALC_UARRX_S+20
R_RxData12              EQU      R_ALC_UARRX_S+21
R_RxData13              EQU      R_ALC_UARRX_S+22
R_RxData14              EQU      R_ALC_UARRX_S+23
R_RxData15              EQU      R_ALC_UARRX_S+24
R_RxData16              EQU      R_ALC_UARRX_S+25
R_RxData17              EQU      R_ALC_UARRX_S+26
R_RxData18              EQU      R_ALC_UARRX_S+27
R_RxData19              EQU      R_ALC_UARRX_S+28
R_RxData20              EQU      R_ALC_UARRX_S+29
R_RxData21              EQU      R_ALC_UARRX_S+30
R_RxData22              EQU      R_ALC_UARRX_S+31
R_RxData23              EQU      R_ALC_UARRX_S+32
R_RxData24              EQU      R_ALC_UARRX_S+33
R_RxData25              EQU      R_ALC_UARRX_S+34
R_RxData26              EQU      R_ALC_UARRX_S+35
R_RxData27              EQU      R_ALC_UARRX_S+36
R_RxData28              EQU      R_ALC_UARRX_S+37
R_RxData29              EQU      R_ALC_UARRX_S+38
R_RxData30              EQU      R_ALC_UARRX_S+39
R_RxData31              EQU      R_ALC_UARRX_S+40
R_RxSbuf                EQU      R_ALC_UARRX_S+41
R_RxQueue_Rear          EQU      R_ALC_UARRX_S+42  
R_RxQueue_Length        EQU      R_ALC_UARRX_S+43  
R_RxQueue_Front         EQU      R_ALC_UARRX_S+44  
R_RxQueue_Flag          EQU      R_ALC_UARRX_S+45  
RxQueueFlagACKFininsh   EQU      0                ;Ӧ������������
RxQueueFlagDataFininsh  EQU      1                ;���ݽ����������
RxQueueFlagACK          EQU      2                ;




/*-------------------------------------------
; Name    : F_Uart1_Init
; Function: ����UART1,������115200
; Input   : 
; Output  : 
; Temp    : 
; Other   :
; log     :
            BR - UART0_CLK / (BRR0 + (BRR1 / 10))
            UART0_CLK - ICK / 2^(UART0_DIV + 1)
            -----------------------------------------------------------------      
            ע1��UART0_DIVԽ�󣬹���Խ�ߣ���Ƶ����Խ��
            ע2��115200bps - 4MHz / (BRR0 + (BRR1 / 10) --> BRR0 - 34, BRR1 - 7
--------------------------------------------*/
F_Uart1_Init:
;	BCF			PT2EN,3				;RX = input/pull/high
;	BSF			PT2PU,3
;	BSF			PT2,3
;	
;	BSF			PT2EN,2				;TX = output/no-pull/high
;	BCF			PT2PU,2
;	BSF			PT2,2		
	;-------------------------------
	;115200bps @ ICK=8MHz
	;-------------------------------	
	movlw		35h					;<����ROOT_EN><���Datasheet>
	movwf		ROOT
	movlw		c8h
	movwf		ROOT
	movlw		17h
	movwf		ROOT
	
	bsf			WDTCON,ROOT_EN		;�����ܱ���SFRдʹ��<���Datasheet>		
		
	bcf			PCK,7				;UART1_DIV[2:0] = 3'b000 --> UART0_CLK = ICK/2
	bcf			PCK,6		
	bcf			PCK,5

	movlw		34
	movwf		UR1_BRR0			;UR1_BRR0:(�ϵ�Ĭ��ֵΪ:00000000)
									;Bit7-0	BRR0: ���������üĴ���0����������

	movlw		7
	movwf		UR1_BRR1			;UR1_BRR1:(�ϵ�Ĭ��ֵΪ:00000000)
									;Bit7	AUTO_BR: �Զ�������ʹ�� --> <�൱���ⲿУ׼SOC UART BR>
									;	0 = �Զ������ʹ���δ�򿪣�����Ҫ���д0
									;	1 = ���Զ������ʹ��ܣ�Ҫ���ⲿ��������Ϊ55H��Ӳ������
		
									;Bit6-4	RFU: 
		
									;Bit3-0	BRR1: ���������üĴ���1��С������

	;<ע�������ж���������һֱ�����ж�>
	movlw		00000000b
	movwf		UR1_CR2				;UR0_CR2:(�ϵ�Ĭ��ֵΪ:00110011)
									;Bit7	NC
		
									;Bit6-4	TXF_WATER_LEVEL: TXFIFO��������С���趨ֵ�󣬱�����ˮ���ж�
									;	000 = ��TX_FIFO������=0ʱ��������ˮ��				
									;	001 = ��TX_FIFO������<=1ʱ��������ˮ���ж�
									;	010 = ��TX_FIFO������<=2ʱ��������ˮ���ж�
									;	011 = ��TX_FIFO������<=3ʱ��������ˮ���ж�
									;	100 = ��TX_FIFO������<=4ʱ��������ˮ���ж�
									;	101 = ��TX_FIFO������<=5ʱ��������ˮ���ж�
									;	110 = ��TX_FIFO������<=6ʱ��������ˮ���ж�
									;   111 = ��TX_FIFO������<=7ʱ��������ˮ���ж�

									;Bit3	RFU: 

									;Bit2-0	RXF_WATER_LEVEL: RXFIFO�������������趨ֵ�󣬱�����ˮ���ж�
									;	000 = ��RX_FIFO����>0ʱ��������ˮ���жϣ��൱�ڷǿ��ж�			
									;	001 = ��RX_FIFO����>1ʱ��������ˮ���ж�
									;	010 = ��RX_FIFO����>2ʱ��������ˮ���ж�
									;	011 = ��RX_FIFO����>3ʱ��������ˮ���ж�
									;	100 = ��RX_FIFO����>4ʱ��������ˮ���ж�
									;	101 = ��RX_FIFO����>5ʱ��������ˮ���ж�
									;	110 = ��RX_FIFO����>6ʱ��������ˮ���ж�
									;   111 = ��RX_FIFO���ݴ���ʱ��������ˮ���ж�

;	;<ע������Sleep�󣬿��Բ���UART�����жϽ��л��ѡ�CPU�����Ѻ󣬿��Բ�ѯ��Bit3�����RX_BUSY=0����ʾ�˴λ��ѿ��������ڸ�����ɡ�>
	movlw		00000000b
	movwf		UR1_ST				;UR0_CR2:(�ϵ�Ĭ��ֵΪ:00000000)		
;									;Bit7-4	NC		
;		
;									;Bit3	RX_BUSY: ����Busyָʾ�ź�		
;									;	0 = ��ʾ���ն�δ���н���
;									;	1 = ��ʾ���ն����ڽ�����
;
;									;Bit2	TX_BUSY: ���ͼĴ���TX_REG�������Ƿ�ȫ�����з������		
;									;	0 = �Ѿ�ȫ���������
;									;	1 = ��δȫ���������		
;		
;									;Bit1	RXOV_ERR: ����RXFIFO��������־�����Դ��������жϣ�Ӳ����1�������0		
;									;	0 = δ�����������
;									;	1 = �����������		
;		
;									;Bit0	STOP_ERR: ����ֹͣλ�����־�����Դ��������жϣ�Ӳ����1�������0		
;									;	0 = ����ʱδ����ֹͣλ����
;									;	1 = ����ʱ����ֹͣλ����		

	movlw		00001101b
	movwf		UR1_CR1				;UR0_CR1:(�ϵ�Ĭ��ֵΪ:00000000)
									;Bit7	TX9D: �������ݵ�9λ
									;	0 = ���͵�9λ����Ϊ0
									;	1 = ���͵�9λ����Ϊ1
		
									;Bit6	RX9D: �������ݵ�9λ(Read Only)
									;	0 = ���յ�9λ����Ϊ0
									;	1 = ���յ�9λ����Ϊ1		
		
									;Bit5	TX9_EN: �������ݵ�9λʹ��
									;	0 = �رշ��͵�9λ*
									;	1 = ʹ�ܷ��͵�9λ
		
									;Bit4	RX9_EN: �������ݵ�9λʹ��
									;	0 = �رս��յ�9λ*
									;	1 = ʹ�ܽ��յ�9λ		

									;Bit3	RX_EN: ���տ���ѡ��
									;	0 = ��ֹ����
									;	1 = �������*
		
									;Bit2	TX_EN: ����ʹ��
									;	0 = ����ʹ�ܹر�
									;	1 = ����ʹ�ܴ�*
		
									;Bit1	UART1_SEL: UART1�ӿ�ѡ��
									;	0 = PT1.7��Ϊ����1��RX��PT1.6��Ϊ����1��TX*	
									;	1 = PT2.6��Ϊ����1��RX��PT2.7��Ϊ����1��TX	
		
									;Bit0	UART1_EN: UART1ʹ�ܿ���
									;	0 = �ر�UART
									;	1 = ��UART*
		
		
    bsf			INTE2,UR1_RNIE      ;����1����FIFO�ǿ��ж�ʹ��
    bcf			INTE2,UR1_TEIE      ;����1����FIFO���ж�ʹ��		
		
	bcf			WDTCON,ROOT_EN		;�ر��ܱ���SFRдʹ��

									;<����ROOT_EN><���Datasheet>
	clrf		ROOT
	return
/*-------------------------------------------
; Name    :F_Uart_Send_Byte 
; Function:Uart ����һ���ֽ�
; Input   : work
; Output  :
; Temp    :  
; Other   :
; log     :���ò�ѯ��ʽ�����ֽڣ�ע����UR1_TX_REG������
           ����Ҫ��ʱһ��ʱ�䣬UR1_TEIF���Ϳ��жϲŻ��
           Ϊ0������ȡ�߷���֮���жϲű�Ϊ1
--------------------------------------------*/
F_Uart_Send_Byte:   
    movwf       UR1_TX_REG
    NOP
    NOP
    nop
    nop
    btfss       INTF2,UR1_TEIF
    goto        $-1 
    return
/*-------------------------------------------
; Name    :F_Uart_Send_NByte 
; Function:����R_TxDataLength���ֽں��������Ҽ���R_TxDataLength���ֽ�У���뷢�͡�
; Input   :R_TxDataLength,R_RxData
; Output  : 
; Temp    : 
; Other   :
; log     :
--------------------------------------------*/   
F_Uart_Send_NByte:              
    clrf        R_TxDataChecksum
    bsf         BSR,IRP1
    movlw       R_TxData1
    movwf       FSR1
F_Uart_Send_NByte_L0:    
    movfw       IND1
    call        F_Uart_Send_Byte    
    xorwf       R_TxDataChecksum,1
    incf        FSR1,1
    decfsz      R_TxDataLength,1
    goto        F_Uart_Send_NByte_L0   
    movfw       R_TxDataChecksum
    call        F_Uart_Send_Byte 
    bcf         BSR,IRP1
    return
/*-------------------------------------------
; Name    : F_Uart_RxFlag_Clear
; Function: ���UART���ձ�־λ
; Input   : 
; Output  :
; Temp    :  
; Other   :
; log     :
--------------------------------------------*/
F_Uart_RxFlag_Clear:
    movfw       UR1_RX_REG
    btfsc       INTF2,UR1_RNIF           
    goto        $-2 
    return  
/*-------------------------------------------
; Name    : F_Uart_Rx_NByte
; Function: Uart�жϴ���
; Input   : 
; Output  :
; Temp    :  
; Other   :
; log     :�����ļ�include���ж���
--------------------------------------------*/
F_Uart_Rx_NByte:
    bsf         bsr,IRP1
;    bcf         bsr,PAGE0
;    bsf         bsr,PAGE1                     ;SRAMҳѡ�񣬵ڶ�ҳ,���Ѱַʹ��FSR1
    incf        R_RxQueue_Length,1
    movlw       01h
    xorwf       R_RxQueue_Length,0
    btfsc       status,z
    goto        F_Uart_Rx_Hear                ;��1���ֽڣ�Hear
    movlw       02h
    xorwf       R_RxQueue_Length,0
    btfss       status,z
    goto        F_Uart_Rx_Loop        
                                              ;��2���ֽڣ�Length
    movfw       R_RxSbuf
    movwf       R_RxQueue_Front
    movlw       03h                           ;���ȼ��ϰ�ͷ�����ȡ�У�����
    addwf       R_RxQueue_Front,1   
    goto        F_Uart_Rx_Loop
F_Uart_Rx_Hear:
    movfw       R_RxSbuf
    xorlw       C7H
    btfsc       status,z
    goto        F_Uart_Rx_C5                  ;c5
F_Uart_Rx_C6:
    BSF         R_RxQueue_Flag,RxQueueFlagACK
    movfw       R_RxSbuf
    xorlw       C6H
    btfss       status,z                
    goto        F_Uart_Rx_Err                 ;c6
    movlw       R_RxAck1                      ;Ӧ������洢�׵�ַ
    movwf       FSR1
    movwf       R_RxQueue_Rear                ;���е�ַ�ݴ�
    movlw       C6H
    movwf       IND1                          ;����֡ͷ
    incf        R_RxQueue_Rear,1        
    goto        F_Uart_Rx_NByte_End 
F_Uart_Rx_C5:   
    BCF         R_RxQueue_Flag,RxQueueFlagACK
    movlw       R_RxData1                     ;��������洢�׵�ַ
    movwf       FSR1
    movwf       R_RxQueue_Rear                ;���е�ַ�ݴ�
    movlw       C7H
    movwf       IND1                          ;����֡ͷ
    incf        R_RxQueue_Rear,1        
    goto        F_Uart_Rx_NByte_End 
F_Uart_Rx_Loop:
    movfw       R_RxQueue_Rear
    movwf       fsr1
    movfw       R_RxSbuf
    movwf       IND1
    incf        R_RxQueue_Rear,1
F_Uart_Rx_Check:                              ;��������ָ������ƣ���ֹBUFF���
    movlw       27
    btfsc       R_RxQueue_Flag,RxQueueFlagACK
    movlw       10
    subwf       R_RxQueue_Length,0
    btfsc       status,c
    goto        F_Uart_Rx_Err       
 
                                              ;�Ƿ�������
    movfw       R_RxQueue_Length
    xorwf       R_RxQueue_Front,0
    btfss       status,z
    goto        F_Uart_Rx_NByte_End 
    BTFSS       R_RxQueue_Flag,RxQueueFlagACK    
    goto        $+3
    BSF         R_RxQueue_Flag,RxQueueFlagACKFininsh
    goto        F_Uart_Rx_Err
    BSF         R_RxQueue_Flag,RxQueueFlagDataFininsh   
F_Uart_Rx_Err:
    clrf        R_RxQueue_Length
    clrf        R_RxQueue_Front   
F_Uart_Rx_NByte_End:
    return
    
    

    
    
    