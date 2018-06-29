__author__ = 'T004314'
#
from pylab import *
from scipy.integrate import quad
from Market_Models.BSM_Call_Greeks import BSM_Theta, BSM_Delta, BSM_Gamma
import mpl_toolkits.mplot3d.axes3d as p3
#___________________________________________________________________________________________________________________
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
#___________________________________________________________________________________________________________________
#
Tl = linspace(0.01 , 1, 25)
Kl = linspace(80 , 120 , 25)
V = zeros((len(Tl), len(Kl)), 'd' )
for j in range(len(Kl)):
    for i in range(len(Tl)):
        V[i, j] = BSM_Theta(St , Kl[j], Tl[i], r, vol , t)
#
# 3D Plotting
#
x, y = meshgrid(Kl, Tl)
fig = figure ()
plot = p3.Axes3D(fig)
plot.plot_wireframe(x, y, V)
plot.set_xlabel( 'K' )
plot.set_ylabel( 'T' )
plot.set_zlabel( 'theta(K,T)' )
#
#___________________________________________________________________________________________________________________
#
Tl = linspace(0.01 , 1, 25)
Kl = linspace(80 , 120 , 25)
V = zeros((len(Tl), len(Kl)), 'd' )
for j in range(len(Kl)):
    for i in range(len(Tl)):
        V[i, j] = BSM_Delta(St , Kl[j], Tl[i], r, vol , t)
#
# 3D Plotting
#
x, y = meshgrid(Kl, Tl)
fig = figure ()
plot = p3.Axes3D(fig)
plot.plot_wireframe(x, y, V)
plot.set_xlabel( 'K' )
plot.set_ylabel( 'T' )
plot.set_zlabel( 'delta(K,T)' )
#
#___________________________________________________________________________________________________________________
#
Tl = linspace(0.01 , 1, 25)
Kl = linspace(80 , 120 , 25)
V = zeros((len(Tl), len(Kl)), 'd' )
for j in range(len(Kl)):
    for i in range(len(Tl)):
        V[i, j] = BSM_Gamma(St , Kl[j], Tl[i], r, vol , t)
#
# 3D Plotting
#
x, y = meshgrid(Kl, Tl)
fig = figure ()
plot = p3.Axes3D(fig)
plot.plot_wireframe(x, y, V)
plot.set_xlabel( 'K' )
plot.set_ylabel( 'T' )
plot.set_zlabel( 'gamma(K,T)' )

show()