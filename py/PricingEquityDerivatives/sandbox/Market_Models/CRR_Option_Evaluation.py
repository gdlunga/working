#
# CRR Model -- European Call Valuation
# CRR_Option_Valuation.py
#
# (c) Dr. Yves J. Hilpisch
# Script for illustration purposes only.
#
from numpy import *
#
# Parameters
#
# Model and Option Parameters
S0 = 100.0 # index level
K = 100.0 # option strike
T = 1.0 # maturity date
r = 0.05 # risk -less short rate
vol = 0.2 # volatility
put = False # option type put = True , call otherwise
# Time Parameters
M = 4 # time intervals
dt = T / M # length of time interval
df = exp(-r * dt) # discount per interval
# Binomial Parameters
u = exp(vol * sqrt(dt)) # up movement
d = 1 / u # down movement
q = (exp(r * dt) - d) / (u - d) # martingale branch probability
#
# Binomial Model Implementation
#
# Array Initialization for Index Levels
mu = arange(M + 1)
mu = resize(mu , (M + 1, M + 1))
md = transpose(mu)
mu = u ** (mu - md)
md = d ** md
S = S0 * mu * md
# Valuation Algorithm
if put is True:
    V = maximum(K - S, 0) # inner values for European put option
else:
    V = maximum(S - K, 0) # inner values for European call option
Qu = zeros ((M + 1, M + 1), 'f' )
Qu[:, :] = q # upwards martingale probabilities
Qd = 1 - Qu # downwards martingale probabilities
z = 0
for t in range(M - 1, -1, -1): # backwards iteration
    V[0:M - z, t] = (Qu[0:M - z, t] * V[0:M - z, t + 1]
        + Qd[0:M - z, t] * V[1:M - z + 1, t + 1]) * df
    z += 1
# Output
print "Value of the European option is %8.3f" % V[0, 0]
print "Number of time steps %8d" % M