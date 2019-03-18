import matplotlib.pyplot as plt
import numpy as np
from waves import *

waves = getWaves()
theta = 0
x = []
y = []
while theta <= 2 * np.pi + 1:
    xValue = 0
    yValue = 0
    for w in waves:
        phi = w.freq * theta + w.phase
        xValue += w.amp * np.cos(phi)
        yValue += w.amp * np.sin(phi)
    x.append(xValue)
    y.append(yValue)
    theta += (2 * np.pi) / len(waves)

plt.plot(x, y, marker='o')
plt.xscale = np.pi
plt.title("Swift Logo")
plt.show()
