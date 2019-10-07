__author__ = 'T004314'

from numpy import *
from matplotlib.pyplot import *

K = 8000
S = linspace(7000,9000,100)
h = maximum(S-K,0)
figure()
plot(S, h, lw=2.5)
xlabel('Index level at maturity')
ylabel('Inner value of european call option')
grid(True)
show()