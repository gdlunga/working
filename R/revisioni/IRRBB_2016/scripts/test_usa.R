setwd("/mnt/R/labdata/Audit/IRRBB/src_bin")

library(CogUtils)
Initialize()

library(xlsx)
library(tseries)
library(urca)
library(fUnitRoots)
library(reshape)
library(lmtest)
library(dyn,lib.loc="../rlib")

#### caricamento serie storiche Euribor (1,3,6,12 mesi) ####

usa=paste("usa",".csv",sep="")
usa_data=read.csv2(file=paste(g_INPUT_DIR,usa,sep="/"),1)

dyn$lm(usa_data$b~usa_data$f)


b=ts(usa_data$b,start=c(1984,1),end=c(2009,4) ,frequency =4)
f=ts(usa_data$f,start=c(1984,1),end=c(2009,4) ,frequency =4)
ft1=ts(usa_data$ft1,start=c(1984,1),end=c(2009,4) ,frequency =4)
ft2=ts(usa_data$ft2,start=c(1984,1),end=c(2009,4) ,frequency =4)

long=dyn$lm(b ~ f)
long$coefficients
res_long=ts(long$residuals,start=c(1984,1),end=c(2009,4) ,frequency =4)

ecm = dyn$lm(diff(b) ~ 0 + ft1 + ft2 + lag(res_long,k=-1) )
summary(ecm)
diff(lag(f,k=-1))
diff(f)

lag(res_long,k=-1)                    

diff_f1=f-lag(f,k=-1)
diff_f2=f-lag(f,k=-2)

ecm = dyn$lm(diff(b) ~ 0 + diff_f1 + diff_f2 + lag(res_long,k=-1) )
summary(ecm)

####  res_sim=b-1.429-0.777*f
####  ecm2 = dyn$lm(diff(b) ~ 0 + diff_f1 + diff_f2 + lag(res_sim,k=-1) )
####  summary(ecm2)
delta_b = ts(diff(b), start=c(1984,1),end=c(2009,4) ,frequency =4)
f1 = ts(lag(f,k=-1), start=c(1984,1),end=c(2009,4) ,frequency =4)
b1 = ts(lag(b,k=-1), start=c(1984,1),end=c(2009,4) ,frequency =4)
#res_lag = ts(lag(res_long,k=-1),start=c(1984,2),end=c(2009,4) ,frequency =4)
diff_f1 = ts(f-lag(f,k=-1), start=c(1984,1),end=c(2009,4) ,frequency =4)
diff_f2 = ts(f-lag(f,k=-2), start=c(1984,1),end=c(2009,4) ,frequency =4)
##m1=min(diff_f1)
##m2=min(diff_f2)
#beta1=-0.1
#beta2=0.8
#beta3=-0.3

val.start= c(beta1=-0.1, beta2=0.82, beta3=-0.3)
#nonlin=nls(delta_b ~ 0 + diff_f1 + diff_f2 + res_lag, start=val.start, trace=TRUE)
nonlin=nls(delta_b ~ -ALFA*(b1-BETA1-BETA2*f1) + beta2*diff_f1 + beta3*diff_f2, start=val.start, trace=TRUE)
summary(nonlin)





#### caso semplificato con un regressore in meno e serie uniformate nei tempi
#delta_b=diff(b)
#res_lag=ts(lag(res_long,k=-1), start=c(1984,2),end=c(2009,4) ,frequency =4)

#m1=-0.05
#m3=0
#val.start= c(diff_f1=m1, res_lag=m3)
#nonlin=nls(delta_b ~ 0 + diff_f1 + res_lag, start=val.start, trace=TRUE)
