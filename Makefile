#Makefile
VASM=vasmm68k_mot
CPU=-m68020
PLATFORM=atari

ifeq ($(PLATFORM),atari)
FLAGS=$(CPU) -DATARI -Ftos -tos-flags=0 -monst
EXT=.tos
else
FLAGS=$(CPU) -DAMIGA -Fhunkexe -nosym
EXT=
endif

all: $(TARGETS)

clean:
	rm -f *.o *.$(EXT)

day01: day01.s
	$(VASM) $(FLAGS) $< -o $@$(EXT)

