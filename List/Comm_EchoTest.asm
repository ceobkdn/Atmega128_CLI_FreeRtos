
;CodeVisionAVR C Compiler V2.05.4 Evaluation
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128
;Program type             : Application
;Clock frequency          : 16.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _con=R5
	.DEF _FndCnt=R6

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  _usart0_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_str:
	.DB  0x3D,0x3D,0x3D,0x4C,0x4B,0x45,0x4D,0x42
	.DB  0x45,0x44,0x44,0x45,0x44,0x3D,0x3D,0x3D
	.DB  0x0,0x3D,0x3D,0x3D,0x3D,0x20,0x20,0x57
	.DB  0x57,0x57,0x2E,0x20,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x0,0x3D,0x3D,0x20,0x4C,0x4B,0x45
	.DB  0x4D,0x42,0x45,0x44,0x44,0x45,0x44,0x2E
	.DB  0x3D,0x3D,0x0,0x3D,0x3D,0x3D,0x3D,0x20
	.DB  0x43,0x4F,0x2E,0x4B,0x52,0x20,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x0,0x20,0x20,0x20,0x45
	.DB  0x64,0x75,0x63,0x61,0x74,0x69,0x6F,0x6E
	.DB  0x20,0x20,0x20,0x20,0x0,0x20,0x20,0x20
	.DB  0x44,0x65,0x76,0x65,0x6C,0x6F,0x70,0x6D
	.DB  0x65,0x6E,0x74,0x20,0x20,0x0,0x20,0x20
	.DB  0x41,0x56,0x52,0x20,0x44,0x65,0x76,0x20
	.DB  0x26,0x20,0x45,0x44,0x55,0x20,0x0,0x20
	.DB  0x20,0x50,0x49,0x43,0x20,0x44,0x65,0x76
	.DB  0x20,0x26,0x20,0x45,0x44,0x55,0x20,0x0
	.DB  0x20,0x20,0x41,0x52,0x4D,0x20,0x44,0x65
	.DB  0x76,0x20,0x26,0x20,0x45,0x44,0x55,0x20
	.DB  0x0,0x20,0x50,0x41,0x44,0x53,0x20,0x44
	.DB  0x65,0x76,0x20,0x26,0x20,0x45,0x44,0x55
	.DB  0x20,0x0,0x20,0x20,0x20,0x43,0x69,0x72
	.DB  0x71,0x75,0x69,0x74,0x20,0x45,0x44,0x55
	.DB  0x20,0x20,0x0
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x4:
	.DB  LOW(_0x3),HIGH(_0x3),LOW(_help_func),HIGH(_help_func),LOW(_0x3+5),HIGH(_0x3+5),LOW(_show_func),HIGH(_show_func)
	.DB  LOW(_0x3+10),HIGH(_0x3+10),LOW(_blink_func),HIGH(_blink_func),LOW(_0x3+16),HIGH(_0x3+16),LOW(_led_func),HIGH(_led_func)
	.DB  LOW(_0x3+20),HIGH(_0x3+20),LOW(_lcd_func),HIGH(_lcd_func),LOW(_0x3+24),HIGH(_0x3+24),LOW(_led7_func),HIGH(_led7_func)
_0x16:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0
_0x2B:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0
_0x0:
	.DB  0x68,0x65,0x6C,0x70,0x0,0x73,0x68,0x6F
	.DB  0x77,0x0,0x62,0x6C,0x69,0x6E,0x6B,0x0
	.DB  0x6C,0x65,0x64,0x0,0x6C,0x63,0x64,0x0
	.DB  0x6C,0x65,0x64,0x37,0x0,0x48,0x45,0x4C
	.DB  0x50,0x20,0x66,0x75,0x6E,0x63,0x74,0x69
	.DB  0x6F,0x6E,0x20,0x65,0x78,0x65,0x63,0x75
	.DB  0x74,0x65,0x64,0x0,0xD,0x68,0x65,0x6C
	.DB  0x70,0x3A,0x20,0x48,0x65,0x6C,0x70,0x20
	.DB  0x66,0x75,0x6E,0x63,0x74,0x69,0x6F,0x6E
	.DB  0x20,0xA,0xD,0x0,0x62,0x6C,0x69,0x6E
	.DB  0x6B,0x3A,0x20,0x42,0x6C,0x69,0x6E,0x6B
	.DB  0x20,0x66,0x75,0x6E,0x63,0x74,0x69,0x6F
	.DB  0x6E,0x20,0xA,0xD,0x0,0x6C,0x65,0x64
	.DB  0x3A,0x20,0x4C,0x65,0x64,0x20,0x66,0x75
	.DB  0x6E,0x63,0x74,0x69,0x6F,0x6E,0x20,0xA
	.DB  0xD,0x0,0x6C,0x63,0x64,0x3A,0x20,0x4C
	.DB  0x63,0x64,0x20,0x66,0x75,0x6E,0x63,0x74
	.DB  0x69,0x6F,0x6E,0x20,0xA,0xD,0x0,0x6C
	.DB  0x65,0x64,0x37,0x3A,0x20,0x4C,0x65,0x64
	.DB  0x37,0x20,0x66,0x75,0x6E,0x63,0x74,0x69
	.DB  0x6F,0x6E,0x20,0xA,0xD,0x0,0x2D,0x68
	.DB  0x65,0x6C,0x70,0x0,0x42,0x4C,0x49,0x4E
	.DB  0x4B,0x20,0x68,0x65,0x6C,0x70,0x20,0x6D
	.DB  0x65,0x6E,0x75,0x3A,0x20,0xD,0x3C,0x62
	.DB  0x6C,0x69,0x6E,0x6B,0x3E,0x20,0x3C,0x6F
	.DB  0x6E,0x2F,0x6F,0x66,0x66,0x3E,0x20,0x3C
	.DB  0x76,0x61,0x6C,0x75,0x65,0x28,0x31,0x2D
	.DB  0x3E,0x38,0x29,0x3E,0x0,0x6F,0x6E,0x0
	.DB  0x65,0x63,0x68,0x6F,0x3A,0x20,0x64,0x69
	.DB  0x73,0x70,0x6C,0x61,0x79,0x20,0x0,0x42
	.DB  0x4C,0x49,0x4E,0x4B,0x20,0x66,0x75,0x6E
	.DB  0x63,0x74,0x69,0x6F,0x6E,0x20,0x65,0x78
	.DB  0x65,0x63,0x75,0x74,0x65,0x64,0x0,0x65
	.DB  0x63,0x68,0x6F,0x3A,0x20,0x4C,0x65,0x64
	.DB  0x20,0x68,0x65,0x6C,0x70,0x20,0x6D,0x65
	.DB  0x6E,0x75,0x3A,0x20,0xD,0x3C,0x6C,0x65
	.DB  0x64,0x3E,0x20,0x3C,0x6F,0x6E,0x2F,0x6F
	.DB  0x66,0x66,0x3E,0x20,0x3C,0x76,0x61,0x6C
	.DB  0x75,0x65,0x28,0x31,0x2D,0x3E,0x38,0x29
	.DB  0x3E,0x0,0x65,0x63,0x68,0x6F,0x3A,0x20
	.DB  0x54,0x75,0x72,0x6E,0x20,0x6F,0x6E,0x20
	.DB  0x6C,0x65,0x64,0x20,0x0,0x61,0x6C,0x6C
	.DB  0x0,0x65,0x63,0x68,0x6F,0x3A,0x20,0x41
	.DB  0x6C,0x6C,0x20,0x6C,0x65,0x64,0x20,0x77
	.DB  0x61,0x73,0x20,0x6F,0x6E,0x0,0x54,0x75
	.DB  0x72,0x6E,0x20,0x6F,0x6E,0x20,0x61,0x6C
	.DB  0x6C,0x20,0x6C,0x65,0x64,0x0,0x6F,0x66
	.DB  0x66,0x0,0x65,0x63,0x68,0x6F,0x3A,0x20
	.DB  0x54,0x75,0x72,0x6E,0x20,0x6F,0x66,0x66
	.DB  0x20,0x6C,0x65,0x64,0x20,0x0,0x65,0x63
	.DB  0x68,0x6F,0x3A,0x20,0x41,0x6C,0x6C,0x20
	.DB  0x6C,0x65,0x64,0x20,0x77,0x61,0x73,0x20
	.DB  0x6F,0x66,0x66,0x0,0x54,0x75,0x72,0x6E
	.DB  0x20,0x6F,0x66,0x66,0x20,0x61,0x6C,0x6C
	.DB  0x20,0x6C,0x65,0x64,0x0,0x4C,0x65,0x64
	.DB  0x20,0x66,0x75,0x6E,0x63,0x74,0x69,0x6F
	.DB  0x6E,0x20,0x65,0x78,0x65,0x63,0x75,0x74
	.DB  0x65,0x64,0x0,0x65,0x63,0x68,0x6F,0x3A
	.DB  0x20,0x4C,0x63,0x64,0x20,0x68,0x65,0x6C
	.DB  0x70,0x20,0x6D,0x65,0x6E,0x75,0x3A,0x20
	.DB  0xD,0x3C,0x6C,0x63,0x64,0x3E,0x20,0x3C
	.DB  0x64,0x69,0x73,0x70,0x3E,0x20,0x3C,0x74
	.DB  0x65,0x78,0x74,0x3E,0x0,0x64,0x69,0x73
	.DB  0x70,0x0,0x65,0x63,0x68,0x6F,0x3A,0x20
	.DB  0x44,0x69,0x73,0x70,0x6C,0x61,0x79,0x20
	.DB  0x6F,0x6E,0x20,0x4C,0x43,0x44,0x0,0x4C
	.DB  0x45,0x44,0x37,0x20,0x68,0x65,0x6C,0x70
	.DB  0x20,0x6D,0x65,0x6E,0x75,0x3A,0x20,0xD
	.DB  0x3C,0x6C,0x65,0x64,0x37,0x3E,0x20,0x3C
	.DB  0x64,0x69,0x73,0x70,0x3E,0x20,0x3C,0x76
	.DB  0x61,0x6C,0x75,0x65,0x28,0x31,0x2D,0x3E
	.DB  0x38,0x29,0x3E,0x0,0x4C,0x65,0x64,0x37
	.DB  0x20,0x66,0x75,0x6E,0x63,0x74,0x69,0x6F
	.DB  0x6E,0x20,0x65,0x78,0x65,0x63,0x75,0x74
	.DB  0x65,0x64,0x0
_0x60003:
	.DB  0x1,0x2,0x4,0x8,0x10,0x20,0x40,0x80
