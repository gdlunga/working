#
# BSM Model -- European Call Option Greeks
# BSM_Call_Greeks.py
#
# (c) Dr. Yves J. Hilpisch
# Script for illustration purposes only.
#
from pylab import *

from BSM_Option_Valuation import *
#
# Functions for Greeks
#
#___________________________________________________________________________________________________________________
#
def BSM_Delta(St, K, T, r, vol , t):
    '''
    Black -Scholes -Merton DELTA of European Call Option.
    :param St: stock/index level at time t
    :param K: strike price
    :param T: date of maturity/time -to -maturity if t = 0
    :param r: constant risk -less short rate
    :param vol: volatility
    :param t: valuation date , t = 0 if today
    '''
    d1 = d1f(St , K, T, r, vol , t)
    return N(d1)
#___________________________________________________________________________________________________________________
#
def BSM_Gamma(St, K, T, r, vol , t):
    '''
    Black -Scholes -Merton GAMMA of European Call Option.
    :param St: stock/index level at time t
    :param K: strike price
    :param T: date of maturity/time -to -maturity if t = 0
    :param r: constant risk -less short rate
    :param vol: volatility
    :param t: valuation date , t = 0 if today
    '''
    d1 = d1f(St , K, T, r, vol , t)
    return dN(d1) / (St * vol * sqrt(T - t))
#___________________________________________________________________________________________________________________
#
def BSM_Theta(St, K, T, r, vol , t):
    '''
    Black -Scholes -Merton THETA of European Call Option.
    :param St: stock/index level at time t
    :param K: strike price
    :param T: date of maturity/time -to -maturity if t = 0
    :param r: constant risk -less short rate
    :param vol: volatility
    :param t: valuation date , t = 0 if today
    '''
    d1 = d1f(St , K, T, r, vol , t)
    d2 = d1 - vol * sqrt(T - t)
    return -(St * dN(d1) * vol / (2 * sqrt(T - t))
        + r * K * exp(-r * (T - t)) * N(d2))
#___________________________________________________________________________________________________________________
#
def BSM_Rho(St , K, T, r, vol , t):
    '''
    Black -Scholes -Merton RHO of European Call Option.
    :param St: stock/index level at time t
    :param K: strike price
    :param T: date of maturity/time -to -maturity if t = 0
    :param r: constant risk -less short rate
    :param vol: volatility
    :param t: valuation date , t = 0 if today
    '''
    d1 = d1f(St , K, T, r, vol , t)
    d2 = d1 - vol * sqrt(T - t)
    return K * (T - t) * exp(-r * (T - t)) * N(d2)
#___________________________________________________________________________________________________________________
#
def BSM_Vega(St, K, T, r, vol , t):
    '''
    Black -Scholes -Merton VEGA of European Call/Put Option.
    :param St: stock/index level at time t
    :param K: strike price
    :param T: date of maturity/time -to -maturity if t = 0
    :param r: constant risk -less short rate
    :param vol: volatility
    :param t: valuation date , t = 0 if today
    '''
    d1 = d1f(St , K, T, r, vol , t)
    return St * dN(d1) * sqrt(T - t)