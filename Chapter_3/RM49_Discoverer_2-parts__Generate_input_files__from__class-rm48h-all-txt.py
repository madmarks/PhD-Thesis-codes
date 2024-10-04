import math
import os
import operator

# | a | b | c | d | e | f | g | h |
# |---|---|---|---|---|---|---|---|
# | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
# | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 |
# | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 |
# | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 1 |
# | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
# | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 1 |
# | 0 | 0 | 0 | 0 | 0 | 1 | 1 | 0 |
# | 0 | 0 | 0 | 0 | 0 | 1 | 1 | 1 |
# | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 |
# | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 1 |
# | 0 | 0 | 0 | 0 | 1 | 0 | 1 | 0 |
# | 0 | 0 | 0 | 0 | 1 | 0 | 1 | 1 |
# | 0 | 0 | 0 | 0 | 1 | 1 | 0 | 0 |
# | 0 | 0 | 0 | 0 | 1 | 1 | 0 | 1 |
# | 0 | 0 | 0 | 0 | 1 | 1 | 1 | 0 |
# | 0 | 0 | 0 | 0 | 1 | 1 | 1 | 1 |
# | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 |
# | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 1 |
# | 0 | 0 | 0 | 1 | 0 | 0 | 1 | 0 |
# | 0 | 0 | 0 | 1 | 0 | 0 | 1 | 1 |
# | 0 | 0 | 0 | 1 | 0 | 1 | 0 | 0 |
# | 0 | 0 | 0 | 1 | 0 | 1 | 0 | 1 |
# | 0 | 0 | 0 | 1 | 0 | 1 | 1 | 0 |
# | 0 | 0 | 0 | 1 | 0 | 1 | 1 | 1 |
# | 0 | 0 | 0 | 1 | 1 | 0 | 0 | 0 |
# | 0 | 0 | 0 | 1 | 1 | 0 | 0 | 1 |
# | 0 | 0 | 0 | 1 | 1 | 0 | 1 | 0 |
# | 0 | 0 | 0 | 1 | 1 | 0 | 1 | 1 |
# | 0 | 0 | 0 | 1 | 1 | 1 | 0 | 0 |
# | 0 | 0 | 0 | 1 | 1 | 1 | 0 | 1 |
# | 0 | 0 | 0 | 1 | 1 | 1 | 1 | 0 |
# | 0 | 0 | 0 | 1 | 1 | 1 | 1 | 1 |
# | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
# | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 1 |
# | 0 | 0 | 1 | 0 | 0 | 0 | 1 | 0 |
# | 0 | 0 | 1 | 0 | 0 | 0 | 1 | 1 |
# | 0 | 0 | 1 | 0 | 0 | 1 | 0 | 0 |
# | 0 | 0 | 1 | 0 | 0 | 1 | 0 | 1 |
# | 0 | 0 | 1 | 0 | 0 | 1 | 1 | 0 |
# | 0 | 0 | 1 | 0 | 0 | 1 | 1 | 1 |
# | 0 | 0 | 1 | 0 | 1 | 0 | 0 | 0 |
# | 0 | 0 | 1 | 0 | 1 | 0 | 0 | 1 |
# | 0 | 0 | 1 | 0 | 1 | 0 | 1 | 0 |
# | 0 | 0 | 1 | 0 | 1 | 0 | 1 | 1 |
# | 0 | 0 | 1 | 0 | 1 | 1 | 0 | 0 |
# | 0 | 0 | 1 | 0 | 1 | 1 | 0 | 1 |
# | 0 | 0 | 1 | 0 | 1 | 1 | 1 | 0 |
# | 0 | 0 | 1 | 0 | 1 | 1 | 1 | 1 |
# | 0 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
# | 0 | 0 | 1 | 1 | 0 | 0 | 0 | 1 |
# | 0 | 0 | 1 | 1 | 0 | 0 | 1 | 0 |
# | 0 | 0 | 1 | 1 | 0 | 0 | 1 | 1 |
# | 0 | 0 | 1 | 1 | 0 | 1 | 0 | 0 |
# | 0 | 0 | 1 | 1 | 0 | 1 | 0 | 1 |
# | 0 | 0 | 1 | 1 | 0 | 1 | 1 | 0 |
# | 0 | 0 | 1 | 1 | 0 | 1 | 1 | 1 |
# | 0 | 0 | 1 | 1 | 1 | 0 | 0 | 0 |
# | 0 | 0 | 1 | 1 | 1 | 0 | 0 | 1 |
# | 0 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
# | 0 | 0 | 1 | 1 | 1 | 0 | 1 | 1 |
# | 0 | 0 | 1 | 1 | 1 | 1 | 0 | 0 |
# | 0 | 0 | 1 | 1 | 1 | 1 | 0 | 1 |
# | 0 | 0 | 1 | 1 | 1 | 1 | 1 | 0 |
# | 0 | 0 | 1 | 1 | 1 | 1 | 1 | 1 |
# | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |
# | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 |
# | 0 | 1 | 0 | 0 | 0 | 0 | 1 | 0 |
# | 0 | 1 | 0 | 0 | 0 | 0 | 1 | 1 |
# | 0 | 1 | 0 | 0 | 0 | 1 | 0 | 0 |
# | 0 | 1 | 0 | 0 | 0 | 1 | 0 | 1 |
# | 0 | 1 | 0 | 0 | 0 | 1 | 1 | 0 |
# | 0 | 1 | 0 | 0 | 0 | 1 | 1 | 1 |
# | 0 | 1 | 0 | 0 | 1 | 0 | 0 | 0 |
# | 0 | 1 | 0 | 0 | 1 | 0 | 0 | 1 |
# | 0 | 1 | 0 | 0 | 1 | 0 | 1 | 0 |
# | 0 | 1 | 0 | 0 | 1 | 0 | 1 | 1 |
# | 0 | 1 | 0 | 0 | 1 | 1 | 0 | 0 |
# | 0 | 1 | 0 | 0 | 1 | 1 | 0 | 1 |
# | 0 | 1 | 0 | 0 | 1 | 1 | 1 | 0 |
# | 0 | 1 | 0 | 0 | 1 | 1 | 1 | 1 |
# | 0 | 1 | 0 | 1 | 0 | 0 | 0 | 0 |
# | 0 | 1 | 0 | 1 | 0 | 0 | 0 | 1 |
# | 0 | 1 | 0 | 1 | 0 | 0 | 1 | 0 |
# | 0 | 1 | 0 | 1 | 0 | 0 | 1 | 1 |
# | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 0 |
# | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 1 |
# | 0 | 1 | 0 | 1 | 0 | 1 | 1 | 0 |
# | 0 | 1 | 0 | 1 | 0 | 1 | 1 | 1 |
# | 0 | 1 | 0 | 1 | 1 | 0 | 0 | 0 |
# | 0 | 1 | 0 | 1 | 1 | 0 | 0 | 1 |
# | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 0 |
# | 0 | 1 | 0 | 1 | 1 | 0 | 1 | 1 |
# | 0 | 1 | 0 | 1 | 1 | 1 | 0 | 0 |
# | 0 | 1 | 0 | 1 | 1 | 1 | 0 | 1 |
# | 0 | 1 | 0 | 1 | 1 | 1 | 1 | 0 |
# | 0 | 1 | 0 | 1 | 1 | 1 | 1 | 1 |
# | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 0 |
# | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 1 |
# | 0 | 1 | 1 | 0 | 0 | 0 | 1 | 0 |
# | 0 | 1 | 1 | 0 | 0 | 0 | 1 | 1 |
# | 0 | 1 | 1 | 0 | 0 | 1 | 0 | 0 |
# | 0 | 1 | 1 | 0 | 0 | 1 | 0 | 1 |
# | 0 | 1 | 1 | 0 | 0 | 1 | 1 | 0 |
# | 0 | 1 | 1 | 0 | 0 | 1 | 1 | 1 |
# | 0 | 1 | 1 | 0 | 1 | 0 | 0 | 0 |
# | 0 | 1 | 1 | 0 | 1 | 0 | 0 | 1 |
# | 0 | 1 | 1 | 0 | 1 | 0 | 1 | 0 |
# | 0 | 1 | 1 | 0 | 1 | 0 | 1 | 1 |
# | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 0 |
# | 0 | 1 | 1 | 0 | 1 | 1 | 0 | 1 |
# | 0 | 1 | 1 | 0 | 1 | 1 | 1 | 0 |
# | 0 | 1 | 1 | 0 | 1 | 1 | 1 | 1 |
# | 0 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
# | 0 | 1 | 1 | 1 | 0 | 0 | 0 | 1 |
# | 0 | 1 | 1 | 1 | 0 | 0 | 1 | 0 |
# | 0 | 1 | 1 | 1 | 0 | 0 | 1 | 1 |
# | 0 | 1 | 1 | 1 | 0 | 1 | 0 | 0 |
# | 0 | 1 | 1 | 1 | 0 | 1 | 0 | 1 |
# | 0 | 1 | 1 | 1 | 0 | 1 | 1 | 0 |
# | 0 | 1 | 1 | 1 | 0 | 1 | 1 | 1 |
# | 0 | 1 | 1 | 1 | 1 | 0 | 0 | 0 |
# | 0 | 1 | 1 | 1 | 1 | 0 | 0 | 1 |
# | 0 | 1 | 1 | 1 | 1 | 0 | 1 | 0 |
# | 0 | 1 | 1 | 1 | 1 | 0 | 1 | 1 |
# | 0 | 1 | 1 | 1 | 1 | 1 | 0 | 0 |
# | 0 | 1 | 1 | 1 | 1 | 1 | 0 | 1 |
# | 0 | 1 | 1 | 1 | 1 | 1 | 1 | 0 |
# | 0 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
# | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
# | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 1 |
# | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 |
# | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 1 |
# | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
# | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 1 |
# | 1 | 0 | 0 | 0 | 0 | 1 | 1 | 0 |
# | 1 | 0 | 0 | 0 | 0 | 1 | 1 | 1 |
# | 1 | 0 | 0 | 0 | 1 | 0 | 0 | 0 |
# | 1 | 0 | 0 | 0 | 1 | 0 | 0 | 1 |
# | 1 | 0 | 0 | 0 | 1 | 0 | 1 | 0 |
# | 1 | 0 | 0 | 0 | 1 | 0 | 1 | 1 |
# | 1 | 0 | 0 | 0 | 1 | 1 | 0 | 0 |
# | 1 | 0 | 0 | 0 | 1 | 1 | 0 | 1 |
# | 1 | 0 | 0 | 0 | 1 | 1 | 1 | 0 |
# | 1 | 0 | 0 | 0 | 1 | 1 | 1 | 1 |
# | 1 | 0 | 0 | 1 | 0 | 0 | 0 | 0 |
# | 1 | 0 | 0 | 1 | 0 | 0 | 0 | 1 |
# | 1 | 0 | 0 | 1 | 0 | 0 | 1 | 0 |
# | 1 | 0 | 0 | 1 | 0 | 0 | 1 | 1 |
# | 1 | 0 | 0 | 1 | 0 | 1 | 0 | 0 |
# | 1 | 0 | 0 | 1 | 0 | 1 | 0 | 1 |
# | 1 | 0 | 0 | 1 | 0 | 1 | 1 | 0 |
# | 1 | 0 | 0 | 1 | 0 | 1 | 1 | 1 |
# | 1 | 0 | 0 | 1 | 1 | 0 | 0 | 0 |
# | 1 | 0 | 0 | 1 | 1 | 0 | 0 | 1 |
# | 1 | 0 | 0 | 1 | 1 | 0 | 1 | 0 |
# | 1 | 0 | 0 | 1 | 1 | 0 | 1 | 1 |
# | 1 | 0 | 0 | 1 | 1 | 1 | 0 | 0 |
# | 1 | 0 | 0 | 1 | 1 | 1 | 0 | 1 |
# | 1 | 0 | 0 | 1 | 1 | 1 | 1 | 0 |
# | 1 | 0 | 0 | 1 | 1 | 1 | 1 | 1 |
# | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
# | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 1 |
# | 1 | 0 | 1 | 0 | 0 | 0 | 1 | 0 |
# | 1 | 0 | 1 | 0 | 0 | 0 | 1 | 1 |
# | 1 | 0 | 1 | 0 | 0 | 1 | 0 | 0 |
# | 1 | 0 | 1 | 0 | 0 | 1 | 0 | 1 |
# | 1 | 0 | 1 | 0 | 0 | 1 | 1 | 0 |
# | 1 | 0 | 1 | 0 | 0 | 1 | 1 | 1 |
# | 1 | 0 | 1 | 0 | 1 | 0 | 0 | 0 |
# | 1 | 0 | 1 | 0 | 1 | 0 | 0 | 1 |
# | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 0 |
# | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 1 |
# | 1 | 0 | 1 | 0 | 1 | 1 | 0 | 0 |
# | 1 | 0 | 1 | 0 | 1 | 1 | 0 | 1 |
# | 1 | 0 | 1 | 0 | 1 | 1 | 1 | 0 |
# | 1 | 0 | 1 | 0 | 1 | 1 | 1 | 1 |
# | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
# | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 1 |
# | 1 | 0 | 1 | 1 | 0 | 0 | 1 | 0 |
# | 1 | 0 | 1 | 1 | 0 | 0 | 1 | 1 |
# | 1 | 0 | 1 | 1 | 0 | 1 | 0 | 0 |
# | 1 | 0 | 1 | 1 | 0 | 1 | 0 | 1 |
# | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 0 |
# | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 1 |
# | 1 | 0 | 1 | 1 | 1 | 0 | 0 | 0 |
# | 1 | 0 | 1 | 1 | 1 | 0 | 0 | 1 |
# | 1 | 0 | 1 | 1 | 1 | 0 | 1 | 0 |
# | 1 | 0 | 1 | 1 | 1 | 0 | 1 | 1 |
# | 1 | 0 | 1 | 1 | 1 | 1 | 0 | 0 |
# | 1 | 0 | 1 | 1 | 1 | 1 | 0 | 1 |
# | 1 | 0 | 1 | 1 | 1 | 1 | 1 | 0 |
# | 1 | 0 | 1 | 1 | 1 | 1 | 1 | 1 |
# | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |
# | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 1 |
# | 1 | 1 | 0 | 0 | 0 | 0 | 1 | 0 |
# | 1 | 1 | 0 | 0 | 0 | 0 | 1 | 1 |
# | 1 | 1 | 0 | 0 | 0 | 1 | 0 | 0 |
# | 1 | 1 | 0 | 0 | 0 | 1 | 0 | 1 |
# | 1 | 1 | 0 | 0 | 0 | 1 | 1 | 0 |
# | 1 | 1 | 0 | 0 | 0 | 1 | 1 | 1 |
# | 1 | 1 | 0 | 0 | 1 | 0 | 0 | 0 |
# | 1 | 1 | 0 | 0 | 1 | 0 | 0 | 1 |
# | 1 | 1 | 0 | 0 | 1 | 0 | 1 | 0 |
# | 1 | 1 | 0 | 0 | 1 | 0 | 1 | 1 |
# | 1 | 1 | 0 | 0 | 1 | 1 | 0 | 0 |
# | 1 | 1 | 0 | 0 | 1 | 1 | 0 | 1 |
# | 1 | 1 | 0 | 0 | 1 | 1 | 1 | 0 |
# | 1 | 1 | 0 | 0 | 1 | 1 | 1 | 1 |
# | 1 | 1 | 0 | 1 | 0 | 0 | 0 | 0 |
# | 1 | 1 | 0 | 1 | 0 | 0 | 0 | 1 |
# | 1 | 1 | 0 | 1 | 0 | 0 | 1 | 0 |
# | 1 | 1 | 0 | 1 | 0 | 0 | 1 | 1 |
# | 1 | 1 | 0 | 1 | 0 | 1 | 0 | 0 |
# | 1 | 1 | 0 | 1 | 0 | 1 | 0 | 1 |
# | 1 | 1 | 0 | 1 | 0 | 1 | 1 | 0 |
# | 1 | 1 | 0 | 1 | 0 | 1 | 1 | 1 |
# | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 |
# | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 1 |
# | 1 | 1 | 0 | 1 | 1 | 0 | 1 | 0 |
# | 1 | 1 | 0 | 1 | 1 | 0 | 1 | 1 |
# | 1 | 1 | 0 | 1 | 1 | 1 | 0 | 0 |
# | 1 | 1 | 0 | 1 | 1 | 1 | 0 | 1 |
# | 1 | 1 | 0 | 1 | 1 | 1 | 1 | 0 |
# | 1 | 1 | 0 | 1 | 1 | 1 | 1 | 1 |
# | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 |
# | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 1 |
# | 1 | 1 | 1 | 0 | 0 | 0 | 1 | 0 |
# | 1 | 1 | 1 | 0 | 0 | 0 | 1 | 1 |
# | 1 | 1 | 1 | 0 | 0 | 1 | 0 | 0 |
# | 1 | 1 | 1 | 0 | 0 | 1 | 0 | 1 |
# | 1 | 1 | 1 | 0 | 0 | 1 | 1 | 0 |
# | 1 | 1 | 1 | 0 | 0 | 1 | 1 | 1 |
# | 1 | 1 | 1 | 0 | 1 | 0 | 0 | 0 |
# | 1 | 1 | 1 | 0 | 1 | 0 | 0 | 1 |
# | 1 | 1 | 1 | 0 | 1 | 0 | 1 | 0 |
# | 1 | 1 | 1 | 0 | 1 | 0 | 1 | 1 |
# | 1 | 1 | 1 | 0 | 1 | 1 | 0 | 0 |
# | 1 | 1 | 1 | 0 | 1 | 1 | 0 | 1 |
# | 1 | 1 | 1 | 0 | 1 | 1 | 1 | 0 |
# | 1 | 1 | 1 | 0 | 1 | 1 | 1 | 1 |
# | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 |
# | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 1 |
# | 1 | 1 | 1 | 1 | 0 | 0 | 1 | 0 |
# | 1 | 1 | 1 | 1 | 0 | 0 | 1 | 1 |
# | 1 | 1 | 1 | 1 | 0 | 1 | 0 | 0 |
# | 1 | 1 | 1 | 1 | 0 | 1 | 0 | 1 |
# | 1 | 1 | 1 | 1 | 0 | 1 | 1 | 0 |
# | 1 | 1 | 1 | 1 | 0 | 1 | 1 | 1 |
# | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 0 |
# | 1 | 1 | 1 | 1 | 1 | 0 | 0 | 1 |
# | 1 | 1 | 1 | 1 | 1 | 0 | 1 | 0 |
# | 1 | 1 | 1 | 1 | 1 | 0 | 1 | 1 |
# | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 |
# | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 1 |
# | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 |
# | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
# |---|---|---|---|---|---|---|---|
# | a | b | c | d | e | f | g | h |



