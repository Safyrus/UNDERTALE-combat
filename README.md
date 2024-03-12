# NES UNDERTALE Combat

## About The Project

This is an attempt at recreating the UNDERTALE combat system for the NES.

This project is also trying to remake all the UNDERTALE ost using the NES MMC5 mapper.

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

## Downloads

### Nightly build

Somewhere at the root of the repo (for now).

## Emulators

I recommend playing it on the [Mesen](https://www.mesen.ca/) emulator
because it's the emulator that I use to test & debug the game on,
so it should work fine.
It is also the most accurate emulator that I know
(I can't think of developing on the NES without all of these debugging features).

## Credits / Disclaimer

```
UNDERTALE belongs to Toby Fox.
Please support the original release @ https://undertale.com
```

### NES

- [NesDev](https://www.nesdev.org/wiki/Nesdev_Wiki) of course.
- Nintendo for the NES, I suppose.

### Sound

- [FamiStudio](https://famistudio.org) sound engine by BleuBleu.
