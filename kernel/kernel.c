// kernel.c
#include "kernel.h"
#include "drivers/screen.h"
#include "drivers/keyboard.h"
#include "drivers/mouse.h"
#include "drivers/ata.h"
#include "fs/filesystem.h"
#include "console/console.h"

void kernel_main(void) {
    init_all();
    console_init();
    
    while(1) {
        console_update();
    }
}

void init_all(void) {
    screen_init();
    keyboard_init();
    mouse_init();
    ata_init();
    fs_init();
}