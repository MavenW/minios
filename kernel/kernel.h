// kernel.h
#ifndef KERNEL_H
#define KERNEL_H

#define VIDEO_MEMORY 0xB8000
#define MAX_ROWS 25
#define MAX_COLS 80

// Prototipos de funciones del kernel
void kernel_main(void);
void init_all(void);

#endif
