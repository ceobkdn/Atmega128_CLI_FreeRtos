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
#include "timer.h"


/******************************************************************************/
/************************* Global variable declaration ************************/
/******************************************************************************/
static int LoadInit;
extern cli_t cli;


/******************************************************************************/
/************************** Functions Implementation **************************/
/******************************************************************************/

void Timer1Init(int LoadValue)
{
 TCNT1      = LoadValue;
 LoadInit   = LoadValue;
 TIMSK      |= 1<<TOIE1;
 TCCR1B     |= (1 << CS10) | (1 << CS12);
 TIFR       = 0x01; //clear timer1 overflow flag to start timer 1
}







//// Timer 0 overflow interrupt service routine
//interrupt [TIM0_OVF] void timer0_ovf_isr(void)
//{
//    //Dotmatrix_Timer();
//    //DotMatRefresh();
//    cli_process(&cli);
//    TCNT0+=0x06;
//}




// Timer 1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
    //DotMatRefresh();
    cli_process(&cli);
    TCNT1+=LoadInit;
}
