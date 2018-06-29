#
# Analyzing Returns from Geometric Brownian Motion
# GBM_Returns.py
#
# (c) Dr. Yves J. Hilpisch
# Script for illustration purposes only.
#
from pylab import *
from pandas import *
from pandas.io.data import DataReader
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

# Read Data for DAX from 21.11.1990 to Today
DAX = DataReader( '^GDAXI' , data_source= 'yahoo' , start= '11/26/1990' , end= '02/01/2013' )
# NOTA. La funzione log seguente non e' math.log di python in quanto non agisce su
# sequenze di numeri. E' la funzione di pandas. Vedi il seguente argomento di discussione:
#
# http://stackoverflow.com/questions/23748842/understanding-math-errors-in-pandas-dataframes
#
# l'utilizzo della funzione math.log produce il seguente errore:
#
# cannot convert the series to 0 .format(str(converter)))
#
DAX[ 'RET' ] = log(DAX[ 'Adj Close' ] / DAX[ 'Adj Close' ]. shift(1))
DAX[ 'RET' ].ix[0] = 0.0
# daily log returns

# Realized Volatility
rvol = zeros(len(DAX), 'd' )
for t in range(len(DAX)):
    rvol[t] = std(DAX[ 'RET' ][0:t]) * sqrt(252)
DAX[ 'RVO' ] = rvol

# Return Sample Statistics and Normality Tests
print "RETURN SAMPLE STATISTICS"
print "---------------------------------------------"
print "Mean of Daily Log Returns %9.6f" % mean(DAX[ 'RET' ])
print "Std of Daily Log Returns %9.6f" % std(DAX[ 'RET' ])
print "Mean of Annua. Log Returns %9.6f" % (mean(DAX[ 'RET' ]) * 252)
print "Std of Annua. Log Returns %9.6f" % (std(DAX[ 'RET' ]) * sqrt(252))
print "---------------------------------------------"
print "Skew of Sample Log Returns %9.6f" % skew(DAX[ 'RET' ])
print "Skew Normal Test p-value %9.6f" % skewtest(DAX[ 'RET' ])[1]
print "---------------------------------------------"
print "Kurt of Sample Log Returns %9.6f" % kurtosis(DAX[ 'RET' ])
print "Kurt Normal Test p-value %9.6f" % kurtosistest(DAX[ 'RET' ])[1]
print "---------------------------------------------"
print "Normal Test p-value %9.6f" % normaltest(DAX[ 'RET' ])[1]
print "---------------------------------------------"
print "Realized Volatility %9.6f" % (sum(rvol[-1]))
print "Realized Variance %9.6f" % (sum(rvol[-1]) ** 2)

# Graphical Output

# Daily Quotes and log Returns
figure ()
subplot(211)
DAX[ 'Adj Close' ]. plot ()
ylabel( 'DAX Daily Quotes' )
grid(True)
axis( 'tight' )
subplot(212)
DAX[ 'RET' ]. plot ()
ylabel( 'DAX Daily Log Returns' )
grid(True)
axis( 'tight' )
# histogram of annualized daily log returns
figure ()
x = linspace(min(DAX[ 'RET' ][1:-1]), max(DAX[ 'RET' ][1:-1]), 100)
hist(array(DAX[ 'RET' ][1:-1]), bins=50 , normed=True)
y = dN(x, mean(DAX[ 'RET' ]), std(DAX[ 'RET' ]))
plot(x, y, linewidth=2)
xlabel( 'Return' )
ylabel( 'Frequency/Probability' )
grid(True)
# Histogram of Annualized Daily log Returns (left tail)
figure ()
x = linspace(min(DAX[ 'RET' ][1:-1]), max(DAX[ 'RET' ][1:-1]), 100)
hist(DAX[ 'RET' ][1:-1], 50 , normed=True)
y = dN(x, mean(DAX[ 'RET' ]), std(DAX[ 'RET' ]))
plot(x, y, 'r' , linewidth=3)
xlabel( 'Return' )
ylabel( 'Frequency/Probability' )
grid(True)
axis([-0.1, -0.03 , 0.0, 2.0])
# Realized Volatility
figure ()
DAX[ 'RVO' ]. plot ()
ylabel( 'Realized Volatility' )
grid(True)
# Mean Return , Volatility and Correlation (252 days moving = 1 year)
figure ()
subplot(311)
mr252 = rolling_mean(DAX[ 'RET' ], 252) * 252
mr252.plot ()
grid(True)
ylabel( 'Return (252d Mov)' )
x, y = REG(mr252 , 0)
plot(x, y, 'g' )
subplot(312)
vo252 = rolling_std(DAX[ 'RET' ], 252) * sqrt(252)
vo252.plot ()
grid(True)
ylabel( 'Vola (252d Mov)' )
x, y = REG(vo252 , 0)
plot(x, y, 'g' )
vx = axis ()
subplot(313)
co252 = rolling_corr(mr252 , vo252 , 252)
co252.plot ()
grid(True)
ylabel( 'Corr (252d Mov)' )
cx = axis ()
axis ([vx[0], vx[1], cx[2], cx[3]])
x, y = REG(co252 , 0)
plot(x, y, 'g' )


show()