##  generate TRUTH table
#
#with open('00__TRUTH_table__8-variables.txt', 'w') as outF:  # 'a' - append, 'w' - overwrite, 'b' - binary
#    outF.write('# | a | b | c | d | e | f | g | h |\n')
#    outF.write('# |---|---|---|---|---|---|---|---|\n')
#    for i in range(0, 256):
#        outF.write('# | {0} | {1} | {2} | {3} | {4} | {5} | {6} | {7} |\n'.format(
#            (i >> 7) & 1,
#            (i >> 6) & 1,
#            (i >> 5) & 1,
#            (i >> 4) & 1,
#            (i >> 3) & 1,
#            (i >> 2) & 1,
#            (i >> 1) & 1,
#            (i >> 0) & 1
#        ))
#    outF.write('# |---|---|---|---|---|---|---|---|\n')
#    outF.write('# | a | b | c | d | e | f | g | h |\n')


a = x1 = 0b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
b = x2 = 0b0000000000000000000000000000000000000000000000000000000000000000111111111111111111111111111111111111111111111111111111111111111100000000000000000000000000000000000000000000000000000000000000001111111111111111111111111111111111111111111111111111111111111111
c = x3 = 0b0000000000000000000000000000000011111111111111111111111111111111000000000000000000000000000000001111111111111111111111111111111100000000000000000000000000000000111111111111111111111111111111110000000000000000000000000000000011111111111111111111111111111111
d = x4 = 0b0000000000000000111111111111111100000000000000001111111111111111000000000000000011111111111111110000000000000000111111111111111100000000000000001111111111111111000000000000000011111111111111110000000000000000111111111111111100000000000000001111111111111111
e = x5 = 0b0000000011111111000000001111111100000000111111110000000011111111000000001111111100000000111111110000000011111111000000001111111100000000111111110000000011111111000000001111111100000000111111110000000011111111000000001111111100000000111111110000000011111111
f = x6 = 0b0000111100001111000011110000111100001111000011110000111100001111000011110000111100001111000011110000111100001111000011110000111100001111000011110000111100001111000011110000111100001111000011110000111100001111000011110000111100001111000011110000111100001111
g = x7 = 0b0011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011
h = x8 = 0b0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101


