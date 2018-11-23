;--------------------------------------------
;                  声明 
; 该程序仅供参考和用于芯片正常工作环境下对其
; 进行简单的功能测试。若程序中存在疏漏，芯海
; 科技(深圳)股份有限公司对此不承担任何责任。
;   (C)Shenzhen Chipsea Technologies Co.,Ltd
;--------------------------------------------
; filename: CS_APP_BLE.asm
; author  : 
; date    : 2017-7-20
; function:
;--------------------------------------------
/*--------------------------------------------
;宏定义
----------------------------------------------*/
DEFINE  BLEWAKEUPPIN        "PT2,0"
DEFINE  BLEWAKEUPPINEN      "PT2EN,0"
DEFINE  BLEWAKEUPPINPU      "PT2PU,0"
DEFINE  BLESTATUSPIN        "PT2,5"
DEFINE  BLESTATUSPINEN      "PT2EN,5"
DEFINE  BLESTATUSPINPU      "PT2PU,5"
DEFINE  UARTFLAGCHECK       "INTF2,UR1_RNIF"
BLESTATUS_REST              EQU     00H       ;复位
BLESTATUS_BOOT              EQU     01H       ;BOOTLODER
BLESTATUS_STANDY            EQU     02H       ;待机
BLESTATUS_ADV               EQU     03H       ;广播
BLESTATUS_CONNECT           EQU     04H       ;连接
BLESTATUS_SLEEP             EQU     05H       ;睡眠
SETADVCMD                   EQU     24h
SENDAPPDATACMD              EQU     30h
R_BLE_SEG_S                 EQU     R_ALC_BLE_S
/*--------------------------------------------
;变量定义
----------------------------------------------*/
;全局变量
R_APP_WeightL               EQU     R_BLE_SEG_S+0   ;重量
R_APP_WeightH               EQU     R_BLE_SEG_S+1
R_APP_RegierL               EQU     R_BLE_SEG_S+2   ;电阻
R_APP_RegierH               EQU     R_BLE_SEG_S+3
R_APP_YearH                 EQU     R_BLE_SEG_S+4   ;年
R_APP_YearL                 EQU     R_BLE_SEG_S+5
R_APP_Month                 EQU     R_BLE_SEG_S+6   ;月
R_APP_Day                   EQU     R_BLE_SEG_S+7   ;日
R_APP_Hour                  EQU     R_BLE_SEG_S+8   ;时
R_APP_Min                   EQU     R_BLE_SEG_S+9   ;分
R_APP_Sec                   EQU     R_BLE_SEG_S+10  ;秒
R_APP_McuStatus             EQU     R_BLE_SEG_S+11  ;MCU状态
                                                    ;bit0   : 处于零位标志
                                                    ;bit1   : 超载标志
                                                    ;bit2   : 提示进入待机标志
                                                    ;bit3   : 提示唤醒标志
                                                    ;bit4   : 提示下秤
                                                    ;bit5   : 重量锁定
R_APP_McuFuntion            EQU     R_BLE_SEG_S+12  ;MCU功能
                                                    ;Bit4-3 单位选择
                                                    ;00 - KG(默认)
                                                    ;01 - 斤
                                                    ;10 - LB
                                                    ;11 - ST:LB
                                                    ;Bit2-1 小数位数选择
                                                    ;00 - 2 位小数(默认)
                                                    ;01 - 0 位小数
                                                    ;10 - 1 位小数
;局部变量
R_SendTime                  EQU     R_BLE_SEG_S+13  ;发送次数
R_CodeLengthH               EQU     R_BLE_SEG_S+14  ;bin文件总字节数高字节
R_CodeLengthL               EQU     R_BLE_SEG_S+15  ;bin文件总字节数低字节
R_CodeCnt                   EQU     R_BLE_SEG_S+16  ;每包数据字节数
R_BleStatus                 EQU     R_BLE_SEG_S+17  ;蓝牙状态标志位
R_Ble_A0                    EQU     R_BLE_SEG_S+18  ;
R_Ble_A1                    EQU     R_BLE_SEG_S+19  ;
R_Ble_A2                    EQU     R_BLE_SEG_S+20
R_Delay_Num					EQU     R_BLE_SEG_S+21  ;
;----------------------------------------------------------------------------
R_PathBufLength				EQU		R_CodeCnt		    ;每个包数据长度
R_BleCodeStartAddH			EQU		R_BLE_SEG_S+22		;blecode存储起始地址高字节
R_BleCodeStartAddL			EQU		R_BLE_SEG_S+23		
R_BleCodeEndAddH			EQU		R_BLE_SEG_S+24		;blecode存储结束地址高字节
R_BleCodeEndAddL			EQU		R_BLE_SEG_S+25
R_Temp_Cnt					EQU		R_BLE_SEG_S+26
R_Checksum					EQU		R_BLE_SEG_S+27
R_BLE_Flag					EQU		R_BLE_SEG_S+28
R_DelayR1					EQU		R_BLE_SEG_S+29
R_FlashSave					EQU     R_BLE_SEG_S+30

/*---------------------------------------------
;program  body
-----------------------------------------------*/
;include     CS_HW_SPI.ASM
include     CS_HW_UART.ASM
include     CS_HW_BLE_Bootloader.ASM
include     CS_HW_BLE_Protocol.ASM
    
