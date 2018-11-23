;============================================
;                  声明
; 该程序仅供参考若程序中存在疏漏， 
; 芯海科技有限公司对此不承担任何责任。
; (C)Shenzhen Chipsea Technologies Co.,Ltd
;============================================
; filename: CS_HW_LCD.asm
; chip    : CSU18M88
; author  : CS0155
; date    : 2017-07-27
; v1.0
;============================================
; 变量地址分配
;============================================		
;全局变量
;R_DSP_BUFFER1
;R_DSP_BUFFER2
;R_DSP_BUFFER3
;R_DSP_BUFFER4
;R_DSP_BUFFER5
;R_DSP_BUFFER6
;R_DSP_BUFFER7
;R_DSP_BUFFER8
;R_DSP_BUFFER9
;R_DSP_BUFFER10
;R_DSP_BUFFER11
;---临时变量
R_LCD_Map_S			 equ  R_SYS_ABC_S
R_LCD_2_1			 equ  R_LCD_Map_S+0		;映射过程缓存
R_LCD_4_3			 equ  R_LCD_Map_S+1			
R_LCD_6_5			 equ  R_LCD_Map_S+2
R_LCD_8_7			 equ  R_LCD_Map_S+3
R_LCD_10_9			 equ  R_LCD_Map_S+4
R_LCD_12_11			 equ  R_LCD_Map_S+5
R_LCD_14_13			 equ  R_LCD_Map_S+6
R_LCD_16_15			 equ  R_LCD_Map_S+7
R_LCD_18_17			 equ  R_LCD_Map_S+8
R_LCD_20_19			 equ  R_LCD_Map_S+9

;============================================
; 常量定义
;============================================
;======================================
;	显示的buffer位定义（一般不修改）
;======================================
DISP_BUF_BIT0	EQU		00000001B
DISP_BUF_BIT1	EQU		00000010B
DISP_BUF_BIT2	EQU		00000100B
DISP_BUF_BIT3	EQU		00001000B
DISP_BUF_BIT4	EQU		00010000B
DISP_BUF_BIT5	EQU		00100000B
DISP_BUF_BIT6	EQU		01000000B
DISP_BUF_BIT7	EQU		10000000B


;======================================
;	数码管的A~G段和显示缓存的位对应关系
;======================================
;  __	   A		4			
; |  |	 F	 B 	  0	  5 	
;  __	   G		1		
; |  |	 E	 C	  2   6		
;  __  	   D		3		
;======================================
S_A		  EQU		DISP_BUF_BIT4	
S_B		  EQU		DISP_BUF_BIT5
S_C		  EQU		DISP_BUF_BIT6	
S_D		  EQU		DISP_BUF_BIT3
S_E		  EQU		DISP_BUF_BIT2		
S_F		  EQU		DISP_BUF_BIT0
S_G		  EQU		DISP_BUF_BIT1	

;======================================
;	数码管的A~G段和显示缓存的位对应关系
;======================================
;  __	   A		7			
; |  |	 F	 B 	  6	  3 	
;  __	   G		2		
; |  |	 E	 C	  5   1		
;  __  	   D		4		
;======================================
S1_A		EQU		DISP_BUF_BIT4	
S1_B		EQU		DISP_BUF_BIT5
S1_C		EQU		DISP_BUF_BIT6	
S1_D		EQU		DISP_BUF_BIT3
S1_E		EQU		DISP_BUF_BIT2		
S1_F		EQU		DISP_BUF_BIT0
S1_G		EQU		DISP_BUF_BIT1

;======================================
;	数字符号编码表
;======================================
;  __		A			
; |  | 	  F	  B 	
;  __		G		
; |  |    E   C		
;  __  		D
;======================================
Lcdch0    EQU   S_A+S_B+S_C+S_D+S_E+S_F
Lcdch1    EQU   S_B+S_C
Lcdch2    EQU   S_A+S_B+S_D+S_E+S_G
Lcdch3    EQU   S_A+S_B+S_C+S_D+S_G
Lcdch4    EQU   S_B+S_C+S_F+S_G
Lcdch5    EQU   S_A+S_C+S_D+S_F+S_G
Lcdch6    EQU   S_A+S_C+S_D+S_E+S_F+S_G
Lcdch7    EQU   S_A+S_B+S_C
Lcdch8    EQU   S_A+S_B+S_C+S_D+S_E+S_F+S_G
Lcdch9    EQU   S_A+S_B+S_C+S_D+S_F+S_G

