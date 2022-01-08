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
#include "uart.h"

/******************************************************************************/
/************************* Global variable declaration ************************/
/******************************************************************************/
extern char rx_buffer0[RX_BUFFER_SIZE0];
extern unsigned int rx_wr_index0,rx_counter0;
extern bit rx_buffer_overflow0, cmd_enter; // This flag is set on USART0 Receiver buffer overflow
extern cli_t cli;

char rx_buffer0[RX_BUFFER_SIZE0];
unsigned int rx_wr_index0,rx_counter0;
bit rx_buffer_overflow0, cmd_enter;


/******************************************************************************/
/************************** Functions Implementation **************************/
/******************************************************************************/
void UartSend( unsigned int data )
{
/* Wait for empty transmit buffer */
while ( !( UCSR0A & (1<<UDRE)) );
/* Copy 9th bit to TXB8 */
UCSR0B &= ~(1<<TXB8);
if ( data & 0x0100 )
UCSR0B |= (1<<TXB8);
/* Put data into buffer, sends the data */
UDR0 = data;
}



interrupt [USART0_RXC] void usart0_rx_isr(void)// USART0 Receiver interrupt service routine
{
char status,data;
status=UCSR0A;
data=UDR0;
UartSend(data);
//cli_put(&cli, data);

if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
        cli_put(&cli, data);
   }     

}

void Uart0Init()
{
    // USART0 initialization
    UCSR0A=0x00; // Communication Parameters: 8 Data, 1 Stop, No Parity
    UCSR0B=0x98; // USART0 Receiver: On
    UCSR0C=0x06; // USART0 Transmitter: On
    UBRR0H=0x00; // USART0 Mode: Asynchronous
    UBRR0L=0x67;  // USART0 Baud Rate: 9600   
}

void UartTest()
{
   int i=0;
   if(rx_buffer_overflow0)
   {
        for(i=0;i<8;i++)
        {
            UartSend(rx_buffer0[i]);
        }

        rx_buffer_overflow0=0; 
        UartSend( '\n' );
    }
}
        
        

