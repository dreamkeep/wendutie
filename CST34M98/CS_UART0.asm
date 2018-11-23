;--------------------------------------------
;                  声明 
; 该程序仅供参考和用于芯片正常工作环境下对其
; 进行简单的功能测试。若程序中存在疏漏，芯海
; 科技(深圳)股份有限公司对此不承担任何责任。
;   (C)Shenzhen Chipsea Technologies Co.,Ltd
;--------------------------------------------
; filename: CS_HW_UART.ASM
; author  : 
; date    : 2017-7-20
; function: UART驱动函数
;--------------------------------------------
/*---------------------------------------------
;宏定义
-----------------------------------------------*/
ACK0_LENGTH              EQU      10             ;循环列表总长度
CMD0_LENGTH              EQU      25             ;命令最长长度
R_UARTX0_SEG_S           EQU      R_ALC_UARTX0_S
R_UARRX0_SEG_S           EQU      R_ALC_UARRX0_S
/*--------------------------------------------
;寄存器定义
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
Rx0QueueFlagACKFininsh   EQU      0                ;应答接收命令完成
Rx0QueueFlagDataFininsh  EQU      1                ;数据接收命令完成
Rx0QueueFlagACK          EQU      2                ;




/*-------------------------------------------
; Name    : F_Uart0_Init
; Function: 设置UART0,波特率115200
; Input   : 
; Output  : 
; Temp    : 
; Other   :
; log     :
            BR - UART0_CLK / (BRR0 + (BRR1 / 10))
            UART0_CLK - ICK / 2^(UART0_DIV + 1)
            -----------------------------------------------------------------      
            注1：UART0_DIV越大，功耗越高，分频精度越低
            注2：115200bps - 4MHz / (BRR0 + (BRR1 / 10) --> BRR0 - 34, BRR1 - 7
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
	movlw		35h					;<解锁ROOT_EN><详见Datasheet>
	movwf		ROOT
	movlw		c8h
	movwf		ROOT
	movlw		17h
	movwf		ROOT
	
	bsf			WDTCON,ROOT_EN		;开启受保护SFR写使能<详见Datasheet>		
		
	bcf			PCK,4				;UART0_DIV[2:0] = 3'b000 --> UART0_CLK = ICK/2
	bcf			PCK,3		
	bcf			PCK,2

	movlw		34
	movwf		UR0_BRR0			;UR0_BRR0:(上电默认值为:00000000)
									;Bit7-0	BRR0: 波特率设置寄存器0，整数部分

	movlw		7
	movwf		UR0_BRR1			;UR0_BRR1:(上电默认值为:00000000)
									;Bit7	AUTO_BR: 自动波特率使能 --> <相当于外部校准SOC UART BR>
									;	0 = 自动波特率功能未打开，不需要软件写0
									;	1 = 打开自动波特率功能，要求外部输入数据为55H，硬件清零
		
									;Bit6-4	RFU: 
		
									;Bit3-0	BRR1: 波特率设置寄存器1，小数部分

	;<注：符合判断条件，会一直产生中断>
	movlw		00000000b
	movwf		UR0_CR2				;UR0_CR2:(上电默认值为:00110011)
									;Bit7	NC
		
									;Bit6-4	TXF_WATER_LEVEL: TXFIFO的数据量小于设定值后，报发送水线中断
									;	000 = 当TX_FIFO数据量=0时，报发送水线				
									;	001 = 当TX_FIFO数据量<=1时，报发送水线中断
									;	010 = 当TX_FIFO数据量<=2时，报发送水线中断
									;	011 = 当TX_FIFO数据量<=3时，报发送水线中断
									;	100 = 当TX_FIFO数据量<=4时，报发送水线中断
									;	101 = 当TX_FIFO数据量<=5时，报发送水线中断
									;	110 = 当TX_FIFO数据量<=6时，报发送水线中断
									;   111 = 当TX_FIFO数据量<=7时，报发送水线中断

									;Bit3	RFU: 

									;Bit2-0	RXF_WATER_LEVEL: RXFIFO的数据量大于设定值后，报接收水线中断
									;	000 = 当RX_FIFO数据>0时，报接收水线中断，相当于非空中断			
									;	001 = 当RX_FIFO数据>1时，报接收水线中断
									;	010 = 当RX_FIFO数据>2时，报接收水线中断
									;	011 = 当RX_FIFO数据>3时，报接收水线中断
									;	100 = 当RX_FIFO数据>4时，报接收水线中断
									;	101 = 当RX_FIFO数据>5时，报接收水线中断
									;	110 = 当RX_FIFO数据>6时，报接收水线中断
									;   111 = 当RX_FIFO数据存满时，报接收水线中断

;	;<注：进入Sleep后，可以采用UART唤醒中断进行唤醒。CPU被唤醒后，可以查询此Bit3。如果RX_BUSY=0，表示此次唤醒可能是由于干扰造成。>
	movlw		00000000b
	movwf		UR0_ST				;UR0_CR2:(上电默认值为:00000000)		
;									;Bit7-4	NC		
;		
;									;Bit3	RX_BUSY: 接收Busy指示信号		
;									;	0 = 表示接收端未进行接收
;									;	1 = 表示接收端正在接收中
;
;									;Bit2	TX_BUSY: 发送寄存器TX_REG的数据是否全部串行发送完毕		
;									;	0 = 已经全部发送完毕
;									;	1 = 还未全部发送完毕		
;		
;									;Bit1	RXOV_ERR: 接收RXFIFO溢出错误标志，可以触发错误中断，硬件置1，软件清0		
;									;	0 = 未发现溢出错误
;									;	1 = 发现溢出错误		
;		
;									;Bit0	STOP_ERR: 接收停止位错误标志，可以触发错误中断，硬件置1，软件清0		
;									;	0 = 接收时未发现停止位错误
;									;	1 = 接收时发现停止位错误		

	movlw		00001111b
	movwf		UR0_CR1				;UR0_CR1:(上电默认值为:00000000)
									;Bit7	TX9D: 发送数据第9位
									;	0 = 发送第9位数据为0
									;	1 = 发送第9位数据为1
		
									;Bit6	RX9D: 接收数据第9位(Read Only)
									;	0 = 接收第9位数据为0
									;	1 = 接收第9位数据为1		
		
									;Bit5	TX9_EN: 发送数据第9位使能
									;	0 = 关闭发送第9位*
									;	1 = 使能发送第9位
		
									;Bit4	RX9_EN: 接收数据第9位使能
									;	0 = 关闭接收第9位*
									;	1 = 使能接收第9位		

									;Bit3	RX_EN: 接收控制选择
									;	0 = 禁止接收
									;	1 = 允许接收*
		
									;Bit2	TX_EN: 发送使能
									;	0 = 发送使能关闭
									;	1 = 发送使能打开*
		
									;Bit1	UART0_SEL: UART0接口选择
									;	0 = PT1.2作为串口0的RX；PT1.3作为串口0的TX
									;	1 = PT2.3作为串口0的RX；PT2.2作为串口0的TX*		
		
									;Bit0	UART0_EN: UART0使能控制
									;	0 = 关闭UART
									;	1 = 打开UART*
		
		
    bcf			INTE2,UR0_RNIE      ;串口0接收FIFO非空中断使能
    bcf			INTE2,UR0_TEIE      ;串口0发送FIFO空中断使能	
    movlw		00000000B
    movwf		INTE2	
		
	bcf			WDTCON,ROOT_EN		;关闭受保护SFR写使能

									;<解锁ROOT_EN><详见Datasheet>
	clrf		ROOT
	return
/*-------------------------------------------
; Name    :F_Uart_Send_Byte 
; Function:Uart 发送一个字节
; Input   : work
; Output  :
; Temp    :  
; Other   :
; log     :采用查询方式发送字节，注意往UR0_TX_REG送数据
           后需要延时一段时间，UR0_TEIF发送空中断才会变
           为0，数据取走发送之后中断才变为1
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
; Function:发送R_TxDataLength个字节函数，并且计算R_TxDataLength个字节校验码发送。
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
; Function: 清除UART接收标志位
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
; Function: Uart中断处理
; Input   : 
; Output  :
; Temp    :  
; Other   :
; log     :将该文件include在中断中
--------------------------------------------*/
F_Uart0_Rx_NByte:
    bsf         bsr,IRP1
