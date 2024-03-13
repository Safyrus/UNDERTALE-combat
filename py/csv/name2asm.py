import argparse
import csv
from utils import int2hex


# args
parser = argparse.ArgumentParser()
parser.add_argument("input", help="CSV file containing names data")
parser.add_argument("-o", "--output", default="names_data.asm")
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
; Array: monster_names_data
;--------------------------------
;
; List of 256 monster names (each 8 bytes long).
; The index in the array is the ID of the monster.
;--------------------------------
monster_names_data:
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
            row.append("XXXXXXXX")

        # read data from row
        # add it to file
        asm_file += f"    .byte \"{row[0]}\"\n"
        n += 1


# file footer
# asm_file += f"""
#     ; unused data
#     .repeat {256-n}
#         .byte "        "
#     .endrepeat
# """

# save file
with open(args.output, "w") as f:
    f.write(asm_file)
