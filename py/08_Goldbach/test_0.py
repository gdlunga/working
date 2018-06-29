'''
Created on 22/lug/2015

@author: giovanni
'''
from scipy.fftpack import fft
import numpy             as np
import matplotlib.pyplot as plt
import bisect

def crivello(ma): 
    c=range(3, ma+1, 2) 
    i=0 
    while c[i]<(ma+1)**0.5: 
        j=i+1 
        while j<len(c): 
            if c[j] % c[i] == 0: 
                del c[j] 
            j+=1 
        i+=1 
    return [2]+c

start             = 2
nprimes_generated = 100000
nprimes_analyzed  = 10000

primes = [1] + crivello(nprimes_generated)
radius = []
for i in range(start, nprimes_analyzed):
    index = bisect.bisect(primes, i)
    k   = 0
    inf = 0
    while inf not in primes:
        sup   = primes[index + k]
        r     = sup - i
        inf   = i - r
        k     = k + 1
        
    check = True
    if inf not in primes: check = False
    radius.append(r)
    
    #print i, sup - inf, check

#yf = fft(radius)
#yf = np.abs(yf) ** 2
#xf = range(start,nprimes_analyzed)
#
#plt.axis([0,nprimes_analyzed,0,1e10])
#plt.plot(xf, yf, 'k')
#plt.grid()
#plt.show()
    
plt.plot(range(start,nprimes_analyzed),radius,'k')
plt.show()    