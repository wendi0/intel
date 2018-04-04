#ifndef SYSTEM_H
#define SYSTEM_H

/* Check if the bit BIT in FLAGS is set. */
#define CHECK_FLAG(flags,bit)   ((flags) & (1 << (bit)))


/* main.c */
extern unsigned char *memcpy(unsigned char *dest, const unsigned char *src, int count);
extern unsigned char *memset(unsigned char *dest, unsigned char val, int count);
extern unsigned short *memsetw(unsigned short *dest, unsigned short val, int count);
extern int strlen(const char *str);
extern unsigned char inportb (unsigned short _port);
extern void outportb (unsigned short _port, unsigned char _data);

/* screen.c */
extern void cls();
extern void putch(unsigned char c);
extern void puts(unsigned char *str);
extern void settextcolor(unsigned char forecolor, unsigned char backcolor);
extern void init_video();

/* gdt.c */
void gdt_install();
void gdt_set_gate(int num, unsigned long base, unsigned long limit, unsigned char access, unsigned char gran);

/* idt.c */
void idt_install();
void idt_set_gate(unsigned char num, unsigned long base, unsigned short sel, unsigned char flags);

/* isr.c */
struct regs /* This defines what the stack looks like after an ISR was running */
{
    unsigned int gs, fs, es, ds;      /* pushed the segs last */
    unsigned int edi, esi, ebp, esp, ebx, edx, ecx, eax;  /* pushed by 'pusha' */
    unsigned int int_no, err_code;    /* our 'push byte #' and ecodes do this */
    unsigned int eip, cs, eflags, useresp, ss;   /* pushed by the processor automatically */ 
};

void isrs_install();
void fault_handler(struct regs *r);

/* irq.c */
void irq_install();
void irq_install_handler(int irq, void (*handler)(struct regs *r));
void irq_uninstall_handler(int irq);

/* timer.c */
void timer_install();

/* kb.c */
void kb_install();

#endif
