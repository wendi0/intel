#include <system.h>
#include <multiboot.h>

/* You will need to code these up yourself!  */
unsigned char *memcpy(unsigned char *dest, const unsigned char *src, int count)
{
    /* Add code here to copy 'count' bytes of data from 'src' to
    *  'dest', finally return 'dest' */

  int i;
  for (i=0; i < count; ++i)
    *dest++ = *src++;

  return dest;
}

unsigned char *memset(unsigned char *dest, unsigned char val, int count)
{
    /* Add code here to set 'count' bytes in 'dest' to 'val'.
    *  Again, return 'dest' */
  int i;
  for (i=0; i < count; ++i)
    *dest++ = val;

  return dest;
}

unsigned short *memsetw(unsigned short *dest, unsigned short val, int count)
{
    /* Same as above, but this time, we're working with a 16-bit
    *  'val' and dest pointer. Your code can be an exact copy of
    *  the above, provided that your local variables if any, are
    *  unsigned short */
  int i;
  for (i=0; i < count; ++i)
    *dest++ = val;

  return dest;

}

int strlen(const char *str)
{
    /* This loops through character array 'str', returning how
    *  many characters it needs to check before it finds a 0.
    *  In simple words, it returns the length in bytes of a string */
  long int n; n = 0;

  while (*str++ != 0) 
    ++n;

  return n;
}

/* We will use this later on for reading from the I/O ports to get data
*  from devices such as the keyboard. We are using what is called
*  'inline assembly' in these routines to actually do the work */
unsigned char inportb (unsigned short _port)
{
    unsigned char rv;
    __asm__ __volatile__ ("inb %1, %0" : "=a" (rv) : "dN" (_port));
    return rv;
}

/* We will use this to write to I/O ports to send bytes to devices. This
*  will be used in the next tutorial for changing the textmode cursor
*  position. Again, we use some inline assembly for the stuff that simply
*  cannot be done in C */
void outportb (unsigned short _port, unsigned char _data)
{
    __asm__ __volatile__ ("outb %1, %0" : : "dN" (_port), "a" (_data));
}

/* This is a very simple main() function. All it does is sit in an
*  infinite loop. This will be like our 'idle' loop */
void main(unsigned long magic, unsigned long addr)
{
  struct multiboot_info *mb;

  init_video(); puts("video set up\n");

  mb = (struct multiboot_info *) addr;

  /* Print out the flags. */
  printf("flags = 0x%x\n", (unsigned) mb->flags);

  /* investigate the available memory */
  if (CHECK_FLAG (mb->flags, 0)) {
    printf ("mem_lower = %uKB, mem_upper = %uKB\n",
	    (unsigned) mb->mem_lower, (unsigned) mb->mem_upper);
  }

  /* Is boot_device valid? */
  if (CHECK_FLAG (mb->flags, 1))
    printf ("boot_device = 0x%x\n", (unsigned) mb->boot_device);
     
  /* Is the command line passed? */
  if (CHECK_FLAG (mb->flags, 2))
    printf ("cmdline = %s\n", (char *) mb->cmdline);
     
  /* Are mods_* valid? */
  if (CHECK_FLAG (mb->flags, 3))
    {
      module_t *mod;
      int i;
     
      printf ("mods_count = %d, mods_addr = 0x%x\n",
	      (int) mb->mods_count, (int) mb->mods_addr);
      for (i = 0, mod = (module_t *) mb->mods_addr;
	   i < mb->mods_count;
	   i++, mod++)
	printf (" mod_start = 0x%x, mod_end = 0x%x, string = %s\n",
		(unsigned) mod->mod_start,
		(unsigned) mod->mod_end,
		(char *) mod->string);
    }
     
  /* Bits 4 and 5 are mutually exclusive! */
  if (CHECK_FLAG (mb->flags, 4) && CHECK_FLAG (mb->flags, 5))
    {
      printf ("Both bits 4 and 5 are set.\n");
      return;
    }
     
  /* Is the symbol table of a.out valid? */
  if (CHECK_FLAG (mb->flags, 4))
    {
      aout_symbol_table_t *aout_sym = &(mb->u.aout_sym);
     
      printf ("aout_symbol_table: tabsize = 0x%0x, "
	      "strsize = 0x%x, addr = 0x%x\n",
	      (unsigned) aout_sym->tabsize,
	      (unsigned) aout_sym->strsize,
	      (unsigned) aout_sym->addr);
    }
     
  /* Is the section header table of ELF valid? */
  if (CHECK_FLAG (mb->flags, 5))
    {
      elf_section_header_table_t *elf_sec = &(mb->u.elf_sec);
     
      printf ("elf_sec: num = %u, size = 0x%x,"
	      " addr = 0x%x, shndx = 0x%x\n",
	      (unsigned) elf_sec->num, (unsigned) elf_sec->size,
	      (unsigned) elf_sec->addr, (unsigned) elf_sec->shndx);
    }
     
  /* Are mmap_* valid? */
  if (CHECK_FLAG (mb->flags, 6))
    {
      memory_map_t *mmap;
     
      printf ("mmap_addr = 0x%x, mmap_length = 0x%x\n",
	      (unsigned) mb->mmap_addr, (unsigned) mb->mmap_length);
      for (mmap = (memory_map_t *) mb->mmap_addr;
	   (unsigned long) mmap < mb->mmap_addr + mb->mmap_length;
	   mmap = (memory_map_t *) ((unsigned long) mmap
				    + mmap->size + sizeof (mmap->size)))
	printf (" size = 0x%x, base_addr = 0x%x%x,"
		" length = 0x%x%x, type = 0x%x\n",
		(unsigned) mmap->size,
		(unsigned) mmap->base_addr_high,
		(unsigned) mmap->base_addr_low,
		(unsigned) mmap->length_high,
		(unsigned) mmap->length_low,
		(unsigned) mmap->type);
    }

  gdt_install();
  idt_install(); 
  isr_install(); 
  irq_install(); 

  timer_install(); puts("clock set up\n");
  kb_install(); puts("keyboard set up\n");
  //__asm__ __volatile__ ("sti"); puts("interrupts will now fire\n");

  //puts("im bery good at division... wanna see?\n"); putch(1/0);
  
  //for (;;); /* */
}
