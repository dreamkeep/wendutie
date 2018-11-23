;============================================
; CSU18MX88 Special Register Addr Definition
; Data:2017-3-3
; Version:V1.0.0
;============================================
IND0        EQU     00H      ;xxxxxxxx 
IND1        EQU     01H      ;xxxxxxxx 
FSR0        EQU     02H      ;00000000 
FSR1        EQU     03H      ;00000000 
STATUS      EQU     04H      ;uuu00xxx 
WORK        EQU     05H      ;00000000 
INTF        EQU     06H      ;u0000000 
INTE        EQU     07H      ;00000000 
BSR         EQU     08H      ;00uuuu00 
MCK         EQU     09H      ;00100010 
EADRH       EQU     0AH      ;01000000 
EADRL       EQU     0BH      ;00000000 
EDAT        EQU     0CH      ;11111111 
EOPEN       EQU     0DH      ;00000000 
WDTCON      EQU     0EH      ;00000000 
WDTIN       EQU     0FH      ;00000000 
ADOH        EQU     10H      ;00000000 
ADOL        EQU     11H      ;00000000 
PCLOADL     EQU     12H      ;00000000 
PCLOADH     EQU     13H      ;uuu00000 
ROOT        EQU     14H      ;00000000 
PCK         EQU     15H      ;00000000 
ADCFG       EQU     16H      ;00000000 
ANACFG      EQU     17H      ;00000000 
TEMPC       EQU     18H      ;00000000 
AD2OH       EQU     19H      ;00000000 
AD2OL       EQU     1AH      ;00000000 
LVDCON      EQU     1BH      ;00u000x0 
ADOLL       EQU     1CH      ;00000000 
PT1         EQU     1DH      ;xxxxxxxx 
PT1EN       EQU     1EH      ;00000000 
PT1PU       EQU     1FH      ;00000000 
AIENB       EQU     20H      ;11111111 
PT2         EQU     21H      ;xxxxxxxx 
PT2EN       EQU     22H      ;00000000 
PT2PU       EQU     23H      ;00000000 
PT3         EQU     24H      ;xxxxxxxx 
PT3EN       EQU     25H      ;00000000 
PT3PU       EQU     26H      ;00000000 
PT4         EQU     27H      ;xxxxxxxx 
PT4EN       EQU     28H      ;00000000 
PT4PU       EQU     29H      ;00000000 
PT5         EQU     2AH      ;000xxxxx 
PT5EN       EQU     2BH      ;11100000 
PT5PU       EQU     2CH      ;00000000 
PTCON       EQU     2DH      ;00000000 
PTINT0      EQU     2EH      ;00000000 
PTINT1      EQU     2FH      ;00000000 
SEGCON0     EQU     30H      ;00000000 
SEGCON1     EQU     31H      ;00000000 
INTF2       EQU     32H      ;00000000 
INTE2       EQU     33H      ;00000000 
TM0CON      EQU     34H      ;0000u100 
TM0IN       EQU     35H      ;00000000 
TM0CNT      EQU     36H      ;00000000 
TM1CON      EQU     37H      ;00000100 
TM1IN       EQU     38H      ;00000000 
TM1CNT      EQU     39H      ;00000000 
TM1R        EQU     3AH      ;00000000 
TM2CON      EQU     3BH      ;00000100 
TM2IN       EQU     3CH      ;00000000 
TM2CNT      EQU     3DH      ;00000000 
TM2R        EQU     3EH      ;00000000 
TM3CON      EQU     3FH      ;00000100 
TM3IN       EQU     40H      ;00000000 
TM3CNT      EQU     41H      ;00000000 
TM3R        EQU     42H      ;00000000 
LCD1        EQU     43H      ;uuuu0000 
LCD2        EQU     44H      ;uuuu0000 
LCD3        EQU     45H      ;uu000000 
LCD4        EQU     46H      ;uu000000 
LCD5        EQU     47H      ;uu000000 
LCD6        EQU     48H      ;uu000000 
LCD7        EQU     49H      ;uu000000 
LCD8        EQU     4AH      ;uu000000 
LCD9        EQU     4BH      ;uu000000 
LCD10       EQU     4CH      ;uu000000 
LCD11       EQU     4DH      ;uu000000 
LCD12       EQU     4EH      ;uu000000 
LCD13       EQU     4FH      ;uu000000 
LCD14       EQU     50H      ;uu000000 
LCD15       EQU     51H      ;uu000000 
LCD16       EQU     52H      ;uu000000 
LCD17       EQU     53H      ;uu000000 
LCD18       EQU     54H      ;uu000000 
LCD19       EQU     55H      ;uu000000 
LCD20       EQU     56H      ;uu000000 
LCDCN1      EQU     57H      ;u0000u00 
LCDCN2      EQU     58H      ;00000000 
LCDENR      EQU     59H      ;00000000 
INTF3       EQU     5AH      ;00000000 
INTE3       EQU     5BH      ;00000000 
SPICFG      EQU     5CH      ;00000000 
SPICN       EQU     5DH      ;000uuuuu 
SPICKR      EQU     5EH      ;00000011 
SPIDAT      EQU     5FH      ;00000000 
RTCCON      EQU     60H      ;0u000111 
RTCAER      EQU     61H      ;00000000 
RTCYEAR     EQU     62H      ;00010101 
RTCMON      EQU     63H      ;uuu10001 
RTCDAY      EQU     64H      ;uu000001 
RTCHOUR     EQU     65H      ;u0000001 
RTCMIN      EQU     66H      ;u0000000 
RTCSEC      EQU     67H      ;u0000000 
I2CCON      EQU     68H      ;0000uuuu 
I2CDAT      EQU     69H      ;00000000 
FRACTION    EQU     6AH      ;0000uuuu      
ADCON       EQU     6BH      ;uuuu0000
TEST        EQU     6CH      ;00000000 
WDT_TRIM    EQU     6DH      ;00xx1000 
ICK_TRIM    EQU     6EH      ;10000000 
VS_TRIM     EQU     6FH      ;01001000 
UR0_CR1     EQU     70H      ;00000000 
UR0_BRR0    EQU     71H      ;00000000 
UR0_BRR1    EQU     72H      ;00000000 
UR0_TX_REG  EQU     73H      ;00000000 
UR0_RX_REG  EQU     74H      ;00000000 
UR0_CR2     EQU     75H      ;00100100 
UR0_ST      EQU     76H      ;00000000 
UR1_CR1     EQU     77H      ;00000000 
UR1_BRR0    EQU     78H      ;00000000 
UR1_BRR1    EQU     79H      ;00000000 
UR1_TX_REG  EQU     7AH      ;00000000 
UR1_RX_REG  EQU     7BH      ;00000000 
UR1_CR2     EQU     7CH      ;00100100 
UR1_ST      EQU     7DH      ;00000000 
RTCDWR      EQU     7EH      ;11111000 
I2CADR      EQU     7FH      ;01010100        
                                                                                                            


