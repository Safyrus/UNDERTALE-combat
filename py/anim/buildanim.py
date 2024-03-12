import argparse
import csv
import glob
import os
from bw_utils import get_anim_csv, name2const


def write_anim(f, anim, offset=0):
    f.write(f"    ; {anim['name']}\n")
    f.write(f"    .byte {anim['x']}, {anim['y']}, {anim['delay']}, {anim['srt']+offset} ; x, y, delay, type\n")
    f.write(f"    .word {anim['img']}, {anim['next']} ; img, next\n")


def write_all_anim_type(f, anims, imgtype, offset=0):
    for anim in anims:
        if anim["type"] == imgtype:
            write_anim(f, anim, offset)


# args
parser = argparse.ArgumentParser()
parser.add_argument("folder")
parser.add_argument("-a", "--animout", default="anim.asm")
parser.add_argument("-c", "--constout", default="const.asm")
args = parser.parse_args()

# getting phase
csv_filenames = glob.glob(os.path.join(args.folder, "**/*.csv"), recursive=True)
csv_filenames = get_anim_csv(csv_filenames)

# for each csv
anims = []
for fn in csv_filenames:
    with open(fn) as f:
        reader = csv.reader(f)
        next(reader)  # skip header
        # for each row
        for i, row in enumerate(reader):
            # skip empty
            if len(row) == 0:
                continue
            # skip if invalid
            if len(row) < 3:
                print("Error: not enought data at line", i + 2, "in file", fn)
                continue
            # get data
            img = os.path.join(os.path.dirname(fn), row[0])
            name = os.path.join(os.path.dirname(fn), row[1])
            imgtype = row[2]
            x = int(row[3]) if len(row) > 3 else 0
            y = int(row[4]) if len(row) > 4 else 0
            delay = int(row[5]) if len(row) > 5 else 0
            nextimg = row[6] if len(row) > 6 else ""
            atr = row[7] if len(row) > 7 else ""
            srt = int(row[8]) if len(row) > 8 and row[8] != "" else 0
            #
            anims.append(
                {
                    "img": "IMG_" + ("CL_" if imgtype == "background_color" else "") + name2const(img),
                    "name": "ANIM_" + name2const(name),
                    "type": imgtype,
                    "x": x if x >= 0 else (x & 0xFF),
                    "y": y if y >= 0 else (y & 0xFF),
                    "delay": delay,
                    "next": "ANIM_" + name2const(os.path.join(os.path.dirname(fn), nextimg)) if nextimg != "" else 0,
                    "atr": atr,
                    "srt": srt,
                }
            )


#
with open(args.animout, "w") as f:
    f.write("""
; this file was generated

.segment "MONSTER_ANIM_DATA"

anim_data:
""")
    write_all_anim_type(f, anims, "background", 0)

    f.write("""
; anim_data_bkg_cl
""")
    write_all_anim_type(f, anims, "background_color", 0)

    f.write("""
; anim_data_spr
""")
    write_all_anim_type(f, anims, "sprite", 1)


with open(args.constout, "w") as f:
    f.write(
        """
; this file was generated

; background anim constants:
"""
    )
    i = 0
    for anim in anims:
        if anim["type"] == "background":
            f.write(f"{anim['name']} = {i}\n")
            i += 1

    f.write("""

; background color anim constants:
""")
    for anim in anims:
        if anim["type"] == "background_color":
            f.write(f"{anim['name']} = {i}\n")
            i += 1

    f.write("""

; sprite anim constants:
""")
    for anim in anims:
        if anim["type"] == "sprite":
            f.write(f"{anim['name']} = {i}\n")
            i += 1
