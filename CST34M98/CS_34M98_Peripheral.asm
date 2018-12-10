;============================================
;                  声明
; 该程序仅供参考若程序中存在疏漏， 
; 芯海科技有限公司对此不承担任何责任。
; (C)Shenzhen Chipsea Technologies Co.,Ltd
;============================================
; filename: CS_18M88_Peripheral.asm
; chip    : CST34M97
; author  : CS0155
; date    : 2017-06-21
; v1.0
;============================================
; 常量定义
;============================================
DEFINE	Port_BackLight	"PT2,6"
;============================================
; 变量地址分配
;============================================
;---输入变量


;---输出变量


;局部变量

;全局变量


;============================================
; 待机初始化函数
;============================================
; 入口变量：
; 出口变量：  
; 中间变量：
; 标志位：  
; 实现的功能：
;     
;
; 程序思路：
;        
;============================================
F_SOC_StandbyInit:

	;-----------------------------------------------------------------
	;设置24bit-ADC
	;-----------------------------------------------------------------
	;VS=2.45V/DR=1.95KHz
	;如果使用2节干电池时，VS选择2.35V
	;-----------------------------------------------------------------	
	movlw		11100000b			;ANACFG:(上电默认值为:00000000)
	movwf		ANACFG				;Bit7	LDOEN: LDO电源使能信号
									
	bcf			ADCON,7				;	1'b1 = <关闭>加强高性能模式
	
	bcf			ADCON,3				;	4'b0001 = CK_SMP/8192 = 1.95KHz<详见Datasheet>
	bcf			ADCON,2
	bcf			ADCON,1
	bsf			ADCON,0

	movlw		00101000b		
	movwf		ADCFG				
									
	;<整机测试后在确定参数>
	movlw		01000000b		
	movwf		TEMPC			
					
	
;	movlf		20,R_SYS_A0					;延时5ms(@cpuclk=2MHz)
;	call		F_delay_1kclk	

	bsf			ANACFG,ADEN			;使能24bit-ADC
	;-----------------------------------------------------------------
	;初始化中断
	;-----------------------------------------------------------------
	bsf			INTE,GIE			;使能总中断
	bsf			INTE,ADIE			;使能24bit-ADC中断

	return	
	
	
	
;============================================
; 芯片硬件进入睡眠函数
;============================================
; 入口变量：
; 出口变量：  
; 中间变量：
; 标志位：  
; 实现的功能：
;     
;
; 程序思路：
;        
;============================================
F_SOC_Sleep:
	;---关闭中断
	bcf			INTE,ADIE
	bcf			INTE2,UR0_RNIE
	bcf			INTE3,RTCIE
	clrf		INTF
	clrf		INTF2
	clrf		INTF3
	;---关闭定时器
		
	;---关闭电源模块
	bcf			LVDCON,LVDEN		;关闭低电压检测				
	;---关闭AD模块
	bcf		ANACFG,7		;LDO关闭
	bcf		ANACFG,ADEN		;关闭AD使能位
	
	;---清显示和关闭LCD模块
	bcf		BSR,PAGE0	
	bcf		BSR,IRP0
	movlw	LCD1
	movwf	FSR0
	clrf	IND0
	movlw	LCD20
	subwf	FSR0,w
	btfsc	STATUS,C
	goto	$+3
	incf	FSR0,f
	goto	$-6
	
	bcf		LCDENR,LCDEN	;关闭LCD
	bcf		LCDENR,ENPMPL	;开pump
	bsf		Port_BackLight	;关背光
	;---配置IO口
	
	;---开启看门狗自动唤醒
	bsf		WDTCON,2			;3'b100 = 1s(@WDTIN=BBH)<详见Datasheet>
	bcf		WDTCON,1
	bcf		WDTCON,0	
	movlw	bbh
	movwf	WDTIN		
	bsf		WDTCON,WDTEN
	
	;---开启pt2.7按键中断用于按键唤醒
;	bcf		PTINT0,6
;	bsf		PTINT0,7
;	bcf		INTF,E0IF
;	bsf		INTE,E0IE
;	bsf		INTE,GIE
	
	;---进入睡眠
F_SOC_Sleep_L1:
	sleep
	nop
	nop
;	btfsc	PT2,7
;	goto	F_SOC_Sleep_L1
;	movlf	10,R_SYS_A0
;	call	F_delay_1kclk
;	btfsc	PT2,7
;	goto	F_SOC_Sleep_L1	
	
	clrwdt
	bcf		WDTCON,WDTEN
	return

;============================================
; 芯片硬件唤醒函数
;============================================
; 入口变量：
; 出口变量：  
; 中间变量：
; 标志位：  
; 实现的功能：
;     
;
; 程序思路：
;        
;============================================
F_SOC_WakeUp:
	;---配置IO口
	
	;---开启电源模块
	bsf			LVDCON,LVDEN		;使能低电压检测		
	;---开启AD模块
	
	;---开启LCD模块
	bsf		LCDENR,LCDEN	;关闭LCD
	bsf		LCDENR,ENPMPL	;开pump
	bcf		Port_BackLight	;开背光
	
	;---清看门狗
	clrwdt
	bcf		WDTCON,WDTEN	
	;---开中断
	clrf	INTF
	clrf	INTF2
	clrf	INTF3
	bcf		PTINT0,6
	bsf		INTE2,UR0_RNIE
	bsf		INTE3,RTCIE
	
	return


	
;============================================
; 芯片AD从高速切换回低速
;============================================
; 入口变量：
; 出口变量：  
; 中间变量：
; 标志位：  
; 实现的功能：
;     
;
; 程序思路：
;        
;============================================
F_AD_ChangeToNormalSpeed:
	bcf		ANACFG,ADEN		;关闭AD使能位
    bsf     ANACFG,7        ;LDO开
	nop
	bsf		ADCON,3			;	4'b1101 = CK_SMP/8192 = 30.5Hz<详见Datasheet>
	bsf		ADCON,2
	bcf		ADCON,1
	bsf		ADCON,0
	bsf		ANACFG,ADEN		;开启AD使能位
	bcf		INTF,ADIF		;关闭24bit-ADC中断
	bsf		INTE,ADIE
	return
;============================================
; 关闭AD
;============================================
; 入口变量：
; 出口变量：
; 中间变量：
; 标志位：
; 实现的功能：
;
;
; 程序思路：
;
;============================================
F_AD_Close:
    bcf     ANACFG,7        ;LDO关闭
    bcf     ANACFG,ADEN     ;关闭AD使能位
    bcf     INTF,ADIF       ;关闭24bit-ADC中断
    return
    
    



	
	



