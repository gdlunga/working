
Dirname <- "/working/R"
Dirs <- list.dirs(path=file.path("~"),recursive=T)
dir_wd <- names(unlist(sapply(Dirs,grep,pattern=Dirname))[1])
dir_wd <- paste(dir_wd,'appunti/dati',sep='/')
setwd(dir_wd)
cat("Current working folder is ' : ", getwd())

require(zoo)

# import del file contenente i dati relativi all'indice S&P MIB
file_name = paste(getwd(),'hist_euribor.csv',sep='/')

euribor <- read.csv(file_name, sep=';')
euribor$Date = as.Date(euribor$Date)

# serie giornaliere
euribor1M = zoo(x=euribor$X1.Month, order.by=euribor$Date) 
euribor6M = zoo(x=euribor$X6.Month, order.by=euribor$Date) 
euribor1Y = zoo(x=euribor$X12.Month, order.by=euribor$Date) 


# creo un nuovo indice aggregando per mese-anno le date presenti originariamente
m_index      <- as.Date(as.yearmon(time(euribor1Y)))
# creo una nuova serie aggregando i dati di euribor1M sul nuovo indice temporale
# (base mensile) e calcolando la media
m_euribor1M  <- aggregate(euribor1M, m_index, mean)
m_euribor6M  <- aggregate(euribor6M, m_index, mean)
m_euribor1Y  <- aggregate(euribor1Y, m_index, mean)

plot (m_euribor1M, typ='l')
lines(m_euribor6M, col='red')
lines(m_euribor1Y, col='blue')

file_name = paste(getwd(), 'tassi_medi_cc_bankit.csv', sep="/")
tassi <- read.csv(file_name, sep=';')

plot.ts(tassi$VALORE)

file_name = paste(getwd(), 'confronto.csv', sep="/")
tassi <- read.csv(file_name, sep=';')

norm_euribor1m <- tassi$EURIBOR1M-mean(tassi$EURIBOR1M)
norm_bank_rate <- tassi$TASSO_BANCA-mean(tassi$TASSO_BANCA)

plot(norm_euribor1m, type = 'l',ylim=c(-3,3))
lines(norm_bank_rate,col='red')

cor(norm_euribor1m, norm_bank_rate)
ccf(norm_euribor1m, norm_bank_rate,lag.max=5, plot=FALSE)

npoints = 500

w=rnorm(npoints)
v=filter(w,sides=2,filter=rep(1/3,3))

par(mfrow=c(2,1))
plot.ts(w, main='white noise')
plot.ts(v, main='moving average')

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

#v = v[3: length(v)-1]
acf(v, lag.max=10, plot=FALSE)
ccf(v,v, lag.max=10)

w=rnorm(550,0,1)
x= filter(w, filter=c(1,-.9),method="recursive")[-(1:50)]
plot.ts(x, main="autoregression")

npoints = 250
drift   = .25

w = rnorm(npoints)
x = cumsum(w)

wd = w + drift
xd = cumsum(wd)

plot.ts(xd,ylim=c(-5,55),main="random walk",ylab='')
lines(x,col=4)
abline(h=0, col=4,  lty=2)
abline(a=0, b=drift,lty=2)

cs     = 2*cos(2*pi*1:500/50+.6*pi)
wd     = 3*w
x      = seq(1:500)
xx     = .01 * x

signal = cs + wd + xx
v=filter(signal,sides=1,filter=rep(1/3,3))

plot.ts(signal)
lines(v,col='red')
lines(xx, col = 'blue')

reg=lm(signal~x)
abline(reg,col="yellow")

lines(cs + xx,col='green',lwd=2)