;-------------------------------------------
; STATUS
;-------------------------------------------
PD       EQU     4
TO       EQU     3
DC       EQU     2
C        EQU     1
Z        EQU     0
                                                  	
;-------------------------------------------
; INTF  
;-------------------------------------------		 
TM2IF     EQU     6  
TM1IF     EQU     5  
TM0IF     EQU     4  
AD2IF     EQU     3  
ADIF      EQU     2  
E1IF      EQU     1  
E0IF      EQU     0 	
	                                                                                          
;-------------------------------------------
; INTE  
;-------------------------------------------
GIE       EQU     7  
TM2IE     EQU     6  
TM1IE     EQU     5  
TM0IE     EQU     4  
AD2IE     EQU     3  
ADIE      EQU     2  
E1IE      EQU     1  
E0IE      EQU     0  
                                                                                                      
;-------------------------------------------
; BSR
;-------------------------------------------                                                 
IRP0	   EQU     7
IRP1	   EQU     6
PAGE1	   EQU     1
PAGE0      EQU     0

;-------------------------------------------
; MCK                                    
;-------------------------------------------                                                
ick_ldo_by        EQU     7 
M3_CK	          EQU     6 
M2_CK	          EQU     5 
M1_CK	          EQU     4 
ECK_EN	          EQU     3 
WDT_CLK_EN	      EQU     2 
ICK_EN	          EQU     1 
CLK_SEL           EQU     0 

;-------------------------------------------
; EADRH                                    
;-------------------------------------------                                                
PROG_BUSY         EQU     7 
READ_CHECK	      EQU     6  
                                            