_0x60004:
	.DB  0xE7,0xDB,0xBD,0xBD,0x81,0xBD,0xBD,0xBD
	.DB  0xC1,0xBD,0xBD,0xC1,0xDD,0xBD,0xBD,0xC1
	.DB  0xC3,0xBD,0xFD,0xFD,0xFD,0xBD,0xBD,0xC3
	.DB  0xC1,0xBD,0xBD,0xBD,0xBD,0xBD,0xBD,0xC1
	.DB  0x81,0xFD,0xFD,0x81,0xFD,0xFD,0xFD,0x81
	.DB  0x81,0xFD,0xFD,0x81,0xFD,0xFD,0xFD,0xFD
	.DB  0xE7,0xD9,0xBD,0xFD,0x8D,0xBD,0xDB,0xE7
	.DB  0xBD,0xBD,0xBD,0x81,0xBD,0xBD,0xBD,0xBD
	.DB  0xC3,0xE7,0xE7,0xE7,0xE7,0xE7,0xE7,0xC3
	.DB  0xC3,0xE7,0xE7,0xE7,0xE7,0xE5,0xF5,0xFB
	.DB  0xDD,0xED,0xF5,0xF9,0xF5,0xED,0xDD,0xBD
	.DB  0xFD,0xFD,0xFD,0xFD,0xFD,0xFD,0xFD,0x81
	.DB  0xBD,0x99,0xA5,0xA5,0xA5,0xBD,0xBD,0xBD
	.DB  0xBD,0xBD,0xB9,0xB5,0xAD,0x9D,0xBD,0xBD
	.DB  0xE7,0xDB,0xBD,0xBD,0xBD,0xBD,0xDB,0xE7
	.DB  0xE1,0xDD,0xDD,0xDD,0xE1,0xFD,0xFD,0xFD
	.DB  0xE3,0xDD,0xDD,0xDD,0xD5,0xCD,0xC3,0xBF
	.DB  0xC1,0xBD,0xBD,0xC1,0xDD,0xBD,0xBD,0xBD
	.DB  0xC3,0xBD,0xFD,0xC3,0xBF,0xBF,0xBD,0xC3
	.DB  0x81,0xE7,0xE7,0xE7,0xE7,0xE7,0xE7,0xE7
	.DB  0xBD,0xBD,0xBD,0xBD,0xBD,0xBD,0xBD,0xC3
	.DB  0xBD,0xBD,0xBD,0xBD,0xBD,0xBD,0xDB,0xE7
	.DB  0xBD,0xBD,0xBD,0xBD,0xA5,0xA5,0xA5,0x99
	.DB  0xBD,0xBD,0xD9,0xE7,0xE7,0xDB,0xBD,0xBD
	.DB  0xBD,0xBD,0xBD,0xDB,0xE7,0xE7,0xE7,0xE7
	.DB  0x81,0xBF,0xDF,0xEF,0xF7,0xFB,0xFD,0x81
_0x80003:
	.DB  0x6
_0x80022:
	.DB  0x0
_0xC0003:
	.DB  0x3E,0x3E,0x20
_0xC0004:
	.DB  0xD
_0xC0006:
	.DB  LOW(_0xC0005),HIGH(_0xC0005),LOW(_0xC0005+3),HIGH(_0xC0005+3)
_0xC0000:
	.DB  0x4F,0x4B,0x0,0x43,0x6F,0x6D,0x6D,0x61
	.DB  0x6E,0x64,0x20,0x6E,0x6F,0x74,0x20,0x72
	.DB  0x65,0x63,0x6F,0x67,0x6E,0x69,0x73,0x65
	.DB  0x64,0x0,0x20,0x0
_0xE0003:
	.DB  0x3F,0x6,0x5B,0x4F,0x66,0x6D,0x7D,0x27
	.DB  0x7F,0x6F
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x05
	.DW  _0x3
	.DW  _0x0*2

	.DW  0x05
	.DW  _0x3+5
	.DW  _0x0*2+5

	.DW  0x06
	.DW  _0x3+10
	.DW  _0x0*2+10

	.DW  0x04
	.DW  _0x3+16
	.DW  _0x0*2+16

	.DW  0x04
	.DW  _0x3+20
	.DW  _0x0*2+20

	.DW  0x05
	.DW  _0x3+24
	.DW  _0x0*2+24

	.DW  0x18
	.DW  _cmd_tbl
	.DW  _0x4*2

	.DW  0x17
	.DW  _0xC
	.DW  _0x0*2+29

	.DW  0x18
	.DW  _0xD
	.DW  _0x0*2+52

	.DW  0x19
	.DW  _0xD+24
	.DW  _0x0*2+76

	.DW  0x15
	.DW  _0xD+49
	.DW  _0x0*2+101

	.DW  0x15
	.DW  _0xD+70
	.DW  _0x0*2+122

	.DW  0x17
	.DW  _0xD+91
	.DW  _0x0*2+143

	.DW  0x06
	.DW  _0x10
	.DW  _0x0*2+166

	.DW  0x31
	.DW  _0x10+6
	.DW  _0x0*2+172

	.DW  0x03
	.DW  _0x10+55
	.DW  _0x0*2+221

	.DW  0x0F
	.DW  _0x10+58
	.DW  _0x0*2+224

	.DW  0x18
	.DW  _0x10+73
	.DW  _0x0*2+239

	.DW  0x06
	.DW  _0x19
	.DW  _0x0*2+166

	.DW  0x33
	.DW  _0x19+6
	.DW  _0x0*2+263

	.DW  0x03
	.DW  _0x19+57
	.DW  _0x0*2+221

	.DW  0x13
	.DW  _0x19+60
	.DW  _0x0*2+314

	.DW  0x0D
	.DW  _0x19+79
	.DW  _0x0*2+320

	.DW  0x04
	.DW  _0x19+92
	.DW  _0x0*2+333

	.DW  0x15
	.DW  _0x19+96
	.DW  _0x0*2+337

	.DW  0x10
	.DW  _0x19+117
	.DW  _0x0*2+358

	.DW  0x04
	.DW  _0x19+133
	.DW  _0x0*2+374

	.DW  0x14
	.DW  _0x19+137
	.DW  _0x0*2+378

	.DW  0x0E
	.DW  _0x19+157
	.DW  _0x0*2+384

	.DW  0x04
	.DW  _0x19+171
	.DW  _0x0*2+333

	.DW  0x16
	.DW  _0x19+175
	.DW  _0x0*2+398

	.DW  0x11
	.DW  _0x19+197
	.DW  _0x0*2+420

	.DW  0x16
	.DW  _0x19+214
	.DW  _0x0*2+437

	.DW  0x06
	.DW  _0x2E
	.DW  _0x0*2+166

	.DW  0x2A
	.DW  _0x2E+6
	.DW  _0x0*2+459

	.DW  0x05
	.DW  _0x2E+48
	.DW  _0x0*2+501

	.DW  0x15
	.DW  _0x2E+53
	.DW  _0x0*2+506

	.DW  0x06
	.DW  _0x3A
	.DW  _0x0*2+166

	.DW  0x2D
	.DW  _0x3A+6
	.DW  _0x0*2+527

	.DW  0x05
	.DW  _0x3A+51
	.DW  _0x0*2+501

	.DW  0x0F
	.DW  _0x3A+56
	.DW  _0x0*2+224

	.DW  0x17
	.DW  _0x3A+71
	.DW  _0x0*2+572

	.DW  0x08
	.DW  _vertical
	.DW  _0x60003*2

	.DW  0xD0
	.DW  _english
	.DW  _0x60004*2

	.DW  0x01
	.DW  _num_cnt2
	.DW  _0x80003*2

	.DW  0x01
	.DW  0x05
	.DW  _0x80022*2

	.DW  0x03
	.DW  _cli_prompt
	.DW  _0xC0003*2

	.DW  0x01
	.DW  _cli_unrecog
	.DW  _0xC0004*2

	.DW  0x03
	.DW  _0xC0005
	.DW  _0xC0000*2

	.DW  0x17
	.DW  _0xC0005+3
	.DW  _0xC0000*2+3

	.DW  0x0A
	.DW  _Num
	.DW  _0xE0003*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;
;
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h> // Standard Input/Output functions
;#include <string.h>
;#include <delay.h>
;#include <stdlib.h>
;#include "uart.h"
;#include "sw.h"
;#include "dotmat.h"
;#include "clcd.h"
;#include "cli.h"
;#include "led7.h"
;
;extern char rx_buffer0[RX_BUFFER_SIZE0];
;extern unsigned int rx_wr_index0,rx_counter0;
;extern bit rx_buffer_overflow0; // This flag is set on USART0 Receiver buffer overflow
;extern cli_t cli;
;cli_t cli;
;
;void SystemInit(void);
;void user_uart_println(char *string);
;cli_status_t help_func(int argc, char **argv);
;cli_status_t blink_func(int argc, char **argv);
;cli_status_t led_func(int argc, char **argv);
;cli_status_t lcd_func(int argc, char **argv);
;cli_status_t led7_func(int argc, char **argv);
;cli_status_t show_func(int argc, char **argv);
;
;
;cmd_t cmd_tbl[] = { {"help",help_func},
;                    {"show",show_func},
;                    {"blink",blink_func},
;                    {"led",led_func},
;                    {"lcd",lcd_func},
;                    {"led7",led7_func}};

	.DSEG
_0x3:
	.BYTE 0x1D
;
;
;void main(void)
; 0000 0028 {

	.CSEG
_main:
; 0000 0029     SystemInit();
	RCALL _SystemInit
; 0000 002A     Uart0Init();
	CALL _Uart0Init
; 0000 002B     LedInit();
	RCALL _LedInit
; 0000 002C     DotMatInit();
	CALL _DotMatInit
; 0000 002D     Led7Init();
	CALL _Led7Init
; 0000 002E     LcdInit();
	CALL _LcdInit
; 0000 002F 
; 0000 0030     cli.println = user_uart_println;
	LDI  R30,LOW(_user_uart_println)
	LDI  R31,HIGH(_user_uart_println)
	STS  _cli,R30
	STS  _cli+1,R31
; 0000 0031     cli.cmd_tbl = cmd_tbl;
	LDI  R30,LOW(_cmd_tbl)
	LDI  R31,HIGH(_cmd_tbl)
	__PUTW1MN _cli,2
; 0000 0032     cli.cmd_cnt = sizeof(cmd_tbl)/sizeof(cmd_t);
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	__PUTW1MN _cli,4
; 0000 0033     cli_init(&cli);
	LDI  R26,LOW(_cli)
	LDI  R27,HIGH(_cli)
	CALL _cli_init
; 0000 0034 
; 0000 0035 
; 0000 0036     while(1)
_0x5:
; 0000 0037     {
; 0000 0038 
; 0000 0039         cli_process(&cli);
	LDI  R26,LOW(_cli)
	LDI  R27,HIGH(_cli)
	CALL _cli_process
; 0000 003A     }
	RJMP _0x5
; 0000 003B 
; 0000 003C }
_0x8:
	RJMP _0x8
;
;
;
;
;void SystemInit(void)
; 0000 0042 {
_SystemInit:
; 0000 0043     //---External I/O initialization
; 0000 0044 	LED_CON=0X00;       // LED GLCD Control bus
	LDI  R30,LOW(0)
	STS  32768,R30
; 0000 0045 	SET_CON=0X00;       // FND, Buzzer, RELAY Control bus
	STS  33024,R30
; 0000 0046 	LCD_CON=0X00;       // TLCD, GLCD Control bus
	CALL SUBOPT_0x0
; 0000 0047 	LCD_DATABUS=0X00;   // TLCD, GLCD, FND, Dotmatrix Data bus
; 0000 0048 	DOT_YELLOW=0X00;    // Dotmatrix Yellow LED
	LDI  R30,LOW(0)
	STS  33792,R30
; 0000 0049 	DOT_RED=0X00;       // Dotmatrix Yellow RED
	STS  34048,R30
; 0000 004A 	STEPMOR=0X00;       // Stepping Motor Control bus
	STS  34304,R30
; 0000 004B 	DCSERVO=0X00;       // DC, Servo Motor Control bus
	STS  34560,R30
; 0000 004C     //----------------------------------------
; 0000 004D     #asm("sei") // Global enable interrupts
	sei
; 0000 004E }
	RET
;
;
;void user_uart_println(char *string)
; 0000 0052 {
_user_uart_println:
; 0000 0053     int i = 0;
; 0000 0054     int size = strlen(string);
; 0000 0055     for(i=0;i<size;i++)
	CALL SUBOPT_0x1
;	*string -> Y+4
;	i -> R16,R17
;	size -> R18,R19
	__GETWRN 16,17,0
	CALL SUBOPT_0x2
	MOVW R18,R30
	__GETWRN 16,17,0
_0xA:
	__CPWRR 16,17,18,19
	BRGE _0xB
; 0000 0056     {
; 0000 0057         UartSend(string[i]);
	MOVW R30,R16
	CALL SUBOPT_0x3
	LD   R26,X
	CLR  R27
	CALL _UartSend
; 0000 0058     }
	__ADDWRN 16,17,1
	RJMP _0xA
_0xB:
; 0000 0059 }
	CALL __LOADLOCR4
	JMP  _0x20A0002
