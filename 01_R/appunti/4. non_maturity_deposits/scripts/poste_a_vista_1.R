library(KFAS)
library(tseries)
library(timeSeries)
#library(zoo)
#library(quantmod)

#file_path = '/Users/giovanni/git_repository/working/R/esempi'
file_path = 'C:/Users/T004314/Documents/GitHub/working/R/esempi'
file_name = paste(file_path, 'poste_vista_1.csv', sep="/")

ts <- read.csv(file_name, sep=';')



#structTInvariant <- StructTS(ts$pf.ts, type ="level", init=NULL, fixed=NULL,optim.control = NULL)

plot.ts(ts$pf.ts)


require(dlm)

s <- dlmSmooth(ts$pf.ts, dlmModPoly(1, dV = 15100, dW = 1470))
lines(dropFirst(s$s), col = "red")



#lines(tsSmooth(structTInvariant), lty = 2, col = 4)   # fixed-interval smoothing
#lines(fitted(structTInvariant), lty = 2)


library(TTR)

emaSmooth = function( x )
{
  ema = EMA(x)
  val = ema[ length(ema) ]
  return(val)
}
windowWidth = 30
emaSmooth = rollapply( data = ts$pf.ts, width=windowWidth, FUN=emaSmooth)
lines(emaSmooth, lty=2,col=4)



# random walk with drift -----------------------------------------------
drift = .2
set.seed(154)
w=rnorm(200,0,1)
x=cumsum(w)
wd=w+drift
xd=cumsum(wd)

structTInvariant <- StructTS(xd, type ="level", init=NULL, fixed=NULL,optim.control = NULL)

plot.ts(xd,ylim=c(-5,55),main="random walk",ylab='')
#lines(tsSmooth(structTInvariant), lty = 2, col = 4)   # fixed-interval smoothing
s <- dlmSmooth(xd, dlmModPoly(1, dV = 15100, dW = 1470))
lines(dropFirst(s$s), col = "red")

lines(x,col=4)
abline(h=0,col=4,lty=2)
abline(a=0,b=drift,lty=2)

