npoints<-550
size<-30

w = rnorm(npoints,0,1)
plot.ts(w)

v=filter(w,sides=1,filter=rep(1/size,size))
lines(v,col='yellow')

x=filter(w,filter=c(1,-.9),method='recursive')[-(1:50)]
plot.ts(x)


set.seed(154)
w=rnorm(200,0,1)
x=cumsum(w)
wd=w+.2
xd=cumsum(wd)
plot.ts(xd,ylim=c(-5,55),main="random walk",ylab='')
lines(x,col=4)
abline(h=0,col=4,lty=2)
abline(a=0,b=.2,lty=2)

# periodic component 

cs=2*cos(2*pi*1:550/50+.6*pi)
plot.ts(cs)
plot.ts(cs+w)
plot.ts(cs+3*w)
v=filter(cs+3*w,sides=1,filter=rep(1/size,size))
lines(v,col='red')
