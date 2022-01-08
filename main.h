/*****************************************************************************
 *   @file   
 *   @brief  Header file of 
 *   @author Kyle 
 *   @version 1.0.0
 *   @note :    1. 
 *              2. 
 *              3. 
********************************************************************************/

#ifndef MAIN_H_
#define MAIN_H_




/******************************************************************************/
/***************************** Include Files **********************************/
/******************************************************************************/

    

/******************************************************************************/
/********************** Macros and Constants Definitions **********************/
/******************************************************************************/
#define LED_CON               *((unsigned char *)0x8000) // LED Control bus
#define SET_CON               *((unsigned char *)0x8100) // FND, Buzzer, RELAY Control bus
#define LCD_CON               *((unsigned char *)0x8200) // TLCD, GLCD Control bus
#define LCD_DATABUS           *((unsigned char *)0x8300) // TLCD, GLCD, FND, Dotmatrix Data bus
#define DOT_YELLOW            *((unsigned char *)0x8400) // Dotmatrix Yellow LED
#define DOT_RED               *((unsigned char *)0x8500) // Dotmatrix Yellow RED
#define STEPMOR               *((unsigned char *)0x8600) // Stepping Motor Control bus
#define DCSERVO				  *((unsigned char *)0x8700) // DC, Servo Motor Control bus




/******************************************************************************/
/************************** Functions declaration    **************************/
/******************************************************************************/




#endif // MAIN_H_