;-------------------------------------------  
; WDTCON                                         
;-------------------------------------------  
WDTEN	          	EQU     7
ROOT_EN	        	EQU     6
AIENB3	        	EQU     5
I2C_DIV_1           EQU     4
I2C_DIV_0           EQU     3
WDTS_2          	EQU     2
WDTS_1          	EQU     1
WDTS_0          	EQU     0
                                                          
;-------------------------------------------   
; PCK                                          
;-------------------------------------------                                                              
UART1DIV_2	    EQU       7  
UART1DIV_1	    EQU       6
UART1DIV_0	    EQU       5
UART0DIV_2	    EQU       4
UART0DIV_1	    EQU       3
UART0DIV_0	    EQU       2
S_BEEP_1        EQU       1
S_BEEP_0        EQU       0   

;-------------------------------------------                                                    
; ADCFG                                                                                                     
;-------------------------------------------  
ADSC	     EQU       7 
F_GAIN_1     EQU       6 
F_GAIN_0     EQU       5 
S_GAIN_1     EQU       4 
S_GAIN_0     EQU       3 
R_GAIN	     EQU       2 
CHOPM_1      EQU       1 
CHOPM_0      EQU       0 

;------------------------------------------- 
; ANACFG                                        
;------------------------------------------- 
LDOEN	     EQU       7 
LDOS_1       EQU       6 
LDOS_0       EQU       5 
BGR_ENB	     EQU       4 
BGID	     EQU       3 
SINL_1       EQU       2 
SINL_0       EQU       1 
ADEN         EQU       0 

;------------------------------------------- 
; AD2OH                                     
;------------------------------------------- 
AD2EN	          EQU       7     
AD2START	      EQU       6 
AD3_SL_3          EQU       5 
AD3_SL_2          EQU       4 
AD3_SL_1          EQU       3 
AD3_SL_0	      EQU       2 
AD2O_9            EQU       1 
AD2O_8            EQU       0 

;------------------------------------------- 
; LVDCON                                     
;------------------------------------------- 
LVDEN			EQU       7
AD2_REF			EQU       6
AIENB1			EQU       5
SILB_2          EQU       4
SILB_1          EQU       3
SILB_0	        EQU       2
LBOUT	        EQU       1
LB_RST_CON      EQU       0    
              
;-------------------------------------------               
; PT5EN                                                   
;-------------------------------------------   
SMT5_EN	     EQU     7
SMT2_EN	     EQU     6
SMT1_EN	     EQU     5
 
;-------------------------------------------               
; PT5PU                                                   
;-------------------------------------------                               
PT15_VDD        EQU   7
PT14_VDD        EQU   6
I2C_VDD         EQU   5
 
;-------------------------------------------  
; PTCON0                                                                                                        
;-------------------------------------------                                                            
BZEN	         EQU       7  
PWM3_SEL	     EQU       6  
PWM2_SEL	     EQU       5  
PWM1_SEL	     EQU       4  
E1M_1            EQU       3  
E1M_0	         EQU       2  
E0M_1            EQU       1  
E0M_0            EQU       0  

;-------------------------------------------  
; INTF2                                                                                                        
;-------------------------------------------  
UR1_RHIF	       EQU       7    
UR1_RNIF	       EQU       6    
UR1_THIF	       EQU       5    
UR1_TEIF	       EQU       4    
UR0_RHIF	       EQU       3  
UR0_RNIF	       EQU       2    
UR0_THIF	       EQU       1  
UR0_TEIF           EQU       0  
                                       
;-------------------------------------------               
; INTE2                                                    
;-------------------------------------------      
UR1_RHIE	         EQU       7      
UR1_RNIE	         EQU       6      
UR1_THIE	         EQU       5      
UR1_TEIE	         EQU       4      
UR0_RHIE	         EQU       3      
UR0_RNIE	         EQU       2      
UR0_THIE	         EQU       1      
UR0_TEIE             EQU       0    

;------------------------------------------- 
; TM0CON                                      
;-------------------------------------------                                                             
T0EN	            EQU       7 
T0RATE_2            EQU       6 
T0RATE_1            EQU       5 
T0RATE_0		    EQU       4 
T0RSTB	            EQU       2 
T0SEL_1             EQU       1 
T0SEL_0             EQU       0

;------------------------------------------- 
; TM1CON                                      
;-------------------------------------------            
T1EN	          EQU       7    
T1RATE_2          EQU       6    
T1RATE_1          EQU       5    
T1RATE_0	      EQU       4    
T1CKS	          EQU       3    
T1RSTB	          EQU       2    
T1OUT	          EQU       1    
PWM1OUT           EQU       0  

