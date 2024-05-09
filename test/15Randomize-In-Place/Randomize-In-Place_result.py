import sys
sys.path.append('../../')
from Array import Array

import testRequirements.py
def Randomize_In_Place(A, B):
    n = len(A)
    for i in range(1, n + 1):
        A[i], A[RANDOM(i, n)] = A[RANDOM(i, n)], A[i]

