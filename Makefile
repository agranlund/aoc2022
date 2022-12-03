#Makefile
VASM  = vasmm68k_mot
GBASM = rgbasm
GBLNK = rgblink
GBFIX = rgbfix
CC    = gcc

all: day01 day02 day03

clean:
	rm -f *.o *.tos *.exe *.gb

# Day 1: Calorie counting (Atari ST, M68000)
day01: day01.s
	$(VASM) -m68000 -Ftos -tos-flags=0 -monst $< -o $@.tos

# Day 2: Rock Paper Scissors (Amiga, M68000)
day02: day02.s
	$(VASM) -m68000 -Fhunkexe -nosym $< -o $@.exe

# Day 3: ? (Nintendo Gameboy, Z80-ish)
day03: day03.s
	$(GBASM) -o $@.o $<
	$(GBLNK) -o $@.gb day03.o
	$(GBFIX) -v -p 0 $@.gb

