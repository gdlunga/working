
options(warn=-1)
require(binhf)

# individuazione cartella di lavoro
Dirname <- "/working/R"
Dirs <- list.dirs(path=file.path("~"),recursive=T)
dir_wd <- names(unlist(sapply(Dirs,grep,pattern=Dirname))[1])
dir_wd <- paste(dir_wd,'esempi',sep='/')
setwd(dir_wd)
cat("La cartella di lavoro e' : ", getwd())

# import del file contenente i dati relativi all'indice S&P MIB
file_name = paste(getwd(), 'ts_sp_mib.csv', sep="/")
ts <- read.csv(file_name, sep=';')
ts$Date = as.Date(ts$Date)

attach(ts)

# calcolo rendimenti
shift_price    <- shift(Price,1)
shift_price[1] <- 0
yield <- log(shift_price/Price)
yield[1] <- 0

# bin vector
x <- seq(-.03,.03,.001)

# calcolo media e standard deviation
m <- mean(yield)
s <- sqrt(var(yield))

# calcolo il fattore di normalizzazione dell'area
delta <- x[2] - x[1]
ntot  <- length(yield)
A     <- delta * ntot

# normalizzazione x
xn <- (x-m)/s

f <- 1/(s*sqrt(2*pi))
y <- f * exp(-.5*xn*xn) * A

hist(yield,x ,ylim=c(0,45))
lines(x, y, col='red',lwd=2)

xseq<-seq(-4,4,.01)
y<-2*xseq + rnorm(length(xseq),0,5.5)

hist(y, prob=TRUE, ylim=c(0,.06), breaks=20)
curve(dnorm(x, mean(y), sd(y)), add=TRUE, col="darkblue", lwd=2)

# the following function simulates a trajectory of Brownian motion at time instants tt

wiener = function( n, tt ) {
  e = rnorm( n, 0, 1 )
  x = c(0,cumsum( e )) / sqrt(n)
  y = x[ 1+floor( n * tt ) ]
  return( list( x = x, y = y ) )
}

time_step  <- 1000
nsim       <- 100
t          <- seq(0,1,1/time_step)
delta_t <- t[2]-t[1]
# volatilita' normalizzata ad un anno (si assumono 250 giorni lavorativi)
sigma   <- s * sqrt(250) * sqrt(delta_t)
# drift 
drift   <- (m + .5*sigma*sigma)*delta_t
# S0 è inizializzato al valore corrente del prezzo (si assume che il vettore sia ordinato per date crescenti)
S0      <- Price[length(Price)]

# generiamo un path di 500 punti fra 0 e tmax
paths <- wiener(time_step, t )$y
S1    <- S0*exp(drift + sigma * paths)

lower = 0.99*min(S1)
upper = 1.01*max(S1)

plot( S1, type="l",ylim = c(lower,upper), xlab = "Time", ylab="" )

for(i in 1:nsim){
    paths <- wiener(time_step, t )$y
    S     <- S0*exp(drift + sigma * paths)
    lines( S , col=sample(rainbow(100)))
}

# 90-esimo percentile
p <- qnorm(0.9)
y1=S0*exp(drift+p*sigma*sqrt(t))
y2=S0*exp(drift-p*sigma*sqrt(t))
lines(y1, lwd=2,col='blue')
lines(y2, lwd=2,col='blue')

# 99-esimo percentile
p <- qnorm(0.99)
y1=S0*exp(drift+p*sigma*sqrt(t))
y2=S0*exp(drift-p*sigma*sqrt(t))
lines(y1, lwd=2,col='red')
lines(y2, lwd=2,col='red')

# 99.99-esimo percentile
p <- qnorm(0.9999)
y1=S0*exp(drift+p*sigma*sqrt(t))
y2=S0*exp(drift-p*sigma*sqrt(t))
lines(y1, lwd=2,col='green')
lines(y2, lwd=2,col='green')



