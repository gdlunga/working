require(sde)
## Parameters for Merton model
V0 <- 1; muV <- 0.03; sigmaV <- 0.25
r <- 0.02; B <- 0.85; T <- 1
N <- 364
## Simulated asset value trajectories for Merton model
npaths <- 10000
paths <- matrix(NA,nrow=N+1,ncol=npaths)
for (i in 1:npaths)
{paths[,i] <- GBM(x=V0,r=muV,sigma=sigmaV,T=T,N=N)}

lower = 0.99*min(paths)
upper = 1.01*max(paths)
plot( paths[,1], type="l", ylim = c(lower,upper), xlab = "Time", ylab="" )
for (i in 2:npaths)
  lines(paths[,i], col=sample(rainbow(10)))

hist(paths[364,], breaks = 100, xlim=c(0,2.5), prob=TRUE)

# Kernel Density Plot
#d <- density (paths[364,]) # returns the density data 
#lines(d, col='red',lw=2) # plots the results
#x = rlnorm(500,1,.6)

grid = seq(0,2.5,2.5/100)

lines(grid,dlnorm(grid,muV,sigmaV),type="l", col='red', lw=2)

#lines(density(x),col="red")
#legend("topright",c("True Density","Estimate"),lty=1,col=1:2)

