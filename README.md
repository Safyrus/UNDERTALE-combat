# NES UNDERTALE Combat

## About The Project

This is an attempt at recreating the **UNDERTALE combat** system for the **NES**.

This project also contain another project:
A **demake** of all the **UNDERTALE OST** using the **NES MMC5** mapper.
You can find the project [here](data/undertale.fms).
You will need [FamiStudio](https://famistudio.org/) to open it.
Also, I'm no musician, so I'm sure there are mistakes here and there.

## Downloads

### Nightly build

Somewhere at the root of the repo (for now).

- [Combat ROM](Undertale.nes)
- [Music ROM](Undertale_music.nes)

## Emulators

I recommend playing it on the [Mesen](https://www.mesen.ca/) emulator
because it's the emulator that I use to test & debug the game on,
so it should work fine.
It is also the most accurate emulator that I know
(I can't think of developing on the NES without all of these debugging features).

## Compile

### Prerequisite

- Make
- [CC65](https://github.com/cc65/cc65): An 6502 C compiler uses to create the binary file used by the NES and the Emulator
- Python with all the necessary packages:
  - argparse
  - Pillow
  - numpy
- [FamiStudio](https://famistudio.org/): If you want to edit the musics

### Commands

Note: You may need to change some configs in the Makefile to be able to run commands.

| Commands    | Description                  |
| ----------- | ---------------------------- |
| `make`      | Compile the game             |
| `make data` | Compile the game data        |
| `make run`  | Run the game                 |
| `make doc`  | Generate the doc             |
| `make img`  | Convert the .nes into a .png |

## Credits / Disclaimer

```
UNDERTALE belongs to Toby Fox.
Please support the original release @ https://undertale.com

You can get the Soundtrack on Steam (https://store.steampowered.com/app/391570/UNDERTALE_Soundtrack/)
or at https://tobyfox.bandcamp.com/album/undertale-soundtrack
```

### NES

- [NesDev](https://www.nesdev.org/wiki/Nesdev_Wiki) of course.
- Nintendo for the NES, I suppose.

### Tools

- [FamiStudio](https://famistudio.org) sound engine by BleuBleu.
- [UndertaleModTool](https://github.com/UnderminersTeam/UndertaleModTool) for decompiling Undertale.

### Musics

Ressources that help me a lot made by people much more talented than me in regard to musics.

- [The Toby Fox Sample Sheet](https://docs.google.com/spreadsheets/d/10is6jIBxYlPm0Bcaf0KFFw9TE0bph8L0pcXSiz6xs5E/edit#gid=676961136)
- Undertale MIDI Resource Archive
  (ShinkoNetCavy, Lu9, Radixan, Jay Reichard, JJokerDude, Zorzag2, Williatico, Zumi, Epikjman27, ShadowChords, and Revle.)
- Undertale MIDI by [Radiáxn](https://yewtu.be/channel/UCFDBGreo_wuOiSDgHDJPHig)
- This [Reddit post](https://www.reddit.com/r/Undertale/comments/9msp3f/heres_a_dump_of_all_the_undertale_midi_files_ive/)

