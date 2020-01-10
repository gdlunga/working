
options(repr.plot.width=10, repr.plot.height=4)

# Example 1.1 Financial Data
require(astsa)
plot(jj, type="o",ylab="Quarterly Earnings per Share")

# Example 1.2 Global Warming
plot(gtemp,type="o",ylab="Global Temperature Deviations")

# Example 1.3 Speech Data
plot(speech)

# Example 1.4 New York Stock Exchange market returns
plot(nyse, ylab="NYSE Returns")

options(repr.plot.width=10, repr.plot.height=8)

# Example 1.5 El Nino and Fish Population
par(mfrow=c(2,1)) #set up the graphics
plot(soi, ylab="", xlab="",main="Souther Oscillation Index" )
plot(rec, ylab="", xlab="",main="Recruitment" )

# Example 1.6 fMRI  Imaging
par(mfrow=c(2,1), mar = c(3,2,1,0)+.5, mgp=c(1.6,.6,0))
ts.plot(fmri1[,2:5],col=1:4, ylab="BOLD",xlab="",main="Cortex")
ts.plot(fmri1[,6:9],col=1:4, ylab="BOLD",xlab="",main="Thalamus & Cerebellum")
mtext("Time (1pt = 2 sec)",side=1,line=2)

# Example 1.7
par(mfrow=c(2,1))
plot(EQ5, main="Earthquake")
plot(EXP6, main="Explosion")

options(repr.plot.width=10, repr.plot.height=8)

npoints = 500
size    = 25

w=rnorm(npoints)
v=filter(w,sides=2,filter=rep(1/size,size))

par(mfrow=c(3,1))
plot.ts(w, main='white noise')
plot.ts(v, main='moving average')
plot.ts(w, main='white noise with moving average')
lines(v, col='red', lwd=2)
# Same computation of the previous example with an user defined function 
ma <- function(x,n=3){filter(x,rep(1/n,n), sides=2)}
w=rnorm(1000)
v=ma(w)

options(repr.plot.width=10, repr.plot.height=5)

w=rnorm(550,0,1)
x= filter(w, filter=c(1,-.9),method="recursive")[-(1:50)]
plot.ts(x, main="autoregression")

w=rnorm(200,0,1)
x=cumsum(w)
wd=w+.2
xd=cumsum(wd)
plot.ts(xd,ylim=c(-5,55),main="random walk",ylab='')
lines(x,col=4)
abline(h=0,col=4,lty=2)
abline(a=0,b=.2,lty=2)

# periodic signal
cs     = 2*cos(2*pi*1:500/50+.6*pi)
# white noise
w      = rnorm(500,0,1)
wd     = 5*w

x      = seq(1:500)
drift  = .01*x

signal = cs + wd + drift
plot.ts(signal)

v=filter(signal,sides=1,filter=rep(1/3,3))
lines(v,col='red')
lines(drift, col = 'blue')

par(mfrow=c(3,1), mar=c(3,2,2,1),cex.main=1.5)
plot.ts(cs,main=expression(2*cos(2*pi*t/50+.6*pi)))
plot.ts(cs+w, main=expression(2*cos(2*pi*t/50+.6*pi)  + N(0,1)))
plot.ts(cs+5*w,main=expression(2*cos(2*pi*t/50+.6*pi) + N(0,25)))

shift<-function(x,shift_by){
  stopifnot(is.numeric(shift_by))
  stopifnot(is.numeric(x))
  
  if (length(shift_by)>1)
    return(sapply(shift_by,shift, x=x))
  
  out<-NULL
  abs_shift_by=abs(shift_by)
  if (shift_by > 0 )
    out<-c(tail(x,-abs_shift_by),rep(NA,abs_shift_by))
  else if (shift_by < 0 )
    out<-c(rep(NA,abs_shift_by), head(x,-abs_shift_by))
  else
    out<-x
  out
}

