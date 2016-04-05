# IMPORTARE DATI DA MAC
dati<= read.csv("~/Desktop/dati.csv", sep=";", dec=",")
View(dati)

# IMPORTARE DATI DA PDL
setwd("/mnt/R/labdata/Audit/RAF/R/src_bin")
library(CogUtils)
Initialize()
file_ind=paste("dati.csv",sep="") 
dati=read.csv2(file=paste(g_INPUT_DIR,file_ind,sep="/"),1)

# PREDISPOSIZIONE DATA FRAME
rownames(dati)=dati$Anno
dati=dati[2:14]
dati_m=as.matrix(dati)

# CALCOLO DEI PERCENTILI PER RISCHIO/SEGMENTO - PER OGNUNA DELLE 13 VARIABILI 
# c(0.20,0.40,0.60,0.80,1,0.005,0.9995)
perc_ind=matrix( , nrow=7,ncol=13)
for (i in 1:13) {
  perc_ind[1,i] = quantile(dati_m[,i],probs=0.20)
  perc_ind[2,i] = quantile(dati_m[,i],probs=0.40)
  perc_ind[3,i] = quantile(dati_m[,i],probs=0.60)
  perc_ind[4,i] = quantile(dati_m[,i],probs=0.80)
  perc_ind[5,i] = quantile(dati_m[,i],probs=1)
  perc_ind[6,i] = quantile(dati_m[,i],probs=0.005)
  perc_ind[7,i] = quantile(dati_m[,i],probs=0.9995)
}
rownames(perc_ind)=c(0.20,0.40,0.60,0.80,1,0.005,0.9995)
colnames(perc_ind)=colnames(dati)

# CALCOLO DEI PERCENTILI PER RISCHIO - CREDITO, TASSO e OPERATIVO (28 obs)
perc_aggr=matrix( , nrow=7,ncol=4)
# RISCHIO CREDITO 
perc_aggr[1,1] = quantile(cbind(dati[,1],dati[,2],dati[,3],dati[,4]),probs=0.20)
perc_aggr[2,1] = quantile(cbind(dati[,1],dati[,2],dati[,3],dati[,4]),probs=0.40)
perc_aggr[3,1] = quantile(cbind(dati[,1],dati[,2],dati[,3],dati[,4]),probs=0.60)
perc_aggr[4,1] = quantile(cbind(dati[,1],dati[,2],dati[,3],dati[,4]),probs=0.80)
perc_aggr[5,1] = quantile(cbind(dati[,1],dati[,2],dati[,3],dati[,4]),probs=1)
perc_aggr[6,1] = quantile(cbind(dati[,1],dati[,2],dati[,3],dati[,4]),probs=0.005)
perc_aggr[7,1] = quantile(cbind(dati[,1],dati[,2],dati[,3],dati[,4]),probs=0.9995)
# RISCHIO MERCATO 
perc_aggr[1,2] = quantile(dati[,5],probs=0.20)
perc_aggr[2,2] = quantile(dati[,5],probs=0.40)
perc_aggr[3,2] = quantile(dati[,5],probs=0.60)
perc_aggr[4,2] = quantile(dati[,5],probs=0.80)
perc_aggr[5,2] = quantile(dati[,5],probs=1)
perc_aggr[6,2] = quantile(dati[,5],probs=0.005)
perc_aggr[7,2] = quantile(dati[,5],probs=0.9995)
# RISCHIO TASSO
perc_aggr[1,3] = quantile(cbind(dati[,6],dati[,7],dati[,8],dati[,9]),probs=0.20)
perc_aggr[2,3] = quantile(cbind(dati[,6],dati[,7],dati[,8],dati[,9]),probs=0.40)
perc_aggr[3,3] = quantile(cbind(dati[,6],dati[,7],dati[,8],dati[,9]),probs=0.60)
perc_aggr[4,3] = quantile(cbind(dati[,6],dati[,7],dati[,8],dati[,9]),probs=0.80)
perc_aggr[5,3] = quantile(cbind(dati[,6],dati[,7],dati[,8],dati[,9]),probs=1)
perc_aggr[6,3] = quantile(cbind(dati[,6],dati[,7],dati[,8],dati[,9]),probs=0.005)
perc_aggr[7,3] = quantile(cbind(dati[,6],dati[,7],dati[,8],dati[,9]),probs=0.9995)
# RISCHIO OPERATIVO
perc_aggr[1,4] = quantile(cbind(dati[,10],dati[,11],dati[,12],dati[,13]),probs=0.20)
perc_aggr[2,4] = quantile(cbind(dati[,10],dati[,11],dati[,12],dati[,13]),probs=0.40)
perc_aggr[3,4] = quantile(cbind(dati[,10],dati[,11],dati[,12],dati[,13]),probs=0.60)
perc_aggr[4,4] = quantile(cbind(dati[,10],dati[,11],dati[,12],dati[,13]),probs=0.80)
perc_aggr[5,4] = quantile(cbind(dati[,10],dati[,11],dati[,12],dati[,13]),probs=1)
perc_aggr[6,4] = quantile(cbind(dati[,10],dati[,11],dati[,12],dati[,13]),probs=0.005)
perc_aggr[7,4] = quantile(cbind(dati[,10],dati[,11],dati[,12],dati[,13]),probs=0.9995)

