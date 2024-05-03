import sys
sys.path.append('../../')
from Array import Array

def MERGE(A, p, q, r):
    n_1 = q - p + 1
    n_2 = r - q
    L[range(1, n_1 + 1)], R[range(1, n_2 + 1)] = Array([])
    for i in range(1, n_1 + 1):
        L[i] = A[p + i - 1]
    for j in range(1, n_2 + 1):
        R[j] = A[q + j]
    L[n_1 + 1] = float('inf')
    R[n_2 + 1] = float('inf')
    i = 1
    j = 1
    for k in range(p, R + 1):
        if L[i] <= R[j]:
            A[k] = L[i]
            i = i + 1
        else:
            A[k] = R[j]
            j = j + 1