def calc_truth_table__8_vars__123(terms):
    zero = 0b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
    one  = 0b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
    cw = 0
    for i in range(0, len(terms)):
        term = terms[i]
        if len(term) == 0:
            continue                         # raise Exception("Empty term!")
        elif len(term) == 1 and term == '0':
            cw ^= zero
        elif len(term) == 1 and term == '1':
            cw ^= one
        else:
            t = one
            for j in range(0, len(term)):
                if term[j] == '1':   t &= a
                elif term[j] == '2': t &= b
                elif term[j] == '3': t &= c
                elif term[j] == '4': t &= d
                elif term[j] == '5': t &= e
                elif term[j] == '6': t &= f
                elif term[j] == '7': t &= g
                elif term[j] == '8': t &= h
                else: raise Exception("Only 1,2,3,4,5,6,7,8 are allowed!")
            cw ^= t
    return cw


def calc_truth_table__7_vars__abc(terms):
    a = x1 = 0b00000000000000000000000000000000000000000000000000000000000000001111111111111111111111111111111111111111111111111111111111111111
    b = x2 = 0b00000000000000000000000000000000111111111111111111111111111111110000000000000000000000000000000011111111111111111111111111111111
    c = x3 = 0b00000000000000001111111111111111000000000000000011111111111111110000000000000000111111111111111100000000000000001111111111111111
    d = x4 = 0b00000000111111110000000011111111000000001111111100000000111111110000000011111111000000001111111100000000111111110000000011111111
    e = x5 = 0b00001111000011110000111100001111000011110000111100001111000011110000111100001111000011110000111100001111000011110000111100001111
    f = x6 = 0b00110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011
    g = x7 = 0b01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101

    zero   = 0b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
    one    = 0b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
    cw     = 0
    for i in range(0, len(terms)):
        term = terms[i]
        if len(term) == 0:
            continue                         # raise Exception("Empty term!")
        elif len(term) == 1 and term == '0':
            cw ^= zero
        elif len(term) == 1 and term == '1':
            cw ^= one
        else:
            t = one
            for j in range(0, len(term)):
                if term[j] == 'a':   t &= a
                elif term[j] == 'b': t &= b
                elif term[j] == 'c': t &= c
                elif term[j] == 'd': t &= d
                elif term[j] == 'e': t &= e
                elif term[j] == 'f': t &= f
                elif term[j] == 'g': t &= g
                else: raise Exception("Only a,b,c,d,e,f,g are allowed!")
            cw ^= t
    return cw


