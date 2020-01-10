n <- seq(10,10000,length=40)

par(mfrow=c(2,2))
for(k in 1:4){
  mn <-numeric(40)
  for(i in 1:40){
    mn[i] <- mean(rnorm(n, mean=10,sd=2))
  }
  plot(n ,mn, type='l', ylim=c(8,12), xaxt='n')
  abline(h=10, lty=2)
  axis(1,c(100,5000,10000))
}
par(mfrow=c(1,1))

