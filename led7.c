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
#include "led7.h"

/******************************************************************************/
/************************* Global variable declaration ************************/
/******************************************************************************/
char Num[11]={0X3F,0X06,0X5B,0X4F,0X66,0X6D,0X7D,0X27,0X7F,0X6F};  //0~9 ????  FND2
int FndCnt;

/******************************************************************************/
/************************** Functions Implementation **************************/
/******************************************************************************/

void Led7Disp(int value)
{
    char j,k,l,m = 0;
    static int cnt = 0;
    cnt++;
    j=value/1000;          //-------1000???     
    k=(value%1000)/100;    //-------100??? 
    l=(value%100)/10;      //-------10??? 
    m=(value%10);          //-------1???       
    
    switch(cnt)
    {
        case 1:
        SET_CON=FND1_ON|FND2_OFF|FND3_OFF|FND4_OFF;
        LCD_DATABUS=Num[j]; //1000???
        break;
        case 2:
        SET_CON=FND2_ON|FND1_OFF|FND3_OFF|FND4_OFF;
        LCD_DATABUS=Num[k]; //100? ??   
        break;
        case 3:
        SET_CON=FND3_ON|FND1_OFF|FND2_OFF|FND4_OFF;
        LCD_DATABUS=Num[l]; //10? ??  
        break;
        case 4:
        SET_CON=FND4_ON|FND1_OFF|FND2_OFF|FND3_OFF;
        LCD_DATABUS=Num[m]; //1? ??
        break;    
        default:cnt=0; //cnt ???  
    } 
    
//    SET_CON=FND1_ON|FND2_OFF|FND3_OFF|FND4_OFF;
//    LCD_DATABUS=Num[j]; //1000???
//
//    SET_CON=FND2_ON|FND1_OFF|FND3_OFF|FND4_OFF;
//    LCD_DATABUS=Num[k]; //100? ??   
//
//    SET_CON=FND3_ON|FND1_OFF|FND2_OFF|FND4_OFF;
//    LCD_DATABUS=Num[l]; //10? ??  
//
//    SET_CON=FND4_ON|FND1_OFF|FND2_OFF|FND3_OFF;
//    LCD_DATABUS=Num[m]; //1? ??  
    

}

void Led7Disp1(int value)
{
    MCUCR=0X80; //enable External memory and I/O control
//    LED_CON=0X00;       // LED GLCD Control bus
	SET_CON=0X00;       // FND, Bu zzer, RELAY Control bus
//	LCD_CON=0X00;       // TLCD, GLCD Control bus
	LCD_DATABUS=0X00;   // TLCD, GLCD, FND, Dotmatrix Data bus
//	DOT_YELLOW=0X00;    // Dotmatrix Yellow LED
//	DOT_RED=0X00;       // Dotmatrix Yellow RED
//	STEPMOR=0X00;       // Stepping Motor Control bus
//	DCSERVO=0X00;       // DC, Servo Motor Control bus
    
    SET_CON=FND4_ON|FND1_OFF|FND2_OFF|FND3_OFF;
    LCD_DATABUS=Num[value]; //1? ??  
    

}