#     34   33   32   31   30   29   28   27   26   25   24   23   22   21   20   19   18   17   16   15   14   13   12   11   10    9    8    7    6    5    4    3    2    1    0
#    abc, abd, abe, abf, abg, acd, ace, acf, acg, ade, adf, adg, aef, aeg, afg, bcd, bce, bcf, bcg, bde, bdf, bdg, bef, beg, bfg, cde, cdf, cdg, cef, ceg, cfg, def, deg, dfg, efg
#
#  Examples:
#
#          abc = 0b10000000000000000000000000000000000 -> 0x0400000000
#      abc+def = 0b10000000000000000000000000000001000 -> 0x0400000008
#
def get__f_idx__by_third_order_ANF_monomials__abc(anf):
    if anf == '0':
        return 0
    terms = anf.split('+')
    idx = 0
    for i in range(0, len(terms)):
        if   terms[i] == 'abc': idx |= 0b10000000000000000000000000000000000
        elif terms[i] == 'abd': idx |= 0b01000000000000000000000000000000000
        elif terms[i] == 'abe': idx |= 0b00100000000000000000000000000000000
        elif terms[i] == 'abf': idx |= 0b00010000000000000000000000000000000
        elif terms[i] == 'abg': idx |= 0b00001000000000000000000000000000000
        elif terms[i] == 'acd': idx |= 0b00000100000000000000000000000000000
        elif terms[i] == 'ace': idx |= 0b00000010000000000000000000000000000
        elif terms[i] == 'acf': idx |= 0b00000001000000000000000000000000000
        elif terms[i] == 'acg': idx |= 0b00000000100000000000000000000000000
        elif terms[i] == 'ade': idx |= 0b00000000010000000000000000000000000
        elif terms[i] == 'adf': idx |= 0b00000000001000000000000000000000000
        elif terms[i] == 'adg': idx |= 0b00000000000100000000000000000000000
        elif terms[i] == 'aef': idx |= 0b00000000000010000000000000000000000
        elif terms[i] == 'aeg': idx |= 0b00000000000001000000000000000000000
        elif terms[i] == 'afg': idx |= 0b00000000000000100000000000000000000
        elif terms[i] == 'bcd': idx |= 0b00000000000000010000000000000000000
        elif terms[i] == 'bce': idx |= 0b00000000000000001000000000000000000
        elif terms[i] == 'bcf': idx |= 0b00000000000000000100000000000000000
        elif terms[i] == 'bcg': idx |= 0b00000000000000000010000000000000000
        elif terms[i] == 'bde': idx |= 0b00000000000000000001000000000000000
        elif terms[i] == 'bdf': idx |= 0b00000000000000000000100000000000000
        elif terms[i] == 'bdg': idx |= 0b00000000000000000000010000000000000
        elif terms[i] == 'bef': idx |= 0b00000000000000000000001000000000000
        elif terms[i] == 'beg': idx |= 0b00000000000000000000000100000000000
        elif terms[i] == 'bfg': idx |= 0b00000000000000000000000010000000000
        elif terms[i] == 'cde': idx |= 0b00000000000000000000000001000000000
        elif terms[i] == 'cdf': idx |= 0b00000000000000000000000000100000000
        elif terms[i] == 'cdg': idx |= 0b00000000000000000000000000010000000
        elif terms[i] == 'cef': idx |= 0b00000000000000000000000000001000000
        elif terms[i] == 'ceg': idx |= 0b00000000000000000000000000000100000
        elif terms[i] == 'cfg': idx |= 0b00000000000000000000000000000010000
        elif terms[i] == 'def': idx |= 0b00000000000000000000000000000001000
        elif terms[i] == 'deg': idx |= 0b00000000000000000000000000000000100
        elif terms[i] == 'dfg': idx |= 0b00000000000000000000000000000000010
        elif terms[i] == 'efg': idx |= 0b00000000000000000000000000000000001
        else: raise Exception("Only third order ANF monomials are allowed!")
    return idx


