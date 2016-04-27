__author__ = 'T004314'
#
from pylab import *
from scipy.integrate import quad
#
# Helper Functions
#
def dN(x):
    '''
    Probability density function of standard normal random variable x.
    '''
    return exp(-0.5 * x ** 2) / sqrt(2 * pi)
#___________________________________________________________________________________________________________________
#
def N(d):
    '''
    Cumulative density function of standard normal random variable x.
    '''
    return quad(lambda x: dN(x), -20, d, limit=50)[0]
#___________________________________________________________________________________________________________________
#
def d1f(St, K, T, r, vol , t):
    '''
    Black -Scholes -Merton d1 function.
    Parameters see e.g. BSM_Call function.
    '''
    return (log(St / K) + (r + (0.5 * vol ** 2))* (T - t)) / (vol * sqrt(T - t))
#
# Valuation Functions
#
def BSM_Call(St, K, T, r, vol , t):
    '''
    Black -Scholes -Merton European Call Option Value.
    St: stock/index level at time t
    K: strike price
    T: date of maturity/time -to -maturity if t = 0
    r: constant risk -less short rate
    vol: volatility
    t: valuation date
    '''
    d1 = d1f(St , K, T, r, vol , t)
    d2 = d1 - vol * sqrt(T - t)
    return St * N(d1) - exp(-r * (T - t)) * K * N(d2)
#___________________________________________________________________________________________________________________
#
def BSM_Put(St , K, T, r, vol , t):
    '''
    Black -Scholes -Merton European Put Option Value.
    St: stock/index level at time t
    K: strike price
    T: date of maturity/time -to -maturity if t = 0
    r: constant risk -less short rate
    vol: volatility
    t: valuation date
    '''
    return BSM_Call(St , K, T, r, vol , t) - St + exp(-r * (T - t)) * K
