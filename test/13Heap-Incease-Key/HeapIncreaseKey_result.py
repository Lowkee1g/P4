import sys
sys.path.append('../../')
from Array import Array

from testRequirements import *
def HEAP_INCREASE_KEY(A, i, key):
    if key < A[i]:
        raise Exception('new key is smaller than current key')
    A[i] = key
    while i > 1 and A[PARENT(i)] < A[i]:
        A[i], A[PARENT(i)] = A[PARENT(i)], A[i]
        i = PARENT(i)

