;----------------------------
;@file:mx88 mtp.asm
;@brief:
;以下e2p操作只对
;2000H
;...
;207FH
;----------------------------



;开始地址
f_e2p_set_start_address:
	movlf 20h, EADRH
	movlf 00h, EADRL
	return

;write 1 byte 
f_e2p_write_byte:
	bcf			inte,gie          ;1.关gie------------------------------
	bsf			wdtcon,wdten      ;2.开wdt

	clrwdt						   ;4.对eopen操作前clrwdt
	movlw		0x96               ;5.eopen 写96 69 5A
	movwf		eopen
	movlw		0x69
	movwf		eopen
	movlw		0x5A
	movwf		eopen
	
	movfw		r_e2p_data         ;6.待烧录数据写work
	tblp		100
	
	bcf			wdtcon,wdten		;7.关wdt
	bsf			inte,gie			;8.开gie
	return
	
;read 1 byte 
f_e2p_read_byte:
	movp					  ;读出到work	
	return
	
;返回work 
f_e2p_get_cal_xor:
	movfw 	r_ad_cal_l
	xorwf 	r_ad_cal_m,0
	xorwf 	r_ad_cal_h,0
	return	
;==========================================;
; 功    能: 写三字节数据。高字节存地址
; 入	口: 
; 出	口: work
; 中间变量: 注意：使用前需先配置	
;==========================================;
f_e2p_write_data_to_rom:
	call 	f_e2p_set_start_address ;2000h 开始

	movfw 	r_ad_cal_l
	movwf   r_e2p_data
	
	call 	f_e2p_write_byte

	;++	EADRL，修正地址
	incf 	EADRL, f
	movfw 	r_ad_cal_m
	movwf   r_e2p_data
	call 	f_e2p_write_byte

	;++	EADRL，修正地址
	incf 	EADRL, f
	movfw 	r_ad_cal_h
	movwf   r_e2p_data
	call 	f_e2p_write_byte

	;++	EADRL，修正地址
	incf 	EADRL, f
	call    f_e2p_get_cal_xor
	movwf   r_e2p_data
	call 	f_e2p_write_byte	
	;===========================;
	call    f_e2p_read_data_from_rom;写完之后，读一下
	;===========================;
	return
	
	
	
;==========================================;
; 功    能: 读三字节数据。高字节存地址
; 入	口: 
; 出	口: 
; 中间变量: 注意：使用前需先配置	
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
	;读完后校验
	;-----------------------
	call 	f_e2p_get_cal_xor
	xorwf 	r_e2p_cal_xor, w
	btfsc 	status, z
	return	
	;---------------------------------;
	;-失败处理
	;?????????????????????????????????;
	nop
	;?????????????????????????????????;
	return
	