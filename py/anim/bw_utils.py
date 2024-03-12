import os
import csv
import numpy as np
from PIL import Image

ANIM_HEADER = ["img", "name", "bkg_or_spr", "pos_x", "pos_y", "duration_time", "next_name", "atr_if_spr", "move_if_spr"]


def img2tiles(img: Image.Image, tw=8, th=8):
    arr = np.array(img.convert("1"))
    return arr2tiles(arr, img.width, img.height, tw=tw, th=th)


def imgcl2tiles(img: Image.Image, tw=8, th=8):
    arr = np.array(img.convert("L")) >> 6
    return arr2tiles(arr, img.width, img.height, tw=tw, th=th)


def arr2tiles(arr, w, h, tw=8, th=8):
    h = h // th + (1 if h % th else 0)
    w = w // tw + (1 if w % tw else 0)

    tiles = []
    data = []
    i = 0
    for y in range(h):
        for x in range(w):
            t = arr[y * th : y * th + th, x * tw : x * tw + tw]
            t = np.pad(t, ((0, th - t.shape[0]), (0, tw - t.shape[1])))
            tiles.append(t)
            data.append(i)
            i += 1

    return (w, h), np.array(tiles, dtype=np.int8), data


def tile2chr(tile, size=16):
    chrtile = bytearray(size)
    for i in range(size // 2):
        chrtile[i] = np.packbits(tile[i] & 0x01)[0]
    for i in range(size // 2):
        chrtile[i + (size // 2)] = np.packbits(tile[i] & 0x02)[0]
    return chrtile


def tilest2chr(tiles):
    chr = bytearray(0)
    for t in tiles:
        chr.extend(tile2chr(t))
    return chr


def spritest2chr(tiles):
    chr = bytearray(0)
    for t in tiles:
        chr.extend(tile2chr(t[0:8]))
        chr.extend(tile2chr(t[8:16]))
    return chr


def get_anim_csv(csv_filenames, type="background"):
    correct_csv = []
    for fn in csv_filenames:
        with open(fn) as f:
            reader = csv.reader(f)
            for row in reader:
                if row == ANIM_HEADER:
                    correct_csv.append(fn)
                break
    return correct_csv


def get_imgs_from_csv(csv_filenames, type="background"):
    img_filenames = []
    for fn in csv_filenames:
        with open(fn) as f:
            reader = csv.reader(f)
            has_first = True
            i = 0
            for row in reader:
                # if header
                if has_first:
                    # if header not correct (incorrect csv file)
                    if row != ANIM_HEADER:
                        break
                    has_first = False
                    continue
                i += 1
                # if empty line
                if len(row) == 0:
                    continue
                # if tow few data
                if len(row) < 3:
                    print("Error: tow few argument in", fn, "at row", i)
                    continue
                #
                if row[2] == type:
                    basefolder = os.path.dirname(fn)
                    path = os.path.join(basefolder, row[0])
                    if not os.path.exists(path):
                        print("Error: file names at row", i, "in", fn, "does not exist")
                    else:
                        if path not in img_filenames:
                            img_filenames.append(path)
    return img_filenames


def name2const(name):
    name = os.path.splitext(name)[0].upper()
    name = name.replace("/", "_").replace("\\", "_").replace(".", "_")
    return name
