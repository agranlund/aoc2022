#Makefile
VASM  = vasmm68k_mot
GBASM = rgbasm
GBLNK = rgblink
GBFIX = rgbfix
TASS  = 64tass
NASM  = nasm
CC    = gcc

all: day01 day02 day03 day04 day05 day06 day07 day08

clean:
	rm -f *.o *.tos *.exe *.gb *.prg *.com

# Day 1: Calorie counting (Atari, 68000)
day01: day01.s
	$(VASM) -m68000 -Ftos -tos-flags=0 -monst $< -o $@.tos

# Day 2: Rock Paper Scissors (Amiga, 68000)
day02: day02.s
	$(VASM) -m68000 -Fhunkexe -nosym $< -o $@.exe

# Day 3: Rucksack reorganization (ameboy, Z80-ish)
day03: day03.s
	$(GBASM) -o $@.o $<
	$(GBLNK) -o $@.gb day03.o
	$(GBFIX) -v -p 0 $@.gb

# Day 4: Camp Cleanup (Commodore 64, 6502)
day04: day04.s
	$(TASS) -a -i $< -o $@.prg

# Day 5: Supply Stacks (Atari, 68020)
day05: day05.s
	$(VASM) -m68020 -Ftos -tos-flags=0 -nosym $< -o $@.tos

# Day 6 : Tuning Trouble (DOS, 8086)
day06: day06.s
	$(NASM) -f bin $< -o $@.com

# Day 7: No Space Left On Device (Atari, 68000)
day07: day07.s
	$(VASM) -m68000 -Ftos -tos-flags=0 -nosym $< -o $@.tos

#day08: Treetop Tree House  (Atari, 68000)
day08: day08.s
	$(VASM) -m68000 -Ftos -tos-flags=0 -nosym $< -o $@.tos
