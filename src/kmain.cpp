#include "stdlibs/stdlibs.h"


extern "C" void kmain()
{
    const short color   = 0x0F00;
    const char* hello   = "YEEEEEEEEEEEEEEEEEEEEEEEEEESSSSSSSSSSSSSSSSSSSS!";
    short* vga          = (short*)0xb8000;


    for (int i=0; i<strlen(hello); ++i)
        vga[i+80] = color | hello[i];
}
