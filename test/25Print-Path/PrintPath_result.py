import sys
sys.path.append('../../')
from Array import Array
import random

def PRINT_PATH(G, s, v):
    if v == S:
        s
    elif (v.float('inf') == None):
        no path from, s, to, v, exists
    else:
        PRINT_PATH(G, s, v.float('inf'))        v

