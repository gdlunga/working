library(mnormt)
xhat <- c(0.2, -0.2)
Sigma <- matrix(c(0.4, 0.3, 
                  0.3, 0.45), ncol=2)
x1 <- seq(-2, 4,length=151)
x2 <- seq(-4, 2,length=151)
f <- function(x1,x2, mean=xhat, varcov=Sigma) 
  dmnorm(cbind(x1,x2), mean,varcov)
z <- outer(x1,x2, f)
mycols <- topo.colors(100,0.5)
image(x1,x2,z, col=mycols, main="Prior density",
      xlab=expression('x'[1]), ylab=expression('x'[2]))
contour(x1,x2,z, add=TRUE)
points(0.2, -0.2, pch=19)
text(0.1, -0.2, labels = expression(hat(x)), adj = 1)


R <- 0.5 * Sigma
z2 <- outer(x1,x2, f, mean=c(2.3, -1.9), varcov=R)
image(x1, x2, z2, col=mycols, main="Sensor density")
contour(x1, x2, z2, add=TRUE)
points(2.3, -1.9, pch=19)
text(2.2, -1.9, labels = "y", adj = 1)
contour(x1, x2,z, add=TRUE)
points(0.2, -0.2, pch=19)
text(0.1, -0.2, labels = expression(hat(x)), adj = 1)


G = diag(2)
y <- c(2.4, -1.9)
xhatf <- xhat + Sigma %*% t(G) %*% solve(G %*% Sigma %*% t(G) + R) %*% (y - G %*% xhat)
Sigmaf <- Sigma - Sigma %*% t(G) %*% solve(G %*% Sigma %*% t(G) + R) %*% G %*% Sigma
z3 <- outer(x1, x2, f, mean=c(xhatf), varcov=Sigmaf)
image(x1, x2, z3, col=mycols,
      xlab=expression('x'[1]), ylab=expression('x'[2]),
      main="Filtered density")
contour(x1, x2, z3, add=TRUE)
points(xhatf[1], xhatf[2], pch=19)
text(xhatf[1]-0.1, xhatf[2],
     labels = expression(hat(x)[f]), adj = 1)
lb <- adjustcolor("black", alpha=0.5)
contour(x1, x2, z, add=TRUE, col=lb)
points(0.2, -0.2, pch=19, col=lb)
text(0.1, -0.2, labels = expression(hat(x)), adj = 1, col=lb)
contour(x1, x2, z2, add=TRUE, col=lb)
points(2.3, -1.9, pch=19, col=lb)
text(2.2, -1.9,labels = "y", adj = 1, col=lb)


