

callBSM <- function(S,X,tau,r,q,vol) { 
  if (tau > 0) { 
    d1 <- (log(S/X) + (r - q + vol^2 / 2)*tau) / (vol*sqrt(tau)) 
    d2 <- d1 - vol*sqrt(tau) 
    S * exp(-q * tau) * pnorm(d1) - X * exp(-r * tau) * pnorm(d2) 
  } else { 
    pmax(S-X,0) 
  } 
  
} 

S <- 70:130 ## evaluate for these spot prices 
X <- 100; tau <- 1; r <- 0.02; q <- 0.01; vol  <- 0.2 

plot(S,pmax(S-X,0), col = 'black', type="l", ylab = "maturity payoff")
lines(S, callBSM(S,X,tau,r,q,vol), col = 'blue', type="l", ylab = "payoff") 

tau <- 0.9 
lines(S, callBSM(S,X,tau,r,q,vol), col = 'red', type="l") 
tau <- 0.8 
lines(S, callBSM(S,X,tau,r,q,vol), col = 'red', type="l") 
tau <- 0.7 
lines(S, callBSM(S,X,tau,r,q,vol), col = 'red', type="l") 
tau <- 0.6 
lines(S, callBSM(S,X,tau,r,q,vol), col = 'red', type="l") 
tau <- 0.5 
lines(S, callBSM(S,X,tau,r,q,vol), col = 'red', type="l") 
tau <- 0.4 
lines(S, callBSM(S,X,tau,r,q,vol), col = 'red', type="l") 
tau <- 0.3 
lines(S, callBSM(S,X,tau,r,q,vol), col = 'red', type="l") 
tau <- 0.2 
lines(S, callBSM(S,X,tau,r,q,vol), col = 'red', type="l") 
tau <- 0.1 
lines(S, callBSM(S,X,tau,r,q,vol), col = 'red', type="l") 

