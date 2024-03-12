import argparse
import csv
import os
import glob
from utils import int2hex


# args
parser = argparse.ArgumentParser()
parser.add_argument("folder", help="Folder where monster data are located")
parser.add_argument("-o", "--output_folder", default="")
parser.add_argument("-d", "--delimiter", default=",")
args = parser.parse_args()
# other args
args.has_header = True
args.stats = "stats.csv"
args.names = "names.csv"

# data
stats_data = {}
names_data = {}
stats_header = ["maxhp", "hp", "atk", "def", "xp", "gold", "item", "itemchance"]

# find every stats file
filespath = glob.glob(os.path.join(args.folder, "**/stats.csv"), recursive=True)
# for each stats file
for filepath in filespath:
    filename = os.path.basename(filepath)
    path = os.path.dirname(filepath)

    # find monster id
    with open(filepath) as f:
        id = 0
        reader = csv.reader(f, delimiter=args.delimiter)
        for row in reader:
            if len(row) >= 2 and row[0] == "id":
                id = int(row[1])

    # add the id to data
    if id in stats_data:
        print(f"Error: multiple monster with same id {id}. ignoring")
    else:
        stats_data[id] = []
        names_data[id] = ["UNKNOWN "]
        stats_data[id] = [0]*len(stats_header)

    with open(filepath) as f:
        # for each row
        reader = csv.reader(f, delimiter=args.delimiter)
        for row in reader:
            # skip empty line
            if len(row) == 0:
                continue
            #
            if row[0] in stats_header:
                if len(row) < 2:
                    print(f"Warning: row in stats file inside folder '{path}' has missing value ({row[0]})")
                    continue
                idx = stats_header.index(row[0])
                stats_data[id][idx] = row[1]
            elif row[0] == "name":
                if len(row) < 2:
                    print(f"Warning: row in stats file inside folder '{path}' has missing value ({row[0]})")
                    continue
                names_data[id] = [row[1][:8]]

# add missing id
for i in range(256):
    if i not in stats_data:
        stats_data[i] = []
    if i not in names_data:
        names_data[i] = []

# sort
stats_data = dict(sorted(stats_data.items(), key=lambda x:x[0]))
names_data = dict(sorted(names_data.items(), key=lambda x:x[0]))

# save names csv file
with open(os.path.join(args.output_folder, args.names), "w", newline="") as f:
    spamwriter = csv.writer(f, delimiter=",")
    spamwriter.writerow(["name"])
    for id, r in names_data.items():
        spamwriter.writerow(r)

# save stats csv file
with open(os.path.join(args.output_folder, args.stats), "w", newline="") as f:
    spamwriter = csv.writer(f, delimiter=",")
    spamwriter.writerow(stats_header)
    for id, r in stats_data.items():
        spamwriter.writerow(r)
