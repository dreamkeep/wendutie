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
; function: UART��������
;--------------------------------------------
/*---------------------------------------------
;�궨��
-----------------------------------------------*/
ACK0_LENGTH              EQU      10             ;ѭ���б��ܳ���
CMD0_LENGTH              EQU      25             ;���������
R_UARTX0_SEG_S           EQU      R_ALC_UARTX0_S
R_UARRX0_SEG_S           EQU      R_ALC_UARRX0_S
/*--------------------------------------------
;�Ĵ�������
----------------------------------------------*/
R_0TxData1               EQU      R_UARTX0_SEG_S+0
R_0TxData2               EQU      R_UARTX0_SEG_S+1
R_0TxData3               EQU      R_UARTX0_SEG_S+2
R_0TxData4               EQU      R_UARTX0_SEG_S+3
R_0TxData5               EQU      R_UARTX0_SEG_S+4
R_0TxData6               EQU      R_UARTX0_SEG_S+5
R_0TxData7               EQU      R_UARTX0_SEG_S+6
R_0TxDataLength          EQU      R_UARTX0_SEG_S+7
R_0TxDataChecksum        EQU      R_UARTX0_SEG_S+8
R_0RxACK1                EQU      R_ALC_UARRX0_S+0
R_0RxACK2                EQU      R_ALC_UARRX0_S+1
R_0RxData1               EQU      R_ALC_UARRX0_S+2
R_0RxData2               EQU      R_ALC_UARRX0_S+3
R_0RxData3               EQU      R_ALC_UARRX0_S+4
R_0RxData4               EQU      R_ALC_UARRX0_S+5
R_0RxSbuf                EQU      R_ALC_UARRX0_S+6
R_0RxQueue_Rear          EQU      R_ALC_UARRX0_S+7
R_0RxQueue_Length        EQU      R_ALC_UARRX0_S+8 
R_0RxQueue_Front         EQU      R_ALC_UARRX0_S+9  
R_0RxQueue_Flag          EQU      R_ALC_UARRX0_S+10 
Rx0QueueFlagACKFininsh   EQU      0                ;Ӧ������������
Rx0QueueFlagDataFininsh  EQU      1                ;���ݽ����������
Rx0QueueFlagACK          EQU      2                ;




/*-------------------------------------------
; Name    : F_Uart0_Init
; Function: ����UART0,������115200
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
F_Uart0_Init:
;	BCF			PT2EN,3				;RX = input/pull/high
;	BSF			PT2PU,3
;	BSF			PT2,3
;	
;	BSF			PT2EN,2				;TX = output/no-pull/high
;	BCF			PT2PU,2
;	BSF			PT2,2		
	;-------------------------------
	;115200bps @ ICK=8MHz
	;-------------------------------\	
	movlw		35h					;<����ROOT_EN><���Datasheet>
	movwf		ROOT
	movlw		c8h
	movwf		ROOT
	movlw		17h
	movwf		ROOT
	
	bsf			WDTCON,ROOT_EN		;�����ܱ���SFRдʹ��<���Datasheet>		
		
	bcf			PCK,4				;UART0_DIV[2:0] = 3'b000 --> UART0_CLK = ICK/2
	bcf			PCK,3		
	bcf			PCK,2

	movlw		34
	movwf		UR0_BRR0			;UR0_BRR0:(�ϵ�Ĭ��ֵΪ:00000000)
									;Bit7-0	BRR0: ���������üĴ���0����������

	movlw		7
	movwf		UR0_BRR1			;UR0_BRR1:(�ϵ�Ĭ��ֵΪ:00000000)
									;Bit7	AUTO_BR: �Զ�������ʹ�� --> <�൱���ⲿУ׼SOC UART BR>
									;	0 = �Զ������ʹ���δ�򿪣�����Ҫ���д0
									;	1 = ���Զ������ʹ��ܣ�Ҫ���ⲿ��������Ϊ55H��Ӳ������
		
									;Bit6-4	RFU: 
		
									;Bit3-0	BRR1: ���������üĴ���1��С������

	;<ע�������ж���������һֱ�����ж�>
	movlw		00000000b
	movwf		UR0_CR2				;UR0_CR2:(�ϵ�Ĭ��ֵΪ:00110011)
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
	movwf		UR0_ST				;UR0_CR2:(�ϵ�Ĭ��ֵΪ:00000000)		
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

	movlw		00001111b
	movwf		UR0_CR1				;UR0_CR1:(�ϵ�Ĭ��ֵΪ:00000000)
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
		
									;Bit1	UART0_SEL: UART0�ӿ�ѡ��
									;	0 = PT1.2��Ϊ����0��RX��PT1.3��Ϊ����0��TX
									;	1 = PT2.3��Ϊ����0��RX��PT2.2��Ϊ����0��TX*		
		
									;Bit0	UART0_EN: UART0ʹ�ܿ���
									;	0 = �ر�UART
									;	1 = ��UART*
		
		
    bcf			INTE2,UR0_RNIE      ;����0����FIFO�ǿ��ж�ʹ��
    bcf			INTE2,UR0_TEIE      ;����0����FIFO���ж�ʹ��	
    movlw		00000000B
    movwf		INTE2	
		
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
; log     :���ò�ѯ��ʽ�����ֽڣ�ע����UR0_TX_REG������
           ����Ҫ��ʱһ��ʱ�䣬UR0_TEIF���Ϳ��жϲŻ��
           Ϊ0������ȡ�߷���֮���жϲű�Ϊ1
--------------------------------------------*/
F_Uart0_Send_Byte:   
    movwf       UR0_TX_REG
    NOP
    NOP
    nop
    nop
    btfss       INTF2,UR0_TEIF
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
F_Uart0_Send_NByte:              
    clrf        R_0TxDataChecksum
    bsf         BSR,IRP1
    movlw       R_0TxData1
    movwf       FSR1
F_Uart0_Send_NByte_L0:    
    movfw       IND1
    call        F_Uart0_Send_Byte    
    xorwf       R_0TxDataChecksum,1
    incf        FSR1,1
    decfsz      R_0TxDataLength,1
    goto        F_Uart0_Send_NByte_L0   
    movfw       R_0TxDataChecksum
    call        F_Uart0_Send_Byte 
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
F_Uart0_RxFlag_Clear:
    movfw       UR0_RX_REG
    btfsc       INTF2,UR0_RNIF           
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
F_Uart0_Rx_NByte:
    bsf         bsr,IRP1
;    bcf         bsr,PAGE0
;    bsf         bsr,PAGE1                     ;SRAMҳѡ�񣬵ڶ�ҳ,���Ѱַʹ��FSR1
    incf        R_0RxQueue_Length,1
    movlw       01h
    xorwf       R_0RxQueue_Length,0
    btfsc       status,z
    goto        F_Uart0_Rx_Hear                ;��1���ֽڣ�Hear
    movlw       02h
    xorwf       R_0RxQueue_Length,0
    btfss       status,z
    goto        F_Uart0_Rx_Loop        
                                              ;��2���ֽڣ�Length
    movfw       R_0RxSbuf
    movwf       R_0RxQueue_Front
    movlw       03h                           ;���ȼ��ϰ�ͷ�����ȡ�У�����
    addwf       R_0RxQueue_Front,1   
    goto        F_Uart0_Rx_Loop
F_Uart0_Rx_Hear:
    movfw       R_0RxSbuf
    xorlw       C7H
    btfsc       status,z
    goto        F_Uart0_Rx_C5                  ;c5
F_Uart0_Rx_C6:
    BSF         R_0RxQueue_Flag,Rx0QueueFlagACK
    movfw       R_0RxSbuf
    xorlw       C6H
    btfss       status,z                
    goto        F_Uart0_Rx_Err                 ;c6
    movlw       R_0RxAck1                      ;Ӧ������洢�׵�ַ
    movwf       FSR1
    movwf       R_0RxQueue_Rear                ;���е�ַ�ݴ�
    movlw       C6H
    movwf       IND1                          ;����֡ͷ
    incf        R_0RxQueue_Rear,1        
    goto        F_Uart0_Rx_NByte_End 
F_Uart0_Rx_C5:   
    BCF         R_0RxQueue_Flag,Rx0QueueFlagACK
    movlw       R_0RxData1                     ;��������洢�׵�ַ
    movwf       FSR1
    movwf       R_0RxQueue_Rear                ;���е�ַ�ݴ�
    movlw       C7H
    movwf       IND1                          ;����֡ͷ
    incf        R_0RxQueue_Rear,1        
    goto        F_Uart0_Rx_NByte_End 
F_Uart0_Rx_Loop:
    movfw       R_0RxQueue_Rear
    movwf       fsr1
    movfw       R_0RxSbuf
    movwf       IND1
    incf        R_0RxQueue_Rear,1
F_Uart0_Rx_Check:                              ;��������ָ������ƣ���ֹBUFF���
    movlw       27
    btfsc       R_0RxQueue_Flag,Rx0QueueFlagACK
    movlw       10
    subwf       R_0RxQueue_Length,0
    btfsc       status,c
    goto        F_Uart0_Rx_Err       
 
                                              ;�Ƿ�������
    movfw       R_0RxQueue_Length
    xorwf       R_0RxQueue_Front,0
    btfss       status,z
    goto        F_Uart0_Rx_NByte_End 
    BTFSS       R_0RxQueue_Flag,Rx0QueueFlagACK    
    goto        $+3
    BSF         R_0RxQueue_Flag,Rx0QueueFlagACKFininsh
    goto        F_Uart0_Rx_Err
    BSF         R_0RxQueue_Flag,Rx0QueueFlagDataFininsh   
F_Uart0_Rx_Err:
    clrf        R_0RxQueue_Length
    clrf        R_0RxQueue_Front   
F_Uart0_Rx_NByte_End:
    return