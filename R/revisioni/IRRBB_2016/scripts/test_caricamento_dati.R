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

####parametri

period_euribor = 1 # 3,6,12
start_anno=2001
end_anno=2016
start_mese=1
end_mese=3
period_serie=12
lag=1


euribor=paste("euribor","_",period_euribor,"M",".csv",sep="")
eur1m=read.csv2(file=paste(g_INPUT_DIR,euribor,sep="/"),1)
#eur3m=read.csv2(file=paste(g_INPUT_DIR,euribor,sep="/"),1)
#eur6m=read.csv2(file=paste(g_INPUT_DIR,euribor,sep="/"),1)
#eur12m=read.csv2(file=paste(g_INPUT_DIR,euribor,sep="/"),1)


# trasformazione dati euribor in serie storica
eur1m=ts(eur1m, start=c(start_anno,start_mese), end=c(end_anno,end_mese), frequency=period_serie)

#creazione serie differenze

eur1m_d=tslag(eur1m, k=lag)
eur1m_d=ts(eur1m_d, start=c(start_anno,start_mese), end=c(end_anno,end_mese), frequency=period_serie)
eur1m_delta=eur1m-eur1m_d


######   da fare
######   modello ECM
######   Wald test
######  F-test
