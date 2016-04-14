Initialize()
library(quadprog)
library(zoo)
library(lmtest)
library(tseries)
library(stats)
library(bstats)
library(package="mFilter",lib.loc=g_RLIB_DIR) #pacchetto installato successivamente

#********************************************************************
# *************************** Carico Dati ***************************
#********************************************************************
TS_PAV_Mod_Vol<- read.csv(".../Modello_Volumi_Raccolta_Vista.csv",header = TRUE, sep = ";")
attach(TS_PAV_Mod_Vol)
summary(TS_PAV_Mod_Vol)
# INSERIRE HP DEL CLUSTER RACCOLTA
# 180 -->PF, 120--> DR E SB , 60 --> TUTTI GLI ALTRI
# INSERIRE HP DEL CLUSTER IMPIEGHI
# 120 -->PF E SB  60 --> TUTTI GLI ALTRI
h=120
#********************************************************************
# ******************* Calcolo Trend ******************
#********************************************************************
hp_Trend<-hpfilter(TS_PAV_Mod_Vol$LogVol,freq=14400,type="lambda",drift=FALSE)
hp_Trend$trend
difference<-TS_PAV_Mod_Vol$LogVol-hp_Trend$trend
dim(vol<-sd(as.vector(difference,"numeric")))

#********************************************************************
# ******************* Calcolo Core No Core **************************
#********************************************************************
# da sostituire con codicce pi? veloce cerca simbolo somma 
ln_core<-rep(0,length(hp_Trend$trend))

# scalare per vettore in R
 for(i in 1:length(hp_Trend$trend))
 {ln_core[i]<-hp_Trend$trend[i]+qnorm(0.01,0,1)*vol}
ln_core

actual_core=exp(ln_core[length(hp_Trend$trend)])*TS_PAV_Mod_Vol$NumRapp[length(TS_PAV_Mod_Vol$NumRapp)]
actual_trend=exp(hp_Trend$trend[length(hp_Trend$trend)])*TS_PAV_Mod_Vol$NumRapp[length(TS_PAV_Mod_Vol$NumRapp)]

#********************************************************************
# ************** Calcolo MPA ( per la parte Core ) ******************
#********************************************************************

mpa<-rep(0,h)
num_rapp=TS_PAV_Mod_Vol$NumRapp[length(TS_PAV_Mod_Vol$NumRapp)]
for(i in 1:h)
{mpa[i]<-num_rapp*(exp(ln_core[length(ln_core)]+sqrt(i)*vol*qnorm(0.01,0,1))-i*exp(ln_core[length(ln_core)]+sqrt(h)*vol*qnorm(0.01,0,1))/h)}
mpa

#********************************************************************
# ************** Calcolo MPA ORIG ( per la parte Core ) *************
#********************************************************************


mpa_orig<-rep(0,h)
num_rapp=TS_PAV_Mod_Vol$NumRapp[length(TS_PAV_Mod_Vol$NumRapp)]
for(i in 1:h)
{mpa_orig[i]<-num_rapp*(exp(ln_core[length(ln_core)]+sqrt(i)*vol*qnorm(0.01,0,1)))}
mpa_orig
core_1=mpa_orig[1]
core_3=mpa_orig[3]

#********************************************************************
# ************** Calcolo CORREZIONE ( per la parte Core ) ***********
#********************************************************************

correzione<-rep(0,h)
mpa_star<-rep(0,h)
correzione<-mpa-mpa_orig

#********************************************************************
# ************** Calcolo Quota in scadenza **************************
#********************************************************************

qc<-rep(0,h-1)

vect_actual_core<-rep(actual_core,h)
vect_vol<-rep(vol,h)
vect_hp<-rep(h,h)
qc<-vect_actual_core[1:h-1]-mpa[1:h-1]
#********************************************************************
# ************** Scrivo file dei risultati se si vuole***************
# **************si rinomina per ciascun cluster**********************

#********************************************************************
mymatrix<-cbind(vect_actual_core,mpa,mpa_orig,correzione,vect_vol,vect_hp)
write.table(mymatrix,".../Output_Modello_Volumi_RACC_DR.csv",append=FALSE,sep=",",row.names=FALSE)