LcdchA    EQU   S_A+S_B+S_C+S_E+S_F+S_G
Lcdchb    EQU   S_C+S_D+S_E+S_F+S_G
LcdchC    EQU   S_A+S_D+S_E+S_F
Lcdchd    EQU   S_B+S_C+S_D+S_E+S_G
LcdchE    EQU   S_A+S_D+S_E+S_F+S_G
LcdchF    EQU   S_A+S_E+S_F+S_G
Lcdnull   EQU   0   

LcdchL    EQU   S_D+S_E+S_F
Lcdcho    EQU   S_C+S_D+S_E+S_G
LcdchP    EQU   S_A+S_B+S_E+S_F+S_G
Lcdchn    EQU   S_C+S_E+S_G
Lcdchr    EQU   S_E+S_G

;======================================
;	数字符号编码表2
;======================================
;  __		A			
; |  | 	  F	  B 	
;  __		G		
; |  |    E   C		
;  __  		D
;======================================
Lcd1ch0    EQU   S1_A+S1_B+S1_C+S1_D+S1_E+S1_F
Lcd1ch1    EQU   S1_B+S1_C
Lcd1ch2    EQU   S1_A+S1_B+S1_D+S1_E+S1_G
Lcd1ch3    EQU   S1_A+S1_B+S1_C+S1_D+S1_G
Lcd1ch4    EQU   S1_B+S1_C+S1_F+S1_G
Lcd1ch5    EQU   S1_A+S1_C+S1_D+S1_F+S1_G
Lcd1ch6    EQU   S1_A+S1_C+S1_D+S1_E+S1_F+S1_G
Lcd1ch7    EQU   S1_A+S1_B+S1_C
Lcd1ch8    EQU   S1_A+S1_B+S1_C+S1_D+S1_E+S1_F+S1_G
Lcd1ch9    EQU   S1_A+S1_B+S1_C+S1_D+S1_F+S1_G

Lcd1chA    EQU   S1_A+S1_B+S1_C+S1_E+S1_F+S1_G
Lcd1chb    EQU   S1_C+S1_D+S1_E+S1_F+S1_G
Lcd1chC    EQU   S1_A+S1_D+S1_E+S1_F
Lcd1chd    EQU   S1_B+S1_C+S1_D+S1_E+S1_G
Lcd1chE    EQU   S1_A+S1_D+S1_E+S1_F+S1_G
Lcd1chF    EQU   S1_A+S1_E+S1_F+S1_G
Lcd1null   EQU   0 

Lcd1chL    EQU   S1_D+S1_E+S1_F
Lcd1cho    EQU   S1_C+S1_D+S1_E+S1_G
Lcd1chP    EQU   S1_A+S1_B+S1_E+S1_F+S1_G
Lcd1chn    EQU   S1_C+S1_E+S1_G
Lcd1chr    EQU   S1_E+S1_G

;======================================
;	编号
;======================================
C_Ch_A	   EQU	 10
C_Ch_b	   EQU	 11
C_Ch_C     EQU	 12
C_Ch_d     EQU	 13
C_Ch_E     EQU	 14
C_Ch_F     EQU	 15
C_Ch_null  EQU	 16
C_Ch_L     EQU	 17
C_Ch_o     EQU	 18
C_Ch_P     EQU	 19
C_Ch_n     EQU	 20
C_Ch_r     EQU	 21

;======================================
;DSP1~7段定义
;  __	   A					
; |  |	 F	 B 	  	  	
;  __	   G				
; |  |	 E	 C	    	
;  __  	   D			

;显示画面（YUNMAI-LCD画面）
;		P1~P10
;FAT  BAT
;BLE	 DSP5 DSP6 DotS DSP7 %
;DSP1 DSP2 DSP3 DotB DSP4
;lb   斤   kg

