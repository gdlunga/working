require(sde)

tau0 <- 0.6
k0 <- ceiling(1000*tau0)
set.seed(123)
X1 <- sde.sim(X0=1, N=2*k0, t0=0, T=tau0, model="CIR",
              theta=c(6,2,1))
X2 <- sde.sim(X0=X1[2*k0+1], N=2*(1000-k0), t0=tau0,
              T=1, model="CIR", theta=c(6,2,3))
Y <- ts(c(X1,X2[-1]), start=0, deltat=deltat(X1))
X <- window(Y,deltat=0.01)
DELTA <- deltat(X)
n <- length(X)
mu <- function(x) 6-2*x
sigma <- function(x) sqrt(x)
cp <- cpoint(X,mu,sigma)
cp
plot(X)
abline(v=tau0,lty=3)
abline(v=cp$tau0,col="red")
# nonparametric estimation
cpoint(X)


N=1000
xdis = rnorm(N, 0 ,1);
ydis = rnorm(N, 0 ,1);
xdis = cumsum(xdis);
ydis = cumsum(ydis);
plot(xdis, ydis, type="l", main ="Brownian Motion in Two Dimension", xlab="x displacement", ylab="y displacement")



wiener = function( n, tt ) {
  e = rnorm( n, 0, 1 )
  x = c(0,cumsum( e )) / sqrt(n)
  y = x[ 1+floor( n * tt ) ]
  return( list( x = x, y = y ) )
}

s=0.1
m=0.1

time_step  <- 100
nsim       <- 10
t          <- seq(0,1,1/time_step)
delta_t <- t[2]-t[1]
# volatilita' normalizzata ad un anno (si assumono 250 giorni lavorativi)
sigma   <- s * sqrt(250) * sqrt(delta_t)
# drift 
drift   <- (m + .5*sigma*sigma)*delta_t
S0      <- 1

# generiamo un path di 500 punti fra 0 e tmax
paths <- wiener(time_step, t )$y
S1    <- S0*exp(drift + sigma * paths)
plot( S1, type="l", xlab = "Time", ylab="",ylim = c(0,2))
for(i in 1:nsim){
  paths <- wiener(time_step, t )$y
  S     <- S0*exp(drift + sigma * paths)
  lines( S , col=sample(rainbow(100)))
}

p = qnorm(0.9)
y1=exp(drift+p*sigma*sqrt(t))
y2=exp(drift-p*sigma*sqrt(t))
lines(y1, lwd=2)
lines(y2, lwd=2)


