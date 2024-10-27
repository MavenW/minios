; boot.asm - Bootloader básico
[BITS 16]
[ORG 0x7C00]

; Constantes
KERNEL_OFFSET equ 0x1000
KERNEL_SEGMENTS equ 20      ; Cargar 20 segmentos (160KB)

start:
    ; Inicializar segmentos
    mov ax, 0x07C0
    mov ds, ax
    mov es, ax
    
    ; Configurar stack
    mov ax, 0x0000
    mov ss, ax
    mov sp, 0xFFFF
    
    ; Mostrar mensaje de inicio
    mov si, boot_msg
    call print_string
    
    ; Cargar kernel
    call load_kernel
    
    ; Cambiar a modo protegido
    call switch_to_pm
    
    jmp $

; Función para imprimir string
print_string:
    pusha
    mov ah, 0x0E
.loop:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .loop
.done:
    popa
    ret

; Cargar kernel desde disco
load_kernel:
    mov ah, 0x02        ; Función BIOS para leer
    mov al, KERNEL_SEGMENTS  ; Número de sectores
    mov ch, 0           ; Cilindro 0
    mov cl, 2           ; Sector 2
    mov dh, 0           ; Cabeza 0
    mov bx, KERNEL_OFFSET
    int 0x13
    jc disk_error
    ret

disk_error:
    mov si, disk_error_msg
    call print_string
    jmp $

; Cambio a modo protegido
switch_to_pm:
    cli
    lgdt [gdt_descriptor]
    
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    
    jmp CODE_SEG:init_pm

[BITS 32]
init_pm:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    
    mov ebp, 0x90000
    mov esp, ebp
    
    jmp KERNEL_OFFSET

; GDT
gdt_start:
gdt_null:
    dd 0x0
    dd 0x0

gdt_code:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10011010b
    db 11001111b
    db 0x0

gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

; Datos
boot_msg db 'Iniciando MiniOS...', 0x0D, 0x0A, 0
disk_error_msg db 'Error al cargar kernel!', 0x0D, 0x0A, 0

times 510-($-$$) db 0
dw 0xAA55