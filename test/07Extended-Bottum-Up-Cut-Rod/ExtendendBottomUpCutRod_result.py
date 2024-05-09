import sys
sys.path.append('../../')
from Array import Array

def EXTENDED_BOTTOM_UP_CUT_ROD(p, n):
    r[range(0, n)], s[range(0, n)] = Array([])
    r[0] = 0
    for j in range(1, n + 1):
        q = float('-inf')
    for i in range(1, j + 1):
        if q < p[i] + r[j - i]:
            q = p[i] + r[j - i]
            s[j] = i
    r[j] = q
    return r, s

