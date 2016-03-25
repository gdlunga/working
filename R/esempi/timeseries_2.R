npoints<-550
size<-30
# white noise ----------------------------------------------------------
w = rnorm(npoints,0,1)
plot.ts(w)
# moving average of white noise ----------------------------------------
v=filter(w,sides=1,filter=rep(1/size,size))
lines(v,col='yellow')
# autoregressive model ------------------------------------------------- 
x=filter(w,filter=c(1,-.9),method='recursive')[-(1:50)]
plot.ts(x)
# random walk with drift -----------------------------------------------
drift = .2
set.seed(154)
w=rnorm(200,0,1)
x=cumsum(w)
wd=w+drift
xd=cumsum(wd)
plot.ts(xd,ylim=c(-5,55),main="random walk",ylab='')
lines(x,col=4)
abline(h=0,col=4,lty=2)
abline(a=0,b=drift,lty=2)

# periodic component ----------------------------------------------------
cs     = 2*cos(2*pi*1:550/50+.6*pi)
wd     = 3*w
x      = seq(1:550)
xx     = .01*x

signal = cs + wd + xx

plot.ts(signal)
v=filter(signal,sides=1,filter=rep(1/size,size))
lines(v,col='red')
lines(xx, col = 'blue')


reg=lm(signal~x)
abline(reg,col="yellow")

y = residuals(reg)
plot.ts(y)
acf(y,lag=200,lwd=1)


set.seed(90210)
x=rnorm(100)
y=lag(x,5)+rnorm(100)
ccf(x,y,ylab='CCovF',type='covariance')


#set.seed(101010)
x1=2*rbinom(11,1,.5)-1
x2=2*rbinom(10001,1,.5)-1
y1 = 5 +filter(x1, sides=1, filter=c(1,-.7))[-1]
y2 = 5 +filter(x2, sides=1, filter=c(1,-.7))[-1]
#plot.ts(y1, type='s')
#plot.ts(y2, type='s')
acf(y1, lag.max=4, plot=FALSE)
acf(y2, lag.max=4, plot=FALSE)

dev.new()
persp(1:64, 1:36, soiltemp, phi=30, theta=30,scale=FALSE,expand=4,ticktype='detailed',xlab='rows',ylab='average temperature')


s=seq(50,100)
s
y = c(rep(0,50), s-50)
y
plot.ts(y)
