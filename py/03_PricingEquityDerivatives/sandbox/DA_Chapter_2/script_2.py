__author__ = 'T004314'

from numpy import *
from matplotlib.pyplot import *
from Market_Models.BSM_Option_Valuation import *

# Model and option parameters
K = 8000
T = 1.0
r = 0.025
vol = 0.2

#Sample data generation
S = linspace(4000, 12000, 100)
h = maximum(S-K,0)
C = []
for s in S:
    C.append(BSM_Call(s, K, T, r, vol, 0))

figure()
plot(S, h, lw = 1.5)
plot(S, C, 'r', lw=2.5)
grid(True)
xlabel('Index level today (T = 1 Year)')
ylabel('Value of European Call Option')
show()
