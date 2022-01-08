/*****************************************************************************
 *   @file   
 *   @brief  Source file of 
 *   @author Kyle
 *   @version 1.0.0
 *   @note :    1. 
 *              2. 
 *              3. 
********************************************************************************/


/******************************************************************************/
/***************************** Include Files **********************************/
/******************************************************************************/
#include "lcd.h"

/******************************************************************************/
/************************* Global variable declaration ************************/
/******************************************************************************/
int num_cnt1=0;
int num_cnt2=6;
unsigned char con=0;


flash char str[11][17]={        "===LKEMBEDDED===",  
                                 "====  WWW. =====", 
                                "== LKEMBEDDED.==",
                                "==== CO.KR =====", 
                                "   Education    ",
                                "   Development  ",
                                "  AVR Dev & EDU ",  
                                "  PIC Dev & EDU ",  
                                "  ARM Dev & EDU ", 
                                " PADS Dev & EDU ",  
                                "   Cirquit EDU  "
                                }; 

/******************************************************************************/
/************************** Functions Implementation **************************/
/******************************************************************************/ 
void DisplayClr(void);
void DisplayClrLine1(void);
void DisplayClrLine2(void);



void DisplayLCDLine1(char *string)
{
	
    int size = strlen(string);
    int i=0;
    DisplayClrLine1();
    clcd_line1();
	for(i=0; i<size; ++i){dsp_str_TLCD(' ');}
    clcd_line1();
    for(i=0; i<size; ++i){dsp_str_TLCD(string[i]);}
}

void DisplayLCDLine2(char *string)
{
	int size = strlen(string);
    int i=0;
    DisplayClrLine2();
	clcd_line2();
    for(i=0; i<size; ++i){dsp_str_TLCD(' ');}
    clcd_line2();
	for(i=0; i<size; ++i){dsp_str_TLCD(string[i]);}
}

void DisplayTest(void)
{

	int i=0;
	clcd_line1();
	for(i=0; i<16; ++i){dsp_str_TLCD(str[num_cnt1][i]);}
	
	clcd_line2();
	for(i=0; i<16; ++i){dsp_str_TLCD(str[num_cnt2][i]);}

}

void DisplayClr(void)
{

	int i=0;
	clcd_line1();
	for(i=0; i<16; ++i){dsp_str_TLCD(' ');}
	
	clcd_line2();
	for(i=0; i<16; ++i){dsp_str_TLCD(' ');}

}

void DisplayClrLine1(void)
{
	int i=0;
	clcd_line1();
	for(i=0; i<16; ++i){dsp_str_TLCD(' ');}

}

void DisplayClrLine2(void)
{

	int i=0;	
	clcd_line2();
	for(i=0; i<16; ++i){dsp_str_TLCD(' ');}

}

void clcd_line1(void)
{
    dsp_cmd_TLCD(0x80);
} //line1		

	
void clcd_line2(void)
{
    dsp_cmd_TLCD(0XC0);
} //line2


void dsp_str_TLCD(char n)
{
    LCD_CON=(con|=0x10);    // E=0, RS=1
    LCD_DATABUS=n;          // 8bit OUTPUT DATA
    LCD_CON=(con|=0x50);    // E=1, RS=1
    delay_us(1);
    LCD_CON=(con&=~0x40);   // E=0; RS=1;
    delay_us(40);
}

void dsp_cmd_TLCD(char n)
{
    LCD_CON=(con&=~0x30);      //E=0, RS=0
    LCD_DATABUS=n;             //8bit OUTPUT DATA=0;
    LCD_CON=(con|=0X40);       // E=1, RS=0
    delay_us(1);
    LCD_CON=(con&=~0X40);      // E=0, RS=0
    delay_us(40);
}

void LcdInit() //16x2line
{  
    LCD_CON=0X00;
    LCD_DATABUS=0X00;
    //lcd_dt=0; lcd_rw=lcd_rs=lcd_en=0;                                                              Ʈ
    delay_ms(10); dsp_cmd_TLCD(0x30); //8bit mode
    delay_ms(5);  dsp_cmd_TLCD(0x30);
    delay_ms(1);  dsp_cmd_TLCD(0x30);
    delay_ms(5);  dsp_cmd_TLCD(0x38); //function set
    dsp_cmd_TLCD(0x0c); //display on/off
    dsp_cmd_TLCD(0x14); //cursor/display
    dsp_cmd_TLCD(0x06); //entry mode
    dsp_cmd_TLCD(0x01); delay_ms(2); //display clear   
}


