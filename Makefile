#Makefile
VASM=vasmm68k_mot
CPU=-m68020

VASM_ATARI=$(VASM) $(CPU) -DATARI -Ftos -tos-flags=0 -monst $< -o $@.tos
VASM_AMIGA=$(VASM) $(CPU) -DAMIGA -Fhunkexe -nosym $< -o $@.exe

clean:
	rm -f *.o *.tos *.exe

day01: day01.s
	$(VASM_ATARI)

day02: day02.s
	$(VASM_AMIGA)