;------------------------------------------- 
; TM2CON                                      
;------------------------------------------- 
T2EN	          EQU       7 
T2RATE_2          EQU       6 
T2RATE_1          EQU       5 
T2RATE_0	      EQU       4 
T2CKS	          EQU       3 
T2RSTB	          EQU       2 
T2OUT	          EQU       1 
PWM2OUT           EQU       0 

;------------------------------------------- 
; TM3CON                                      
;------------------------------------------- 
T3EN	          EQU       7   
T3RATE_2          EQU       6   
T3RATE_1          EQU       5   
T3RATE_0	      EQU       4   
T3SEL	          EQU       3   
T3RSTB	          EQU       2   
T3OUT	          EQU       1   
PWM3OUT           EQU       0 

;------------------------------------------- 
; LCDCN1                                      
;------------------------------------------- 
LCDFC_1        EQU      6
LCDFC_0        EQU      5
WDT_LCD	       EQU      4
CSE_LCD		   EQU      3
VLCDX_1        EQU      1
VLCDX_0        EQU      0

;------------------------------------------- 
; LCDCN2                                     
;------------------------------------------- 
LCDSCKS_3        EQU       7        
LCDSCKS_2        EQU       6        
LCDSCKS_1        EQU       5        
LCDSCKS_0        EQU       4        
LCDFR	         EQU       3        
LCDREF_2         EQU       2        
LCDREF_1         EQU       1        
LCDREF_0         EQU       0      

;------------------------------------------- 
; LCDENR                                     
;------------------------------------------- 
LCDCKS_1            EQU       7   
LCDCKS_0            EQU       6               
LCDEN	            EQU       5   
LCDWS	            EQU       4   
LEVEL	            EQU       3     
LCD_DUTY_1          EQU       2   
LCD_DUTY_0	        EQU       1   
ENPMPL              EQU       0     

;------------------------------------------- 
; INTF3                                                    
;-------------------------------------------                                  
I2C_TIF            EQU        7
I2C_RIF            EQU        6
UR0ERR_IF          EQU        5             
UR1WK_IF	       EQU        4 
UR0WK_IF	       EQU        3
TM3IF	           EQU        2
RTCIF	           EQU        1
SPIIF              EQU        0 

;------------------------------------------- 
; INTE3                                                    
;-------------------------------------------                   
I2C_TIE            EQU        7
I2C_RIE            EQU        6
UR0ERR_IE          EQU        5
UR1WK_IE	       EQU        4 
UR0WK_IE	       EQU        3 
TM3IE	           EQU        2 
RTCIE	           EQU        1 
SPIIE              EQU        0 

;-------------------------------------------  
; SPICFG                                       
;-------------------------------------------  
SPIEN	           EQU       7
MSTEN	           EQU       6
CKPHA	           EQU       5
CKPOL	           EQU       4
MULMST	           EQU       3  
WIREMOD	           EQU       2
SPIBSY	           EQU       1
SPIRST             EQU       0

;-------------------------------------------  
; SPICN                                                   
;-------------------------------------------                                                                                                                   
SLVSEL	           EQU      7
WCOL	           EQU      6
MODCOL	           EQU      5

;------------------------------------------- 
; RTCCON                                      
;------------------------------------------- 
LIR	             EQU      7  
RFU	             EQU      6 
HR_24_12         EQU      5    		
RTCEN	         EQU      4
INTEGER_3        EQU      3
INTEGER_2        EQU      2
INTEGER_1        EQU      1
INTEGER_0        EQU      0
;-------------------------------------------   
; RTCYEAR                                     
;------------------------------------------- 
TEN_YEAR_3         EQU       7    
TEN_YEAR_2         EQU       6    
TEN_YEAR_1         EQU       5    
TEN_YEAR_0         EQU       4  
ONE_YEAR_3         EQU       3    
ONE_YEAR_2	       EQU       2    
ONE_YEAR_1         EQU       1    
ONE_YEAR_0         EQU       0  

;------------------------------------------- 
; RTCMON                                    
;-------------------------------------------     
TEN_MON	          EQU       4
ONE_MON_3         EQU       3
ONE_MON_2         EQU       2
ONE_MON_1         EQU       1
ONE_MON_0         EQU       0

