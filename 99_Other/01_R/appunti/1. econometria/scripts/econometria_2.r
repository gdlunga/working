
require("vars")
require("forecast")

arma.sim <- arima.sim(model=list(ar=c(1.0,-0.5),ma=c(0.75)),n=100) 
#arima(arma.sim, order=c(2,0,1))

VAR <- auto.arima(arma.sim) 
VAR