;
;cli_status_t help_func(int argc, char **argv)
; 0000 005C {
_help_func:
; 0000 005D     cli.println("HELP function executed");
	ST   -Y,R27
	ST   -Y,R26
;	argc -> Y+2
;	*argv -> Y+0
	__POINTW2MN _0xC,0
	CALL SUBOPT_0x4
; 0000 005E     return CLI_OK;
	LDI  R30,LOW(0)
	JMP  _0x20A0004
; 0000 005F }

	.DSEG
_0xC:
	.BYTE 0x17
;
;cli_status_t show_func(int argc, char **argv)
; 0000 0062 {

	.CSEG
_show_func:
; 0000 0063     cli.println("\rhelp: Help function \n\r");
	ST   -Y,R27
	ST   -Y,R26
;	argc -> Y+2
;	*argv -> Y+0
	__POINTW2MN _0xD,0
	CALL SUBOPT_0x4
; 0000 0064     cli.println("blink: Blink function \n\r");
	__POINTW2MN _0xD,24
	CALL SUBOPT_0x4
; 0000 0065     cli.println("led: Led function \n\r");
	__POINTW2MN _0xD,49
	CALL SUBOPT_0x4
; 0000 0066     cli.println("lcd: Lcd function \n\r");
	__POINTW2MN _0xD,70
	CALL SUBOPT_0x4
; 0000 0067     cli.println("led7: Led7 function \n\r");
	__POINTW2MN _0xD,91
	CALL SUBOPT_0x4
; 0000 0068 
; 0000 0069     return CLI_OK;
	LDI  R30,LOW(0)
	JMP  _0x20A0004
; 0000 006A }

	.DSEG
_0xD:
	.BYTE 0x72
;
;cli_status_t blink_func(int argc, char **argv)
; 0000 006D {

	.CSEG
_blink_func:
; 0000 006E     int value;
; 0000 006F     if(argc > 0)
	CALL SUBOPT_0x5
;	argc -> Y+4
;	*argv -> Y+2
;	value -> R16,R17
	BRGE _0xE
; 0000 0070     {
; 0000 0071         if(strcmp(argv[1], "-help") == 0)
	CALL SUBOPT_0x6
	__POINTW2MN _0x10,0
	CALL _strcmp
	CPI  R30,0
	BRNE _0xF
; 0000 0072         {
; 0000 0073             cli.println("BLINK help menu: \r<blink> <on/off> <value(1->8)>");
	__POINTW2MN _0x10,6
	CALL SUBOPT_0x4
; 0000 0074         }
; 0000 0075 
; 0000 0076         if(strcmp(argv[1], "on") == 0)
_0xF:
	CALL SUBOPT_0x6
	__POINTW2MN _0x10,55
	CALL _strcmp
	CPI  R30,0
	BRNE _0x11
; 0000 0077         {
; 0000 0078             value = atoi(argv[2]);
	CALL SUBOPT_0x7
	CALL _atoi
	MOVW R16,R30
; 0000 0079             if(value >= 0 && value < 10)
	TST  R17
	BRMI _0x13
	__CPWRN 16,17,10
	BRLT _0x14
_0x13:
	RJMP _0x12
_0x14:
; 0000 007A             {
; 0000 007B                 Led7Disp1(value);
	MOVW R26,R16
	CALL _Led7Disp1
; 0000 007C                 cli.println("echo: display ");
	__POINTW2MN _0x10,58
	CALL SUBOPT_0x4
; 0000 007D                 user_uart_println(argv[2]);
	CALL SUBOPT_0x7
	RCALL _user_uart_println
; 0000 007E             }
; 0000 007F 
; 0000 0080         }
_0x12:
; 0000 0081 
; 0000 0082     }
_0x11:
; 0000 0083     if(argc == 0)
_0xE:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BRNE _0x15
; 0000 0084     {
; 0000 0085         cli.println("BLINK function executed");
	__POINTW2MN _0x10,73
	CALL SUBOPT_0x4
; 0000 0086     }
; 0000 0087     return CLI_OK;
_0x15:
	LDI  R30,LOW(0)
	JMP  _0x20A0001
; 0000 0088 }

	.DSEG
_0x10:
	.BYTE 0x61
;
;
;cli_status_t led_func(int argc, char **argv)
; 0000 008C {

	.CSEG
_led_func:
; 0000 008D     int value;
; 0000 008E     char string [17]={0};
; 0000 008F     if(argc > 0)
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,17
	LDI  R24,17
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x16*2)
	LDI  R31,HIGH(_0x16*2)
	CALL __INITLOCB
	ST   -Y,R17
	ST   -Y,R16
;	argc -> Y+21
;	*argv -> Y+19
;	value -> R16,R17
;	string -> Y+2
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	CALL __CPW02
	BRLT PC+3
	JMP _0x17
; 0000 0090     {
; 0000 0091         if(strcmp(argv[1], "-help") == 0)
	CALL SUBOPT_0x8
	__POINTW2MN _0x19,0
	CALL _strcmp
	CPI  R30,0
	BRNE _0x18
; 0000 0092         {
; 0000 0093             cli.println("echo: Led help menu: \r<led> <on/off> <value(1->8)>");
	__POINTW2MN _0x19,6
	CALL SUBOPT_0x4
; 0000 0094         }
; 0000 0095 
; 0000 0096         if(strcmp(argv[1], "on") == 0)
_0x18:
	CALL SUBOPT_0x8
	__POINTW2MN _0x19,57
	CALL _strcmp
	CPI  R30,0
	BRNE _0x1A
; 0000 0097         {
; 0000 0098             value = atoi(argv[2]);
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
; 0000 0099             if(value > 0 && value < 9)
	BRGE _0x1C
	__CPWRN 16,17,9
	BRLT _0x1D
_0x1C:
	RJMP _0x1B
_0x1D:
; 0000 009A             {
; 0000 009B                 LedOn(value-1);
	MOV  R26,R16
	SUBI R26,LOW(1)
	RCALL _LedOn
; 0000 009C                 cli.println("echo: Turn on led ");
	__POINTW2MN _0x19,60
	CALL SUBOPT_0x4
; 0000 009D                 user_uart_println(argv[2]);
	CALL SUBOPT_0x9
	CALL SUBOPT_0xB
; 0000 009E                 strcpy(string,"Turn on led ");
	__POINTW2MN _0x19,79
	CALL SUBOPT_0xC
; 0000 009F                 strcat(string, argv[2]);
; 0000 00A0                 DisplayLCDLine1(string);
; 0000 00A1             }
; 0000 00A2 
; 0000 00A3             if(strcmp(argv[2], "all") == 0)
_0x1B:
	CALL SUBOPT_0x9
	ST   -Y,R27
	ST   -Y,R26
	__POINTW2MN _0x19,92
	CALL _strcmp
	CPI  R30,0
	BRNE _0x1E
; 0000 00A4             {
; 0000 00A5                 for(value = 0; value < 8; value++)
	__GETWRN 16,17,0
_0x20:
	__CPWRN 16,17,8
	BRGE _0x21
; 0000 00A6                 {
; 0000 00A7                     LedOn(value);
	MOV  R26,R16
	RCALL _LedOn
; 0000 00A8                 }
	__ADDWRN 16,17,1
	RJMP _0x20
_0x21:
; 0000 00A9                 cli.println("echo: All led was on");
	__POINTW2MN _0x19,96
	CALL SUBOPT_0x4
; 0000 00AA                 DisplayLCDLine1("Turn on all led");
	__POINTW2MN _0x19,117
	CALL _DisplayLCDLine1
; 0000 00AB             }
; 0000 00AC 
; 0000 00AD         }
_0x1E:
; 0000 00AE 
; 0000 00AF         if(strcmp(argv[1], "off") == 0)
_0x1A:
	CALL SUBOPT_0x8
	__POINTW2MN _0x19,133
	CALL _strcmp
	CPI  R30,0
	BRNE _0x22
; 0000 00B0         {
; 0000 00B1             value = atoi(argv[2]);
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
; 0000 00B2             if(value > 0 && value < 9)
	BRGE _0x24
	__CPWRN 16,17,9
	BRLT _0x25
_0x24:
	RJMP _0x23
_0x25:
; 0000 00B3             {
; 0000 00B4                 LedOff(value-1);
	MOV  R26,R16
	SUBI R26,LOW(1)
	RCALL _LedOff
; 0000 00B5                 cli.println("echo: Turn off led ");
	__POINTW2MN _0x19,137
	CALL SUBOPT_0x4
; 0000 00B6                 user_uart_println(argv[2]);
	CALL SUBOPT_0x9
	CALL SUBOPT_0xB
; 0000 00B7                 strcpy(string,"Turn off led ");
	__POINTW2MN _0x19,157
	CALL SUBOPT_0xC
; 0000 00B8                 strcat(string, argv[2]);
; 0000 00B9                 DisplayLCDLine1(string);
; 0000 00BA             }
; 0000 00BB 
; 0000 00BC             if(strcmp(argv[2], "all") == 0)
_0x23:
	CALL SUBOPT_0x9
	ST   -Y,R27
	ST   -Y,R26
	__POINTW2MN _0x19,171
	CALL _strcmp
	CPI  R30,0
	BRNE _0x26
; 0000 00BD             {
; 0000 00BE                 for(value = 0; value < 8; value++)
	__GETWRN 16,17,0
_0x28:
	__CPWRN 16,17,8
	BRGE _0x29
; 0000 00BF                 {
; 0000 00C0                     LedOff(value);
	MOV  R26,R16
	RCALL _LedOff
; 0000 00C1                 }
	__ADDWRN 16,17,1
	RJMP _0x28
_0x29:
; 0000 00C2                 cli.println("echo: All led was off");
	__POINTW2MN _0x19,175
	CALL SUBOPT_0x4
; 0000 00C3                 DisplayLCDLine1("Turn off all led");
	__POINTW2MN _0x19,197
	CALL _DisplayLCDLine1
; 0000 00C4             }
; 0000 00C5         }
_0x26:
; 0000 00C6 
; 0000 00C7 
; 0000 00C8     }
_0x22:
; 0000 00C9     if(argc == 0)
_0x17:
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	SBIW R30,0
	BRNE _0x2A
; 0000 00CA     {
; 0000 00CB         cli.println("Led function executed");
	__POINTW2MN _0x19,214
	CALL SUBOPT_0x4
; 0000 00CC     }
; 0000 00CD     return CLI_OK;
_0x2A:
	LDI  R30,LOW(0)
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,23
	RET
; 0000 00CE }

	.DSEG
_0x19:
	.BYTE 0xEC
;
;
;
;cli_status_t lcd_func(int argc, char **argv)
; 0000 00D3 {

	.CSEG
_lcd_func:
; 0000 00D4     int i,value, cnt=0;
; 0000 00D5     char string1[17] ={0};
; 0000 00D6     char string2[17] ={0};
; 0000 00D7     if(argc > 0)
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,34
	LDI  R24,34
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x2B*2)
	LDI  R31,HIGH(_0x2B*2)
	CALL __INITLOCB
	CALL __SAVELOCR6