;逻辑表
;COM	SEG1 SEG3 SEG5  SEG7  SEG9  SEG11  SEG13  SEG15  SEG17  SEG19
;		SEG2 SEG4 SEG6  SEG8  SEG10 SEG12  SEG14  SEG16  SEG18  SEG20
;0		ble	 P3   DotB  P4    P5    P8     P1     DotS   % 
;1		P9	 4B   3B    2B    1B    P7     5C	  6C     7C
;2		P10	 4G   3G    2G    1G    P6     5G     6G     7G
;3		bat  4C   3C    2C    1C    FAT    5B     6B     7B

;4		P2	 4A   3A	2A	  1A    5D     6D     7D
;5		kg   4F   3F	2F    1F    5E     6E     7E
;6		斤   4E   3E	2E    1E    5F     6F     7F
;7		lb   4D	  3D	2D    1D    5A     6A     7A 
;TEMP   2_1	 4_3  6_5   8_7   10_9  12_11  14_13  16_15  18_17

;R_LCD_2_1的bit0~3 LCD1的bit0~3
;R_LCD_2_1的bit4~7 LCD2的bit0~3
;......
;R_LCD_20_19的bit0~3 LCD19的bit0~3
;R_LCD_20_19的bit4~7 LCD20的bit0~3
;======================================
;显示数字编码和LCD寄存器对应表
;======================================
;R_DSP_BUF1_To_LCD		equ		R_LCD_10_9	;buffer1的数据对应LCD寄存器的位置
;R_DSP_BUF2_To_LCD		equ		R_LCD_8_7	;......
;R_DSP_BUF3_To_LCD		equ		R_LCD_6_5
;R_DSP_BUF4_To_LCD		equ		R_LCD_4_3
;
;R_DSP_BUF5_To_LCD_H4	equ		R_LCD_12_11		
;R_DSP_BUF5_To_LCD_L4	equ		R_LCD_14_13	
;
;R_DSP_BUF6_To_LCD_H4	equ		R_LCD_14_13		
;R_DSP_BUF6_To_LCD_L4	equ		R_LCD_16_15
;
;R_DSP_BUF7_To_LCD_H4	equ		R_LCD_16_15		
;R_DSP_BUF7_To_LCD_L4	equ		R_LCD_18_17

;======================================
;显示符号和LCD寄存器对应表
;======================================
DEFINE	L_P1	"R_LCD_14_13,0"
DEFINE	L_P2	"R_LCD_2_1,4"
DEFINE	L_P3	"R_LCD_4_3,0"
DEFINE	L_P4	"R_LCD_8_7,0"
DEFINE	L_P5	"R_LCD_10_9,0"
DEFINE	L_P6	"R_LCD_12_11,2"
DEFINE	L_P7	"R_LCD_12_11,1"
DEFINE	L_P8	"R_LCD_12_11,0"

DEFINE	L_P9	"R_LCD_2_1,1"
DEFINE	L_P10	"R_LCD_2_1,2"
DEFINE	L_BLE	"R_LCD_2_1,0"
DEFINE	L_BAT	"R_LCD_2_1,3"
DEFINE	L_KG	"R_LCD_2_1,5"
DEFINE	L_JIN	"R_LCD_2_1,6"
DEFINE	L_LB	"R_LCD_2_1,7"
DEFINE	L_DOTB	"R_LCD_6_5,4"

DEFINE	L_FAT	"R_LCD_12_11,3"
DEFINE	L_DOTS	"R_LCD_16_15,0"
DEFINE	L_PEC	"R_LCD_18_17,0"
DEFINE	L_NONE	"WORK,0"


