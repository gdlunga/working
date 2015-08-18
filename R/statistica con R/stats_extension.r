hist.pf <- function(x, br){
  if(missing(br))
    ist <- hist(x)
  else
    ist <- hist(x, breaks = br)
  
  if(ist$equidist)
    lines(c(min(ist$breaks),ist$mids,max(ist$breaks)),c(0,ist$counts,0))
  else
    lines(c(min(ist$breaks),ist$mids,max(ist$breaks)),c(0,ist$density,0))
}

skew <- function(x){
  n  <- length(x)
  s3 <- sqrt(var(x)*(n-1)/n)^3
  mx <- mean(x)
  sk <- sum((x - mx)^3)/s3
  sk/n
}

kurt <- function(x){
  n  <- length(x)
  s4 <- sqrt(var(x)*(n-1)/n)^4
  mx <- mean(x)
  kt <- sum((x - mx)^4)/s4
  kt/n
}

# indice di gini e curva di lorentz
gini <- function(x, plot=TRUE, add=FALSE, col="black") {
  
  n <- length(x) 
  x <- sort(x) 
  P <- (0:n)/n 
  Q <- c(0,cumsum(x)/sum(x)) 
  G <- 2*sum(P-Q)/(n-1) 
  
  IG <- list(G, (n-1)*G/n,P,Q) 
  names (IG) <- c("G","R","P","Q") 

  if (plot) { 
    angle=45 
    if(!add) { 
      plot(P,Q,type="l", axes = FALSE, asp=1, main ="curva di Lorenz") 
      axis(1); axis(2); rect(0,0,1,1) 
      lines(c(1,(n-1)/n),c(1,0),lty=2) 
      angle=90 
    }
    polygon(P,Q, density=10,angle=angle,col=col) 
  } 
  IG
}
  