;	argc -> Y+42
;	*argv -> Y+40
;	i -> R16,R17
;	value -> R18,R19
;	cnt -> R20,R21
;	string1 -> Y+23
;	string2 -> Y+6
	__GETWRN 20,21,0
	LDD  R26,Y+42
	LDD  R27,Y+42+1
	CALL __CPW02
	BRLT PC+3
	JMP _0x2C
; 0000 00D8     {
; 0000 00D9         if(strcmp(argv[1], "-help") == 0)
	CALL SUBOPT_0xD
	__POINTW2MN _0x2E,0
	CALL _strcmp
	CPI  R30,0
	BRNE _0x2D
; 0000 00DA         {
; 0000 00DB             cli.println("echo: Lcd help menu: \r<lcd> <disp> <text>");
	__POINTW2MN _0x2E,6
	CALL SUBOPT_0x4
; 0000 00DC         }
; 0000 00DD 
; 0000 00DE         if(strcmp(argv[1], "disp") == 0)
_0x2D:
	CALL SUBOPT_0xD
	__POINTW2MN _0x2E,48
	CALL _strcmp
	CPI  R30,0
	BREQ PC+3
	JMP _0x2F
; 0000 00DF         {
; 0000 00E0             value = 0;
	__GETWRN 18,19,0
; 0000 00E1             for(i=2; i< argc; i++)
	__GETWRN 16,17,2
_0x31:
	LDD  R30,Y+42
	LDD  R31,Y+42+1
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x32
; 0000 00E2             {
; 0000 00E3              value += strlen(argv[i]);
	CALL SUBOPT_0xE
	MOVW R26,R30
	CALL _strlen
	__ADDWRR 18,19,30,31
; 0000 00E4              if(value < 17)
	__CPWRN 18,19,17
	BRGE _0x33
; 0000 00E5              {
; 0000 00E6 
; 0000 00E7                 string1[cnt] = argv[i][cnt];
	MOVW R30,R20
	MOVW R26,R28
	ADIW R26,23
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	CALL SUBOPT_0xE
	ADD  R30,R20
	ADC  R31,R21
	LD   R30,Z
	MOVW R26,R0
	ST   X,R30
; 0000 00E8              }
; 0000 00E9              if(value >16 && value < 23)
_0x33:
	__CPWRN 18,19,17
	BRLT _0x35
	__CPWRN 18,19,23
	BRLT _0x36
_0x35:
	RJMP _0x34
_0x36:
; 0000 00EA              {
; 0000 00EB                 strcat(string2,argv[i]);
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	LDD  R26,Y+42
	LDD  R27,Y+42+1
	CALL SUBOPT_0xF
	MOVW R26,R30
	CALL _strcat
; 0000 00EC              }
; 0000 00ED             }
_0x34:
	__ADDWRN 16,17,1
	RJMP _0x31
_0x32:
; 0000 00EE 
; 0000 00EF             DisplayLCDLine1(string1);
	MOVW R26,R28
	ADIW R26,23
	CALL _DisplayLCDLine1
; 0000 00F0 
; 0000 00F1             if(value > 16)
	__CPWRN 18,19,17
	BRLT _0x37
; 0000 00F2             {
; 0000 00F3                 DisplayLCDLine2(string2);
	MOVW R26,R28
	ADIW R26,6
	CALL _DisplayLCDLine2
; 0000 00F4             }
; 0000 00F5 
; 0000 00F6             cli.println("echo: Display on LCD");
_0x37:
	__POINTW2MN _0x2E,53
	CALL SUBOPT_0x4
; 0000 00F7         }
; 0000 00F8     return CLI_OK;
_0x2F:
	LDI  R30,LOW(0)
; 0000 00F9     }
; 0000 00FA }
_0x2C:
_0x20A000D:
	CALL __LOADLOCR6
	ADIW R28,44
	RET

	.DSEG
_0x2E:
	.BYTE 0x4A
;
;
;cli_status_t led7_func(int argc, char **argv)
; 0000 00FE {

	.CSEG
_led7_func:
; 0000 00FF     int value;
; 0000 0100     if(argc > 0)
	CALL SUBOPT_0x5
;	argc -> Y+4
;	*argv -> Y+2
;	value -> R16,R17
	BRGE _0x38
; 0000 0101     {
; 0000 0102         if(strcmp(argv[1], "-help") == 0)
	CALL SUBOPT_0x6
	__POINTW2MN _0x3A,0
	CALL _strcmp
	CPI  R30,0
	BRNE _0x39
; 0000 0103         {
; 0000 0104             cli.println("LED7 help menu: \r<led7> <disp> <value(1->8)>");
	__POINTW2MN _0x3A,6
	CALL SUBOPT_0x4
; 0000 0105         }
; 0000 0106 
; 0000 0107         if(strcmp(argv[1], "disp") == 0)
_0x39:
	CALL SUBOPT_0x6
	__POINTW2MN _0x3A,51
	CALL _strcmp
	CPI  R30,0
	BRNE _0x3B
; 0000 0108         {
; 0000 0109             value = atoi(argv[2]);
	CALL SUBOPT_0x7
	CALL _atoi
	MOVW R16,R30
; 0000 010A             if(value >= 0 && value < 10)
	TST  R17
	BRMI _0x3D
	__CPWRN 16,17,10
	BRLT _0x3E
_0x3D:
	RJMP _0x3C
_0x3E:
; 0000 010B             {
; 0000 010C                 Led7Disp1(value);
	MOVW R26,R16
	CALL _Led7Disp1
; 0000 010D                 cli.println("echo: display ");
	__POINTW2MN _0x3A,56
	CALL SUBOPT_0x4
; 0000 010E                 user_uart_println(argv[2]);
	CALL SUBOPT_0x7
	RCALL _user_uart_println
; 0000 010F             }
; 0000 0110 
; 0000 0111         }
_0x3C:
; 0000 0112 
; 0000 0113     }
_0x3B:
; 0000 0114     if(argc == 0)
_0x38:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BRNE _0x3F
; 0000 0115     {
; 0000 0116         cli.println("Led7 function executed");
	__POINTW2MN _0x3A,71
	CALL SUBOPT_0x4
; 0000 0117     }
; 0000 0118     return CLI_OK;
_0x3F:
	LDI  R30,LOW(0)
	JMP  _0x20A0001
; 0000 0119 }

	.DSEG
_0x3A:
	.BYTE 0x5E
;/*****************************************************************************
; *   @file
; *   @brief  Source file of
; *   @author Kyle
; *   @version 1.0.0
; *   @note :    1.
; *              2.
; *              3.
;********************************************************************************/
;
;
;/******************************************************************************/
;/***************************** Include Files **********************************/
;/******************************************************************************/
;#include "sw.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;
;/******************************************************************************/
;/************************* Global variable declaration ************************/
;/******************************************************************************/
;extern unsigned int LedCtrl;
;unsigned int LedCtrl = 0;
;
;/******************************************************************************/
;/************************** Functions Implementation **************************/
;/******************************************************************************/
;void LedTurn()
; 0001 001B {

	.CSEG
; 0001 001C     static unsigned char SW=0;
; 0001 001D     SW=PINB;
; 0001 001E 
; 0001 001F     switch(SW)
; 0001 0020     {
; 0001 0021         case 0xfe:LED_CON=0x01;break;
; 0001 0022         case 0xfd:LED_CON=0x02;break;
; 0001 0023         case 0xfb:LED_CON=0x04;break;
; 0001 0024         case 0xf7:LED_CON=0X08;break;
; 0001 0025         case 0xef:LED_CON=0X10;break;
; 0001 0026         case 0xdf:LED_CON=0X20;break;
; 0001 0027         case 0xbf:LED_CON=0X40;break;
; 0001 0028         case 0x7f:LED_CON=0X80;break;
; 0001 0029         default:LED_CON=0X00;break;
; 0001 002A     }
; 0001 002B }
;
;
;void LedOn(enum LedEnum led)
; 0001 002F {
_LedOn:
; 0001 0030 LedCtrl |= (0x01 << led);
	CALL SUBOPT_0x10
;	led -> Y+0
	LDS  R26,_LedCtrl
	LDS  R27,_LedCtrl+1
	OR   R30,R26
	OR   R31,R27
	CALL SUBOPT_0x11
; 0001 0031 LED_CON  = LedCtrl;
; 0001 0032 }
	JMP  _0x20A000A
;
;void LedOff(enum LedEnum led)
; 0001 0035 {
_LedOff:
; 0001 0036 LedCtrl &= ~(0x01 << led);
	CALL SUBOPT_0x10
;	led -> Y+0
	COM  R30
	COM  R31
	LDS  R26,_LedCtrl
	LDS  R27,_LedCtrl+1
	AND  R30,R26
	AND  R31,R27
	CALL SUBOPT_0x11
; 0001 0037 LED_CON  = LedCtrl;
; 0001 0038 }
	JMP  _0x20A000A
;
;void LedInit()
; 0001 003B {
_LedInit:
; 0001 003C     DDRB=0x00;  //PORTB INPUTPORT Set
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0001 003D     MCUCR=0X80; //enable External memory and I/O control
	JMP  _0x20A0006
; 0001 003E 
; 0001 003F }
;/*****************************************************************************
; *   @file
; *   @brief  Source file of
; *   @author Kyle
; *   @version 1.0.0
; *   @note :    1.
; *              2.
; *              3.
;********************************************************************************/
;
;
;/******************************************************************************/
;/***************************** Include Files **********************************/
;/******************************************************************************/
;#include "uart.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;
;/******************************************************************************/
;/************************* Global variable declaration ************************/
;/******************************************************************************/
;extern char rx_buffer0[RX_BUFFER_SIZE0];
;extern unsigned int rx_wr_index0,rx_counter0;
;extern bit rx_buffer_overflow0, cmd_enter; // This flag is set on USART0 Receiver buffer overflow
;extern cli_t cli;
;
;char rx_buffer0[RX_BUFFER_SIZE0];
;unsigned int rx_wr_index0,rx_counter0;
;bit rx_buffer_overflow0, cmd_enter;
;
;
;/******************************************************************************/
;/************************** Functions Implementation **************************/
;/******************************************************************************/
;void UartSend( unsigned int data )
; 0002 0022 {

	.CSEG
_UartSend:
; 0002 0023 /* Wait for empty transmit buffer */
; 0002 0024 while ( !( UCSR0A & (1<<UDRE)) );
	ST   -Y,R27
	ST   -Y,R26
;	data -> Y+0
_0x40003:
	SBIS 0xB,5
	RJMP _0x40003
; 0002 0025 /* Copy 9th bit to TXB8 */
; 0002 0026 UCSR0B &= ~(1<<TXB8);
	CBI  0xA,0
; 0002 0027 if ( data & 0x0100 )
	LDD  R30,Y+1
	ANDI R30,LOW(0x1)
	BREQ _0x40006
; 0002 0028 UCSR0B |= (1<<TXB8);
	SBI  0xA,0
; 0002 0029 /* Put data into buffer, sends the data */
; 0002 002A UDR0 = data;
_0x40006:
	LD   R30,Y
	OUT  0xC,R30
; 0002 002B }
	JMP  _0x20A0005
;
;
;
;interrupt [USART0_RXC] void usart0_rx_isr(void)// USART0 Receiver interrupt service routine
; 0002 0030 {
_usart0_rx_isr:
	CALL SUBOPT_0x12
; 0002 0031 char status,data;
; 0002 0032 status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0002 0033 data=UDR0;
	IN   R16,12
; 0002 0034 UartSend(data);
	MOV  R26,R16
	CLR  R27
	RCALL _UartSend
; 0002 0035 //cli_put(&cli, data);
; 0002 0036 
; 0002 0037 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x40007
; 0002 0038    {
; 0002 0039         cli_put(&cli, data);
	LDI  R30,LOW(_cli)
	LDI  R31,HIGH(_cli)
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R16
	CALL _cli_put
; 0002 003A    }
; 0002 003B 
; 0002 003C }
_0x40007:
	LD   R16,Y+
	LD   R17,Y+
	CALL SUBOPT_0x13
	RETI
