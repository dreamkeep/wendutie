;============================================
; CST34XX Bluetooth Configuration Definition
;============================================

BT_PATCH_BIN_SIZE       EQU 	1A81H			; The filesize of bt_patch.bin

;-------------------------------------------
; PrimaryService about GAP: 
;-------------------------------------------
HANDLE_DeviceName       EQU 	0003H			; Device Name
HANDLE_Appearance       EQU 	0005H			; Appearance
HANDLE_PerhPrefConnParm EQU 	0007H			; Peripheral Preferred Connection Parameters
HANDLE_PerhPrivFlag     EQU 	0009H			; Peripheral Privacy Flag

;-------------------------------------------
; PrimaryService about DIS: 
;-------------------------------------------
HANDLE_ManufactureName  EQU 	000CH			; Manufacture Name
HANDLE_ModuleNumber     EQU 	000EH			; Module Number
HANDLE_SerialNumber     EQU 	0010H			; Serial Number
HANDLE_FirmVer          EQU 	0012H			; Firmware Version
HANDLE_HardVer          EQU 	0014H			; Hardware Version

;-------------------------------------------
; PrimaryService about FFF0: 
;-------------------------------------------
HANDLE_FFF1             EQU 	0017H			; 
HANDLE_FFF2             EQU 	001AH			; 

;-------------------------------------------
; PrimaryService about BCS: Body Composition Service
;-------------------------------------------
HANDLE_2A9C             EQU 	001DH			; 
HANDLE_FA9C             EQU 	0020H			; 

;-------------------------------------------
; PrimaryService about BAS: Battery Service
;-------------------------------------------
HANDLE_2A19             EQU 	0024H			; 

;-------------------------------------------
; PrimaryService about CTS: Current Time Service
;-------------------------------------------
HANDLE_2A08             EQU 	0028H			; 

;-------------------------------------------
; PrimaryService about FAA0: 
;-------------------------------------------
HANDLE_FAA1             EQU 	002CH			; 
HANDLE_FAA2             EQU 	002EH			; 

;============================================
; End of CST34XX Bluetooth Configuration Definition
;============================================


;----------------------------------------------
;	体温贴数据头
;----------------------------------------------
THERMOPLIE_HEAD_PART_1    equ   0xFA
THERMOPLIE_HEAD_PART_2    equ   0xAA
THERMOPLIE_HEAD_PART_3    equ   0xAA
THERMOPLIE_HEAD_PART_4    equ   0xAF
;----------------------------------------------
;	体温贴数据尾
;----------------------------------------------
THERMOPLIE_TAIL_PART_1    equ   0xF5
THERMOPLIE_TAIL_PART_2    equ   0x5F

