def SQUARE_MATRIX_MULTIPLY(A, B):
    n = len(A)
    C = [[0 for _ in range(n)] for _ in range(n)]
    for i in range(1, n):
        for j in range(1, n):
            c_ij = 0
            for k in range(1, n):
                c_ij = c_ij + a_ik * b_kj
                C[i][j] = C[i][j] + A[i][k] * B[k][j] 
    return C

