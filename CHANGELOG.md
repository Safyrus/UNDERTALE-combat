# Changelog

## 0.1.0 - 2024.05.14 : OST update

- **All the OST is now done!**
- Change python music helper script to also generate some assembly files.
- Export all the OST to assembly.
- Change Makefile to also create the music NES file.
- Fix FamiStudio bug related to incrementing 16 bits pointer when fetching a song.
  (Already fix in new release, I just need to update the engine and re-export all the song, again -_-)

## 0.0.23 - 2024.04.23

- Add a piece of code that transform the game into a music player when compiling with the `MUSICROM` flag
- Fix some musics
- Fix a bug when preprocessing text containing `SPD 0`

## 0.0.22 - 2024.04.22

- Musics (94/101)

## 0.0.21 - 2024.03.26

- Another batch of musics (79/101)

## 0.0.20 - 2024.03.19

- A lot of musics (64/101)

## 0.0.19 - 2024.03.1X

- int (16bits) to BCD
- BCD to big number sprites
- Start adding FIGHT animation
  - Damage numbers
  - hit marker (also fixed it being displayed oustide of the box)

## 0.0.18 - 2024.03.13

- Change python script making stats & names to pad thing correctly depending on monsters id
- Fix python scripts
  - Convertion of negative number into hex
  - _pos_ and _spa_ not working
  - Remove transparency from images convertion, because too many color ?
- Start adding _Dummy_ monster
- Change some monster code and macros to be global
- Fix assembly
  - Animation with only 1 frame not having position set correctly
  - Menu displaying not enought or too many dialogs
  - Damage calculation using player defense instead of monster defense
  - Some control characters
  - Minor things
- Refactor clearing main box to work for any dialog box size

## 0.0.17 - 2024.03.11

- Add ITEM (but still not the actual items)
- Updated Famistudio
- Setup Musics
  - FamiStudio (init,update,play)
  - Table for more than 8KB of musics
  - DPCM callback
  - protect inputs from DPCM conflict
  - Script to find in which bank to put musics
- Add more stats to fps lua scripts
- Optimise remove_all_sprite and draw_spr_buf
- Finally making a git repo

## 0.0.16 - 2024.03.09

- Made many musics (44/101)
- Add script and change others to encode color image (4 color max & can't choose)
- Add fight soul
  - display atk image
  - hit marker that move and stop when pressing A
  - damage computation (but monster still need to apply them, with it's own rules if needed)
- Add wait soul (ez)

## 0.0.15 - 2024.02.24

- Change menu text display from 8 char to 15 char + font
- Spare functionnal: Add yellow spare text if any monster set their spare flag
- Little cycle optimization on updating bullets sprites
- Change variables location to use more of the RAM bank
- Add functionnal ACT menu
- Monsters can/need to setup their act menu
- Variable string size when drawing menu text (fix text overlapping)
- Made many musics (18/101)

## 0.0.14 - 2024.02.18

- Add bullets
  - hitbox collision detection
  - bullet/collision move and hit call
  - add basic bullet type that follow the player at 45 degree angle
  - can be link to an animation (and thus draw the bullet)
- add lua script to see hitbox
- Change background packet to have low/high priority
  (fixing drawing text before clearing the dialog box)
- fix sprites
  - box animation move before sprite buffer draw
  - clear sprite every frame
  - python script (CHR)
- Refactor monster events to work like interrupts
  (game set interrupt, monster clear it, event called each frame when interrupt set)
- Change menu to have a dialog to display (set by monsters). Menu now redisplay dialog when in main menu
- Add crude dialog speed skip when in menu soul
- Add 'basic attack' to testobug turn (resize dialog box + soul=red -> spawn some bullet every ~1s for 8s -> end turn)
- Work on sans and papyrus font

## 0.0.13 - 2024.02.12

- Add sprite animations
  - data encoding (python)
  - decoding (reuse background code)
  - image to entity
  - create and remove entities
  - draw sprite from entities
  - entity animations (by linking entities to animations)
- Fix wrong constants in anim data
- Move some variables into ZP
- update 'fps.lua' script to display FPS and CPU usage

## 0.0.12 - 2024.02.09

- Add menu logic
  - select menu option
  - jump to selected option
  - return to previous selected option
- Add menu draw
  - change position based on selected option
  - draw menu option text (still a bug where text is drawn before clearing box)
- Add partial menu data for fight, act and spare
- Change reset and init code location in another bank
- Refactor main menu display to work with the real menu system
- Fix bugs that I don't remember (because I didn't note them when I fix them)

## 0.0.11 - 2024.02.05

- Change bank layout
- Fix bugs
- Add script to generate animation and constant data
- Add background animations
- Optimise NMI background code (some bytes and some cycles)
- Change main to disable NMI palette update at the stat of each frame but can still be enabled later in the frame

## 0.0.10 - 2024.02.04

- Fix python script 'bw_bkgimg2chr' (incorrect data and tile positions)
- Add code to draw background image
  - find image in data
  - decode the image with rleinc
  - cut the image into lines that are put in a ppu packet buffer
  - draw packet inside the packet buffer that fit in current ppu background array
- Build CHR with background image tiles

## 0.0.9 - 2024.02.02

- Add random function (from nesdev)
- Add script to generate monster text data
  - merge text
  - generate constants
- Add code to read text monster data and LZ decode if needed

## 0.0.8 - 2024.02.01

- Add scripts to transform background and sprite images into CHR and Data.
- Add script to copy monsters code to asm data
  - Event labels are changed to match destination folder
  - Generate include file
  - Generate code and bnk arrays

## 0.0.7 - 2024.01.27

- Fix wait in-frame with scanline IRQ.
- Change order of color in backgrounds palette.
- Add player UI with HP bar and numbers that can be updated (for now with the B button when in menu soul).
- Oh, and remove B debug button from red souls a moment ago.

## 0.0.6 - 2024.01.27

- Add fights structure (choose which monster to load)
- Add (empty) monster data array and structures (names, stats, code)
- Add basic monsters loading (stats and names)
- Add scripts to convert some specific CSV data to specific ASM (stats, names, fights)
- Add code to call events (only "start" is called for now)

## 0.0.5 - 2024.01.25

- Add Blue soul.
- Refactor bounding box collision to be outside soul types.
- Main dialog box can now be resized with an adaptive animation.
  - This also affect bounding box (so the player collision follow the animation).
  - Limitation of this code: x resize THEN y resize, not both at the same time.
  - 1 KB of lots of code repetition x_x.

## 0.0.4 - 2024.01.24

- Add basic text display in multiple dialog boxes at the same time.
  - Dialog box structure.
  - Preprocess text to create necessary dialog box.
  - Process text (printing and control char).
  - Post process to destroy all dialog box.
- Temporary debug input (B) in red soul to read next text.

## 0.0.3 - 2024.01.22

- Change palette / fix having 'orange' instead of 'red' / NES color are complicated.
- Start adding soul type.
- Add menu soul (can't select any actions for now, only visual).
  - Soul move on the 4 main actions and highlight the selected one.
  - Temporary debug input (A) for switching between red and menu soul.
- Update CHR for the menu to work
- Fix FIGHT and ACT position.

## 0.0.2 - 2024.01.21

- Change player movement to have a bounding box.
- Add UI (not functional, just drawn on the screen).

## 0.0.1 - 2024.01.21

- Add Natural Docs
- Add a player sprite that can be moved with the d-pad.
- Some code related to sprite initialization for it to work.
- Added a script to see the precise player position

## 0.0.0 - 2024.01.21

- The start.
- Boilerplate stuff.
- Adapted determination font to 8*8.