;    bcf         bsr,PAGE0
;    bsf         bsr,PAGE1                     ;SRAM页选择，第二页,间接寻址使用FSR1
    incf        R_0RxQueue_Length,1
    movlw       01h
    xorwf       R_0RxQueue_Length,0
    btfsc       status,z
    goto        F_Uart0_Rx_Hear                ;第1个字节，Hear
    movlw       02h
    xorwf       R_0RxQueue_Length,0
    btfss       status,z
    goto        F_Uart0_Rx_Loop        
                                              ;第2个字节，Length
    movfw       R_0RxSbuf
    movwf       R_0RxQueue_Front
    movlw       03h                           ;长度加上包头、长度、校验个数
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
    movlw       R_0RxAck1                      ;应答命令，存储首地址
    movwf       FSR1
    movwf       R_0RxQueue_Rear                ;队列地址暂存
    movlw       C6H
    movwf       IND1                          ;缓存帧头
    incf        R_0RxQueue_Rear,1        
    goto        F_Uart0_Rx_NByte_End 
F_Uart0_Rx_C5:   
    BCF         R_0RxQueue_Flag,Rx0QueueFlagACK
    movlw       R_0RxData1                     ;数据命令，存储首地址
    movwf       FSR1
    movwf       R_0RxQueue_Rear                ;队列地址暂存
    movlw       C7H
    movwf       IND1                          ;缓存帧头
    incf        R_0RxQueue_Rear,1        
    goto        F_Uart0_Rx_NByte_End 
F_Uart0_Rx_Loop:
    movfw       R_0RxQueue_Rear
    movwf       fsr1
    movfw       R_0RxSbuf
    movwf       IND1
    incf        R_0RxQueue_Rear,1
F_Uart0_Rx_Check:                              ;接收命令指令长度限制，防止BUFF溢出
    movlw       27
    btfsc       R_0RxQueue_Flag,Rx0QueueFlagACK
    movlw       10
    subwf       R_0RxQueue_Length,0
    btfsc       status,c
    goto        F_Uart0_Rx_Err       
 
                                              ;是否接收完成
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