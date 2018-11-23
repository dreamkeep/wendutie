;--------------------------------------------
;                  ���� 
; �ó�������ο�������оƬ�������������¶���
; ���м򵥵Ĺ��ܲ��ԡ��������д�����©��о��
; �Ƽ�(����)�ɷ����޹�˾�Դ˲��е��κ����Ρ�
;   (C)Shenzhen Chipsea Technologies Co.,Ltd
;--------------------------------------------
; filename: CS_APP_BLE.asm
; author  : 
; date    : 2017-7-20
; function:
;--------------------------------------------
/*--------------------------------------------
;�궨��
----------------------------------------------*/
DEFINE  BLEWAKEUPPIN        "PT2,0"
DEFINE  BLEWAKEUPPINEN      "PT2EN,0"
DEFINE  BLEWAKEUPPINPU      "PT2PU,0"
DEFINE  BLESTATUSPIN        "PT2,5"
DEFINE  BLESTATUSPINEN      "PT2EN,5"
DEFINE  BLESTATUSPINPU      "PT2PU,5"
DEFINE  UARTFLAGCHECK       "INTF2,UR1_RNIF"
BLESTATUS_REST              EQU     00H       ;��λ
BLESTATUS_BOOT              EQU     01H       ;BOOTLODER
BLESTATUS_STANDY            EQU     02H       ;����
BLESTATUS_ADV               EQU     03H       ;�㲥
BLESTATUS_CONNECT           EQU     04H       ;����
BLESTATUS_SLEEP             EQU     05H       ;˯��
SETADVCMD                   EQU     24h
SENDAPPDATACMD              EQU     30h
R_BLE_SEG_S                 EQU     R_ALC_BLE_S
/*--------------------------------------------
;��������
----------------------------------------------*/
;ȫ�ֱ���
R_APP_WeightL               EQU     R_BLE_SEG_S+0   ;����
R_APP_WeightH               EQU     R_BLE_SEG_S+1
R_APP_RegierL               EQU     R_BLE_SEG_S+2   ;����
R_APP_RegierH               EQU     R_BLE_SEG_S+3
R_APP_YearH                 EQU     R_BLE_SEG_S+4   ;��
R_APP_YearL                 EQU     R_BLE_SEG_S+5
R_APP_Month                 EQU     R_BLE_SEG_S+6   ;��
R_APP_Day                   EQU     R_BLE_SEG_S+7   ;��
R_APP_Hour                  EQU     R_BLE_SEG_S+8   ;ʱ
R_APP_Min                   EQU     R_BLE_SEG_S+9   ;��
R_APP_Sec                   EQU     R_BLE_SEG_S+10  ;��
R_APP_McuStatus             EQU     R_BLE_SEG_S+11  ;MCU״̬
                                                    ;bit0   : ������λ��־
                                                    ;bit1   : ���ر�־
                                                    ;bit2   : ��ʾ���������־
                                                    ;bit3   : ��ʾ���ѱ�־
                                                    ;bit4   : ��ʾ�³�
                                                    ;bit5   : ��������
R_APP_McuFuntion            EQU     R_BLE_SEG_S+12  ;MCU����
                                                    ;Bit4-3 ��λѡ��
                                                    ;00 - KG(Ĭ��)
                                                    ;01 - ��
                                                    ;10 - LB
                                                    ;11 - ST:LB
                                                    ;Bit2-1 С��λ��ѡ��
                                                    ;00 - 2 λС��(Ĭ��)
                                                    ;01 - 0 λС��
                                                    ;10 - 1 λС��
;�ֲ�����
R_SendTime                  EQU     R_BLE_SEG_S+13  ;���ʹ���
R_CodeLengthH               EQU     R_BLE_SEG_S+14  ;bin�ļ����ֽ������ֽ�
R_CodeLengthL               EQU     R_BLE_SEG_S+15  ;bin�ļ����ֽ������ֽ�
R_CodeCnt                   EQU     R_BLE_SEG_S+16  ;ÿ�������ֽ���
R_BleStatus                 EQU     R_BLE_SEG_S+17  ;����״̬��־λ
R_Ble_A0                    EQU     R_BLE_SEG_S+18  ;
R_Ble_A1                    EQU     R_BLE_SEG_S+19  ;
R_Ble_A2                    EQU     R_BLE_SEG_S+20
R_Delay_Num					EQU     R_BLE_SEG_S+21  ;
;----------------------------------------------------------------------------
R_PathBufLength				EQU		R_CodeCnt		    ;ÿ�������ݳ���
R_BleCodeStartAddH			EQU		R_BLE_SEG_S+22		;blecode�洢��ʼ��ַ���ֽ�
R_BleCodeStartAddL			EQU		R_BLE_SEG_S+23		
R_BleCodeEndAddH			EQU		R_BLE_SEG_S+24		;blecode�洢������ַ���ֽ�
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
;;	B_BS_KG				equ		0						;��λ KG
;;	B_BS_JIN			equ		1						;��λ JIN
;;	B_BS_LB				equ		2						;��λ LB
;;	B_BS_ST				equ		3						;��λ ST
;L_McuToBle_Uint:                                        ;��λ
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