import binpacking

MAX_SIZE = (1024*8)-1024#887

musics = {
    "=)": 128,
    "Once Upon a Time": 817,
    "Start Menu": 355,
    "Your Best Friend": 474,
    "Fallen Down": 443,
    "Ruins": 2001,
    "Uwa!! So Temperate": 653,
    "Anticipation": 310,
    "Unnecessary Tension": 286,
    "Enemy Approaching": 1919,
    "Ghost Fight": 1903,
    "Determination": 878,
    "Home": 1461,
    "Home (Music Box)": 1787,
    "Heartache": 3470,
    "sans": 908,
    "Nyeh Heh Heh": 866,
    "Snowy": 1008,
    "Uwa!! So Holiday": 254,
    "Dogbass": 168,
    "Mysterious Place": 1530,
    "Dogsong": 1310,
    "Snowdin Town": 1120,
    "Shop": 972,
    "Bonetrousle": 1762,
    "Dating Start": 2092,
    "Dating Tense": 660,
    "Dating Fight": 743,
    "Premonition": 258,
    "Danger Mystery": 232,
    "Undyne": 651,
    "Waterfall": 1131,
    "Run": 604,
    "Quiet Water": 387,
    "Memory": 355,
    "Bird That Carries You Over a Disproportionately Small Gap": 551,
    "Dummy": 3973,
    "Pathetic House": 298,
    "Spooktune": 221,
    "Spookwave": 750,
    "Ghouliday": 459,
    "Chill": 887,
    "Thundersnail": 1131,
    "Temmie Village": 664,
    "Tem Shop": 456,
    "NGAHHH!!": 1703,
    "Spear of Justice": 3184,
    "Ooo": 46,
    "Alphys": 1225,
    "It's Showtime": 1125,
    "Metal Crusher": 2168,
    "Another Medium": 2869,
    "Uwa!! So Heats": 345,
    "Stronger Monsters": 2086,
    "Hotel": 1664,
    "Can You Really Call This a Hotel, I Didn't Receive a Mint on My Pillow or Anything": 1495,
    "Confession": 285,
    "Live Report": 371,
    "Death Report": 1605,
    "Spider Dance": 3939,
    "Wrong Enemy": 1272,
    "Oh! One True Love": 620,
    "Oh! Dungeon": 939,
    "It's Raining Somewhere Else": 1946,
    "Core Approach": 355,
    "Core": 2952,
    "Last Episode": 247,
    "Oh My...": 256,
    "Death by Glamour": 3117,
    "For the Fans": 718,
    "Long Elevator": 119,
    "Undertale": 3078,
    "Song That Might Play When You Fight Sans": 1871,
    "The Choice": 1380,
    "Small Shock": 153,
    "Barrier": 133,
    "Bergentrückung": 465,
    "ASGORE": 5165,
    "You Idiot": 250,
    "Your Best Nightmare": 4460,
    "Finale": 2446,
    "An Ending": 1639,
    "She's Playing Piano": 380,
    "Here We Are": 1274,
    "Amalgam": 1675,
    "Fallen Down (Reprise)": 1543,
    "Don't Give Up": 1087,
    "Hopes and Dreams": 4898,
    "Burn in Despair": 561,
    "Save the World": 2086,
    "His Theme": 780,
    "Final Power": 769,
    "Reunited": 3186,
    "Menu (Full)": 1994,
    "Respite": 869,
    "Bring It In, Guys": 6858,
    "Last Goodbye": 4090,
    "But the Earth Refused to Die": 168,
    "Battle Against a True Hero": 2603,
    "Power of \"Neo\"": 719,
    "MEGALOVANIA": 3778,
    "Good Night": 394,
    "Sigh of Dog": 271,
    "Wrong Number Song": 249,
    "Happy Town": 71,
    "Meat Factory": 37,
    "Trouble Dingle": 82,
    "[REDACTED]": 235,
}

# remove item that have no size
k,v = list(musics.keys()), list(musics.values())
for i in range(len(k)):
    if v[i] <= 0:
        del musics[k[i]]

# find best banks
bins = binpacking.to_constant_volume(musics,MAX_SIZE)

# print
for i, b in enumerate(bins):
    size = sum(b.values())
    print(f"Bank {i}: (size={size})")
    print(list(b.keys()))
    print("\n")

# write "idx.asm" file
bank_count = [0]*len(bins)
with open("idx.asm", "w") as f:
    f.write(f"MAX_MUSIC = {len(musics)}\n")
    f.write("\n")
    f.write("music_idx_table:\n")
    for name, size in musics.items():
        idx = 0
        for i, b in enumerate(bins):
            if name in b.keys():
                idx = i
                break
        f.write(f"    .byte {bank_count[idx]} ; {name}\n")
        bank_count[idx] += 1

# write "bank.asm" file
with open("bank.asm", "w") as f:
    f.write("MUS_START_BNK = <.bank(music_data_undertale_ost_0) + $80\n")
    f.write("\n")
    f.write("music_bank_table:\n")
    for name, size in musics.items():
        bnk = 0
        for i, b in enumerate(bins):
            if name in b.keys():
                bnk = i
                break
        f.write(f"    .byte MUS_START_BNK + {bnk} ; {name}\n")