;------------------------------------------- 
; RTCDAY                                    
;------------------------------------------- 
TEN_DAY_1	      EQU       5          
TEN_DAY_0	      EQU       4
ONE_DAY_3         EQU       3
ONE_DAY_2         EQU       2
ONE_DAY_1         EQU       1
ONE_DAY_0         EQU       0

;-------------------------------------------     
; RTCHOUR                                         
;-------------------------------------------     
AM_PM              EQU       6    
TEN_HOUR_1	       EQU       5
TEN_HOUR_0	       EQU       4
ONE_HOUR_3         EQU       3
ONE_HOUR_2         EQU       2
ONE_HOUR_1         EQU       1
ONE_HOUR_0         EQU       0
    
;-------------------------------------------                                    
; RTCMIN                                                                                   
;-------------------------------------------    
TEN_MIN_2     EQU       6 
TEN_MIN_1     EQU       5 
TEN_MIN_0     EQU       4 
ONE_MIN_3     EQU       3 
ONE_MIN_2     EQU       2 
ONE_MIN_1     EQU       1 
ONE_MIN_0     EQU       0 

;-------------------------------------------   
; RTCSEC                                      
;-------------------------------------------  
TEN_SEC_2     EQU       6 
TEN_SEC_1     EQU       5 
TEN_SEC_0     EQU       4 
ONE_SEC_3     EQU       3 
ONE_SEC_2     EQU       2 
ONE_SEC_1     EQU       1 
ONE_SEC_0     EQU       0  
                           
;-------------------------------------------   
; I2CCON                                      
;-------------------------------------------  
I2C_EN         EQU       7
AWK_EN	       EQU       6 
CST_EN         EQU       5 
ACK_EN         EQU       4 
I2CSTUS_3      EQU       3 
I2CSTUS_2	   EQU       2 
I2CSTUS_1      EQU       1 
I2CSTUS_0      EQU       0  
    
;-------------------------------------------
; WDT_TRIM                                       
;-------------------------------------------           
TMOD_1             EQU       7
TMOD_0             EQU       6
ICK_SEL_1          EQU       5
ICK_SEL_0          EQU       4
WDT_TRIM_3         EQU       3
WDT_TRIM_2         EQU       2
WDT_TRIM_1         EQU       1
WDT_TRIM_0         EQU       0

;-------------------------------------------              
; VS_TRIM                                                
;------------------------------------------- 
sim_rst        	   EQU      7             
LVD_TRIM_2         EQU       6 
LVD_TRIM_1         EQU       5 
LVD_TRIM_0	       EQU       4 
VS_TRIM_3          EQU       3 
VS_TRIM_2          EQU       2 
VS_TRIM_1          EQU       1 
VS_TRIM_0          EQU       0
                                                      
;-------------------------------------------                           
; UR0_CR1      UR1_CR1                                                                                                                                                      
;-------------------------------------------                                                 
TX9D	            EQU       7
RX9D	            EQU       6   
TX9_EN	            EQU       5   
RX9_EN	            EQU       4   
RX_EN               EQU       3   
TX_EN	            EQU       2   
UART_SEL	        EQU       1   
UART_EN             EQU       0            
                     
                           
;-------------------------------------------                           
; UR0_CR2      UR1_CR2                                                                                                                                                      
;-------------------------------------------                                                    
RXF_WATER_LEVEL_2   EQU       6
RXF_WATER_LEVEL_1   EQU       5
RXF_WATER_LEVEL_0   EQU       4
TXF_WATER_LEVEL_2   EQU       2
TXF_WATER_LEVEL_1   EQU       1
TXF_WATER_LEVEL_0   EQU       0

;-------------------------------------------                           
; UR0_ST    UR1_ST                                                                                                                                                        
;-------------------------------------------       
RX_BUSY          EQU    3
TX_BUSY	         EQU    2
RXOV_ERR	     EQU    1
STOP_ERR         EQU    0 
                                                                       
;-------------------------------------------  
; RTCDWR                                                                                         
;-------------------------------------------                 
DWR_2      EQU       2 
DWR_1      EQU       1 
DWR_0      EQU       0   

;-------------------------------------------  
; I2CADR                                                                                         
;-------------------------------------------
GC_EN      EQU       0 

;==========================================
W        EQU    0
F        EQU    1                                                          