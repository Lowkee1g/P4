import sys
sys.path.append('../')
from Array import Array

#If a parameter is an array or matrix, implement arra as A = Array(arra)


def SQUARE_MATRIX_MULTIPLY(A, B):
    n = len(A)
    C = Array([Array([0 for _ in range(n)]) for _ in range(n)])
    for i in range(1, n + 1):
        for j in range(1, n + 1):
            C[i][j] = 0
            for k in range(1, n + 1):
                C[i][j] = C[i][j] + A[i][k] * B[k][j]
    return C

A = Array([
    Array([12, 7, 3]),
    Array([4, 5, 6]),
    Array([7, 8, 9])
    ])
B = Array([
    Array([5, 8, 1]),
    Array([6, 7, 3]),
    Array([4, 5, 9])
    ])

result = SQUARE_MATRIX_MULTIPLY(A, B)
print(result)