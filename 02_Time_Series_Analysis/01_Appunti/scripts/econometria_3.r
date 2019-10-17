#
# some example of zoo package use described in vignette('zoo')
#
library('zoo')

set.seed(1071)


z1.index <- ISOdatetime(2019,rep(1:2,5),sample(28,10),0,0,0)
z1.data  <- rnorm(10)
z1       <- zoo(z1.data, z1.index)

z2.index <- as.POSIXct(paste(2004, rep(1:2, 5), sample(1:28, 10),sep="-"))                       
z2.data  <- sin(2*1:10/pi)
z2       <- zoo(z2.data, z2.index)

Z.index  <- as.Date(sample(12450:12500, 10))
Z.data   <- matrix(rnorm(30), ncol = 3)
colnames(Z.data) <- c("Aa", "Bb", "Cc")
Z        <- zoo(Z.data, Z.index)


test<-ISOdatetime(2019,rep(1:4,8),sample(28,10),0,0,0)
test
as.Date(as.yearmon(test))

zr1 <- zooreg(sin(1:9), start = 2000, frequency = 4)
as.ts(zr1[-c(2,5)])

plot(Z, type = "b", lty = 1:3, 
     pch = list(Aa = 1:5, Bb = 2, Cc = 4),
     col = list(Bb = 2, 4))
