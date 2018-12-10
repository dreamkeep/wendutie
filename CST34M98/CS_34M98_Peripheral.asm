;============================================
;                  ����
; �ó�������ο��������д�����©�� 
; о���Ƽ����޹�˾�Դ˲��е��κ����Ρ�
; (C)Shenzhen Chipsea Technologies Co.,Ltd
;============================================
; filename: CS_18M88_Peripheral.asm
; chip    : CST34M97
; author  : CS0155
; date    : 2017-06-21
; v1.0
;============================================
; ��������
;============================================
DEFINE	Port_BackLight	"PT2,6"
;============================================
; ������ַ����
;============================================
;---�������


;---�������


;�ֲ�����

;ȫ�ֱ���


;============================================
; ������ʼ������
;============================================
; ��ڱ�����
; ���ڱ�����  
; �м������
; ��־λ��  
; ʵ�ֵĹ��ܣ�
;     
;
; ����˼·��
;        
;============================================
F_SOC_StandbyInit:

	;-----------------------------------------------------------------
	;����24bit-ADC
	;-----------------------------------------------------------------
	;VS=2.45V/DR=1.95KHz
	;���ʹ��2�ڸɵ��ʱ��VSѡ��2.35V
	;-----------------------------------------------------------------	
	movlw		11100000b			;ANACFG:(�ϵ�Ĭ��ֵΪ:00000000)
	movwf		ANACFG				;Bit7	LDOEN: LDO��Դʹ���ź�
									
	bcf			ADCON,7				;	1'b1 = <�ر�>��ǿ������ģʽ
	
	bcf			ADCON,3				;	4'b0001 = CK_SMP/8192 = 1.95KHz<���Datasheet>
	bcf			ADCON,2
	bcf			ADCON,1
	bsf			ADCON,0

	movlw		00101000b		
	movwf		ADCFG				
									
	;<�������Ժ���ȷ������>
	movlw		01000000b		
	movwf		TEMPC			
					
	
;	movlf		20,R_SYS_A0					;��ʱ5ms(@cpuclk=2MHz)
;	call		F_delay_1kclk	

	bsf			ANACFG,ADEN			;ʹ��24bit-ADC
	;-----------------------------------------------------------------
	;��ʼ���ж�
	;-----------------------------------------------------------------
	bsf			INTE,GIE			;ʹ�����ж�
	bsf			INTE,ADIE			;ʹ��24bit-ADC�ж�

	return	
	
	
	
;============================================
; оƬӲ������˯�ߺ���
;============================================
; ��ڱ�����
; ���ڱ�����  
; �м������
; ��־λ��  
; ʵ�ֵĹ��ܣ�
;     
;
; ����˼·��
;        
;============================================
F_SOC_Sleep:
	;---�ر��ж�
	bcf			INTE,ADIE
	bcf			INTE2,UR0_RNIE
	bcf			INTE3,RTCIE
	clrf		INTF
	clrf		INTF2
	clrf		INTF3
	;---�رն�ʱ��
		
	;---�رյ�Դģ��
	bcf			LVDCON,LVDEN		;�رյ͵�ѹ���				
	;---�ر�ADģ��
	bcf		ANACFG,7		;LDO�ر�
	bcf		ANACFG,ADEN		;�ر�ADʹ��λ
	
	;---����ʾ�͹ر�LCDģ��
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
	
	bcf		LCDENR,LCDEN	;�ر�LCD
	bcf		LCDENR,ENPMPL	;��pump
	bsf		Port_BackLight	;�ر���
	;---����IO��
	
	;---�������Ź��Զ�����
	bsf		WDTCON,2			;3'b100 = 1s(@WDTIN=BBH)<���Datasheet>
	bcf		WDTCON,1
	bcf		WDTCON,0	
	movlw	bbh
	movwf	WDTIN		
	bsf		WDTCON,WDTEN
	
	;---����pt2.7�����ж����ڰ�������
;	bcf		PTINT0,6
;	bsf		PTINT0,7
;	bcf		INTF,E0IF
;	bsf		INTE,E0IE
;	bsf		INTE,GIE
	
	;---����˯��
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
; оƬӲ�����Ѻ���
;============================================
; ��ڱ�����
; ���ڱ�����  
; �м������
; ��־λ��  
; ʵ�ֵĹ��ܣ�
;     
;
; ����˼·��
;        
;============================================
F_SOC_WakeUp:
	;---����IO��
	
	;---������Դģ��
	bsf			LVDCON,LVDEN		;ʹ�ܵ͵�ѹ���		
	;---����ADģ��
	
	;---����LCDģ��
	bsf		LCDENR,LCDEN	;�ر�LCD
	bsf		LCDENR,ENPMPL	;��pump
	bcf		Port_BackLight	;������
	
	;---�忴�Ź�
	clrwdt
	bcf		WDTCON,WDTEN	
	;---���ж�
	clrf	INTF
	clrf	INTF2
	clrf	INTF3
	bcf		PTINT0,6
	bsf		INTE2,UR0_RNIE
	bsf		INTE3,RTCIE
	
	return


	
;============================================
; оƬAD�Ӹ����л��ص���
;============================================
; ��ڱ�����
; ���ڱ�����  
; �м������
; ��־λ��  
; ʵ�ֵĹ��ܣ�
;     
;
; ����˼·��
;        
;============================================
F_AD_ChangeToNormalSpeed:
	bcf		ANACFG,ADEN		;�ر�ADʹ��λ
    bsf     ANACFG,7        ;LDO��
	nop
	bsf		ADCON,3			;	4'b1101 = CK_SMP/8192 = 30.5Hz<���Datasheet>
	bsf		ADCON,2
	bcf		ADCON,1
	bsf		ADCON,0
	bsf		ANACFG,ADEN		;����ADʹ��λ
	bcf		INTF,ADIF		;�ر�24bit-ADC�ж�
	bsf		INTE,ADIE
	return
;============================================
; �ر�AD
;============================================
; ��ڱ�����
; ���ڱ�����
; �м������
; ��־λ��
; ʵ�ֵĹ��ܣ�
;
;
; ����˼·��
;
;============================================
F_AD_Close:
    bcf     ANACFG,7        ;LDO�ر�
    bcf     ANACFG,ADEN     ;�ر�ADʹ��λ
    bcf     INTF,ADIF       ;�ر�24bit-ADC�ж�
    return
    
    



	
	



