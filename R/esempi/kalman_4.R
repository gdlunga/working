install.packages('KFAS')
require(KFAS)

# Example of local level model for Nile series
modelNile<-SSModel(Nile~SSMtrend(1,Q=list(matrix(NA))),H=matrix(NA))
modelNile
modelNile<-fitSSM(inits=c(log(var(Nile)),log(var(Nile))),model=modelNile,
                  method='BFGS',control=list(REPORT=1,trace=1))$model



# Can use different optimisation: 
# should be one of “Nelder-Mead”, “BFGS”, “CG”, “L-BFGS-B”, “SANN”, “Brent”
#modelNile<-SSModel(Nile~SSMtrend(1,Q=list(matrix(NA))),H=matrix(NA))
#modelNile
#modelNile<-fitSSM(inits=c(log(var(Nile)),log(var(Nile))),model=modelNile,
#                  method='L-BFGS-B',control=list(REPORT=1,trace=1))$model

# Filtering and state smoothing
out<-KFS(modelNile,filtering='state',smoothing='state')
out
