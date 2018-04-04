; REWRITE in AT&T syntax
	

; This is the kernel's entry point. We could either call main here,
; or we can use this to setup the stack or other nice stuff, like
; perhaps setting up the GDT and segments. Please note that interrupts
; are disabled at this point by the boot loader
[BITS 32]
global start
extern main
start:
    mov esp, _sys_stack     ; This points the stack to our new stack area
    push dword 0            	; reset eflags
    popf
    push ebx 			; push mboot struct pointer
    push eax 			; push magic value
    call main
    jmp $

; This part MUST be 4byte aligned, so we solve that issue using 'ALIGN 4'
ALIGN 4
mboot:
    ; Multiboot macros to make a few lines later more readable
    MULTIBOOT_PAGE_ALIGN	equ 1<<0
    MULTIBOOT_MEMORY_INFO	equ 1<<1
    MULTIBOOT_AOUT_KLUDGE	equ 1<<16

    MULTIBOOT_HEADER_MAGIC	equ 0x1BADB002
    MULTIBOOT_HEADER_FLAGS	equ MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO | MULTIBOOT_AOUT_KLUDGE
    MULTIBOOT_CHECKSUM	equ -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)
    EXTERN code, bss, end

    ; This is the GRUB Multiboot header. A boot signature
    dd MULTIBOOT_HEADER_MAGIC
    dd MULTIBOOT_HEADER_FLAGS
    dd MULTIBOOT_CHECKSUM
    
    ; AOUT kludge - must be physical addresses. Make a note of these:
    ; The linker script fills in the data for these ones!
    dd mboot
    dd code
    dd bss
    dd end
    dd start

; Shortly we will add code for loading the GDT right here!
	;; done
; This will set up our new segment registers. We need to do
; something special in order to set CS. We do what is called a
; far jump. A jump that includes a segment as well as an offset.
; This is declared in C as 'extern void gdt_flush();'
global gdt_flush     ; Allows the C code to link to this
extern gp            ; Says that '_gp' is in another file
gdt_flush:
    lgdt [gp]        ; Load the GDT with our '_gp' which is a special pointer
    mov ax, 0x10     ; 0x10 is the offset in the GDT to our data segment
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    jmp 0x08:flush2   ; 0x08 is the offset to our code segment: Far jump!
flush2:
    ret               ; Returns back to the C code!

; In just a few pages in this tutorial, we will add our Interrupt
; Service Routines (ISRs) right here!
	;; done
; Loads the IDT defined in 'idtp' into the processor.
; This is declared in C as 'extern void idt_load();'
global idt_load
extern idtp
idt_load:
    lidt [idtp]
    ret

; In just a few pages in this tutorial, we will add our Interrupt
; Service Routines (ISRs) right here!
global isr0
global isr1
global isr2
global isr3
global isr4
global isr5
global isr6
global isr7
global isr8
global isr9
global isr10
global isr11
global isr12
global isr13
global isr14
global isr15
global isr16
global isr17
global isr18
global isr19
global isr20
global isr21
global isr22
global isr23
global isr24
global isr25
global isr26
global isr27
global isr28
global isr29
global isr30
global isr31

;  0: Divide By Zero Exception
isr0:
    cli
    push byte 0    ; A normal ISR stub that pops a dummy error code to keep a
                   ; uniform stack frame
    push byte 0
    jmp isr_common_stub

;  1: Debug Exception
isr1:
    cli
    push byte 0
    push byte 1
    jmp isr_common_stub

isr2:
    cli
    push byte 0
    push byte 2
    jmp isr_common_stub
	
isr3:
	cli
	push byte 0
	push byte 3
	jmp isr_common_stub
isr4:
	cli
	push byte 0
	push byte 4
	jmp isr_common_stub
isr5:
	cli
	push byte 0
	push byte 5
	jmp isr_common_stub
isr6:
	cli
	push byte 0
	push byte 6
	jmp isr_common_stub
isr7:
	cli
	push byte 0
	push byte 7
	jmp isr_common_stub

;  8: Double Fault Exception (With Error Code!)
isr8:
    cli
    push byte 8        ; Note that we DON'T push a value on the stack in this one!
                   ; It pushes one already! Use this type of stub for exceptions
                   ; that pop error codes!
    jmp isr_common_stub

isr9:
	cli
	push byte 0
	push byte 9
	jmp isr_common_stub

isr10:
    cli
    push byte 10   ; Note that we DON'T push a value on the stack in this one!
                   ; It pushes one already! Use this type of stub for exceptions
                   ; that pop error codes!
    jmp isr_common_stub

isr11:
	cli
	push byte 11
	jmp isr_common_stub
isr12:
	cli
	push byte 12
	jmp isr_common_stub
isr13:
	cli
	push byte 13
	jmp isr_common_stub
