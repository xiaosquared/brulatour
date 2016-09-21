# to run: python plot.py <filename>
# takes a newline delineated textfile
# plots it

import matplotlib.pyplot as plt
import numpy as np
import sys

filename = sys.argv[1]
lines = open(filename).read().splitlines()
lines = map(int, lines)

start = 0
end = len(lines)
numargs = len(sys.argv)
if numargs == 3:
    end = int(sys.argv[2])
elif numargs == 4:
    start = int(sys.argv[2])
    end = int(sys.argv[3])

to_plot = lines[start:end]
plt.plot(to_plot, '*', markersize=5)
#plt.xticks(np.arange(start-1, end+1, 50))
plt.yticks(np.arange(min(to_plot)-1, max(to_plot)+2, 1))
plt.show()