;======================================
;根据LCD的BUFFER定义填写对应值
;======================================
;R_LED_BUFFER8--------------------------
DEFINE	R_DSP_BUFFER8_BIT0	"L_P1"
DEFINE	R_DSP_BUFFER8_BIT1	"L_P2"
DEFINE	R_DSP_BUFFER8_BIT2	"L_P3"
DEFINE	R_DSP_BUFFER8_BIT3	"L_P4"
DEFINE	R_DSP_BUFFER8_BIT4	"L_P5"
DEFINE	R_DSP_BUFFER8_BIT5	"L_P6"
DEFINE	R_DSP_BUFFER8_BIT6	"L_P7"
DEFINE	R_DSP_BUFFER8_BIT7	"L_P8"
;R_LED_BUFFER9--------------------------
DEFINE	R_DSP_BUFFER9_BIT0	"L_P9"
DEFINE	R_DSP_BUFFER9_BIT1	"L_P10"
DEFINE	R_DSP_BUFFER9_BIT2	"L_BLE"
DEFINE	R_DSP_BUFFER9_BIT3	"L_BAT"
DEFINE	R_DSP_BUFFER9_BIT4	"L_KG"
DEFINE	R_DSP_BUFFER9_BIT5	"L_JIN"
DEFINE	R_DSP_BUFFER9_BIT6	"L_LB"
DEFINE	R_DSP_BUFFER9_BIT7	"L_DOTB"
;R_LED_BUFFER10--------------------------
DEFINE	R_DSP_BUFFER10_BIT0	"L_FAT"
DEFINE	R_DSP_BUFFER10_BIT1	"L_DOTS"
DEFINE	R_DSP_BUFFER10_BIT2	"L_PEC"
DEFINE	R_DSP_BUFFER10_BIT3	"L_NONE"
DEFINE	R_DSP_BUFFER10_BIT4	"L_NONE"
DEFINE	R_DSP_BUFFER10_BIT5	"L_NONE"
DEFINE	R_DSP_BUFFER10_BIT6	"L_NONE"
DEFINE	R_DSP_BUFFER10_BIT7	"L_NONE"
;R_LED_BUFFER11--------------------------
DEFINE	R_DSP_BUFFER11_BIT0	"L_NONE"
DEFINE	R_DSP_BUFFER11_BIT1	"L_NONE"
DEFINE	R_DSP_BUFFER11_BIT2	"L_NONE"
DEFINE	R_DSP_BUFFER11_BIT3	"L_NONE"
DEFINE	R_DSP_BUFFER11_BIT4	"L_NONE"
DEFINE	R_DSP_BUFFER11_BIT5	"L_NONE"
DEFINE	R_DSP_BUFFER11_BIT6	"L_NONE"
DEFINE	R_DSP_BUFFER11_BIT7	"L_NONE"




;============================================
; 查表函数
;============================================
F_Dsp_Table:
		addpcw	       
		retlw	Lcdch0	;0	(work=0)
		retlw	Lcdch1	;1	(work=1)
		retlw	Lcdch2	;2	(work=2)
		retlw	Lcdch3	;3	(work=3)
		retlw	Lcdch4	;4	(work=4)
		retlw	Lcdch5	;5	(work=5)
		retlw	Lcdch6	;6	(work=6)
		retlw	Lcdch7	;7	(work=7)
		retlw	Lcdch8	;8	(work=8)
		retlw	Lcdch9	;9	(work=9)
		retlw	LcdchA	;A	(work=a)
		retlw	Lcdchb	;b	(work=b)
		retlw	LcdchC	;C	(work=c)
		retlw	Lcdchd	;d	(work=d)
		retlw	LcdchE	;E	(work=e)
		retlw	LcdchF	;F	(work=f)	
		retlw	Lcdnull ;   (work=16)
		retlw	LcdchL	;L  (work=17)
		retlw	Lcdcho	;o  (work=18)
		retlw	LcdchP	;P  (work=19)
		retlw	Lcdchn	;n  (work=20)
		retlw	Lcdchr	;r  (work=21)

		
;============================================
; 查表函数
;============================================
F_Dsp_Table1:
		addpcw	       
		retlw	Lcd1ch0	;0	(work=0)
		retlw	Lcd1ch1	;1	(work=1)
		retlw	Lcd1ch2	;2	(work=2)
		retlw	Lcd1ch3	;3	(work=3)
		retlw	Lcd1ch4	;4	(work=4)
		retlw	Lcd1ch5	;5	(work=5)
		retlw	Lcd1ch6	;6	(work=6)
		retlw	Lcd1ch7	;7	(work=7)
		retlw	Lcd1ch8	;8	(work=8)
		retlw	Lcd1ch9	;9	(work=9)
		retlw	Lcd1chA	;A	(work=a)
		retlw	Lcd1chb	;b	(work=b)
		retlw	Lcd1chC	;C	(work=c)
		retlw	Lcd1chd	;d	(work=d)
		retlw	Lcd1chE	;E	(work=e)
		retlw	Lcd1chF	;F	(work=f)
		retlw	Lcd1null;   (work=16)
		retlw	Lcd1chL	;L  (work=17)
		retlw	Lcd1cho	;o  (work=18)
		retlw	Lcd1chP	;P  (work=19)
		retlw	Lcd1chn	;n  (work=20)
		retlw	Lcd1chr	;r  (work=21)

