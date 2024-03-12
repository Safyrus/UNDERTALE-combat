import argparse
import csv
import glob
import os


def find_include_files(filename, basedir="", found=[]):
    if filename in found:
        print("Warning: recursive include found")
        return []
    found = [filename]
    with open(os.path.join(basedir, filename), "r") as f:
        for line in f:
            words = line.split(";")[0].split()
            for i, w in enumerate(words):
                if w == ".include":
                    fn = words[i + 1][1:-1]  # get filename without quotes
                    found.extend(find_include_files(fn, basedir=basedir, found=found))
    return found


def asm_struct_file(struct_list):
    # add missing id
    for i in range(256):
        if i not in struct_list:
            struct_list[i] = {}
    # sort
    struct_list = dict(sorted(struct_list.items(), key=lambda x: x[0]))

    asm_file = """
; this file was generated

.segment "MONSTER_DATA"
;--------------------------------
; Array: monster_code_bnk
;--------------------------------
;
; List of 256 PRG bank indices.
; The index in the array is the ID of the monster.
;--------------------------------
monster_code_bnk:
"""

    # struct data
    for id, struct in struct_list.items():
        start = struct[CSV_NAMES[0]] if CSV_NAMES[0] in struct else "0"
        if start == "0":
            asm_file += f"    .byte 0\n"
        else:
            asm_file += f"    .byte MONSTER_CODE_START_BNK + <(({start} - $8000) >> 13) ; monster {id}\n"

    asm_file += """

.segment "MONSTER_STRUCT_DATA"

;--------------------------------
; Array: monster_code_struct
;--------------------------------
;
; List of 256 <MonsterCode> structures.
; The index in the array is the ID of the monster.
;--------------------------------
monster_code_struct:
    """

    # struct data
    for id, struct in struct_list.items():
        # empty code
        if len(struct.values()) == 0:
            asm_file += "    .tag MonsterCode\n"
            continue
        #
        start = struct[CSV_NAMES[0]] if CSV_NAMES[0] in struct else "0"
        asm_file += f"    .word {start}"
        #
        last_label = start
        for i in range(1, 8):
            if CSV_NAMES[i] in struct:
                label = struct[CSV_NAMES[i]]
                asm_file += f",{label}-{last_label}"
                last_label = label
            else:
                asm_file += ",0"
        asm_file += f" ; monster {id}\n"

    return asm_file


def asm_inc_file(struct_list):
    # file header
    asm_file = """
; this file was generated

.segment "MONSTER_CODE_DATA"

monster_code_data:
"""

    # sort
    struct_list = dict(sorted(struct_list.items(), key=lambda x: x[0]))

    # file data
    for id, struct in struct_list.items():
        if "filename" in struct:
            asm_file += f'    .include "m_{id}/{struct["filename"]}"\n'

    return asm_file


CSV_NAMES = ["code_start", "code_turn", "code_custom", "code_hit", "code_act", "code_item", "code_spare", "code_flee"]

# args
parser = argparse.ArgumentParser()
parser.add_argument("folder")
parser.add_argument("-o", "--output", default="monster_code")
parser.add_argument("-as", "--asmstruct", default="monster_code.asm")
parser.add_argument("-ai", "--asminclude", default="code_data.asm")
args = parser.parse_args()

# find every CSV with code data
csvfiles = glob.glob(os.path.join(args.folder, "**/stats.csv"), recursive=True)

main_file_list = {}
codestruct_list = {}

# for each CSV
for fn in csvfiles:
    codestruct = {}
    codefile = ""
    id = -1

    # read csv file
    with open(fn) as f:
        reader = csv.reader(f)
        for row in reader:
            # skip empty line
            if len(row) == 0:
                continue
            # if line with main code file
            if row[0] == "code":
                if len(row) == 1:
                    print("Error: missing arguments for code file location")
                    continue
                codefile = row[1]
            # if line with event subroutine name
            if row[0] in CSV_NAMES:
                if len(row) == 1:
                    print("Error: missing arguments for subroutine data")
                    continue
                codestruct[row[0]] = row[1]
            # id
            if row[0] == "id":
                if len(row) == 1:
                    print("Error: missing arguments for id")
                id = int(row[1])

    # stop if no ID was found
    if id == -1:
        print("Error: id was not found")
        continue

    # edit struct
    basefolder = os.path.dirname(fn)
    prefix = "m_" + str(id)
    for k, v in codestruct.items():
        codestruct[k] = prefix + "_" + v
    codestruct["filename"] = codefile
    codestruct_list[id] = codestruct

    #
    outfolder = os.path.join(args.output, prefix)
    main_file_list[id] = os.path.join(prefix, os.path.basename(codefile))

    # search for 'include'
    inc_list = find_include_files(os.path.basename(codefile), basedir=basefolder)

    # copy included files
    for fn in inc_list:
        # read
        with open(os.path.join(basefolder, fn), "r") as f:
            lines = f.readlines()

        # edit label to match struct
        for l_idx, l in enumerate(lines):
            # cut line into words and put comments apart
            if ";" in l:
                line, comment = l.split(";", maxsplit=1)
            else:
                line, comment = l, ""

            # split line by " (but not on \")
            if len(line) > 0 and line[-1] == "\n":
                line = line[:-1]
            if len(comment) > 0 and comment[-1] == "\n":
                comment = comment[:-1]
            line = line.split('"')
            new_line = [line[0]]
            for i in range(1, len(line)):
                if len(line[i - 1]) > 0 and line[i - 1][-1] == "\\":
                    new_line[-1] += '"' + line[i]
                else:
                    new_line.append(line[i])
            line = new_line

            #
            quote = True
            for i, subline in enumerate(line):
                #
                quote = not quote
                if quote:
                    continue
                #
                subline_spaced = ""
                for c in subline:
                    if c == ",":
                        subline_spaced += " , "
                    else:
                        subline_spaced += c
                #
                words = subline_spaced.split(" ")
                for j, w in enumerate(words):
                    # if label present
                    label = prefix + "_" + w
                    if label in codestruct.values():
                        words[j] = label
                    # maybe with a ":" at the end
                    elif label[:-1] in codestruct.values():
                        words[j] = label
                #
                line[i] = " ".join(words)

            #
            lines[l_idx] = '"'.join(line)
            if comment:
                lines[l_idx] += ";" + comment
            lines[l_idx] += "\n"

        # write
        outfn = os.path.join(outfolder, fn)
        os.makedirs(os.path.dirname(outfn), exist_ok=True)
        with open(outfn, "w") as f:
            f.writelines(lines)

# save asm struct file
with open(os.path.join(args.output, args.asmstruct), "w") as f:
    f.write(asm_struct_file(codestruct_list))

# save asm include file
with open(os.path.join(args.output, args.asminclude), "w") as f:
    f.write(asm_inc_file(codestruct_list))
