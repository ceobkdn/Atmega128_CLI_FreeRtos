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
static unsigned int LedCtrl;
unsigned int LedCtrl = 0;

/******************************************************************************/
/************************** Functions Implementation **************************/
/******************************************************************************/
void LedTurn()
{
    static unsigned char SW=0;     
    SW=PINB;
    
    switch(SW)
    {
        case 0xfe:LED_CON=0x01;break;
        case 0xfd:LED_CON=0x02;break;
        case 0xfb:LED_CON=0x04;break;
        case 0xf7:LED_CON=0X08;break;   
        case 0xef:LED_CON=0X10;break;
        case 0xdf:LED_CON=0X20;break; 
        case 0xbf:LED_CON=0X40;break;
        case 0x7f:LED_CON=0X80;break;           
        default:LED_CON=0X00;break;  
    }
}


void LedOn(enum LedEnum led)
{
LedCtrl |= (0x01 << led);
LED_CON  = LedCtrl;
}

void LedOff(enum LedEnum led)
{
LedCtrl &= ~(0x01 << led);
LED_CON  = LedCtrl;
}
