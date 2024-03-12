import argparse
import csv
from utils import int2hex


# args
parser = argparse.ArgumentParser()
parser.add_argument("input", help="CSV file containing fights data")
parser.add_argument("-o", "--output", default="fights_data.asm")
parser.add_argument("-d", "--delimiter", default=",")
args = parser.parse_args()

args.has_header = True

#
n = 0

# file header
asm_file = """
; this file was generated

.segment "MONSTER_DATA"

;--------------------------------
; Array: fights
;--------------------------------
;
; List of 256 <Fight> structures.
; The index in the array is the ID of the fight.
;--------------------------------
fights:
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

        # read data from row
        flag = int(row[0]) if len(row) > 0 else 0
        m0 = int(row[1]) if len(row) > 1 else 0
        m1 = int(row[2]) if len(row) > 2 else 0
        m2 = int(row[3]) if len(row) > 3 else 0
        # add it to file
        asm_file += f"    .byte ${int2hex(flag)}, ${int2hex(m0)}, ${int2hex(m1)}, ${int2hex(m2)} ; fight {n}\n"
        n += 1


# file footer
asm_file += f"""
    ; unused data
    .repeat {256-n}
        .tag Fight
    .endrepeat
"""

# save file
with open(args.output, "w") as f:
    f.write(asm_file)
