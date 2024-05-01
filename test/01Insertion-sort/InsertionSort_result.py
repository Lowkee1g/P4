import sys
sys.path.append('../')
from Array import Array

#If a parameter is an array or matrix, implement arra as A = Array(arra)

def INSERTION_SORT(A): 
    for j in range(2, len(A)):
        key = A[j]
        i = j - 1
        while i > 0 and A[i] > key:
            A[i + 1] = A[i]
            i = i - 1
        A[i + 1] = key


arr = Array([12, 11, 13, 5, 6])
INSERTION_SORT(arr)
for i in range(len(arr)):
    print ("% d" % arr[i])

