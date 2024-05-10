import sys
sys.path.append('../../')
from Array import Array

from testRequirements import *
def Random_Sample(m, n):
    if m == 0:
        return {}
    else:
        S = Random_Sample(m, 1, n, 1)
        i = random.randint(1, n)
        if i in S:
            S = S.union({n})
        else:
            S = S.union({i})
        return S

