import argparse
import math

# args
parser = argparse.ArgumentParser()
parser.add_argument("file")
parser.add_argument("-m", "--max", type=int, default=0x100000)#-1)
args = parser.parse_args()

# vars
count = [0] * 256
total = 0

# count bytes in file
with open(args.file, "rb") as f:
    for line in f:
        for c in line:
            count[int(c)] += 1
            total += 1
            if args.max > 0 and total >= args.max:
                break
        if args.max > 0 and total >= args.max:
            break

print("count:")
# compute entropy
entropy = 0
for i, c in enumerate(count):
    print(i, c)
    if c == 0:
        continue
    p = 1.0 * c / total
    entropy -= p * math.log(p, 256)

# display
print("entropy:", "{0:.4f}".format(entropy * 100), "%")
