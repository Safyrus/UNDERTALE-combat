import argparse
import glob
import os
import numpy as np
from PIL import Image
from bw_utils import imgcl2tiles, tilest2chr
from rle_inc import rleinc_encode
from bw_utils import get_imgs_from_csv, name2const


# args
parser = argparse.ArgumentParser()
parser.add_argument("folder", help="folder containing mosnter images")
parser.add_argument("-c", "--chrfile", default="BKGCLANIM.chr")
parser.add_argument("-d", "--datafile", default="test.bin")
parser.add_argument("-cf", "--constfile", default="const.asm")
parser.add_argument("-b", "--bnk", default=0)
parser.add_argument("-bs", "--bnk_size_from", default="")
args = parser.parse_args()

args.bnk = int(args.bnk) << 8
if args.bnk_size_from != "":
    size = os.path.getsize(args.bnk_size_from) >> 4
    if size % 64 != 0:
        size += 64 - (size % 64)
    args.bnk += size

# init phase
tile_list = []
data_list = []

# getting phase
csv_filenames = glob.glob(os.path.join(args.folder, "**/*.csv"), recursive=True)
img_filenames = get_imgs_from_csv(csv_filenames, type="background_color")

# process phase
for imgname in img_filenames:
    print(imgname)
    # open image
    img = Image.open(imgname)
    # if number of color exeed 4
    if not img.getcolors(maxcolors=4):
        # skip
        print("Warning: number of color exeed 4 on img", imgname, ". ignoring")
        continue

    # cut image into tiles and data
    size, tiles, data = imgcl2tiles(img)
    if size[0] > 16 or size[1] > 16:
        print(f"Error: img {imgname} too big {size}")

    # for each tile
    for i in range(len(tiles)):
        t = tiles[i]
        d = data[i]

        # try to find the tile on our list
        idx = -1
        for j, t1 in enumerate(tile_list):
            if np.equal(t, t1).all():
                idx = j
                break

        # if tile seen before
        if idx >= 0:
            # then change the data to use the already seen tile
            data[i] = idx
        else:
            # else add the tile to the list
            data[i] = len(tile_list)
            tile_list.append(t)

    pal = 2*0x4000

    # add formated data to the list
    data_list.append(
        {
            "name": imgname,
            "size": size,
            "data": data,
            "pal": pal,
        }
    )

# palette phase
for img_data in data_list:
    for i, d in enumerate(img_data["data"]):
        d += args.bnk + img_data["pal"]
        img_data["data"][i] = d


# CHR phase
chr = tilest2chr(tile_list)  # convert tiles to CHR
# write CHR to file
with open(args.chrfile, "wb") as f:
    chr = bytes(chr)
    f.write(chr)
    m = len(chr) % 1024
    if m > 0:
        f.write(bytes(1024 - m))

# compression phase
data_bin = bytearray()
for data in data_list:
    # width and height
    w, h = data["size"]
    # compressed data
    data_lo = [x & 0xFF for x in data["data"]]
    data_hi = [(x >> 8) & 0xFF for x in data["data"]]
    d = rleinc_encode(data_lo + data_hi)

    data_bin.append(len(d) + 1)
    data_bin.append((w & 0xF) + ((h & 0xF) << 4))
    data_bin.extend(d)

# write to file
with open(args.datafile, "wb") as f:
    f.write(data_bin)
with open(args.constfile, "w") as f:
    f.write("""
; This file was generated

; background color image constants
""")
    i = 0
    for data in data_list:
        name = name2const(data["name"])
        f.write(f"IMG_CL_{name} = _IMG_LAST_BKG + {i}\n")
        i += 1
    f.write(f"_IMG_LAST_BKG_CL = {i}\n")
