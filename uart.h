/*****************************************************************************
 *   @file   
 *   @brief  Header file of 
 *   @author Kyle 
 *   @version 1.0.0
 *   @note :    1. 
 *              2. 
 *              3. 
********************************************************************************/

#ifndef UART_H_
#define UART_H_




/******************************************************************************/
/***************************** Include Files **********************************/
/******************************************************************************/
#include <delay.h>
#include <mega128.h>
#include "cli.h"
#include "stdio.h"
#include "string.h"    

/******************************************************************************/
/********************** Macros and Constants Definitions **********************/
/******************************************************************************/
#define RXB8 1
#define TXB8 0
#define UPE 2
#define DOR 3
#define FE 4
#define UDRE 5
#define RXC 7

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
#define RX_BUFFER_SIZE0 17 // USART0 Receiver buffer

/******************************************************************************/
/************************** Functions declaration    **************************/
/******************************************************************************/
void Uart0Init(void);

void UartSend( unsigned int data );



#endif // UART_H_