def has_allowed_chars_only(str, allowed_chars):
    for ch in str:
        if ch not in allowed_chars:
            return False
    return True


def is_power_of_two(n):
    return n.bit_count() == 1


def convert__12345678__to__abcdefgh(anf):
    anf = anf.replace('1','a').replace('2','b')
    anf = anf.replace('3','c').replace('4','d') 
    anf = anf.replace('5','e').replace('6','f')
    anf = anf.replace('7','g').replace('8','h')
    return anf


def get_rm37_anf__from_its_dual__rm47_anf(anf):  #  2357+1457+1367+1467+2467  |  146+236+245+235+135
    if anf == '0':
        return '0'   
    terms_rm47 = anf.split('+')
    terms_rm37 = [] 
    for term in terms_rm47:
        term_dual_rm37 = ''
        for c in '1234567':
            if c not in term:
                term_dual_rm37 += c
        terms_rm37.append(term_dual_rm37)
    terms_rm37.sort(key=lambda x: (-len(x), x))                         # sort list by length of strings followed by alphabetical order: https://archive.ph/SuoEB
    anf_rm37 = '+'.join(                                                # ANF terms are sorted lexicographically
        '{0}'.format(terms_rm37[i]) for i in range(len(terms_rm37))
    )
    return anf_rm37


Idx_to_Fi_dict = { # 7 vars, 128 bits ANF     #             Original ANF             |     |             Ordered ANF              |   orbitSize   |      stabSize       |
                                              #--------------------------------------|-----|--------------------------------------|---------------|---------------------|
     0: 0x00000000000000000000000000000000,   #  0                                   |  f0 |  0                                   |            1  |  20972799094947840  |
     1: 0x000100020001000D01000103101145B7,   #  abcd+bcde+cdef+abcg+abfg+aefg+defg  |  f1 |  abcd+abcg+abfg+aefg+bcde+cdef+defg  |  13545799680  |            1548288  |
     2: 0x00000000000303330003030F00000F33,   #  abce+acde+bcdf+acef+bcef+adef+bdef  |  f2 |  abce+acde+acef+adef+bcdf+bcef+bdef  |      1763776  |        11890851840  |
     3: 0x00000101000301570011011F0517377F,   #  acde+abcf+bdef+bcdg+abeg+adfg+cefg  |  f3 |  abcf+abeg+acde+adfg+bcdg+bdef+cefg  |    238109760  |           88080384  |
     4: 0x00000003011004160101020100113527,   #  abcf+acef+cdef+bceg+bdfg+aefg+befg  |  f4 |  abcf+acef+aefg+bceg+bdfg+befg+cdef  |    444471552  |           47185920  |
     5: 0x0000001700000018010110070101233B,   #  bcde+abcf+cdef+cdeg+acfg+cdfg+aefg  |  f5 |  abcf+acfg+aefg+bcde+cdef+cdeg+cdfg  |  17778862080  |            1179648  |
     6: 0x00010001000111100001050400544115,   #  abcg+abdg+aceg+bcfg+defg            |  f6 |  abcg+abdg+aceg+bcfg+defg            |     21165312  |          990904320  |
     7: 0x00010001000100010001000100015554,   #  abcg+defg                           |  f7 |  abcg+defg                           |     45354240  |          462422016  |
     8: 0x00010001000100010001111005041415,   #  abeg+acfg+defg                      |  f8 |  abeg+acfg+defg                      |     59527440  |          352321536  |
     9: 0x000100020001030E000111130001121F,   #  bcde+bcef+cdef+acfg+defg            |  f9 |  acfg+bcde+bcef+cdef+defg            |   2222357760  |            9437184  |
    10: 0x00010001000111100001000100011110,   #  bcfg+defg                           | f10 |  bcfg+defg                           |      2314956  |         9059696640  |
    11: 0x00010001000100010001000100010001    #  defg                                | f11 |  defg                                |        11811  |      1775700541440  |
}