;============================================
; LCD显示函数
;============================================
; 入口变量：
; 出口变量：  
; 中间变量：
; 标志位：  
; 实现的功能：
;     
; 程序思路：
;   NOP    
;============================================
F_LCD_Proc:	
		;btfss	R_Flag_Sys,B_LCD_En	
		goto	L_LCD_Proc_Exit
		call	F_LCD_MAPPING_CLR
		call	F_LCD_MAPPING
		call	F_LCD_MAPPING_ASSIGNMENT 
L_LCD_Proc_Exit:
		RETURN

;============================================
; 清中间缓存变量函数
;============================================
; 入口变量：
; 出口变量：  
; 中间变量：
; 标志位：  
; 实现的功能：
;     
; 程序思路：
;   NOP    
;============================================
F_LCD_MAPPING_CLR:
		clrf	R_LCD_2_1
		clrf	R_LCD_4_3
		clrf	R_LCD_6_5
		clrf	R_LCD_8_7
		clrf	R_LCD_10_9
		clrf	R_LCD_12_11
		clrf	R_LCD_14_13	
		clrf	R_LCD_16_15
		clrf	R_LCD_18_17
		clrf	R_LCD_20_19	
		RETURN

;============================================
; 显示缓存转换函数
;============================================
; 入口变量：
; 出口变量：  
; 中间变量：
; 标志位：  
; 实现的功能：
;     
; 程序思路：
;   NOP    
;============================================
;通用版本	
F_LCD_MAPPING:
		;---数字部分转换
		;---buffer1-4转换
		movfw	R_DSP_BUFFER1
		call	F_Dsp_Table
		movwf	R_LCD_2_1
		
		movfw	R_DSP_BUFFER2
		call	F_Dsp_Table
		movwf	R_LCD_4_3
		
		movfw	R_DSP_BUFFER3
		call	F_Dsp_Table
		movwf	R_LCD_6_5
		
		movfw	R_DSP_BUFFER4
		call	F_Dsp_Table
		movwf	R_LCD_8_7

		;---buffer5转换
		movfw	R_DSP_BUFFER5
		call	F_Dsp_Table
		movwf	R_LCD_10_9
		;---buffer6转换
		movfw	R_DSP_BUFFER6
		call	F_Dsp_Table
		movwf	R_LCD_12_11
		;---buffer7转换
		movfw	R_DSP_BUFFER7
		call	F_Dsp_Table
		movwf	R_LCD_14_13
		
		;---符号部分映射转换1
		btfsc	R_DSP_BUFFER8,0
		bsf		R_DSP_BUFFER8_BIT0
		btfsc	R_DSP_BUFFER8,1
		bsf		R_DSP_BUFFER8_BIT1
		btfsc	R_DSP_BUFFER8,2
		bsf		R_DSP_BUFFER8_BIT2
		btfsc	R_DSP_BUFFER8,3
		bsf		R_DSP_BUFFER8_BIT3
		btfsc	R_DSP_BUFFER8,4
		bsf		R_DSP_BUFFER8_BIT4
		btfsc	R_DSP_BUFFER8,5
		bsf		R_DSP_BUFFER8_BIT5
		btfsc	R_DSP_BUFFER8,6
		bsf		R_DSP_BUFFER8_BIT6	
		btfsc	R_DSP_BUFFER8,7
		bsf		R_DSP_BUFFER8_BIT7
		;---符号部分映射转换2
		btfsc	R_DSP_BUFFER9,0
		bsf		R_DSP_BUFFER9_BIT0
		btfsc	R_DSP_BUFFER9,1
		bsf		R_DSP_BUFFER9_BIT1
		btfsc	R_DSP_BUFFER9,2
		bsf		R_DSP_BUFFER9_BIT2
		btfsc	R_DSP_BUFFER9,3
		bsf		R_DSP_BUFFER9_BIT3
		btfsc	R_DSP_BUFFER9,4
		bsf		R_DSP_BUFFER9_BIT4
		btfsc	R_DSP_BUFFER9,5
		bsf		R_DSP_BUFFER9_BIT5
		btfsc	R_DSP_BUFFER9,6
		bsf		R_DSP_BUFFER9_BIT6	
		btfsc	R_DSP_BUFFER9,7
		bsf		R_DSP_BUFFER9_BIT7
		;---符号部分映射转换3
		btfsc	R_DSP_BUFFER10,0
		bsf		R_DSP_BUFFER10_BIT0
		btfsc	R_DSP_BUFFER10,1
		bsf		R_DSP_BUFFER10_BIT1
		btfsc	R_DSP_BUFFER10,2
		bsf		R_DSP_BUFFER10_BIT2
		btfsc	R_DSP_BUFFER10,3
		bsf		R_DSP_BUFFER10_BIT3
		btfsc	R_DSP_BUFFER10,4
		bsf		R_DSP_BUFFER10_BIT4
		btfsc	R_DSP_BUFFER10,5
		bsf		R_DSP_BUFFER10_BIT5
		btfsc	R_DSP_BUFFER10,6
		bsf		R_DSP_BUFFER10_BIT6	
		btfsc	R_DSP_BUFFER10,7
		bsf		R_DSP_BUFFER10_BIT7
		;---符号部分映射转换4
		btfsc	R_DSP_BUFFER11,0
		bsf		R_DSP_BUFFER11_BIT0
		btfsc	R_DSP_BUFFER11,1
		bsf		R_DSP_BUFFER11_BIT1
		btfsc	R_DSP_BUFFER11,2
		bsf		R_DSP_BUFFER11_BIT2
		btfsc	R_DSP_BUFFER11,3
		bsf		R_DSP_BUFFER11_BIT3
		btfsc	R_DSP_BUFFER11,4
		bsf		R_DSP_BUFFER11_BIT4
		btfsc	R_DSP_BUFFER11,5
		bsf		R_DSP_BUFFER11_BIT5
		btfsc	R_DSP_BUFFER11,6
		bsf		R_DSP_BUFFER11_BIT6	
		btfsc	R_DSP_BUFFER11,7
		bsf		R_DSP_BUFFER11_BIT7
		
		return

