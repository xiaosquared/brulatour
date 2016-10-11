# 9.20.16
# to run: python plotZAvg.py <filename>
# Purpose: to test the running average calculation of Arduino

import matplotlib.pyplot as plt
import sys

# Get data from file
filename = sys.argv[1]
lines = open(filename).read().splitlines()
lines = map(lambda q: q.split(','), lines)

# Separate z values and avg values
z = map(lambda q: float(q[0]), lines)
avg = map(lambda q: float(q[1]), lines)

# Determine which portion to plot
start = 0
end = len(lines)
numargs = len(sys.argv)
if numargs == 3:
    end = int(sys.argv[2])
elif numargs == 4:
    start = int(sys.argv[2])
    end = int(sys.argv[3])

z_plot = z[start:end]
avg_plot = avg[start:end]

# Diff between consecutive frames of averages
# diff = list(avg_plot)
# for i in range(1, len(diff)):
#     diff[i] = (avg_plot[i] - avg_plot[i-1])*10 + 58


plt.plot(z_plot, 'o', markersize=3, color='b')
plt.plot(avg_plot, 'x', markersize=3, color='r')
#plt.plot(diff, 'x', markersize=3, color='g')

plt.show()
