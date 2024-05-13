# - - - - - - - - - - - - - #
#    Variables to change    #
# - - - - - - - - - - - - - #

# CA65 executable locations
CA65 = ../../cc65/bin/ca65.exe

# LD65 executable locations
LD65 = ../../cc65/bin/ld65.exe

# Emulator executable location
EMULATOR = ../../emu/Mesen/Mesen.exe

# Game name
GAME_NAME = Undertale

# Bin folder for binary output
BIN = bin

# Folder with assembler sources files
ASM = asm

# Natural Docs exectuable location
NATURALDOCS = "..\..\doc\Natural Docs\NaturalDocs.exe"


# ! - - - - - - - - - - - - - - - - ! #
#  DO NOT CHANGE ANYTHING AFTER THIS  #
# ! - - - - - - - - - - - - - - - - ! #


# make the nes game from assembler files
all:
	make clean_all
	make $(GAME_NAME).nes
	make $(GAME_NAME)_music.nes
	make clean


# create the nes file from assembler sources
$(GAME_NAME).nes: FORCE
# create folder if it does not exist
	mkdir -p "$(BIN)"
# assemble main file
	$(CA65) asm/crt0.asm -o $(BIN)/$(GAME_NAME).o --debug-info
# link files
	$(LD65) $(BIN)/$(GAME_NAME).o -C link.cfg -o $(GAME_NAME).nes --dbgfile $(GAME_NAME).DBG


# create the nes file (music player) from assembler sources
$(GAME_NAME)_music.nes: FORCE
# create folder if it does not exist
	mkdir -p "$(BIN)"
# assemble main file
	$(CA65) asm/crt0.asm -o $(BIN)/$(GAME_NAME)_music.o --debug-info -DMUSICROM
# link files
	$(LD65) $(BIN)/$(GAME_NAME)_music.o -C link.cfg -o $(GAME_NAME)_music.nes --dbgfile $(GAME_NAME)_music.DBG


# clean object files
clean:
	-rm -rf "$(BIN)"


# clean all generated files
clean_all:
	make clean
	rm -f $(GAME_NAME).nes
	rm -f $(GAME_NAME).DBG


# run the nes game generated with assembler sources
run:
	$(EMULATOR) $(GAME_NAME).nes


# generate the documentation
doc: FORCE
	mkdir -p "doc"
	$(NATURALDOCS) "cfg/nd"


data: FORCE
	python py/csv/buildcsv.py data/monsters -o data
	python py/csv/fights2asm.py data/fights.csv -o asm/data/fights.asm
	python py/csv/name2asm.py data/names.csv -o asm/data/monster_names.asm
	python py/csv/stats2asm.py data/stats.csv -o asm/data/monster_stats.asm

	python py/buildcode.py data/monsters -o asm/data

	python py/txtEncode/buildtxt.py data/monsters -to asm/data/txt.bin -co asm/data/txt_const.asm
	python py/txtEncode/lz_encode_block.py asm/data/txt.bin -o asm/data/txt.bin -a asm/data/txt_data.asm

	python py/anim/bw_bkgimg2chr.py data/monsters -d asm/data/img_bkg.bin -b 16 -cf asm/data/img_bkg_const.asm -c data/BKGANIM.chr
	python py/anim/bw_sprimg2chr.py data/monsters -d asm/data/img_spr.bin -b 64 -bs data/BKGANIM.chr -cf asm/data/img_spr_const.asm -c data/SPRANIM.chr
	python py/merge_chr.py -o data/TMP.chr data/BKGANIM.chr data/SPRANIM.chr -p 0
	python py/anim/bkgimg2chr.py data/monsters -d asm/data/img_bkg_cl.bin -b 16 -bs data/TMP.chr -cf asm/data/img_bkg_cl_const.asm -c data/BKGCLANIM.chr
	python py/merge_chr.py -o Undertale.chr data/BASE.chr data/TMP.chr data/BKGCLANIM.chr
	python py/anim/buildanim.py data/monsters -a asm/data/anim_data.asm -c asm/data/anim_const.asm

img:
	python py/bin2img.py $(GAME_NAME).nes nesfile.png NES 2048

FORCE: