
def int2hex(n, pad=2):
    if n < 0:
        n ^= (1 << (pad * 4)) - 1
        n += 1
    s = hex(n)[2:]
    if len(s) < pad:
        s = "0" * (pad - len(s)) + s
    return s

