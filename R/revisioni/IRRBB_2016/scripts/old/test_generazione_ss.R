#########################################################################
################# GENERAZIONE S.S. AUTOREGRESSIVA #######################
#########################################################################

setwd("/mnt/R/labdata/Audit/IRRBB/src_bin")
library(CogUtils)
Initialize()
library(dyn,lib.loc="../rlib")
library(tseries)
library(urca)
library(stats)
library(fBasics)
library(drc)
library(lmtest)
library(nlme)
library(bstat)
library(car)

# Assegnazione parametri
n_autoregr = 1
oss_wn     = 283
mean_wn    = 0
sd_wn      = 1
soglia     = 100
alpha      = 0
start_ss   = 2001
mese_ini   = 1
mens       = 12


# Generazione serie MPS
c = runif(n_autoregr) # ipotesi di stazionarietà
c = rep(1,n_autoregr) # ipotesi di non stazionarietà (RANDOM WALK)
#c = rnorm(n_autoregr) 
c
w = rnorm(oss_wn,mean_wn,sd_wn) # 100 extra to avoid startup problems
x = filter(w, filter=c, method="recursive")[-(1:soglia)]
x = x + alpha
tassi_mps = ts(x, start = c(start_ss, mese_ini), freq=mens)


# Test Dickey-Fuller - Metodo ur.df (che ha la summary)
summary(ur.df(tassi_mps,type=c("none"), lags = 1))
ur.df


# Test Dickey-Fuller - Metodo adf.test 
adf.test(tassi_mps)
adf.test(eur1m)

summary(ur.df(eur1m,type=c("none"), lags = 2))