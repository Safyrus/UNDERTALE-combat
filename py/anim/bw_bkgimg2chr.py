import argparse
import glob
import os
import numpy as np
from PIL import Image
from bw_utils import img2tiles, tilest2chr
from rle_inc import rleinc_encode, rleinc_decode
from bw_utils import get_imgs_from_csv, name2const


# consts
PALETTE = 0x4000

# args
parser = argparse.ArgumentParser()
parser.add_argument("folder", help="folder containing mosnter images")
parser.add_argument("-c", "--chrfile", default="BKGANIM.chr")
parser.add_argument("-d", "--datafile", default="test.bin")
parser.add_argument("-cf", "--constfile", default="const.asm")
parser.add_argument("-b", "--bnk", type=int, default=0)
args = parser.parse_args()
args.bnk = int(args.bnk) << 8

# init phase
tile_list = []
data_list = []  # {"name": "", "size": (), "data":[]}

# getting phase
csv_filenames = glob.glob(os.path.join(args.folder, "**/*.csv"), recursive=True)
img_filenames = get_imgs_from_csv(csv_filenames, type="background")

# process phase
for imgname in img_filenames:
    print(imgname)
    # open image
    img = Image.open(imgname)
    # if number of color exeed 2
    if not img.getcolors(maxcolors=2):
        # skip
        print("Warning: number of color exeed 2 on img", imgname, ". ignoring")
        continue

    # cut image into tiles and data
    size, tiles, data = img2tiles(img)
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
        # try:
        #     idx = tile_list.index(t)
        # except ValueError:
        #     idx = -1
        # if tile seen before
        if idx >= 0:
            # then change the data to use the aleardy seen tile
            data[i] = idx
        else:
            # else add the tile to the list
            data[i] = len(tile_list)
            tile_list.append(t)

    # add formated data to the list
    data_list.append(
        {
            "name": imgname,
            "size": size,
            "data": data,
        }
    )

# palette phase
odd = len(tile_list) % 2
split_point = len(tile_list) // 2 + odd
for img_data in data_list:
    for i, d in enumerate(img_data["data"]):
        if d >= split_point:
            d = d - split_point + PALETTE
        d += args.bnk
        img_data["data"][i] = d

# tile merge phase
for i in range(split_point - odd):
    tile_list[i] = (tile_list[i]) + (tile_list[split_point + i] << 1)
tile_list = tile_list[:split_point]


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
    # 0=background, 1=sprite
    # atr = 0x00000000
    # width and height
    w, h = data["size"]
    # compressed data
    data_lo = [x & 0xFF for x in data["data"]]
    data_hi = [(x >> 8) & 0xFF for x in data["data"]]
    d = rleinc_encode(data_lo + data_hi)  # , doprint=True)
    # print(rleinc_decode(d, doprint=True))

    # data_bin.append(atr)
    data_bin.append(len(d) + 1)
    data_bin.append((w & 0xF) + ((h & 0xF) << 4))
    data_bin.extend(d)

# write to file
with open(args.datafile, "wb") as f:
    f.write(data_bin)
with open(args.constfile, "w") as f:
    f.write("""
; This file was generated

; background image constant
""")
    i = 0
    for data in data_list:
        name = name2const(data["name"])
        f.write(f"IMG_{name} = {i}\n")
        i += 1
    f.write(f"_IMG_LAST_BKG = {i}\n")