# white noise
w      = rnorm(10000,0,1)
v  = filter(w,sides=2,filter=rep(1/3,3))
n  = length(w)
ww = shift(w, 1)[1:n-1]
w  = w[1:n-1] 

cat('covariance of w(t,t+1) = ',  cov(w,ww), "\n")

v = v[3:length(v)-1]

#cat('variance of v        = ',  var(w), "\n")
cat('covariance of v(t,t) = ',  cov(v,v), "\n")
cat('3*sigma^2 / 9        = ',  3*var(w)/9, "\n")

n  = length(v)
vv = shift(v,1)
vv = vv[1:n-1]
v  = v[1:n-1]

cat('covariance of v(t,t+1) = ',  cov(v,vv), "\n")
cat('2*sigma^2 / 9          = ',  2*var(w)/9, "\n")

n  = length(v)
vv = shift(vv,1)
vv = vv[1:n-1]
v  = v[1:n-1]

cat('covariance of v(t,t+2) = ',  cov(v,vv), "\n")
cat('1*sigma^2 / 9          = ',  1*var(w)/9, "\n")

n  = length(v)
vv = shift(vv,1)
vv = vv[1:n-1]
v  = v[1:n-1]

cat('covariance of v(t,t+3) = ',  cov(v,vv), "\n")

v  = filter(w,sides=2,filter=rep(1/3,3))
acf(v[3:length(v)-1], lag.max=10, main="")

# w(t)
w0 = rnorm(1000000)
# w(t-1)
w1 = shift(w0, -1)

x  = w0 + w1
y  = w0 - w1

x  = x[!is.na(x)]
y  = y[!is.na(y)]

ccf(x,y,lag.max = 2,main="Cross Correlation of x, y")

# gamma_xy(0) = 0
cat('covariance of gamma_xy(0) = ',  cov(x,y), " (th. value = 0)\n")

# gamma_xy(1) = 1
x1  = shift(x,1)
x1  = x1[!is.na(x1)]
y   = y[1:length(x1)]
cat('covariance of gamma_xy(1) = ',  cov(x1,y), " (th. value = 1)\n")

# gamma_xy(2) = 0
x2  = shift(x,2)
x2  = x2[!is.na(x2)]
y   = y[1:length(x2)]
cat('covariance of gamma_xy(2) = ',  cov(x2,y), " (th. value = 0)\n")


set.seed(90210)
x = rnorm(100)
y = lag(x, -5) + rnorm(100)
ccf(x,y, ylab="CCovF",type="covariance")

set.seed(1492)
num = 120
t   = 1:num
X   = ts(2*cos(2*pi*t/12)     + rnorm(num), freq =12)
Y   = ts(2*cos(2*pi*(t+5)/12) + rnorm(num), freq =12)
Yw = resid(lm(Y ~ cos(2*pi*t/12) + sin(2*pi*t/12), na.action=NULL))
par(mfrow=c(3,2), mgp=c(1.6,.6,0), mar=c(3,3,1,1) )
plot(X)
plot(Y)
 lines(Yw, col='red')
# auto-correlation
acf(X,48,ylab='ACF(X)')
acf(Y,48,ylab='ACF(Y)')
# cross-correlation
ccf(X,Y, 24,ylab='CCF(X,Y)')
ccf(X,Yw,24,ylab='CCF(X,Yw)',ylim=c(-.6,.6))

# Example 1.7
plot(EQ5, )
lines(EXP6, col='red')

w = rnorm(100)
st = c(rep(0,100), 10*exp(-(1:100)/20)*cos(2*pi*1:100/4))
plot.ts(st+.2*w)


w = rnorm(550,0,1)
x = filter(w, filter=c(1,-.9),method="recursive")[-(1:50)]
v = filter(x,rep(1/4,4), sides=1)
plot.ts(x, main="autoregression")
lines(v, col='red',lty=2)

w = rnorm(100,0,1)
x = cos(2*pi*1:100/4) + w
v = filter(x,rep(1/4,4), sides=1)
plot.ts(x, main="autoregression")
lines(v, col='red',lty=2)


