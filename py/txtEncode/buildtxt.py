import argparse
import csv
import glob
import os
from txt_2_bin import txt_2_bin, printv, V_INFO

# args
parser = argparse.ArgumentParser()
parser.add_argument("folder")
parser.add_argument("-to", "--txtout", default="text.bin")
parser.add_argument("-co", "--constout", default="const.asm")
args = parser.parse_args()

# find all text.csv
printv(f"find all text.csv...", param="t", v=V_INFO)
csv_filenames = glob.glob(os.path.join(args.folder, "**/text.csv"), recursive=True)

#
alltxt = bytearray()
allconst = {}

for filename in csv_filenames:
    printv(f"convert '{filename}' ...", param="t", v=V_INFO)
    with open(filename) as f:
        reader = csv.reader(f, delimiter="\t")
        for row in reader:
            # ignore empty row
            if len(row) == 0:
                continue
            txt_const, txt = row[0], row[1]
            txt += "<end>"
            txt = txt_2_bin(txt)
            allconst[txt_const] = len(alltxt)
            alltxt.extend(txt)

# outputting results
printv(f"writing results...", param="t", v=V_INFO)
with open(args.txtout, "wb") as f:
    f.write(alltxt)
with open(args.constout, "w") as f:
    f.write(f"; This file was generated\n\n; Text constants:\n")
    for name, val in allconst.items():
        f.write(f"    {name} = {val}\n")
