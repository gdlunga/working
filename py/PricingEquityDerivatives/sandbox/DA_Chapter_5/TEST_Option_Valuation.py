__author__ = 'T004314'
#
from pylab import *
from scipy.integrate import quad
from Market_Models.BSM_Option_Valuation import BSM_Call, BSM_Put
##___________________________________________________________________________________________________________________
#
#
# General Parameters
#
St  = 100.0 # index level
K   = 100.0 # option strike
T   = 1.0 # maturity date
r   = 0.05 # risk -less short rate
vol = 0.2 # volatility
t   = 0.0 # valuation date
#
# Sample Values and Plots for Call
#
figure ()
points = 100
## C(K) Plot
subplot(221)
Kl = linspace(80 , 120 , points)
Vl = []
for _K in Kl:
    Vl.append(BSM_Call(St , _K, T, r, vol , t))
plot(Kl , Vl)
grid(True)
xlabel( 'K' )
ylabel( 'C(t=0)' )
## C(T) Plot
subplot(222)
Tl = linspace(0.0001 , 1, points)
Vl = []
for _T in Tl:
    Vl.append(BSM_Call(St , K, _T, r, vol , t))
plot(Tl , Vl)
grid(True)
xlabel( 'T' )
## C(r) Plot
subplot(223)
rl = linspace(0, 0.1, points)
Vl = []
for _r in rl:
    Vl.append(BSM_Call(St , K, T, _r, vol , t))
plot(rl , Vl)
grid(True)
xlabel( 'r' )
ylabel( 'C(t=0)' )
axis( 'tight' )
## C(vol) Plot
subplot(224)
vl = linspace(0.001 , 0.5, points)
Vl = []
for _vol in vl:
    Vl.append(BSM_Call(St , K, T, r, _vol , t))
plot(vl , Vl)
grid(True)
xlabel( 'vol' )
#
# Sample Values and Plots for Put
#
figure ()
points = 100
## P(K) Plot
subplot(221)
Kl = linspace(80 , 120 , points)
Vl = []
for _K in Kl:
    Vl.append(BSM_Put(St , _K, T, r, vol , t))
plot(Kl , Vl)
grid(True)
xlabel( 'K' )
ylabel( 'P(t=0)' )
## P(T) Plot
subplot(222)
Tl = linspace(0.0001 , 1, points)
Vl = []
for _T in Tl:
    Vl.append(BSM_Put(St , K, _T, r, vol , t))
plot(Tl , Vl)
grid(True)
xlabel( 'T' )
## P(r) Plot
subplot(223)
rl = linspace(0, 0.1, points)
Vl = []
for _r in rl:
    Vl.append(BSM_Put(St , K, T, _r, vol , t))
plot(rl , Vl)
grid(True)
xlabel( 'r' )
ylabel( 'P(t=0)' )
axis( 'tight' )
## P(vol) Plot
subplot(224)
vl = linspace(0.001 , 0.5, points)
Vl = []
for _vol in vl:
    Vl.append(BSM_Put(St , K, T, r, _vol , t))
plot(vl , Vl)
grid(True)
xlabel( 'vol' )

show()