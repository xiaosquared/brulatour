# 9.20.16
# to run: python plotxyz.py <filename>
# takes a newline delineated textfile
# where each line is in the form <x,y,z>

# Figure 1
# plots x as red, y as green, z as blue

# Figure 2
# plots just the z and the running average of z


import matplotlib.pyplot as plt
import numpy as np
import sys

# Global Variables
interval = 10
default_z = 59

# Get data from file
filename = sys.argv[1]
lines = open(filename).read().splitlines()
lines = map(lambda q: q.split(','), lines)

# Separate each axis
x = map(lambda q: int(q[0]), lines)
y = map(lambda q: int(q[1]), lines)
z = map(lambda q: int(q[2]), lines)

# Determine which portion to plot
start = 0
end = len(lines)
numargs = len(sys.argv)
if numargs == 3:
    end = int(sys.argv[2])
elif numargs == 4:
    start = int(sys.argv[2])
    end = int(sys.argv[3])


# Plot figure 1
x_plot = x[start:end]
y_plot = y[start:end]
z_plot = z[start:end]

xyz = plt.figure(1)
plt.plot(x_plot, 'o', markersize=3, color='r')
plt.plot(y_plot, 'o', markersize=3, color='g')
plt.plot(z_plot, 'o', markersize=3, color='b')

# Plot figure 2
z = plt.figure(2)
plt.plot(z_plot, 'o', markersize=3, color='b')

# Compute running average

# this is a cute way of doing it, breaks if input is too long :-(
def runningAvg(input, interval, result):
    if len(input) < interval:
        return result
    else:
        result.append(sum(input[0:interval])/float(interval))
        input.pop(0)
        return runningAvg(input, interval, result)

def runningAvg2(input, interval):
    counter = 0;
    l = len(input)
    result = []
    while counter < l-interval:
        result.append(sum(input[counter:counter+interval])/float(interval))
        counter = counter+1
    return result

z_ra = runningAvg2(z_plot, interval)
#z_ra = runningAvg(z_plot, interval, [])
z_ra = [default_z] * interval + z_ra

plt.plot(z_ra, 'x', markersize=3, color='r')


plt.show()