;
;void Uart0Init()
; 0002 003F {
_Uart0Init:
; 0002 0040     // USART0 initialization
; 0002 0041     UCSR0A=0x00; // Communication Parameters: 8 Data, 1 Stop, No Parity
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0002 0042     UCSR0B=0x98; // USART0 Receiver: On
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0002 0043     UCSR0C=0x06; // USART0 Transmitter: On
	LDI  R30,LOW(6)
	STS  149,R30
; 0002 0044     UBRR0H=0x00; // USART0 Mode: Asynchronous
	LDI  R30,LOW(0)
	STS  144,R30
; 0002 0045     UBRR0L=0x67;  // USART0 Baud Rate: 9600
	LDI  R30,LOW(103)
	OUT  0x9,R30
; 0002 0046 }
	RET
;
;void UartTest()
; 0002 0049 {
; 0002 004A    int i=0;
; 0002 004B    if(rx_buffer_overflow0)
;	i -> R16,R17
; 0002 004C    {
; 0002 004D         for(i=0;i<8;i++)
; 0002 004E         {
; 0002 004F             UartSend(rx_buffer0[i]);
; 0002 0050         }
; 0002 0051 
; 0002 0052         rx_buffer_overflow0=0;
; 0002 0053         UartSend( '\n' );
; 0002 0054     }
; 0002 0055 }
;
;
;
;/*****************************************************************************
; *   @file
; *   @brief  Source file of
; *   @author Kyle
; *   @version 1.0.0
; *   @note :    1.
; *              2.
; *              3.
;********************************************************************************/
;
;
;/******************************************************************************/
;/***************************** Include Files **********************************/
;/******************************************************************************/
;#include "dotmat.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;
;/******************************************************************************/
;/************************* Global variable declaration ************************/
;/******************************************************************************/
;//------------DOT MATRIX-----------------------------
;const unsigned char vertical[]={0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80};

	.DSEG
;const unsigned char english[28][8]={
;0xe7,0xdb,0xbd,0xbd,0x81,0xbd,0xbd,0xbd,     // A
;0xc1,0xbd,0xbd,0xc1,0xdd,0xbd,0xbd,0xc1,     // B
;0xc3,0xbd,0xfd,0xfd,0xfd,0xbd,0xbd,0xc3,     // C
;0xc1,0xbd,0xbd,0xbd,0xbd,0xbd,0xbd,0xc1,     // D
;0x81,0xfd,0xfd,0x81,0xfd,0xfd,0xfd,0x81,     // E
;0x81,0xfd,0xfd,0x81,0xfd,0xfd,0xfd,0xfd,     // F
;0xe7,0xd9,0xbd,0xfd,0x8d,0xbd,0xdb,0xe7,     // G
;0xbd,0xbd,0xbd,0x81,0xbd,0xbd,0xbd,0xbd,     // H
;0xc3,0xe7,0xe7,0xe7,0xe7,0xe7,0xe7,0xc3,     // I
;0xc3,0xe7,0xe7,0xe7,0xe7,0xe5,0xf5,0xfb,     // J
;0xdd,0xed,0xf5,0xf9,0xf5,0xed,0xdd,0xbd,     // K
;0xfd,0xfd,0xfd,0xfd,0xfd,0xfd,0xfd,0x81,     // L
;0xbd,0x99,0xa5,0xa5,0xa5,0xbd,0xbd,0xbd,     // M
;0xbd,0xbd,0xb9,0xb5,0xad,0x9d,0xbd,0xbd,     // N
;0xe7,0xdb,0xbd,0xbd,0xbd,0xbd,0xdb,0xe7,     // O
;0xe1,0xdd,0xdd,0xdd,0xe1,0xfd,0xfd,0xfd,     // P
;0xe3,0xdd,0xdd,0xdd,0xd5,0xcd,0xc3,0xbf,     // Q
;0xc1,0xbd,0xbd,0xc1,0xdd,0xbd,0xbd,0xbd,     // R
;0xc3,0xbd,0xfd,0xc3,0xbf,0xbf,0xbd,0xc3,     // S
;0x81,0xe7,0xe7,0xe7,0xe7,0xe7,0xe7,0xe7,     // T
;0xbd,0xbd,0xbd,0xbd,0xbd,0xbd,0xbd,0xc3,     // U
;0xbd,0xbd,0xbd,0xbd,0xbd,0xbd,0xdb,0xe7,     // V
;0xbd,0xbd,0xbd,0xbd,0xa5,0xa5,0xa5,0x99,     // W
;0xbd,0xbd,0xd9,0xe7,0xe7,0xdb,0xbd,0xbd,     // X
;0xbd,0xbd,0xbd,0xdb,0xe7,0xe7,0xe7,0xe7,     // Y
;0x81,0xbf,0xdf,0xef,0xf7,0xfb,0xfd,0x81,     // Z
;};
;
;static volatile int Toggle=0;
;static volatile int num_cnt=0;
;extern char DispChar;
;char DispChar;
;
;
;/******************************************************************************/
;/************************** Functions Implementation **************************/
;/******************************************************************************/
;
;
;void Dotmatrix_Timer()
; 0003 003F {

	.CSEG
; 0003 0040 
; 0003 0041 	static unsigned int cnt=0;
; 0003 0042 	cnt++;
; 0003 0043 	if(cnt>1000) //1? ??
; 0003 0044 	{
; 0003 0045 	num_cnt++;
; 0003 0046 	cnt=0;
; 0003 0047 		if(num_cnt==27)
; 0003 0048 		{
; 0003 0049 			Toggle++;
; 0003 004A 			num_cnt=0;
; 0003 004B 			if(Toggle==2)
; 0003 004C 			{
; 0003 004D 				Toggle=0;
; 0003 004E 			}
; 0003 004F 		}
; 0003 0050   	}
; 0003 0051 }
;void DotmatrixTest()
; 0003 0053 {
; 0003 0054 
; 0003 0055 	int i=0;
; 0003 0056     for(i=0;i<8;i++)
;	i -> R16,R17
; 0003 0057     {
; 0003 0058         switch(Toggle)
; 0003 0059         {
; 0003 005A             case 0:
; 0003 005B             DOT_YELLOW=~english[num_cnt][i]; //Orange LED ?? ??(Horizontal)
; 0003 005C             DOT_RED=~0XFF;                   //Red LED ?? ??(Horizontal)
; 0003 005D             LCD_DATABUS=vertical[i];         // ?? ??(Vertical)
; 0003 005E             delay_ms(1); 				     //1ms?? ???? ?????
; 0003 005F             break;
; 0003 0060             case 1:
; 0003 0061             DOT_YELLOW=~0xff;     //Orange LED ?? ??(Horizontal)
; 0003 0062             DOT_RED=~english[num_cnt][i];//Red LED ?? ??(Horizontal)
; 0003 0063             LCD_DATABUS=vertical[i];
; 0003 0064             delay_ms(1);             //1ms?? ???? ?????
; 0003 0065             break;
; 0003 0066         }
; 0003 0067 	}
; 0003 0068 }
;
;
;void DotMatInit(void)
; 0003 006C {
_DotMatInit:
; 0003 006D     DDRB=0x00;  //PORTB INPUTPORT Set
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0003 006E     MCUCR=0X80; //enable External memory and I/O control
	JMP  _0x20A0006
; 0003 006F 
; 0003 0070 //    TCCR0=0x04; //Prescaler 64 ??
; 0003 0071 //    TCNT0=0X06; //??? ???? ??
; 0003 0072 //    TIMSK=0X01; //TIMER 0 ?????? ??
; 0003 0073 }
;
;
;void DotMatDisp(char c)
; 0003 0077 {
; 0003 0078 	int i=0;
; 0003 0079     int num_value = 0;
; 0003 007A     DDRB=0x00;  //PORTB INPUTPORT Set
;	c -> Y+4
;	i -> R16,R17
;	num_value -> R18,R19
; 0003 007B     MCUCR=0X80; //enable External memory and I/O control
; 0003 007C 
; 0003 007D     TCCR0=0x04; //Prescaler 64 ??
; 0003 007E     TCNT0=0X06; //??? ???? ??
; 0003 007F     TIMSK=0X01; //TIMER 0 ?????? ??
; 0003 0080 
; 0003 0081 
; 0003 0082     DispChar = c;
; 0003 0083     num_value = (int) (c - '0');
; 0003 0084 
; 0003 0085     for(i=0;i<8;i++)
; 0003 0086     {
; 0003 0087         DOT_YELLOW=~english[num_value][i]; //Orange LED ?? ??(Horizontal)
; 0003 0088         DOT_RED=~0XFF;                   //Red LED ?? ??(Horizontal)
; 0003 0089         LCD_DATABUS=vertical[i];         // ?? ??(Vertical)
; 0003 008A         delay_ms(1);
; 0003 008B     }
; 0003 008C }
;
;void DotMatRefresh(void)
; 0003 008F {
_DotMatRefresh:
; 0003 0090     int i=0;
; 0003 0091     int num_value = 0;
; 0003 0092     DDRB=0x00;  //PORTB INPUTPORT Set
	CALL __SAVELOCR4
;	i -> R16,R17
;	num_value -> R18,R19
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0003 0093     MCUCR=0X80; //enable External memory and I/O control
	LDI  R30,LOW(128)
	OUT  0x35,R30
; 0003 0094 
; 0003 0095     num_value = (int) (DispChar - '0');
	LDS  R30,_DispChar
	LDI  R31,0
	SBIW R30,48
	MOVW R18,R30
; 0003 0096 
; 0003 0097     for(i=0;i<8;i++)
	__GETWRN 16,17,0
_0x60014:
	__CPWRN 16,17,8
	BRGE _0x60015
; 0003 0098     {
; 0003 0099         DOT_YELLOW=~english[num_value][i]; //Orange LED ?? ??(Horizontal)
	MOVW R30,R18
	CALL __LSLW3
	SUBI R30,LOW(-_english)
	SBCI R31,HIGH(-_english)
	ADD  R30,R16
	ADC  R31,R17
	LD   R30,Z
	COM  R30
	STS  33792,R30
; 0003 009A         DOT_RED=~0XFF;                   //Red LED ?? ??(Horizontal)
	LDI  R30,LOW(0)
	STS  34048,R30
; 0003 009B         LCD_DATABUS=vertical[i];         // ?? ??(Vertical)
	LDI  R26,LOW(_vertical)
	LDI  R27,HIGH(_vertical)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	STS  33536,R30
; 0003 009C         delay_ms(1);
	CALL SUBOPT_0x14
; 0003 009D     }
	__ADDWRN 16,17,1
	RJMP _0x60014
_0x60015:
; 0003 009E 
; 0003 009F }
	CALL __LOADLOCR4
	JMP  _0x20A0004
;/*****************************************************************************
; *   @file
; *   @brief  Source file of
; *   @author Kyle
; *   @version 1.0.0
; *   @note :    1.
; *              2.
; *              3.
;********************************************************************************/
;
;
;/******************************************************************************/
;/***************************** Include Files **********************************/
;/******************************************************************************/
;#include "clcd.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;
;/******************************************************************************/
;/************************* Global variable declaration ************************/
;/******************************************************************************/
;extern int num_cnt1;
;extern int num_cnt2;
;
;//static int Toggle=0;
;int num_cnt1=0;
;int num_cnt2=6;

	.DSEG
