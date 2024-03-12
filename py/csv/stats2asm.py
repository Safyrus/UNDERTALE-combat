import argparse
import csv
from utils import int2hex


# args
parser = argparse.ArgumentParser()
parser.add_argument("input", help="CSV file containing stats data")
parser.add_argument("-o", "--output", default="stats_data.asm")
parser.add_argument("-d", "--delimiter", default=",")
args = parser.parse_args()

args.has_header = True

#
n = 0

# file header
asm_file = """
; this file was generated

.segment "MONSTER_STRUCT_DATA"

;--------------------------------
; Array: monster_stats_data
;--------------------------------
;
; List of 256 <MonsterStats> structures.
; The index in the array is the ID of the monster.
;--------------------------------
monster_stats_data:
"""

# file data
with open(args.input, newline="") as csvfile:
    reader = csv.reader(csvfile, delimiter=args.delimiter)
    for row in reader:
        # skip header
        if args.has_header:
            args.has_header = False
            continue
        # skip empty lines
        if len(row) == 0:
            continue

        # add words to file
        asm_file += f"    .word "
        for i in range(6):
            s = int2hex(int(row[i]) if len(row) > i else 0, pad=4)
            asm_file += f"${s},"
        asm_file = asm_file[:-1] + f"; monster {n}\n"

        # add bytes to file
        asm_file += f"    .byte "
        for i in range(6, 8):
            asm_file += f"${int2hex(int(row[i]) if len(row) > i else 0)},"
        asm_file += "$00,$00" + " " * 20 + f";"

        # add comments to file
        if len(row) > 8:
            for i in range(8, len(row)):
                asm_file += row[i] + " "
        asm_file += "\n"
        n += 1


# file footer
asm_file += f"""
    ; unused data
    .repeat {256-n}
        .tag MonsterStat
    .endrepeat
"""

# save file
with open(args.output, "w") as f:
    f.write(asm_file)
