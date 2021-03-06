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
#include "led.h"

/******************************************************************************/
/************************* Global variable declaration ************************/
/******************************************************************************/
static volatile unsigned int LedCtrl;
volatile unsigned int LedCtrl = 0;
//extern unsigned int LedCtrl;
//unsigned int LedCtrl = 0;

/******************************************************************************/
/************************** Functions Implementation **************************/
/******************************************************************************/
void LedOn(enum LedEnum led)
{
    MCUCR=0X80; //enable External memory and I/O control
    LED_CON=0X00;       // LED GLCD Control bus
	SET_CON=0X00;       // FND, Bu zzer, RELAY Control bus
	LCD_CON=0X00;       // TLCD, GLCD Control bus
	LCD_DATABUS=0X00;   // TLCD, GLCD, FND, Dotmatrix Data bus
	DOT_YELLOW=0X00;    // Dotmatrix Yellow LED
	DOT_RED=0X00;       // Dotmatrix Yellow RED
	STEPMOR=0X00;       // Stepping Motor Control bus
	DCSERVO=0X00;       // DC, Servo Motor Control bus
    LedCtrl |= (0x01 << led);
    LED_CON  = LedCtrl;
}

void LedOff(enum LedEnum led)
{
    MCUCR=0X80; //enable External memory and I/O control
    LED_CON=0X00;       // LED GLCD Control bus
	SET_CON=0X00;       // FND, Bu zzer, RELAY Control bus
	LCD_CON=0X00;       // TLCD, GLCD Control bus
	LCD_DATABUS=0X00;   // TLCD, GLCD, FND, Dotmatrix Data bus
	DOT_YELLOW=0X00;    // Dotmatrix Yellow LED
	DOT_RED=0X00;       // Dotmatrix Yellow RED
	STEPMOR=0X00;       // Stepping Motor Control bus
	DCSERVO=0X00;       // DC, Servo Motor Control bus
    LedCtrl &= ~(0x01 << led);
    LED_CON  = LedCtrl;
}
