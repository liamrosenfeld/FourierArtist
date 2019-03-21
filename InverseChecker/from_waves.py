import matplotlib.pyplot as plt
import math as m
from waves import *

waves = getWaves()
theta = 0
x = []
y = []
while theta <= 2 * m.pi + 1:
    xValue = 0
    yValue = 0
    for w in waves:
        phi = w.freq * theta + w.phase
        xValue += w.amp * m.cos(phi)
        yValue += w.amp * m.sin(phi)
    x.append(xValue)
    y.append(yValue)
    theta += (2 * m.pi) / len(waves)

plt.plot(x, y, marker='o')
plt.xscale = m.pi
plt.title("Swift Logo")
plt.show()