rownames(perc_aggr)=c(0.20,0.40,0.60,0.80,1,0.005,0.9995)
colnames(perc_aggr)=c("R_CREDITO","R_MERCATO","R_TASSO","R_OPERATIVO")

# CALCOLO DEI PERCENTILI PER RISCHIO - CREDITO, TASSO e OPERATIVO (28 obs)
perc_aggr_N=matrix( , nrow=7,ncol=4)

RC=as.vector(cbind(dati[,1],dati[,2],dati[,3],dati[,4]))
RT=as.vector(cbind(dati[,6],dati[,7],dati[,8],dati[,9]))
RO=as.vector(cbind(dati[,10],dati[,11],dati[,12],dati[,13]))

# RISCHIO CREDITO 
perc_aggr_N[1,1] = qnorm(0.20,   mean=mean(RC), sd=sqrt(27/28*var(RC)))
perc_aggr_N[2,1] = qnorm(0.40,   mean=mean(RC), sd=sqrt(27/28*var(RC)))
perc_aggr_N[3,1] = qnorm(0.60,   mean=mean(RC), sd=sqrt(27/28*var(RC)))
perc_aggr_N[4,1] = qnorm(0.80,   mean=mean(RC), sd=sqrt(27/28*var(RC)))
perc_aggr_N[5,1] = qnorm(0.9999, mean=mean(RC), sd=sqrt(27/28*var(RC)))
perc_aggr_N[6,1] = qnorm(0.005,  mean=mean(RC), sd=sqrt(27/28*var(RC)))
perc_aggr_N[7,1] = qnorm(0.9995, mean=mean(RC), sd=sqrt(27/28*var(RC)))
# RISCHIO MERCATO 
perc_aggr_N[1,2] = qnorm(0.20,   mean=mean(dati[,5]), sd=sqrt(6/7*var(dati[,5])))
perc_aggr_N[2,2] = qnorm(0.40,   mean=mean(dati[,5]), sd=sqrt(6/7*var(dati[,5])))
perc_aggr_N[3,2] = qnorm(0.60,   mean=mean(dati[,5]), sd=sqrt(6/7*var(dati[,5])))
perc_aggr_N[4,2] = qnorm(0.80,   mean=mean(dati[,5]), sd=sqrt(6/7*var(dati[,5])))
perc_aggr_N[5,2] = qnorm(0.9999, mean=mean(dati[,5]), sd=sqrt(6/7*var(dati[,5])))
perc_aggr_N[6,2] = qnorm(0.005,  mean=mean(dati[,5]), sd=sqrt(6/7*var(dati[,5])))
perc_aggr_N[7,2] = qnorm(0.9995, mean=mean(dati[,5]), sd=sqrt(6/7*var(dati[,5])))
# RISCHIO TASSO
perc_aggr_N[1,3] = qnorm(0.20,   mean=mean(RT), sd=sqrt(27/28*var(RT)))
perc_aggr_N[2,3] = qnorm(0.40,   mean=mean(RT), sd=sqrt(27/28*var(RT)))
perc_aggr_N[3,3] = qnorm(0.60,   mean=mean(RT), sd=sqrt(27/28*var(RT)))
perc_aggr_N[4,3] = qnorm(0.80,   mean=mean(RT), sd=sqrt(27/28*var(RT)))
perc_aggr_N[5,3] = qnorm(0.9999, mean=mean(RT), sd=sqrt(27/28*var(RT)))
perc_aggr_N[6,3] = qnorm(0.005,  mean=mean(RT), sd=sqrt(27/28*var(RT)))
perc_aggr_N[7,3] = qnorm(0.9995, mean=mean(RT), sd=sqrt(27/28*var(RT)))
# RISCHIO OPERATIVO
perc_aggr_N[1,4] = qnorm(0.20,   mean=mean(RO), sd=sqrt(27/28*var(RO)))
perc_aggr_N[2,4] = qnorm(0.40,   mean=mean(RO), sd=sqrt(27/28*var(RO)))
perc_aggr_N[3,4] = qnorm(0.60,   mean=mean(RO), sd=sqrt(27/28*var(RO)))
perc_aggr_N[4,4] = qnorm(0.80,   mean=mean(RO), sd=sqrt(27/28*var(RO)))
perc_aggr_N[5,4] = qnorm(0.9999, mean=mean(RO), sd=sqrt(27/28*var(RO)))
perc_aggr_N[6,4] = qnorm(0.005,  mean=mean(RO), sd=sqrt(27/28*var(RO)))
perc_aggr_N[7,4] = qnorm(0.9995, mean=mean(RO), sd=sqrt(27/28*var(RO)))

rownames(perc_aggr_N)=c(0.20,0.40,0.60,0.80,1,0.005,0.9995)
colnames(perc_aggr_N)=c("R_CREDITO","R_MERCATO","R_TASSO","R_OPERATIVO")


# VALUTARE DOPO SE CALCOLARE QUI MEDIE E VARIANZE


