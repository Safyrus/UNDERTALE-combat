import argparse

parser = argparse.ArgumentParser()
parser.add_argument("chr", type=str, nargs="+")
parser.add_argument("-o", "--out", type=str, default="out.chr")
parser.add_argument("-p", "--pad", type=int, default=0x100000)
args = parser.parse_args()

with open(args.out, "wb") as o:
    l = 0
    for c in args.chr:
        with open(c, "rb") as f:
            data = f.read()
        o.write(data)
        l += len(data)
        # m = l % 4096
        # if m > 0:
        #     o.write(bytes(4096 - m))
        #     l += 4096 - m
    if args.pad > 0:
        o.write(bytes(args.pad-l))