;unsigned char con=0;
;
;
;flash char str[11][17]={        "===LKEMBEDDED===",
;                                 "====  WWW. =====",
;                                "== LKEMBEDDED.==",
;                                "==== CO.KR =====",
;                                "   Education    ",
;                                "   Development  ",
;                                "  AVR Dev & EDU ",
;                                "  PIC Dev & EDU ",
;                                "  ARM Dev & EDU ",
;                                " PADS Dev & EDU ",
;                                "   Cirquit EDU  "
;                                };
;
;/******************************************************************************/
;/************************** Functions Implementation **************************/
;/******************************************************************************/
;void DisplayClr(void);
;void DisplayClrLine1(void);
;void DisplayClrLine2(void);
;
;
;
;void DisplayLCDLine1(char *string)
; 0004 0034 {

	.CSEG
_DisplayLCDLine1:
; 0004 0035 
; 0004 0036     int size = strlen(string);
; 0004 0037     int i=0;
; 0004 0038     DisplayClrLine1();
	CALL SUBOPT_0x1
;	*string -> Y+4
;	size -> R16,R17
;	i -> R18,R19
	CALL SUBOPT_0x2
	MOVW R16,R30
	__GETWRN 18,19,0
	RCALL _DisplayClrLine1
; 0004 0039     clcd_line1();
	RCALL _clcd_line1
; 0004 003A 	for(i=0; i<size; ++i){dsp_str_TLCD(' ');}
	__GETWRN 18,19,0
_0x80005:
	__CPWRR 18,19,16,17
	BRGE _0x80006
	LDI  R26,LOW(32)
	RCALL _dsp_str_TLCD
	__ADDWRN 18,19,1
	RJMP _0x80005
_0x80006:
; 0004 003B     clcd_line1();
	RCALL _clcd_line1
; 0004 003C     for(i=0; i<size; ++i){dsp_str_TLCD(string[i]);}
	__GETWRN 18,19,0
_0x80008:
	__CPWRR 18,19,16,17
	BRGE _0x80009
	MOVW R30,R18
	CALL SUBOPT_0x3
	LD   R26,X
	RCALL _dsp_str_TLCD
	__ADDWRN 18,19,1
	RJMP _0x80008
_0x80009:
; 0004 003D }
	CALL __LOADLOCR4
	JMP  _0x20A0002
;
;void DisplayLCDLine2(char *string)
; 0004 0040 {
_DisplayLCDLine2:
; 0004 0041 	int size = strlen(string);
; 0004 0042     int i=0;
; 0004 0043     DisplayClrLine2();
	CALL SUBOPT_0x1
;	*string -> Y+4
;	size -> R16,R17
;	i -> R18,R19
	CALL SUBOPT_0x2
	MOVW R16,R30
	__GETWRN 18,19,0
	RCALL _DisplayClrLine2
; 0004 0044 	clcd_line2();
	RCALL _clcd_line2
; 0004 0045     for(i=0; i<size; ++i){dsp_str_TLCD(' ');}
	__GETWRN 18,19,0
_0x8000B:
	__CPWRR 18,19,16,17
	BRGE _0x8000C
	LDI  R26,LOW(32)
	RCALL _dsp_str_TLCD
	__ADDWRN 18,19,1
	RJMP _0x8000B
_0x8000C:
; 0004 0046     clcd_line2();
	RCALL _clcd_line2
; 0004 0047 	for(i=0; i<size; ++i){dsp_str_TLCD(string[i]);}
	__GETWRN 18,19,0
_0x8000E:
	__CPWRR 18,19,16,17
	BRGE _0x8000F
	MOVW R30,R18
	CALL SUBOPT_0x3
	LD   R26,X
	RCALL _dsp_str_TLCD
	__ADDWRN 18,19,1
	RJMP _0x8000E
_0x8000F:
; 0004 0048 }
	CALL __LOADLOCR4
	JMP  _0x20A0002
;
;void DisplayTest(void)
; 0004 004B {
; 0004 004C 
; 0004 004D 	int i=0;
; 0004 004E 	clcd_line1();
;	i -> R16,R17
; 0004 004F 	for(i=0; i<16; ++i){dsp_str_TLCD(str[num_cnt1][i]);}
; 0004 0050 
; 0004 0051 	clcd_line2();
; 0004 0052 	for(i=0; i<16; ++i){dsp_str_TLCD(str[num_cnt2][i]);}
; 0004 0053 
; 0004 0054 }
;
;void DisplayClr(void)
; 0004 0057 {
; 0004 0058 
; 0004 0059 	int i=0;
; 0004 005A 	clcd_line1();
;	i -> R16,R17
; 0004 005B 	for(i=0; i<16; ++i){dsp_str_TLCD(' ');}
; 0004 005C 
; 0004 005D 	clcd_line2();
; 0004 005E 	for(i=0; i<16; ++i){dsp_str_TLCD(' ');}
; 0004 005F 
; 0004 0060 }
;
;void DisplayClrLine1(void)
; 0004 0063 {
_DisplayClrLine1:
; 0004 0064 	int i=0;
; 0004 0065 	clcd_line1();
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
	RCALL _clcd_line1
; 0004 0066 	for(i=0; i<16; ++i){dsp_str_TLCD(' ');}
	__GETWRN 16,17,0
_0x8001D:
	__CPWRN 16,17,16
	BRGE _0x8001E
	LDI  R26,LOW(32)
	RCALL _dsp_str_TLCD
	__ADDWRN 16,17,1
	RJMP _0x8001D
_0x8001E:
; 0004 0067 
; 0004 0068 }
	RJMP _0x20A000C
;
;void DisplayClrLine2(void)
; 0004 006B {
_DisplayClrLine2:
; 0004 006C 
; 0004 006D 	int i=0;
; 0004 006E 	clcd_line2();
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
	RCALL _clcd_line2
; 0004 006F 	for(i=0; i<16; ++i){dsp_str_TLCD(' ');}
	__GETWRN 16,17,0
_0x80020:
	__CPWRN 16,17,16
	BRGE _0x80021
	LDI  R26,LOW(32)
	RCALL _dsp_str_TLCD
	__ADDWRN 16,17,1
	RJMP _0x80020
_0x80021:
; 0004 0070 
; 0004 0071 }
_0x20A000C:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void clcd_line1(void)
; 0004 0074 {
_clcd_line1:
; 0004 0075     dsp_cmd_TLCD(0x80);
	LDI  R26,LOW(128)
	RJMP _0x20A000B
; 0004 0076 } //line1
;
;
;void clcd_line2(void)
; 0004 007A {
_clcd_line2:
; 0004 007B     dsp_cmd_TLCD(0XC0);
	LDI  R26,LOW(192)
_0x20A000B:
	RCALL _dsp_cmd_TLCD
; 0004 007C } //line2
	RET
;
;
;void dsp_str_TLCD(char n)
; 0004 0080 {
_dsp_str_TLCD:
; 0004 0081     LCD_CON=(con|=0x10);    // E=0, RS=1
	ST   -Y,R26
;	n -> Y+0
	MOV  R30,R5
	ORI  R30,0x10
	CALL SUBOPT_0x15
; 0004 0082     LCD_DATABUS=n;          // 8bit OUTPUT DATA
; 0004 0083     LCD_CON=(con|=0x50);    // E=1, RS=1
	ORI  R30,LOW(0x50)
	RJMP _0x20A0009
; 0004 0084     delay_us(1);
; 0004 0085     LCD_CON=(con&=~0x40);   // E=0; RS=1;
; 0004 0086     delay_us(40);
; 0004 0087 }
;
;void dsp_cmd_TLCD(char n)
; 0004 008A {
_dsp_cmd_TLCD:
; 0004 008B     LCD_CON=(con&=~0x30);      //E=0, RS=0
	ST   -Y,R26
;	n -> Y+0
	MOV  R30,R5
	ANDI R30,LOW(0xCF)
	CALL SUBOPT_0x15
; 0004 008C     LCD_DATABUS=n;             //8bit OUTPUT DATA=0;
; 0004 008D     LCD_CON=(con|=0X40);       // E=1, RS=0
	ORI  R30,0x40
_0x20A0009:
	MOV  R5,R30
	STS  33280,R30
; 0004 008E     delay_us(1);
	__DELAY_USB 5
; 0004 008F     LCD_CON=(con&=~0X40);      // E=0, RS=0
	MOV  R30,R5
	ANDI R30,0xBF
	MOV  R5,R30
	STS  33280,R30
; 0004 0090     delay_us(40);
	__DELAY_USB 213
; 0004 0091 }
_0x20A000A:
	ADIW R28,1
	RET
;
;void LcdInit() //16x2line
; 0004 0094 {
_LcdInit:
; 0004 0095 //    TCCR0=0X04;
; 0004 0096 //	TCNT0=6;
; 0004 0097 //	TIMSK=0X01;
; 0004 0098 //	SREG=0X80;
; 0004 0099 
; 0004 009A     LCD_CON=0X00;
	CALL SUBOPT_0x0
; 0004 009B     LCD_DATABUS=0X00;
; 0004 009C     //lcd_dt=0; lcd_rw=lcd_rs=lcd_en=0;                                                              Ʈ
; 0004 009D     delay_ms(10); dsp_cmd_TLCD(0x30); //8bit mode
	LDI  R26,LOW(10)
	CALL SUBOPT_0x16
; 0004 009E     delay_ms(5);  dsp_cmd_TLCD(0x30);
	LDI  R26,LOW(5)
	CALL SUBOPT_0x16
; 0004 009F     delay_ms(1);  dsp_cmd_TLCD(0x30);
	CALL SUBOPT_0x14
	LDI  R26,LOW(48)
	RCALL _dsp_cmd_TLCD
; 0004 00A0     delay_ms(5);  dsp_cmd_TLCD(0x38); //function set
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
	LDI  R26,LOW(56)
	RCALL _dsp_cmd_TLCD
; 0004 00A1     dsp_cmd_TLCD(0x0c); //display on/off
	LDI  R26,LOW(12)
	RCALL _dsp_cmd_TLCD
; 0004 00A2     dsp_cmd_TLCD(0x14); //cursor/display
	LDI  R26,LOW(20)
	RCALL _dsp_cmd_TLCD
; 0004 00A3     dsp_cmd_TLCD(0x06); //entry mode
	LDI  R26,LOW(6)
	RCALL _dsp_cmd_TLCD
; 0004 00A4     dsp_cmd_TLCD(0x01); delay_ms(2); //display clear
	LDI  R26,LOW(1)
	RCALL _dsp_cmd_TLCD
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
; 0004 00A5 }
	RET
;
;
;/*****************************************************************************
; *   @file
; *   @brief  Source file of
; *   @author Kyle
; *   @version 1.0.0
; *   @note :    1.
; *              2.
; *              3.
;********************************************************************************/
;
;
;/******************************************************************************/
;/***************************** Include Files **********************************/
;/******************************************************************************/
;#include "uart.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include "dotmat.h"
;#include "clcd.h"
;/******************************************************************************/
;/************************* Global variable declaration ************************/
;/******************************************************************************/
;extern int num_cnt1;
;extern int num_cnt2;
;
;/******************************************************************************/
;/************************** Functions Implementation **************************/
;/******************************************************************************/
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0005 001E {

	.CSEG
_timer0_ovf_isr:
	CALL SUBOPT_0x12
; 0005 001F     //Dotmatrix_Timer();
; 0005 0020     DotMatRefresh();
	CALL _DotMatRefresh
; 0005 0021     TCNT0+=0x06;
	IN   R30,0x32
	SUBI R30,-LOW(6)
	OUT  0x32,R30
; 0005 0022 }
	CALL SUBOPT_0x13
	RETI
