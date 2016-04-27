#
# Analyzing Euribor Rates
# EURIBOR_Analysis.py
#
# (c) Dr. Yves J. Hilpisch
# Script for illustration purposes only.
#
from pylab import *
from pandas import *
from scipy.stats import *
#
# Helper Function
#
def dN(x, mu , si):
    '''
    Probability density function of a normal random variable x.
    :param mu: expected value
    :param si: standard deviation
    '''
    z = (x - mu) / si
    return exp(-0.5 * z ** 2) / sqrt(2 * pi * si ** 2)

# EURIBOR Open Workbook , Read All Euribor Data
xls = ExcelFile( 'D:/data/Euribor_1999_2013.xls' )
EBO = xls.parse( 'EURIBOR_1999_2013' , index_col=0)

# Log Changes of 1 Week EURIBOR
EBO[ '1wr' ] = log(EBO[ '1w' ] / EBO[ '1w' ]. shift(1))
# Return Sample Statistics and Normality Tests
print "RETURN SAMPLE STATISTICS"
print "---------------------------------------------"
print "Mean of EURIBOR %9.6f" % mean(EBO[ '1w' ])
print "Std of EURIBOR %9.6f" % std(EBO[ '1w' ])
print "---------------------------------------------"
print "Skew of EURIBOR %9.6f" % skew(EBO[ '1w' ])
print "Skew Normal Test p-value %9.6f" % skewtest(EBO[ '1w' ])[1]
print "---------------------------------------------"
print "Kurt of EURIBOR %9.6f" % kurtosis(EBO[ '1w' ])
print "Kurt Normal Test p-value %9.6f" % kurtosistest(EBO[ '1w' ])[1]
print "---------------------------------------------"
print "Normal Test p-value %9.6f" % normaltest(EBO[ '1w' ])[1]
print "---------------------------------------------"
#
# Graphical Output
# Daily 1w EURIBOR with log Changes
#
figure ()
subplot(211)
EBO[ '1w' ]. plot ()
ylabel( 'EURIBOR Daily Quotes' )
grid(True)
axis( 'tight' )
subplot(212)
EBO[ '1wr' ]. plot ()
ylabel( 'EURIBOR Log Changes' )
grid(True)
axis( 'tight' )
# Histogram of Log Changes
figure ()
x = linspace(min(EBO[ '1wr' ][1:-1]), max(EBO[ '1wr' ][1:-1]), 100)
hist(EBO[ '1wr' ][1:-1], 100 , normed=True)
y = dN(x, mean(EBO[ '1wr' ]), std(EBO[ '1wr' ]))
plot(x, y, 'r' , linewidth=3)
xlabel( 'Log Change' )
ylabel( 'Frequency/Probability' )
grid(True)
# Histogram of Log Changes (Right Tail)
figure ()
x = linspace(min(EBO[ '1wr' ][1:-1]), max(EBO[ '1wr' ][1:-1]), 100)
hist(EBO[ '1wr' ][1:-1], 100 , normed=True)
y = dN(x, mean(EBO[ '1wr' ]), std(EBO[ '1wr' ]))
plot(x, y, 'r' , linewidth=3)
xlabel( 'Log Change' )
ylabel( 'Frequency/Probability' )
grid(True)
axis ([0.05 , 0.35 , 0.0, 0.6])
# Daily Quotes and Log Returns (Term Structure)
figure ()
EBO[ '1w' ]. plot(style= 'r-' )
EBO[ '1m' ]. plot(style= 'b--' )
EBO[ '6m' ]. plot(style= 'g-.' )
EBO[ '12m' ]. plot(style= 'm:' )
ylabel( 'EURIBOR Daily Quotes' )
grid(True)
axis( 'tight' )

show()
