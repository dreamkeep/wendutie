;----------------------------
;@file:mx88 mtp.asm
;@brief:
;����e2p����ֻ��
;2000H
;...
;207FH
;----------------------------



;��ʼ��ַ
f_e2p_set_start_address:
	movlf 20h, EADRH
	movlf 00h, EADRL
	return

;write 1 byte 
f_e2p_write_byte:
	bcf			inte,gie          ;1.��gie------------------------------
	bsf			wdtcon,wdten      ;2.��wdt

	clrwdt						   ;4.��eopen����ǰclrwdt
	movlw		0x96               ;5.eopen д96 69 5A
	movwf		eopen
	movlw		0x69
	movwf		eopen
	movlw		0x5A
	movwf		eopen
	
	movfw		r_e2p_data         ;6.����¼����дwork
	tblp		100
	
	bcf			wdtcon,wdten		;7.��wdt
	bsf			inte,gie			;8.��gie
	return
	
;read 1 byte 
f_e2p_read_byte:
	movp					  ;������work	
	return
	
;����work 
f_e2p_get_cal_xor:
	movfw 	r_ad_cal_l
	xorwf 	r_ad_cal_m,0
	xorwf 	r_ad_cal_h,0
	return	
;==========================================;
; ��    ��: д���ֽ����ݡ����ֽڴ��ַ
; ��	��: 
; ��	��: work
; �м����: ע�⣺ʹ��ǰ��������	
;==========================================;
f_e2p_write_data_to_rom:
	call 	f_e2p_set_start_address ;2000h ��ʼ

	movfw 	r_ad_cal_l
	movwf   r_e2p_data
	
	call 	f_e2p_write_byte

	;++	EADRL��������ַ
	incf 	EADRL, f
	movfw 	r_ad_cal_m
	movwf   r_e2p_data
	call 	f_e2p_write_byte

	;++	EADRL��������ַ
	incf 	EADRL, f
	movfw 	r_ad_cal_h
	movwf   r_e2p_data
	call 	f_e2p_write_byte

	;++	EADRL��������ַ
	incf 	EADRL, f
	call    f_e2p_get_cal_xor
	movwf   r_e2p_data
	call 	f_e2p_write_byte	
	;===========================;
	call    f_e2p_read_data_from_rom;д��֮�󣬶�һ��
	;===========================;
	return
	
	
	
;==========================================;
; ��    ��: �����ֽ����ݡ����ֽڴ��ַ
; ��	��: 
; ��	��: 
; �м����: ע�⣺ʹ��ǰ��������	
;==========================================;	
f_e2p_read_data_from_rom:
	call  	f_e2p_set_start_address

	call	f_e2p_read_byte
	movwf	r_ad_cal_l

	incf	EADRL,1
	call 	f_e2p_read_byte
	movwf	r_ad_cal_m

	incf	EADRL,1
	call 	f_e2p_read_byte
	movwf	r_ad_cal_h

	incf	EADRL,1
	call 	f_e2p_read_byte
	movwf	r_e2p_cal_xor
	;-----------------------
	;�����У��
	;-----------------------
	call 	f_e2p_get_cal_xor
	xorwf 	r_e2p_cal_xor, w
	btfsc 	status, z
	return	
	;---------------------------------;
	;-ʧ�ܴ���
	;?????????????????????????????????;
	nop
	;?????????????????????????????????;
	return
	