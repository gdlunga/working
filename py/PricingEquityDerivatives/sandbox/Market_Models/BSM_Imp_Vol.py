#
# Valuation of European Call Options in BSM Model
# and Numerical Derivation of Implied Volatility
# BSM_Imp_Vol.py
#
# (c) Dr. Yves J. Hilpisch
# Script for illustration purposes only.
#
from math import *
from numpy import *
from scipy import stats
#
# Valuation and Implied Volatility
#
def BSM_Call_Value(S0, K, T, r, vol):
    '''
    Black -Scholes -Merton European Call Option Value.
    S0: stock/index level at time 0 (today)
    K: strike price
    T: time -to -maturity
    r: constant risk -less short rate
    vol: volatility
    '''
    d1 = (log(float(S0) / K) + (r + 0.5 * vol ** 2) * T) / (vol * sqrt(T))
    d2 = (log(float(S0) / K) + (r - 0.5 * vol ** 2) * T) / (vol * sqrt(T))
    BS_C = (S0 * stats.norm.cdf(d1 , 0.0, 1.0)
    - K * exp(-r * T) * stats.norm.cdf(d2, 0.0, 1.0))
    return BS_C
#___________________________________________________________________________________________________________________
#
def BSM_Call_ImpVol(S0, K, T, r, C0, vol_hist , it=100 , i=1):
    '''
    Black -Scholes -Merton Implied Volatility for European Call Options.
    :param S0: stock/index level at time 0 (today)
    :param K: strike price
    :param T: time -to -maturity
    :param r: constant risk -less short rate
    :param vol_hist: some (historically) estimated volatility level
    :param it: number of iterations
    :param i: iteration counter
    :return:
    '''
    if i > it:
        return vol_hist
    else:
        new = (vol_hist - (BSM_Call_Value (S0 , K, T, r, vol_hist)- C0) / BSM_Vega(S0, K, T, r, vol_hist))
    return BSM_Call_ImpVol(S0 , K, T, r, C0 , new , it , i + 1)
#___________________________________________________________________________________________________________________
#
def BSM_Vega(S0, K, T, r, vol):
    '''
    :param Black -Scholes -Merton Vega for European Call Options.
    :param S0: stock/index level at time 0 (today)
    :param K: strike price
    :param T: time -to -maturity
    :param r: constant risk -less short rate
    :param vol: volatility
    '''
    d1 = (log(float(S0) / K) + (r + (0.5 * vol ** 2)) * T) / (vol * sqrt(T))
    return S0 * stats.norm.cdf(d1 , 0.0, 1.0) * sqrt(T)