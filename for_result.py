def MERGE(A, p, q, r):
    n_1 = q - p + 1
    n_2 = r - q
    L[range(1, n_1 + 1)], L[range(1, n_1 + 1)] = []
    for i in range(1, n_1):
        L[i] = A[p + i - 1]
    for j in range(1, n_2):
        R[j] = A[q + j]
    i = 1
    j = 1
    for k in range(p, R):
        if L[i] <= R[j]:
            A[k] = L[i]
            i = i + 1
        else:
            A[k] = R[j]
            j = j + 1
        print('hej')

