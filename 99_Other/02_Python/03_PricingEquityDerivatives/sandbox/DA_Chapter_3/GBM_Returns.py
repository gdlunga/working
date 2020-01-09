#
# Analyzing Returns from Geometric Brownian Motion
# GBM_Returns.py
#
# (c) Dr. Yves J. Hilpisch
# Script for illustration purposes only.
#
from pylab import *
from pandas import *
from scipy.stats import *
#
# Helper Functions
#
def dN(x, mu , si):
    '''
    Probability density function of a normal random variable x.
    mu: expected value
    si: standard deviation
    '''
    z = (x - mu) / si
    return exp(-0.5 * z ** 2) / sqrt(2 * pi * si ** 2)

def REG(Ser , n):
    '''
    Regression function for time series data.
    Ser: time series
    n: degree of fitting polynomial
    '''
    x = range(len(Ser[notnull(Ser)]))
    p = polyfit(x, Ser[notnull(Ser)], n)
    y = polyval(p, x)
    d = Ser[notnull(Ser)].index
    return d, y

# Simulate a number of years of daily stock quotes
# Stock Parameters
S0  = 100.0 # initial index level
T   = 10.0  # time horizon
r   = 0.05  # risk -less short rate
vol = 0.2   # instantaneous volatility

# Simulation Parameters
seed(250000)
M  = int(261 * T) # time steps
I  = 1            # index level paths
dt = T / M        # time interval
df = exp(-r * dt) # discount factor

# Stock Price Paths
rand = standard_normal ((M + 1, I)) # random numbers
S = zeros_like(rand)                # stock matrix
S[0, :] = S0                        # initial values
for t in range(1, M + 1, 1):        # stock price paths
    S[t, :] = S[t - 1, :] * exp((r - vol ** 2 / 2)
        * dt + vol * rand[t, :] * sqrt(dt))

# Time Series Conversion
datesGBM = DatetimeIndex(start= 1/31/2003 , periods=M + 1, freq=datetools.bday)
GBM = DataFrame(S[:, 0], index=datesGBM , columns =[ 'QUO' ])
GBM[ 'RET' ] = log(GBM[ 'QUO' ] / GBM[ 'QUO' ]. shift(1))

# Realized Volatility
rvol = zeros(len(GBM), 'd' )
for t in range(len(GBM)):
    rvol[t] = std(GBM[ 'RET' ][0:t]) * sqrt(261)
GBM[ 'RVO' ] = rvol

# Return Sample Statistics and Normality Tests
print "RETURN SAMPLE STATISTICS"
print "---------------------------------------------"
print "Mean of Daily Log Returns %9.6f" % mean(GBM[ 'RET' ])
print "Std of Daily Log Returns %9.6f" % std(GBM[ 'RET' ])
print "Mean of Annua. Log Returns %9.6f" % (mean(GBM[ 'RET' ]) * 261)
print "Std of Annua. Log Returns %9.6f" % (std(GBM[ 'RET' ]) * sqrt(261))
print "---------------------------------------------"
print "Skew of Sample Log Returns %9.6f" % skew(GBM[ 'RET' ][1:])
print "Skew Normal Test p-value %9.6f" % skewtest(GBM[ 'RET' ][1:])[1]
print "---------------------------------------------"
print "Kurt of Sample Log Returns %9.6f" % kurtosis(GBM[ 'RET' ][1:])
print "Kurt Normal Test p-value %9.6f" % kurtosistest(GBM[ 'RET' ][1:])[1]
print "---------------------------------------------"
print "Normal Test p-value %9.6f" % normaltest(GBM[ 'RET' ][1:])[1]
print "---------------------------------------------"
print "Realized Volatility %9.6f" % (sum(rvol[-1]))
print "Realized Variance %9.6f" % (sum(rvol[-1]) ** 2)
#
# Graphical Output
#
# Daily Quotes and log Returns
figure ()
subplot(211)
GBM[ 'QUO' ]. plot ()
ylabel( 'GBM Daily Quotes' )
grid(True)
axis( 'tight' )
subplot(212)
GBM[ 'RET' ]. plot ()
ylabel( 'GBM Daily Log Returns' )
grid(True)
axis( 'tight' )

# Histogram of Annualized Daily log Returns
figure ()
x = linspace(min(GBM[ 'RET' ][1:-1]), max(GBM[ 'RET' ][1:-1]), 100)
hist(array(GBM[ 'RET' ][1:-1]), bins=50 , normed=True)
y = dN(x, mean(GBM[ 'RET' ]), std(GBM[ 'RET' ]))
plot(x, y, linewidth=2)
xlabel( 'Return' )
ylabel( 'Frequency/Probability' )
grid(True)

# Realized Volatility
figure ()
GBM[ 'RVO' ]. plot ()
ylabel( 'Realized Volatility' )
grid(True)

# Mean Return , Volatility and Correlation (261 days moving = 1 year)
figure ()
subplot(311)
mr261 = rolling_mean(GBM[ 'RET' ], 261) * 261
mr261.plot ()
grid(True)
ylabel( 'Return (261d Mov)' )
x, y = REG(mr261 , 0)
plot(x, y)
subplot(312)
vo261 = rolling_std(GBM[ 'RET' ], 261) * sqrt(261)
vo261.plot ()
grid(True)
ylabel( 'Vola (261d Mov)' )
x, y = REG(vo261 , 0)
plot(x, y)
vx = axis ()
subplot(313)
co261 = rolling_corr(mr261 , vo261 , 261)
co261.plot ()
grid(True)
ylabel( 'Corr (261d Mov)' )
cx = axis ()
axis ([vx[0], vx[1], cx[2], cx[3]])
x, y = REG(co261 , 0)
plot(x, y)

show()