e_idx__to__RM47_e_idx__dict = {
               #                     RM(4,8) = e + f * x8
               #--------------------------------------------------------------------------------------------------------------------------------
               #  idx | count |         e - RM(4,7)             | Our |   RM(4,7) as 'abcdef' (Langevin)   |   RM(4,7) as '1234567' (Langevin)  |
               #------|-------|---------------------------------|-----|------------------------------------|------------------------------------|
     0:  0,    #   0  |    3  |  0                              |  e0 | 0                                  | 0                                  | same
     9:  1,    #   9  |    1  |  1267+1357+1456+2347+2356       |  e1 | abcd+abcg+abfg+aefg+bcde+cdef+defg | 1234+1237+1267+1567+2345+3456+4567 |
     6:  2,    #   6  |   21  |  2367+2457+3456                 |  e2 | abce+acde+acef+adef+bcdf+bcef+bdef | 1235+1345+1356+1456+2346+2356+2456 |
     8:  3,    #   8  |    7  |  1567+2367+2457+3456            |  e3 | abcf+abeg+acde+adfg+bcdg+bdef+cefg | 1236+1257+1345+1467+2347+2456+3567 |
    11:  4,    #  11  |  502  |  1246+1356+2345+2467+2567+3467  |  e4 | abcf+acef+aefg+bceg+bdfg+befg+cdef | 1236+1356+1567+2357+2467+2567+3456 |
     7:  5,    #   7  |  292  |  1267+1457+2357+3456            |  e5 | abcf+acfg+aefg+bcde+cdef+cdeg+cdfg | 1236+1367+1567+2345+3456+3457+3467 |
    10:  6,    #  10  |   10  |  1367+1457+1467+2357+2467       |  e6 | abcg+abdg+aceg+bcfg+defg           | 1237+1247+1357+2367+4567           |
     2:  7,    #   2  |   89  |  1267+3457                      |  e7 | abcg+defg                          | 1237+4567                          |
     5:  8,    #   5  |   56  |  1567+2467+3457                 |  e8 | abeg+acfg+defg                     | 1257+1367+4567                     |
     4:  9,    #   4  |    1  |  1247+1356+4567                 |  e9 | acfg+bcde+bcef+cdef+defg           | 1367+2345+2356+3456+4567           |
     3: 10,    #   3  |   15  |  2567+3467                      | e10 | bcfg+defg                          | 2367+4567                          |
     1: 11     #   1  |    2  |  4567                           | e11 | defg                               | 4567                               | same
               #--------------------------------------------------------------------------------------------------------------------------------
}


RM37_anf__to__RM37_Leander_anf__dict = {
    '0':                       '0',
    '123':                     '123',
    '126+345':                 '123+456',
    '125+134':                 '123+145',
    '123+247+356':             '123+127+147+167+245',
    '126+135+234':             '123+245+346',
    '127+136+145':             '137+147+157+237+247+267+467',
    '127+146+236+345':         '125+126+127+167+234+245+457',
    '127+136+145+234':         '124+137+156+235+267+346+457',
    '147+156+237+246+345':     '123+127+167+234+345+456+567',
    '135+146+235+236+245':     '123+145+246+356+456',
    '125+134+135+167+247+357': '127+134+135+146+234+247+457'
}


RM37_Leander_anf__to__orbitSize__dict = {
    '0':                                     1,
    '123':                               11811,
    '123+127+147+167+245':          2222357760,
    '123+127+167+234+345+456+567': 13545799680,
    '123+145':                         2314956,
    '123+145+246+356+456':            21165312,
    '123+245+346':                    59527440,
    '123+456':                        45354240,
    '124+137+156+235+267+346+457':   238109760,
    '125+126+127+167+234+245+457': 17777862080,
    '127+134+135+146+234+247+457':   444471552,
    '137+147+157+237+247+267+467':     1763776
}


print()
print('a = x1 = 0x{0:064X} = {0:0256b}'.format(a))
print('b = x2 = 0x{0:064X} = {0:0256b}'.format(b))
print('c = x3 = 0x{0:064X} = {0:0256b}'.format(c))
print('d = x4 = 0x{0:064X} = {0:0256b}'.format(d))
print('e = x5 = 0x{0:064X} = {0:0256b}'.format(e))
print('f = x6 = 0x{0:064X} = {0:0256b}'.format(f))
print('g = x7 = 0x{0:064X} = {0:0256b}'.format(g))
print('h = x8 = 0x{0:064X} = {0:0256b}'.format(h))


# list of dictionaries
Fr = [
    #{
    #    'anf_12345678':
    #    'anf_abcdefgh':
    #    'anf_by_lex_order':
    #    'terms_all':
    #    'truth_table':
    #    'orbit_size':
    #    'stab_size':
    #    'stabilizers':
    #}
]


#
# Linear group order: LG_order(2,m) =       (2^m - 2^0)*(2^m - 2^1)*...*(2^m - 2^(m-1))
#
# Affine group order: AG_order(2,m) = (2^m)*(2^m - 2^0)*(2^m - 2^1)*...*(2^m - 2^(m-1)) = (2^m)*LG_order(2,m)
#
print('\n')
linear_group_order = 1
for i in range(0,8):
    linear_group_order *= (2**8 - 2**i)                                                       #      (2^8 - 1)(2^8 - 2)(2^8 - 4)(2^8 - 8)(2^8 - 16)(2^8 - 32)(2^8 - 64)(2^8 - 2^7)
print('linear_group_order (GL) = {0:>22}\n'.format(linear_group_order))

affine_group_order = (2**8) * linear_group_order                                              # (2^8)(2^8 - 1)(2^8 - 2)(2^8 - 4)(2^8 - 8)(2^8 - 16)(2^8 - 32)(2^8 - 64)(2^8 - 128)
print('affine_group_order (GA) = {0:>22}\n'.format(affine_group_order))


