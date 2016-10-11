# 10.6.16
# to run: python plotAAB.py <filename>
# Plots accelerometer Z, altitude, and button press times
# to test ground truth from elevator

import matplotlib.pyplot as plt
import sys

# Get data from file
filename = sys.argv[1]
lines = open(filename).read().splitlines()
lines = map(lambda q: q.split(','), lines)

# Separate Accelation Z values and Altitude values
z = map(lambda q: float(q[0]), lines)
alt = map(lambda q: float(q[1]), lines)

# Deal with button push times
def buttonData(i, q):
    if len(q) == 4:
        q[0] = float(q[0])
        q[1] = float(q[1])
        q[3] = float(q[3])
        q = [i] + q
        return q
btn = map(lambda (i, q): buttonData(i, q), enumerate(lines))
btn = [q for q in btn if q != None]
print btn

# Determine which portion to plot
start = 0
end = len(lines)
numargs = len(sys.argv)
if numargs == 3:
    end = int(sys.argv[2])
elif numargs ==4:
    start = int(sys.argv[2])
    end = int(sys.argv[3])

z_plot = z[start:end]
alt_plot = alt[start:end]

# btn: [index, z_val, alt_val, event_tag, timestamp]
def annotateButtonData(q, plt, count, which):
    index = q[0]
    if index > start and index < end:
        index = index - start
        if (which%2 == 0):
            plt.annotate(q[3]+' ' + str(q[4]), xy=(index, q[1]), xytext=(index, q[1]+0.25*count),
                    arrowprops=dict(width=0.5,headwidth=4,headlength=4,facecolor='black', shrink=0.05),)
        if (which > 0):
            plt.annotate(q[3]+' ' + str(q[4]), xy=(index, q[2]), xytext=(index, q[2]+2),
                    arrowprops=dict(width=0.5,headwidth=4,headlength=4,facecolor='black', shrink=0.05),)
        return True
    return False

def annotate(which):
    count = 1;
    for elt in btn:
        if annotateButtonData(elt, plt, count, which):
            count=count+1

def runningAvg2(input, interval):
    counter = 0;
    l = len(input)
    result = []
    while counter < l-interval:
        result.append(sum(input[counter:counter+interval])/float(interval))
        counter = counter+1
    return result

# remove outliers from z
z_plot = map(lambda q: max(min(q, 65), 50), z_plot)

z_avg = runningAvg2(z_plot, 10)

diff = list(z_avg)
for i in range(1, len(diff)):
    diff[i] = (z_avg[i] - z_avg[i-1])*10 + 58


# fig 1: time stamps for z and altitude
# plt.figure(1)
plt.plot(z_plot, 'o', markersize=3, color='b')
plt.plot(z_avg, 'x', markersize=3, color='r')
# plt.plot(diff, 'x', markersize=3, color='g')
# #plt.plot(diff_sum[10:end], 'o', markersize=3, color='r')
annotate(0)


alt_avg = runningAvg2(alt_plot, 20)
# diff = list(alt_avg)
# for i in range(1, len(diff)):
#     diff[i] = (alt_avg[i] - alt_avg[i-1])

#f1_height = alt_plot[369:706]
f1_height = alt_plot[1793:2064]
f1_height = reduce(lambda x, y: x+y, f1_height)/len(f1_height)
print f1_height

f2_height = alt_plot[1087:1384]
f2_height = reduce(lambda x, y: x+y, f2_height)/len(f2_height)
print f2_height

# fig 2: altitude with running avg
plt.figure(2)
plt.plot(alt_plot, 'x', markersize=3, color='r')
plt.plot(alt_avg, 'o', markersize=2, color='b')
#plt.plot(diff_sum, 'x', markersize=2, color='b')
#plt.plot(diff, 'x', markersize=2, color='b')

annotate(1)

plt.show()
