import argparse
import glob
import os

parser = argparse.ArgumentParser()
parser.add_argument("folder")
args = parser.parse_args()


filenames = glob.glob(os.path.join(args.folder, "**/*.asm"), recursive=True)

for fn in filenames:
    # read file
    with open(fn) as f:
        lines = f.readlines()

    # dumb sugestion
    for i in range(len(lines)):
        # get lines
        line = lines[i].lstrip().split(";")[0].upper()
        nextline = lines[i+1].lstrip().split(";")[0].upper() if i+1 < len(lines) else ""
        prevline = lines[i-1].lstrip().split(";")[0].upper() if i-1 > 0 else ""

        # JSR RTS --> JMP
        if "JSR " in line and "RTS " in nextline:
            print(f'File "{fn}", line {i+1} : JMP instead of JSR,RTS ?')
        # CMP #0
        if "CMP " in line and ("#0" in line or "#$00" in line or "#$0 " in line):
            print(f'File "{fn}", line {i+1} : Maybe you can remove #$00 ?')

        # LDA, STA --> MOV
        if "LDA " in line and "STA " in nextline \
        and not (",X" in line or ", X" in line) \
        and not (",X" in nextline or ", X" in nextline) \
        and not (",Y" in line or ", Y" in line) \
        and not (",Y" in nextline or ", Y" in nextline):
            print(f'File "{fn}", line {i+1} : use "mov" for readability ?')
        # LDX, STX --> MOV
        if "LDX " in line and "STX " in nextline \
        and not (",Y" in line or ", Y" in line) \
        and not (",Y" in nextline or ", Y" in nextline):
            print(f'File "{fn}", line {i+1} : use "mvx" for readability ?')
        # LDY, STY --> MOV
        if "LDY " in line and "STY " in nextline \
        and not (",X" in line or ", X" in line) \
        and not (",X" in nextline or ", X" in nextline):
            print(f'File "{fn}", line {i+1} : use "mvy" for readability ?')
        # CLC, ADC --> ADC
        if ("CLC" in prevline and "ADC " in line) \
        or ("ADD " in line):
            print(f'File "{fn}", line {i+1} : maybe CLC is not needed ?')

