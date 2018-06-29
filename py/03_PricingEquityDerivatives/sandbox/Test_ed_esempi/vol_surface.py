from pylab import *
from pandas import *
from scipy.stats import *

import mpl_toolkits.mplot3d.axes3d as p3
from Market_Models.BSM_Imp_Vol import *
#
#
#xls = ExcelFile( 'D:/temp/Euribor6M_Vol_Cap.xls' )
#vol = xls.parse( 'Sheet1' , index_col=0)

xls = ExcelFile( 'D:/temp/report-dynamictable.xls' )
vol = xls.parse( 'report-dynamictable' , index_col=0)

T = array(vol.axes[1])
K = array(vol.axes[0])
T_Scale = array([round(t, 2) for t in T])

imv = []
#for k in K:
#    row = array(vol.loc[k].tolist())
#    imv.append(row)
for t in T:
    row = array(vol[t].tolist())
    imv.append(row)
imv = array(imv)
#
# Graphical Output
#
## 2d Output
figure ()
for i in range(10):
    plot(K, imv[i] )
grid(True)
xlabel( 'Strike' )
ylabel( 'Implied Volatility' )
## 3d Output
k, t = meshgrid(K, T)
fig = figure ()
plot = p3.Axes3D(fig)
plot.plot_wireframe(k, t, imv)
plot.set_xlabel( K )
plot.set_ylabel( T_Scale )
plot.set_zlabel( 'Implied Volatility' )


show()