e_set = set()
sum_of_orbit_sizes = 0
name_of_current_script = os.path.splitext(os.path.basename(__file__))[0]                      # get name of current script in Python: https://archive.ph/NZ7A1 , https://archive.ph/L3hng

with open('DATA/class-rm48h-all__file-of-999-representatives.txt', 'r') as inF:               # 'a' - append, 'w' - overwrite, 'b' - binary
    count = 0
    while True:
        line = inF.readline()

        if not line:
            break                                                                             # if line is empty end of file is reached
        elif line.startswith('Q='):
            line = line[2:].rstrip('\r\n').replace(' ','')                                    # skip 'Q=', get substring without any '\r' and '\n' at the end and without any ' '

            if not has_allowed_chars_only(line, '+012345678'):                                # check if any 'term' contains only allowed characters ['+','0','1','2','3','4','5','6','7','8']                                      
                print('Wrong character in ANF \'{0}\''.format(line))

            anf_12345678 = line[:-1] if line[-1] == '+' else (line + '.')[:-1]                # ANF (remove last '+' if hase one)

            anf_abcdefgh = convert__12345678__to__abcdefgh(anf_12345678)                      # convert BF representation from '12345678' to 'abcdefgh'

            terms_all = anf_12345678.split('+')                                               # split ANF representation by '+'

            truth_table = calc_truth_table__8_vars__123(terms_all)                            # Truth Table (TT)

            terms_all.sort(key=lambda x: (-len(x), x))                                        # sort list by length of strings followed by alphabetical order: https://archive.ph/SuoEB
            anf_by_lex_order = '+'.join(                                                      # ANF terms are sorted lexicographically
                '{0}'.format(terms_all[i]) for i in range(len(terms_all))
            )

            terms_e = [term for term in terms_all if not term.__contains__('8')]
            terms_e.sort(key=lambda x: (len(x), x))                                           # ANF terms are sorted by length and then lexicographically
            anf_e = '+'.join(
                '{0}'.format(terms_e[i]) for i in range(len(terms_e))
            )
            if len(anf_e) == 0:
                anf_e = '0'

            e_set.add(anf_e)

            terms_f = [term for term in terms_all if term.__contains__('8')]
            terms_f.sort(key=lambda x: (len(x), x))                                           # ANF terms are sorted by length and then lexicographically
            anf_f = '+'.join(
                '{0}'.format(terms_f[i]) for i in range(len(terms_f))
            )
            if len(anf_f) == 0:
                anf_f = '0'

            # Initialize variables

            invariants  = ''  # 'Inv='
            orbit_size  = 0   # 'Orb='
            stab_size   = 0   # 'Fix='
            stabilizers = []  # [ '[0......1 ... 0......1]', ..., '[0......1 ... 0......1]' ]

            while True:
                line = inF.readline()
                if not line:
                    break                          # if line is empty end of file is reached
                line = line.rstrip('\r\n')         # remove any '\r' and '\n' at the end of the string

                if line.startswith('Inv='):
                    invariants = line[4:]
                elif line.startswith('Orb='):
                    orbit_size = int(line[4:])
                elif line.startswith('Fix='):
                    stab_size = int(line[4:])
                elif line.startswith('['):
                    stabilizers.append(line.replace('[ ','[') + '00000000')
                elif line.startswith('cpt='):
                    break

            # Do some checks

            if (orbit_size * stab_size) != linear_group_order:
                print('{0} != {1}\n'.format(orbit_size * stab_size, linear_group_order))
                raise Exception('(orbit_size * stab_size) != linear_group_order')

            sum_of_orbit_sizes += orbit_size

            Fr.append({
                'anf_12345678': anf_12345678,
                'anf_abcdefgh': anf_abcdefgh,
                'anf_by_lex_order': anf_by_lex_order,
                'anf_e': anf_e,
                'anf_f': anf_f,
                'terms_all': terms_all,
                'terms_e': terms_e,
                'terms_f': terms_f,
                'truth_table': truth_table,
                'orbit_size': orbit_size,
                'stab_size': stab_size,
                'stabilizers': stabilizers
            })

            count += 1

            #print('  N={0}'.format(count))
            #print('  Q={0}'.format(anf_12345678))
            #print('ANF={0}'.format(anf_abcdefgh))
            #print('ANF={0}'.format(anf_by_lex_order))
            #print(' TT=0x{0:>064X}'.format(truth_table))
            #print('Orb={0}'.format(orbit_size))
            #print('Fix={0}'.format(stab_size))
            #print('{0}\n'.format(stabilizers))


    print('       Number of orbits = {0:>22}\n'.format(count))
    print('     sum_of_orbit_sizes = {0}'.format(sum_of_orbit_sizes), end='')

    if 2**70 == sum_of_orbit_sizes:
        print(' = 2^70\n\n')
    else:
        print(' = 2^({0:f})  !!! MUST be 2^70 !!!\n\n'.format(math.log2(sum_of_orbit_sizes)))


##  sort orbits by lexicographically ordered ANF's
#if len(Fr) > 0:
#    Fr.sort(key=operator.itemgetter('anf_by_lex_order'))

#  sort orbits by 'orbit_size'
#if len(Fr) > 0:
#    Fr.sort(key=operator.itemgetter('orbit_size'))

#  sort orbits by length of 'anf_by_lex_order'
#if len(Fr) > 0:
#    Fr.sort(key=lambda x: len(x['anf_e']))

#  sort orbits by length of 'anf_e' and then by lexicographical order of 'anf_e' 
if len(Fr) > 0:
    Fr.sort(key=lambda x: (len(x['anf_e']), x['anf_e']))

#  sort orbits by length of 'anf_f' and then by lexicographical order of 'anf_f' 
#if len(Fr) > 0:
#    Fr.sort(key=lambda x: (len(x['anf_f']), x['anf_f']))

# Convert e_set to list and sort:

e_list_sorted = list(e_set)
e_list_sorted.sort(key=lambda x: (len(x), x))

e_dict_sorted = {}
e_count_dict = {}
idx = 0
for x in e_list_sorted:
    e_dict_sorted[x] = idx
    e_count_dict[x] = 0     # count of times 'e' was met (998 representatives split to e + f * x8)
    idx += 1

print('{0}'.format(184 * '-'))
print('{0}RM(4,8) = e + f * x8   (999 representatives){0}|{1}e{1}|{2}f{2}|      orbit length     |'.format(17 * ' ', 18 * ' ', 21 * ' '))