;============================================
; LCD寄存器赋值函数
;============================================
; 入口变量：
; 出口变量：  
; 中间变量：
; 标志位：  
; 实现的功能：
;     
; 程序思路：
;   NOP    
;============================================
F_LCD_MAPPING_ASSIGNMENT:
		movfw	R_LCD_2_1
		movwf	LCD1
		swapf	R_LCD_2_1,w
		movwf	LCD2		
		movfw	R_LCD_4_3
		movwf	LCD3
		swapf	R_LCD_4_3,w
		movwf	LCD4
		
		movfw	R_LCD_6_5
		movwf	LCD5
		swapf	R_LCD_6_5,w
		movwf	LCD6		
		movfw	R_LCD_8_7
		movwf	LCD7
		swapf	R_LCD_8_7,w
		movwf	LCD8
		
		movfw	R_LCD_10_9
		movwf	LCD9
		swapf	R_LCD_10_9,w
		movwf	LCD10
		movfw	R_LCD_12_11
		movwf	LCD11
		swapf	R_LCD_12_11,w
		movwf	LCD12
		
		movfw	R_LCD_14_13
		movwf	LCD13
		swapf	R_LCD_14_13,w
		movwf	LCD14	
		movfw	R_LCD_16_15
		movwf	LCD15
		swapf	R_LCD_16_15,w
		movwf	LCD16
		
		movfw	R_LCD_18_17
		movwf	LCD17
		swapf	R_LCD_18_17,w
		movwf	LCD18	
		movfw	R_LCD_20_19
		movwf	LCD19
		swapf	R_LCD_20_19,w
		movwf	LCD20
		RETURN


		



