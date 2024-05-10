import sys
sys.path.append('../../')
from Array import Array

from testRequirements import *
def RECURSIVE_MATRIX_CHAIN(p, i, j):
    if i == j:
        return 0
    m[i][j] = float('inf')
    for k in range(i, j - 1 + 1):
        q = RECURSIVE_MATRIX_CHAIN(p, i, k) + RECURSIVE_MATRIX_CHAIN(p, k + 1, j) + P[i - 1] * P[k] * P[j]
    if q < m[i][j]:
        m[i][j] = q
    return m[i][j]