;
;
;
;//// Timer 0 overflow interrupt service routine
;//interrupt [TIM1_OVF] void timer1_ovf_isr(void)
;//{
;//	static unsigned int cnt,cnt2=0;
;//	cnt++;
;//	if(cnt==1000)
;//	{
;//	cnt2++;
;//	if(cnt2==2)
;//	{
;//	num_cnt1++;cnt2=0;
;//	}
;//	num_cnt2++;
;//	cnt=0;
;//	}
;//	if(num_cnt1==6)
;//	{
;//	num_cnt1=0;
;//	}
;//	if(num_cnt2==9)
;//	{
;//	num_cnt2=6;
;//	}
;//	TCNT1+=6;
;//}
;/*
; * MIT License
; *
; * Copyright (c) 2019 Sean Farrelly
; *
; * Permission is hereby granted, free of charge, to any person obtaining a copy
; * of this software and associated documentation files (the "Software"), to deal
; * in the Software without restriction, including without limitation the rights
; * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; * copies of the Software, and to permit persons to whom the Software is
; * furnished to do so, subject to the following conditions:
; *
; * The above copyright notice and this permission notice shall be included in all
; * copies or substantial portions of the Software.
; *
; * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; * SOFTWARE.
; *
; * File        cli.c
; * Created by  Sean Farrelly
; * Version     1.0
; *
; */
;
;/*! @file cli.c
; * @brief Implementation of command-line interface.
; */
;#include "cli.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <stdint.h>
;#include <string.h>
;extern bit cmd_enter;
;
;static uint8_t buf[MAX_BUF_SIZE];      /* CLI Rx byte-buffer */
;static uint8_t *buf_ptr;               /* Pointer to Rx byte-buffer */
;
;static uint8_t cmd_buf[MAX_BUF_SIZE];  /* CLI command buffer */
;static uint8_t *cmd_ptr;               /* Pointer to command buffer */
;
;const char cli_prompt[] = ">> ";       /* CLI prompt displayed to the user */

	.DSEG
;const char cli_unrecog[] = "\r"; //const char cli_unrecog[] = "CMD: Command not recognised \r";
;const char *cli_error_msg[] = { "OK", "Command not recognised" };
_0xC0005:
	.BYTE 0x1A
;
;
;
;
;/*!
; * @brief This internal API prints a message to the user on the CLI.
; */
;static void cli_print(cli_t *cli, const char *msg);
;
;/*!
; * @brief This API initialises the command-line interface.
; */
;cli_status_t cli_init(cli_t *cli)
; 0006 003D {

	.CSEG
_cli_init:
; 0006 003E     /* Set buffer ptr to beginning of buf */
; 0006 003F     buf_ptr = buf;
	ST   -Y,R27
	ST   -Y,R26
;	*cli -> Y+0
	CALL SUBOPT_0x17
; 0006 0040 
; 0006 0041     /* Print the CLI prompt. */
; 0006 0042     cli_print(cli, cli_prompt);
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0x18
; 0006 0043 
; 0006 0044     return CLI_OK;
	RJMP _0x20A0005
; 0006 0045 }
;
;/*!
; * @brief This API deinitialises the command-line interface.
; */
;cli_status_t cli_deinit(cli_t *cli)
; 0006 004B {
; 0006 004C     return CLI_OK;
;	*cli -> Y+0
; 0006 004D }
;
;
;/*! @brief This API must be periodically called by the user to process and execute
; *         any commands received.
; */
;cli_status_t cli_process(cli_t *cli)
; 0006 0054 {
_cli_process:
; 0006 0055     uint8_t argc = 0;
; 0006 0056     int i = 0;
; 0006 0057     char *argv[30];
; 0006 0058     if(cmd_enter)
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,60
	CALL __SAVELOCR4
;	*cli -> Y+64
;	argc -> R17
;	i -> R18,R19
;	argv -> Y+4
	LDI  R17,0
	__GETWRN 18,19,0
	SBRS R2,1
	RJMP _0xC0007
; 0006 0059     {
; 0006 005A         cmd_enter = 0;
	CLT
	BLD  R2,1
; 0006 005B         /* Get the first token (cmd name) */
; 0006 005C         argv[argc] = strtok(cmd_buf, " ");
	CALL SUBOPT_0x19
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_cmd_buf_G006)
	LDI  R31,HIGH(_cmd_buf_G006)
	CALL SUBOPT_0x1A
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0006 005D 
; 0006 005E         /* Walk through the other tokens (parameters) */
; 0006 005F         while((argv[argc] != NULL) && (argc < 30))
_0xC0008:
	CALL SUBOPT_0x19
	CALL SUBOPT_0xF
	SBIW R30,0
	BREQ _0xC000B
	CPI  R17,30
	BRLO _0xC000C
_0xC000B:
	RJMP _0xC000A
_0xC000C:
; 0006 0060         {
; 0006 0061             argv[++argc] = strtok(NULL, " ");
	SUBI R17,-LOW(1)
	CALL SUBOPT_0x19
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x1A
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0006 0062         }
	RJMP _0xC0008
_0xC000A:
; 0006 0063 
; 0006 0064         /* Search the command table for a matching command, using argv[0]
; 0006 0065          * which is the command name. */
; 0006 0066         for(i = 0 ; i < cli->cmd_cnt ; i++)
	__GETWRN 18,19,0
_0xC000E:
	__GETW2SX 64
	ADIW R26,4
	CALL __GETW1P
	CP   R18,R30
	CPC  R19,R31
	BRSH _0xC000F
; 0006 0067         {
; 0006 0068             if(strcmp(argv[0], cli->cmd_tbl[i].cmd) == 0)
	CALL SUBOPT_0x1B
	__GETW1SX 66
	LDD  R26,Z+2
	LDD  R27,Z+3
	MOVW R30,R18
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	MOVW R26,R30
	CALL _strcmp
	CPI  R30,0
	BRNE _0xC0010
; 0006 0069             {
; 0006 006A                 /* Found a match, execute the associated function. */
; 0006 006B                 cli->cmd_tbl[i].func(argc, argv);
	CALL SUBOPT_0x1C
	LDD  R26,Z+2
	LDD  R27,Z+3
	MOVW R30,R18
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,2
	CALL __GETW1P
	PUSH R31
	PUSH R30
	MOV  R30,R17
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,6
	POP  R30
	POP  R31
	ICALL
; 0006 006C                 UartSend( '\r' );
	LDI  R26,LOW(13)
	LDI  R27,0
	CALL _UartSend
; 0006 006D                 cli_print(cli, cli_prompt);
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x18
; 0006 006E 
; 0006 006F                 return CLI_OK;
	RJMP _0x20A0008
; 0006 0070                 //return cli->cmd_tbl[i].func(argc, argv);
; 0006 0071             }
; 0006 0072         }
_0xC0010:
	__ADDWRN 18,19,1
	RJMP _0xC000E
_0xC000F:
; 0006 0073 
; 0006 0074 
; 0006 0075         /* Command not found */
; 0006 0076         cli_print(cli, cli_unrecog);
	CALL SUBOPT_0x1C
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_cli_unrecog)
	LDI  R27,HIGH(_cli_unrecog)
	RCALL _cli_print_G006
; 0006 0077         cli_print(cli, cli_prompt);
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
; 0006 0078         return CLI_E_CMD_NOT_FOUND;
	LDI  R30,LOW(3)
; 0006 0079     }
; 0006 007A }
_0xC0007:
_0x20A0008:
	CALL __LOADLOCR4
	ADIW R28,63
	ADIW R28,3
	RET
;
;/*!
; * @brief This API should be called from the devices interrupt handler whenever a
; *        character is received over the input stream.
; */
;cli_status_t cli_put(cli_t *cli, char c)
; 0006 0081 {
_cli_put:
; 0006 0082     switch(c)
	ST   -Y,R26
;	*cli -> Y+1
;	c -> Y+0
	LD   R30,Y
	LDI  R31,0
; 0006 0083     {
; 0006 0084     case '\r':
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0xC0014
; 0006 0085 
; 0006 0086         *buf_ptr = '\0';            /* Terminate the msg and reset the msg ptr.      */
	LDS  R26,_buf_ptr_G006
	LDS  R27,_buf_ptr_G006+1
	LDI  R30,LOW(0)
	ST   X,R30
; 0006 0087         strcpy(cmd_buf, buf);       /* Copy string to command buffer for processing. */
	LDI  R30,LOW(_cmd_buf_G006)
	LDI  R31,HIGH(_cmd_buf_G006)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_buf_G006)
	LDI  R27,HIGH(_buf_G006)
	CALL _strcpy
; 0006 0088         buf_ptr = buf;              /* Reset buf_ptr to beginning.                   */
	CALL SUBOPT_0x17
; 0006 0089         cli_print(cli, cli_prompt); /* Print the CLI prompt to the user.             */
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	CALL SUBOPT_0x1D
; 0006 008A         cmd_enter = 1;
	SET
	BLD  R2,1
; 0006 008B         break;
	RJMP _0xC0013
; 0006 008C 
; 0006 008D     case '\b':
_0xC0014:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xC0017
; 0006 008E         /* Backspace. Delete character. */
; 0006 008F         if(buf_ptr > buf)
	LDI  R30,LOW(_buf_G006)
	LDI  R31,HIGH(_buf_G006)
	LDS  R26,_buf_ptr_G006
	LDS  R27,_buf_ptr_G006+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0xC0016
; 0006 0090             buf_ptr--;
	LDI  R26,LOW(_buf_ptr_G006)
	LDI  R27,HIGH(_buf_ptr_G006)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0006 0091         break;
_0xC0016:
	RJMP _0xC0013
; 0006 0092 
; 0006 0093     default:
_0xC0017:
; 0006 0094         /* Normal character received, add to buffer. */
; 0006 0095         if((buf_ptr - buf) < MAX_BUF_SIZE)
	LDI  R26,LOW(_buf_G006)
	LDI  R27,HIGH(_buf_G006)
	LDS  R30,_buf_ptr_G006
	LDS  R31,_buf_ptr_G006+1
	SUB  R30,R26
	SBC  R31,R27
	CPI  R30,LOW(0x80)
	LDI  R26,HIGH(0x80)
	CPC  R31,R26
	BRSH _0xC0018
; 0006 0096             *buf_ptr++ = c;
	LDI  R26,LOW(_buf_ptr_G006)
	LDI  R27,HIGH(_buf_ptr_G006)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LD   R26,Y
	STD  Z+0,R26
; 0006 0097         else
	RJMP _0xC0019
_0xC0018:
; 0006 0098             return CLI_E_BUF_FULL;
	LDI  R30,LOW(5)
; 0006 0099         break;
_0xC0019:
; 0006 009A     }
_0xC0013:
; 0006 009B }
_0x20A0007:
	ADIW R28,3
	RET
;
;/*!
; * @brief Print a message on the command-line interface.
; */
;static void cli_print(cli_t *cli, const char *msg)
; 0006 00A1 {
_cli_print_G006:
; 0006 00A2     /* Temp buffer to store text in ram first */
; 0006 00A3     char buf[50];
; 0006 00A4 
; 0006 00A5     strcpy(buf, msg);
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,50
;	*cli -> Y+52
;	*msg -> Y+50
;	buf -> Y+0
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+52
	LDD  R27,Y+52+1
	CALL _strcpy
; 0006 00A6     cli->println(buf);
	LDD  R26,Y+52
	LDD  R27,Y+52+1
	CALL __GETW1P
	PUSH R31
	PUSH R30
	MOVW R26,R28
	POP  R30
	POP  R31
	ICALL
; 0006 00A7 }
	ADIW R28,54
	RET
