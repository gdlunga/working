#install.packages("stringr", dependencies=TRUE)
#install.packages("binhf", dependencies=TRUE)

require(stringr)
require(binhf)
#
#-----------------------------------------------------------------------------------------------------------
#
working_dir = getwd()
# import del file contenente i dati relativi all'indice S&P MIB
file_name = paste(working_dir, 'ts_sp_mib.csv', sep="/")
ts <- read.csv(file_name, sep=";")
ts$Date = as.Date(ts$Date)
attach(ts)

# calcolo rendimenti
shift_price    <- shift(Price,1)
shift_price[1] <- 0
yield <- log(shift_price/Price)
yield[1] <- 0

m <- mean(yield)
s <- sqrt(var(yield))

#dev.new()
x <- seq(-.03,.03,.001)
hist(yield,x ,ylim=c(0,80))
lines(density(yield), main="stima della densita'",col='red')

xn <- (x-m)/s
delta <- x[2] - x[1]
ntot  <- length(yield)

f <- 1/(s*sqrt(2*pi))
y <- f*exp(-.5*xn*xn) * delta * ntot

lines(x, y, col='blue')
#
#-----------------------------------------------------------------------------------------------------------
#
wiener = function( n, tt ) {
  e = rnorm( n, 0, 1 )
  x = c(0,cumsum( e )) / sqrt(n)
  y = x[ 1+floor( n * tt ) ]
  return( list( x = x, y = y ) )
}

t       <- seq(0,1,.01)
delta_t <- t[2]-t[1]
# volatilita' normalizzata ad un anno (si assumono 250 giorni lavorativi)
sigma   <- s * sqrt(250) * sqrt(delta_t)
# drift 
drift   <- (m + .5*sigma*sigma)*delta_t
# generiamo un path di 500 punti fra 0 e tmax
paths <- wiener(500, t )$y
S0    <- Price[1]
S1    <- S0*exp(drift + sigma * paths)

#plot(t,S1,type="n")
#lines(t,S1)