isr14:
	cli
	push byte 14
	jmp isr_common_stub

isr15:
	cli
	push byte 0
	push byte 15
	jmp isr_common_stub
isr16:
	cli
	push byte 0
	push byte 16
	jmp isr_common_stub
isr17:
	cli
	push byte 0
	push byte 17
	jmp isr_common_stub
isr18:
	cli
	push byte 0
	push byte 18
	jmp isr_common_stub
isr19:
	cli
	push byte 0
	push byte 19
	jmp isr_common_stub
isr20:
	cli
	push byte 0
	push byte 20
	jmp isr_common_stub
isr21:
	cli
	push byte 0
	push byte 21
	jmp isr_common_stub
isr22:
	cli
	push byte 0
	push byte 22
	jmp isr_common_stub
isr23:
	cli
	push byte 0
	push byte 23
	jmp isr_common_stub
isr24:
	cli
	push byte 0
	push byte 24
	jmp isr_common_stub
isr25:
	cli
	push byte 0
	push byte 25
	jmp isr_common_stub
isr26:
	cli
	push byte 0
	push byte 26
	jmp isr_common_stub
isr27:
	cli
	push byte 0
	push byte 27
	jmp isr_common_stub
isr28:
	cli
	push byte 0
	push byte 28
	jmp isr_common_stub
isr29:
	cli
	push byte 0
	push byte 29
	jmp isr_common_stub
isr30:
	cli
	push byte 0
	push byte 30
	jmp isr_common_stub
isr31:
	cli
	push byte 0
	push byte 31
	jmp isr_common_stub
	
; We call a C function in here. We need to let the assembler know
; that '_fault_handler' exists in another file
extern fault_handler

; This is our common ISR stub. It saves the processor state, sets
; up for kernel mode segments, calls the C-level fault handler,
; and finally restores the stack frame.
isr_common_stub:
    pusha          ; pushes a lota stuffa into da stack
    push ds
    push es
    push fs
    push gs
    mov ax, 0x10   ; Load the Kernel Data Segment descriptor!
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov eax, esp   ; Push us the stack
    push eax
    mov eax, fault_handler
    call eax       ; A special call, preserves the 'eip' register
    pop eax
    pop gs
    pop fs
    pop es
    pop ds
    popa
    add esp, 8     ; Cleans up the pushed error code and pushed ISR number
    iret           ; pops 5 things at once: CS, EIP, EFLAGS, SS, and ESP!

	;; irqs
global irq0
global irq1
global irq2
global irq3
global irq4
global irq5
global irq6
global irq7
global irq8
global irq9
global irq10
global irq11
global irq12
global irq13
global irq14
global irq15

	;; 32: irq0
irq0:
	cli
	push byte 0
	push byte 32
	jmp irq_common_stub

irq1:
	cli
	push byte 0
	push byte 33
	jmp irq_common_stub
	
irq2:
	cli
	push byte 0
	push byte 34
	jmp irq_common_stub

irq3:
	cli
	push byte 0
	push byte 35
	jmp irq_common_stub

irq4:
	cli
	push byte 0
	push byte 36
	jmp irq_common_stub

irq5:
	cli
	push byte 0
	push byte 37
	jmp irq_common_stub

irq6:
	cli
	push byte 0
	push byte 38
	jmp irq_common_stub

irq7:
	cli
	push byte 0
	push byte 39
	jmp irq_common_stub

irq8:
	cli
	push byte 0
	push byte 40
	jmp irq_common_stub

irq9:
	cli
	push byte 0
	push byte 41
	jmp irq_common_stub

irq10:
	cli
	push byte 0
	push byte 42
	jmp irq_common_stub

irq11:
	cli
	push byte 0
	push byte 43
	jmp irq_common_stub

irq12:
	cli
	push byte 0
	push byte 44
	jmp irq_common_stub

irq13:
	cli
	push byte 0
	push byte 45
	jmp irq_common_stub

irq14:
	cli
	push byte 0
	push byte 46
	jmp irq_common_stub

irq15:
	cli
	push byte 0
	push byte 47
	jmp irq_common_stub

extern irq_handler


; This is a stub that we have created for IRQ based ISRs. This calls
; '_irq_handler' in our C code. We need to create this in an 'irq.c'
irq_common_stub:
    pusha
    push ds
    push es
    push fs
    push gs
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov eax, esp
    push eax
    mov eax, irq_handler
    call eax
    pop eax
    pop gs
    pop fs
    pop es
    pop ds
    popa
    add esp, 8
    iret
	
; Here is the definition of our BSS section. Right now, we'll use
; it just to store the stack. Remember that a stack actually grows
; downwards, so we declare the size of the data before declaring
; the identifier '_sys_stack'
SECTION .bss
    resb 8192               ; This reserves 8KBytes of memory here
_sys_stack:

	