;/*****************************************************************************
; *   @file
; *   @brief  Source file of
; *   @author Kyle
; *   @version 1.0.0
; *   @note :    1.
; *              2.
; *              3.
;********************************************************************************/
;
;
;/******************************************************************************/
;/***************************** Include Files **********************************/
;/******************************************************************************/
;#include "led7.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;
;/******************************************************************************/
;/************************* Global variable declaration ************************/
;/******************************************************************************/
;char Num[11]={0X3F,0X06,0X5B,0X4F,0X66,0X6D,0X7D,0X27,0X7F,0X6F};  //0~9 ????  FND2

	.DSEG
;int FndCnt;
;
;/******************************************************************************/
;/************************** Functions Implementation **************************/
;/******************************************************************************/
;
;
;void Led7Init(void)
; 0007 001D {

	.CSEG
_Led7Init:
; 0007 001E     MCUCR=0X80; //enable External memory and I/O control
_0x20A0006:
	LDI  R30,LOW(128)
	OUT  0x35,R30
; 0007 001F }
	RET
;
;void Led7Disp(int value)
; 0007 0022 {
; 0007 0023     char j,k,l,m = 0;
; 0007 0024     static int cnt = 0;
; 0007 0025     cnt++;
;	value -> Y+4
;	j -> R17
;	k -> R16
;	l -> R19
;	m -> R18
; 0007 0026     j=value/1000;          //-------1000???
; 0007 0027     k=(value%1000)/100;    //-------100???
; 0007 0028     l=(value%100)/10;      //-------10???
; 0007 0029     m=(value%10);          //-------1???
; 0007 002A 
; 0007 002B     switch(cnt)
; 0007 002C     {
; 0007 002D         case 1:
; 0007 002E         SET_CON=FND1_ON|FND2_OFF|FND3_OFF|FND4_OFF;
; 0007 002F         LCD_DATABUS=Num[j]; //1000???
; 0007 0030         break;
; 0007 0031         case 2:
; 0007 0032         SET_CON=FND2_ON|FND1_OFF|FND3_OFF|FND4_OFF;
; 0007 0033         LCD_DATABUS=Num[k]; //100? ??
; 0007 0034         break;
; 0007 0035         case 3:
; 0007 0036         SET_CON=FND3_ON|FND1_OFF|FND2_OFF|FND4_OFF;
; 0007 0037         LCD_DATABUS=Num[l]; //10? ??
; 0007 0038         break;
; 0007 0039         case 4:
; 0007 003A         SET_CON=FND4_ON|FND1_OFF|FND2_OFF|FND3_OFF;
; 0007 003B         LCD_DATABUS=Num[m]; //1? ??
; 0007 003C         break;
; 0007 003D         default:cnt=0; //cnt ???
; 0007 003E     }
; 0007 003F 
; 0007 0040 //    SET_CON=FND1_ON|FND2_OFF|FND3_OFF|FND4_OFF;
; 0007 0041 //    LCD_DATABUS=Num[j]; //1000???
; 0007 0042 //
; 0007 0043 //    SET_CON=FND2_ON|FND1_OFF|FND3_OFF|FND4_OFF;
; 0007 0044 //    LCD_DATABUS=Num[k]; //100? ??
; 0007 0045 //
; 0007 0046 //    SET_CON=FND3_ON|FND1_OFF|FND2_OFF|FND4_OFF;
; 0007 0047 //    LCD_DATABUS=Num[l]; //10? ??
; 0007 0048 //
; 0007 0049 //    SET_CON=FND4_ON|FND1_OFF|FND2_OFF|FND3_OFF;
; 0007 004A //    LCD_DATABUS=Num[m]; //1? ??
; 0007 004B 
; 0007 004C 
; 0007 004D }
;
;void Led7Disp1(int value)
; 0007 0050 {
_Led7Disp1:
; 0007 0051 
; 0007 0052     SET_CON=FND4_ON|FND1_OFF|FND2_OFF|FND3_OFF;
	ST   -Y,R27
	ST   -Y,R26
;	value -> Y+0
	LDI  R30,LOW(32)
	STS  33024,R30
; 0007 0053     LCD_DATABUS=Num[value]; //1? ??
	LD   R30,Y
	LDD  R31,Y+1
	SUBI R30,LOW(-_Num)
	SBCI R31,HIGH(-_Num)
	LD   R30,Z
	STS  33536,R30
; 0007 0054 
; 0007 0055 
; 0007 0056 }
_0x20A0005:
	ADIW R28,2
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG
_strcat:
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcat0:
    ld   r22,x+
    tst  r22
    brne strcat0
    sbiw r26,1
strcat1:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcat1
    movw r30,r24
    ret
_strcmp:
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strcmp0:
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strcmp1
    tst  r22
    brne strcmp0
strcmp3:
    clr  r30
    ret
strcmp1:
    sub  r22,r23
    breq strcmp3
    ldi  r30,1
    brcc strcmp2
    subi r30,2
strcmp2:
    ret
_strcpy:
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpy0:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcpy0
    movw r30,r24
    ret
_strlen:
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strpbrkf:
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+3
    ldd  r26,y+2
strpbrkf0:
    ld   r22,x
    tst  r22
    breq strpbrkf2
    ldd  r31,y+1
    ld   r30,y
strpbrkf1:
	lpm
    tst  r0
    breq strpbrkf3
    adiw r30,1
    cp   r22,r0
    brne strpbrkf1
    movw r30,r26
    rjmp strpbrkf4
strpbrkf3:
    adiw r26,1
    rjmp strpbrkf0
strpbrkf2:
    clr  r30
    clr  r31
strpbrkf4:
	JMP  _0x20A0003
_strspnf:
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+3
    ldd  r26,y+2
    clr  r24
    clr  r25
strspnf0:
    ld   r22,x+
    tst  r22
    breq strspnf2
    ldd  r31,y+1
    ld   r30,y
strspnf1:
	lpm  r0,z+
    tst  r0
    breq strspnf2
    cp   r22,r0
    brne strspnf1
    adiw r24,1
    rjmp strspnf0
strspnf2:
    movw r30,r24
_0x20A0003:
_0x20A0004:
	ADIW R28,4
	RET
_strtok:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BRNE _0x2020003
	LDS  R30,_p_S1010026000
	LDS  R31,_p_S1010026000+1
	SBIW R30,0
	BRNE _0x2020004
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x20A0001
_0x2020004:
	LDS  R30,_p_S1010026000
	LDS  R31,_p_S1010026000+1
	STD  Y+4,R30
	STD  Y+4+1,R31
_0x2020003:
	CALL SUBOPT_0x1B
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL _strspnf
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+4,R30
	STD  Y+4+1,R31
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R30,X
	CPI  R30,0
	BRNE _0x2020005
	LDI  R30,LOW(0)
	STS  _p_S1010026000,R30
	STS  _p_S1010026000+1,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x20A0001
_0x2020005:
	CALL SUBOPT_0x1B
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL _strpbrkf
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020006
	MOVW R26,R16
	__ADDWRN 16,17,1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2020006:
	__PUTWMRN _p_S1010026000,0,16,17
	LDD  R30,Y+4
	LDD  R31,Y+4+1
_0x20A0001:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20A0002:
	ADIW R28,6
	RET

	.CSEG
_atoi:
	ST   -Y,R27
	ST   -Y,R26
   	ldd  r27,y+1
   	ld   r26,y
__atoi0:
   	ld   r30,x
        mov  r24,r26
	MOV  R26,R30
	CALL _isspace
        mov  r26,r24
   	tst  r30
   	breq __atoi1
   	adiw r26,1
   	rjmp __atoi0
__atoi1:
   	clt
   	ld   r30,x
   	cpi  r30,'-'
   	brne __atoi2
   	set
   	rjmp __atoi3
__atoi2:
   	cpi  r30,'+'
   	brne __atoi4
__atoi3:
   	adiw r26,1
__atoi4:
   	clr  r22
   	clr  r23
__atoi5:
   	ld   r30,x
        mov  r24,r26
	MOV  R26,R30
	CALL _isdigit
        mov  r26,r24
   	tst  r30
   	breq __atoi6
   	movw r30,r22
   	lsl  r22
   	rol  r23
   	lsl  r22
   	rol  r23
   	add  r22,r30
   	adc  r23,r31
   	lsl  r22
   	rol  r23
   	ld   r30,x+
   	clr  r31
   	subi r30,'0'
   	add  r22,r30
   	adc  r23,r31
   	rjmp __atoi5
__atoi6:
   	movw r30,r22
   	brtc __atoi7
   	com  r30
   	com  r31
   	adiw r30,1
__atoi7:
   	adiw r28,2
   	ret

	.DSEG

	.CSEG

	.CSEG
_isdigit:
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,'0'
    brlo isdigit0
    cpi  r31,'9'+1
    brlo isdigit1
isdigit0:
    clr  r30
isdigit1:
    ret
_isspace:
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,' '
    breq isspace1
    cpi  r31,9
    brlo isspace0
    cpi  r31,13+1
    brlo isspace1
isspace0:
    clr  r30
isspace1:
    ret

	.CSEG

	.DSEG
_rx_buffer0:
	.BYTE 0x11
_cli:
	.BYTE 0x6
_cmd_tbl:
	.BYTE 0x18
_LedCtrl:
	.BYTE 0x2
_vertical:
	.BYTE 0x8
_english:
	.BYTE 0xE0
_Toggle_G003:
	.BYTE 0x2
_num_cnt_G003:
	.BYTE 0x2
_DispChar:
	.BYTE 0x1
_num_cnt1:
	.BYTE 0x2
_num_cnt2:
	.BYTE 0x2
_buf_G006:
	.BYTE 0x80
_buf_ptr_G006:
	.BYTE 0x2
_cmd_buf_G006:
	.BYTE 0x80
_cli_prompt:
	.BYTE 0x4
_cli_unrecog:
	.BYTE 0x2
_Num:
	.BYTE 0xB
_p_S1010026000:
	.BYTE 0x2
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	STS  33280,R30
	STS  33536,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	JMP  _strlen

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:54 WORDS
SUBOPT_0x4:
	__CALL1MN _cli,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDD  R26,Z+2
	LDD  R27,Z+3
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDD  R26,Z+4
	LDD  R27,Z+5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	LDD  R26,Z+2
	LDD  R27,Z+3
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9:
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	LDD  R26,Z+4
	LDD  R27,Z+5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	CALL _atoi
	MOVW R16,R30
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	CALL _user_uart_println
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xC:
	CALL _strcpy
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	LDD  R26,Z+4
	LDD  R27,Z+5
	CALL _strcat
	MOVW R26,R28
	ADIW R26,2
	JMP  _DisplayLCDLine1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDD  R30,Y+40
	LDD  R31,Y+40+1
	LDD  R26,Z+2
	LDD  R27,Z+3
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xE:
	MOVW R30,R16
	LDD  R26,Y+40
	LDD  R27,Y+40+1
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	ST   -Y,R26
	LD   R30,Y
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	STS  _LedCtrl,R30
	STS  _LedCtrl+1,R31
	LDS  R30,_LedCtrl
	STS  32768,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x12:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x13:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	MOV  R5,R30
	STS  33280,R30
	LD   R30,Y
	STS  33536,R30
	MOV  R30,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	LDI  R27,0
	CALL _delay_ms
	LDI  R26,LOW(48)
	JMP  _dsp_cmd_TLCD

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(_buf_G006)
	LDI  R31,HIGH(_buf_G006)
	STS  _buf_ptr_G006,R30
	STS  _buf_ptr_G006+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x18:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_cli_prompt)
	LDI  R27,HIGH(_cli_prompt)
	CALL _cli_print_G006
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x19:
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0xC0000,26
	JMP  _strtok

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1C:
	__GETW1SX 64
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_cli_prompt)
	LDI  R27,HIGH(_cli_prompt)
	JMP  _cli_print_G006


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE: