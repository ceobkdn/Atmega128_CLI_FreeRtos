

#include <mega128.h>
#include <stdio.h>
#include <string.h>
#include <delay.h>
#include <stdlib.h>
#include "uart.h"
#include "led.h"
#include "dotmat.h"
#include "lcd.h"
#include "cli.h"
#include "led7.h"
#include "timer.h"


extern cli_t cli;
cli_t cli;

void SystemInit(void);
void user_uart_println(char *string);
cli_status_t help_func(int argc, char **argv);
cli_status_t blink_func(int argc, char **argv);
cli_status_t led_func(int argc, char **argv);
cli_status_t lcd_func(int argc, char **argv);
cli_status_t led7_func(int argc, char **argv);
cli_status_t show_func(int argc, char **argv);
cli_status_t dotmat_func(int argc, char **argv);


cmd_t cmd_tbl[] = { {"help",help_func},
                    {"show",show_func},
                    {"blink",blink_func},
                    {"led",led_func},
                    {"lcd",lcd_func},
                    {"led7",led7_func},
                    {"dotmat", dotmat_func}};


void main(void)
{
    SystemInit();
    Uart0Init();
    LcdInit();
    //Timer1Init(0xFF00);

    cli.println = user_uart_println;
    cli.cmd_tbl = cmd_tbl;
    cli.cmd_cnt = sizeof(cmd_tbl)/sizeof(cmd_t);
    cli_init(&cli);
    cli.println("*** Atmel 128 demo ***\n");
    while(1)
    {

        cli_process(&cli);
    }

}




void SystemInit(void)
{
    MCUCR=0X80; //enable External memory and I/O control
    //---External I/O initialization
	LED_CON=0X00;       // LED GLCD Control bus
	SET_CON=0X00;       // FND, Bu zzer, RELAY Control bus
	LCD_CON=0X00;       // TLCD, GLCD Control bus
	LCD_DATABUS=0X00;   // TLCD, GLCD, FND, Dotmatrix Data bus
	DOT_YELLOW=0X00;    // Dotmatrix Yellow LED
	DOT_RED=0X00;       // Dotmatrix Yellow RED
	STEPMOR=0X00;       // Stepping Motor Control bus
	DCSERVO=0X00;       // DC, Servo Motor Control bus
    //----------------------------------------
    #asm("sei") // Global enable interrupts
}


void user_uart_println(char *string)
{
    int i = 0;
    int size = strlen(string);
    for(i=0;i<size;i++)
    {
        UartSend(string[i]);
    }
}

cli_status_t help_func(int argc, char **argv)
{
    (void) argc;
    (void*) argv;
    cli.println("HELP function executed");
    cli.println("Test 1");
    cli.println("Test 2");
    cli.println("Test 3");
    return CLI_OK;
}

cli_status_t show_func(int argc, char **argv)
{
    (void) argc;
    (void*) argv;
    cli.println("\rhelp: Help function \n\r");
    cli.println("blink: Blink function \n\r");
    cli.println("led: Led function \n\r");
    cli.println("lcd: Lcd function \n\r");
    cli.println("led7: Led7 function \n\r");

    return CLI_OK;
}

cli_status_t blink_func(int argc, char **argv)
{
    int value;
    if(argc > 1)
    {
        if(strcmp(argv[1], "help") == 0)
        {
            cli.println("BLINK help menu: \r<blink> <on/off> <value(1->8)>");
        }

        if(strcmp(argv[1], "on") == 0)
        {
            value = atoi(argv[2]);
            if(value >= 0 && value < 28)
            {
                DotMatDisp(value);
                cli.println("echo: display ");
                user_uart_println(argv[2]);
            }

        }

    }
    else
    {
        cli.println("BLINK function executed");
    }
    return CLI_OK;
}

cli_status_t dotmat_func(int argc, char **argv)
{
    int value;
    if(argc > 1)
    {
        if(strcmp(argv[1], "help") == 0)
        {
            cli.println("DotMat help menu: \r<dotmat> <disp> <value(0->27)>");
        }

        if(strcmp(argv[1], "disp") == 0)
        {
            value = atoi(argv[2]);
            if(value >= 0 && value < 28)
            {
                DotMatDisp(value);
                cli.println("echo: Dot Matrix display ");
                user_uart_println(argv[2]);
            }

        }

    }
    else
    {
       cli.println("echo: <dotmat> <disp> <character>");
    }
    return CLI_OK;
}

cli_status_t led_func(int argc, char **argv)
{
    int value;
    char string [17]={0};
    if(argc > 1)
    {
        if(strcmp(argv[1], "help") == 0)
        {
            cli.println("echo: Led help menu: \r<led> <on/off> <value(1->8)>");
        }

        if(strcmp(argv[1], "on") == 0)
        {
            value = atoi(argv[2]);
            if(value > 0 && value < 9)
            {
                LedOn(value-1);
                cli.println("echo: Turn on led ");
                user_uart_println(argv[2]);
                strcpy(string,"Turn on led ");
                strcat(string, argv[2]);
                DisplayLCDLine1(string);
            }

            if(strcmp(argv[2], "all") == 0)
            {
                for(value = 0; value < 8; value++)
                {
                    LedOn(value);
                }
                cli.println("echo: All led was on");
                DisplayLCDLine1("Turn on all leds");
            }

        }

        if(strcmp(argv[1], "off") == 0)
        {
            value = atoi(argv[2]);
            if(value > 0 && value < 9)
            {
                LedOff(value-1);
                cli.println("echo: Turn off led ");
                user_uart_println(argv[2]);
                strcpy(string,"Turn off led ");
                strcat(string, argv[2]);
                DisplayLCDLine1(string);
            }

            if(strcmp(argv[2], "all") == 0)
            {
                for(value = 0; value < 8; value++)
                {
                    LedOff(value);
                }
                cli.println("echo: All led was off");
                DisplayLCDLine1("Turn off all leds");
            }
        }


    }
    else
    {
        cli.println("echo: <led> <on/off> <channel/all>");
    }
    return CLI_OK;
}

cli_status_t lcd_func(int argc, char **argv)
{
    int i,value, cnt=0;
    char string1[17] ={0};
    char string2[17] ={0};
    if(argc > 1)
    {
        if(strcmp(argv[1], "help") == 0)
        {
            cli.println("echo: Lcd help menu: \r<lcd> <disp> <text>");
        }

        if(strcmp(argv[1], "disp") == 0)
        {
            value = 0;
            for(i=2; i< argc; i++)
            {
             value += strlen(argv[i]);
             if(value < 17)
             {

                string1[cnt] = argv[i][cnt];
             }
             if(value >16 && value < 23)
             {
                strcat(string2,argv[i]);
             }
            }

            DisplayLCDLine1(string1);

            if(value > 16)
            {
                DisplayLCDLine2(string2);
            }

            cli.println("echo: Display on LCD");
        }
    return CLI_OK;
    }
}

cli_status_t led7_func(int argc, char **argv)
{
    int value;
    if(argc > 1)
    {
        if(strcmp(argv[1], "-help") == 0)
        {
            cli.println("LED7 help menu: \r<led7> <disp> <value(1->8)>");
        }

        if(strcmp(argv[1], "disp") == 0)
        {
            value = atoi(argv[2]);
            if(value >= 0 && value < 10)
            {
                Led7Disp1(value);
                cli.println("echo: display ");
                user_uart_println(argv[2]);
            }

        }

    }
    else
    {
        cli.println("echo: <led7> <value>");
    }
    return CLI_OK;
}