prev_orbit_anf_e = ''

#for i in (0,1,2,3,4,993,994,995,996,997): # print data of first 5 and last 5 orbits
for i in range(0, len(Fr)):                # print all orbits data

    e_count_dict[Fr[i]['anf_e']] += 1

    if Fr[i]['anf_e'] != prev_orbit_anf_e:
        print('{0}|{1}|{2}|{3}|'.format(78 * '-', 37 * '-', 43 * '-', 23 * '-'))
        prev_orbit_anf_e = Fr[i]['anf_e']

    #print('  N={0}'.format(i+1))
    #print('  Q={0}'.format(Fr[i]['anf_12345678']))
    #print('ANF={0}'.format(Fr[i]['anf_abcdefgh']))
    print('  {0:<74}  |  {1:<29}  {2:>2}  |  {3:<39}  |  {4:>19}  |'.format(
        Fr[i]['anf_by_lex_order'],
        Fr[i]['anf_e'],
        e_dict_sorted[Fr[i]['anf_e']],
        Fr[i]['anf_f'].replace('8',''),
        Fr[i]['orbit_size'])
    )  #{3:<39}  #.replace('8','')
    #print(' TT=0x{0:>064X}'.format(Fr[i]['truth_table']))
    #print('Orb={0}'.format(Fr[i]['orbit_size']))
    #print('Fix={0}'.format(Fr[i]['stab_size']))
    #print('{0}\n\n-------\n'.format('\n'.join('{0}'.format(Fr[i]['stabilizers'][j]) for j in range(len(Fr[i]['stabilizers'])))))
print('{0}\n\n\n'.format(184 * '-'))


print('----------------------------------------------------------------------------')
print('                       \'e_set\' consist of {0} elements                       |'.format(len(e_set)))
print('----------------------------------------------------------------------------|---------------------------------------------------------')
print('                                 |                _          |      |       |                               |                         |')
print('         e - E\'(4,7)             |    Dual of e - E\'(4,7)    |  idx | count |       RM*(3,7) - Leander      |  orbit size of RM*(3,7) |')
print('---------------------------------|---------------------------|------|-------|-------------------------------|-------------------------|')

for key in e_dict_sorted:  # ANF of RM*(4,7) = RM(4,7)/RM(3,7)
    rm37_anf               = get_rm37_anf__from_its_dual__rm47_anf(key)
    rm37_Leander_anf       = RM37_anf__to__RM37_Leander_anf__dict[rm37_anf]
    rm37_Leander_orbitSize = RM37_Leander_anf__to__orbitSize__dict[rm37_Leander_anf]
    print('  {0:<29}  |  {1:<23}  |  {2:>2}  |  {3:>3}  |  {4:<27}  |  {5:>21}  |'.format(
        key, 
        rm37_anf, 
        e_dict_sorted[key], 
        e_count_dict[key],
        rm37_Leander_anf,
        rm37_Leander_orbitSize)
    )
print('{0}\n\n\n\n\n\n\n\n\n'.format(134 * '-'))



e_idx_RM48__to__num_of_f_orbits = [  # count of f sub-orbits related to every e orbit from RM(4,8)

      3,  #  e0
      2,  #  e1
     89,  #  e2
     15,  #  e3
      1,  #  e4
     56,  #  e5
     21,  #  e6
    292,  #  e7
      7,  #  e8
      1,  #  e9
     10,  #  e10
    502,  #  e11
]


# Write files:

# 1. write 'RM47__gp__e{u}__from_RM48.bin' files

repr_idx = 0 
for i in range(12):
    e_idx_RM47 = e_idx__to__RM47_e_idx__dict[i]
    fname = 'RM48__input_data\\e{0}\\RM47__gp__e{0}__from_RM48.bin'.format(e_idx_RM47)
    os.makedirs(os.path.dirname(fname), exist_ok=True)
    with open(fname , 'wb') as outF:
        num_of_f_orbits = e_idx_RM48__to__num_of_f_orbits[i]
        for j in range(0, num_of_f_orbits):
            anf_f_123 = Fr[repr_idx]['anf_f'].replace('8','')
            anf_f_abc = convert__12345678__to__abcdefgh(anf_f_123)
            terms_abc = anf_f_abc.split('+')
            f = calc_truth_table__7_vars__abc(terms_abc)
            outF.write(f.to_bytes(16, byteorder='little', signed=False))
            repr_idx += 1


# 2. write 'RM47__gp_anf_idxs__e{u}__from_RM48.bin' files

repr_idx = 0 
for i in range(12):
    e_idx_RM47 = e_idx__to__RM47_e_idx__dict[i]
    fname = 'RM48__input_data\\e{0}\\RM47__gp_anf_idxs__e{0}__from_RM48.bin'.format(e_idx_RM47)
    os.makedirs(os.path.dirname(fname), exist_ok=True)
    with open(fname , 'wb') as outF:
        num_of_f_orbits = e_idx_RM48__to__num_of_f_orbits[i]
        for j in range(0, num_of_f_orbits):
            anf_f_123 = Fr[repr_idx]['anf_f'].replace('8','')
            anf_f_abc = convert__12345678__to__abcdefgh(anf_f_123)
            f_anf_idx = get__f_idx__by_third_order_ANF_monomials__abc(anf_f_abc)
            outF.write(f_anf_idx.to_bytes(8, byteorder='little', signed=False))
            repr_idx += 1


# 3. write 'RM47__gp_orbits_lengths__e{u}__from_RM48.bin' files

repr_idx = 0 
for i in range(12):
    e_idx_RM47 = e_idx__to__RM47_e_idx__dict[i]
    fname = 'RM48__input_data\\e{0}\\RM47__gp_orbits_lengths__e{0}__from_RM48.bin'.format(e_idx_RM47)
    os.makedirs(os.path.dirname(fname), exist_ok=True)
    with open(fname , 'wb') as outF:
        num_of_f_orbits = e_idx_RM48__to__num_of_f_orbits[i]
        for j in range(0, num_of_f_orbits):
            orbit_size = Fr[repr_idx]['orbit_size']
            outF.write(orbit_size.to_bytes(8, byteorder='little', signed=False))
            repr_idx += 1
