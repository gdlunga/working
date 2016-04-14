#RELAZIONE DI LUNGO PERIODO
#Stima modello ADL
stima_long=dyn$lm(tassi_mps~1+eur1m)
summary(stima_long)
res_long=stima_long$residuals

#analisi residui
res_reg=res_long
N=length(res_reg)
res_media=mean(res_reg)
res_dev=var(res_reg)


stima_ecm=dyn$lm(diff(tassi_mps)~diff(lag)
  
  [,"rec_c"])~0+diff(data_ts_1[,"dec_c"])
                   +diff(lag(data_ts_1[,"dec_c"],k=-1))+
                     lag(res_long_c,k=-1))

quantile(res_reg ,p=.5)
read.csv2()


b=ts(usa_data$b,start=c(1984,1),end=c(2009,4),freq=4)
f=ts(usa_data$f,start=c(1984,1),end=c(2009,4),freq=4)

long=dyn$lm(b ~ f)
long$coefficients
res_long=ts(long$residuals,start=start(diff(b)),end=end(diff(b)),freq=4)

# analisi residui per autocorrelazione (Acf e Durbin Watson)
acf(res_long)
a1=durbinWatsonTest(long$residuals, max.lag=5)
a1
a=dwtest(b ~ f)
rho =  1 - a$statistic/2 
rho1 = 1 - a1/2

# stima GLS che eliminando l'autocorrelazione dei residui, fornisce stime BLUE
gls(b ~ f,correlation=corAR1(rho) , method="ML") 
gls(b ~ f,correlation=corARMA(p=3,q=4) , method="ML")


ecm = dyn$lm(diff(b) ~ 0 + lag(res_long,k=-1) + diff(f) + diff(lag(f,k=-1))) 
summary(ecm)


res_sim = b-1.429-0.777*f
ecm2 =dyn$lm(diff(b) ~ 0 + lag( res_sim,k=-1) + diff(f) + diff(lag(f,k=-1))) 
summary(ecm2)

prova = dyn$lm(b ~ 1 + lag(b,k=-1) + f + lag(f,k=-1))
summary(prova)
beta1=0.22636 / (1-0.87999)
beta2=(-0.60017+0.68582)/(1-0.87999)
names(prova$coefficients) = c("delta","teta1","delta0","delta1")
p=prova$coefficients
p
delta = p[[1]] 
tetha1 = p[[2]] 
delta0 = p[[3]]
delta1 = p[[4]]
beta1 = delta / (1 - tetha1)
beta2 = (delta0 + delta1) / (1 - tetha1)
beta1
beta2

# calcolo residui e test ADF di stazionarietà per verificare che le serie siano cointegrate
epsilon = lag(b,k=-1) - 1.429 - 0.777*lag(f,k=-1) # libro
epsilon = lag(b,k=-1) - 1.5638502 - 0.8322964*lag(f,k=-1) # calcolata con corARMA (3,4)
z=dyn$lm(diff(epsilon) ~ 0 + lag(epsilon,k=-1) + diff(lag(epsilon,k=-1)))
summary(z)