/*-------------------------------------------
; Name    : F_McuToBle_Proc
; Function: 
; Input   : 
; Output  :
; Temp    :  
; Other   :
; log     :
--------------------------------------------*/    
F_Ble_Proc:
;MCU  Send  data  to  ble
;		   movff  R_BS_Scale_Flag,R_APP_McuStatus          	
;		   btfss  R_BS_Scale_Flag,B_BS_Lock
;		   goto   L_McuToBle_Proc		   
;L_McuToBle_1256:	   
;;	       incf   R_Temp_Cnt,1
;;	       movlw  70
;;	       subwf  R_Temp_Cnt,0
;;	       btfss  status,c
;;	       bcf    R_APP_McuStatus,B_BS_Lock
;	       goto   L_McuToBle_Proc1       
;L_McuToBle_Proc:	   
;	       clrf   R_Temp_Cnt
;	   
;           movff  RTCYEAR,R_SYS_A0
;           movlf  20h,R_SYS_A1
;           clrf   R_SYS_A2
;		   call	  F_BCD2Hex
;		   movff  R_SYS_C0,R_APP_YearL
;		   movff  R_SYS_C1,R_APP_YearH
;		   
;		   
;		   movff  RTCMON,R_SYS_A0
;		   clrf   R_SYS_A1
;		   clrf   R_SYS_A2
;		   call   F_BCD2Hex
;		   movff  R_SYS_C0,R_APP_Month 
;		   
;
;		   movff  RTCDAY,R_SYS_A0
;		   clrf   R_SYS_A1
;		   clrf   R_SYS_A2
;		   call   F_BCD2Hex
;		   movff  R_SYS_C0,R_APP_Day 		   
;  	   
;		   movff  RTCHOUR,R_SYS_A0
;		   clrf   R_SYS_A1
;		   clrf   R_SYS_A2
;		   call   F_BCD2Hex
;		   movff  R_SYS_C0,R_APP_Hour 
;		   
;		   movff  RTCMIN,R_SYS_A0
;		   clrf   R_SYS_A1
;		   clrf   R_SYS_A2
;		   call   F_BCD2Hex
;		   movff  R_SYS_C0,R_APP_Min
;		   
;		   
;		   movff  RTCSEC,R_SYS_A0
;		   clrf   R_SYS_A1
;		   clrf   R_SYS_A2
;		   call   F_BCD2Hex
;		   movff  R_SYS_C0,R_APP_Sec				
;L_McuToBle_Proc1:
;	       btfss  R_BS_Scale_Unit,B_BS_ST
;	       goto	  L_McuToBle_Proc1_0
;	       movff  R_WeightH,R_APP_WeightH
;           movff  R_WeightL,R_APP_WeightL
;	       goto	  L_McuToBle_Proc1_1           
;           
;L_McuToBle_Proc1_0:	       
;		   clrf	  R_Math_A5	
;		   clrf	  R_Math_A4
;           clrf   R_Math_A3
;           clrf   R_Math_A2
;           movff  R_WeightH,R_Math_A1
;           movff  R_WeightL,R_Math_A0
;           clrf   R_Math_B2
;           clrf   R_Math_B1
;           movlf  10,R_Math_B0
;	       call	  F_Div24U
;           movff  R_Math_C0,R_APP_WeightL
;           movff  R_Math_C1,R_APP_WeightH
;           
;L_McuToBle_Proc1_1: 
;           clrf   R_Math_A2
;           movff  R_Body_Res_H,R_Math_A1
;           movff  R_Body_Res_L,R_Math_A0
;           clrf   R_Math_B2
;           clrf   R_Math_B1
;           movlf  10,R_Math_B0
;           call   F_Mul24U
;           movff  R_Math_C0,R_APP_RegierL      
;           movff  R_Math_C1,R_APP_RegierH
;
;	
;;R_BS_Scale_Unit			
;;	B_BS_KG				equ		0						;单位 KG
;;	B_BS_JIN			equ		1						;单位 JIN
;;	B_BS_LB				equ		2						;单位 LB
;;	B_BS_ST				equ		3						;单位 ST
;L_McuToBle_Uint:                                        ;单位
;
;
;L_McuToBle_UintKg:
;           btfss  R_BS_Scale_Unit,B_BS_KG
;           goto   L_McuToBle_UintJin  
;           
;           movlf  04h,R_APP_McuFuntion
;           goto   L_McuToBle_Uint_end
;           
;L_McuToBle_UintJin:
;           btfss  R_BS_Scale_Unit,B_BS_JIN
;           goto   L_McuToBle_UintLB
;           
;           movlf  00001100B,R_APP_McuFuntion
;           goto   L_McuToBle_Uint_end
;           
;L_McuToBle_UintLB:
;           btfss  R_BS_Scale_Unit,B_BS_LB
;           goto   L_McuToBle_UintST
;           movlf  00010100B,R_APP_McuFuntion
;           goto   L_McuToBle_Uint_end
;           
;L_McuToBle_UintST: 
;           movlf  00011100B,R_APP_McuFuntion
	
L_McuToBle_Uint_end:	
	
           call   F_McuToBle_Proc	
          
;ble send data to mcu

       
	       return