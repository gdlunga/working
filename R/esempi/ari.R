setwd("C:/Users/T004314/Documents/GitHub/working/R/esempi")
#setwd("/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/src_bin")
#library(CogUtils)
#Initialize()
library(quadprog)
library(zoo)
library(lmtest)
library(tseries)
library(stats)
library(urca)
library(astsa)
library(strucchange)
library(FactoMineR)
library(lubridate)
library(sandwich)
library(XLConnect)
library(EMCluster)
library(package="mFilter",lib.loc="../rlib/")
library(package="EMCluster",lib.loc="../rlib/")
library(package="mFilter") 

#********************************************************************
# *************************** Carico Dati ***************************
#********************************************************************

#**********
Log_Nb<- read.csv("SerieVolumi.csv",header = TRUE, sep = ";")
attach(Log_Nb)
# ********************************* ******************
# *********** ENTI ***********
# ********************************* ******************
library(fUnitRoots)

#CAHANGE COL
enti.ts<-ts(Log_Nb[,2],start=c(2008,2),end=c(2016,7),frequency = 12)
kc.ts<-ts(Log_Nb[,3],start=c(2008,2),end=c(2016,7),frequency = 12)
pf.ts<-ts(Log_Nb[,4],start=c(2008,2),end=c(2016,7),frequency = 12)
pmi.ts<-ts(Log_Nb[,5],start=c(2008,2),end=c(2016,7),frequency = 12)
private.ts<-ts(Log_Nb[,6],start=c(2008,2),end=c(2016,7),frequency = 12)
sb.ts<-ts(Log_Nb[,7],start=c(2008,2),end=c(2016,7),frequency = 12)
dr.ts<-ts(Log_Nb[,8],start=c(2008,2),end=c(2016,7),frequency = 12)

###############################################################
                    # ENTI #
###############################################################


# UNIT ROOT #
summary(ur.df(enti.ts,type=c("none"),lags=0))
summary(ur.df(enti.ts,type=c("drift"),lags=0))
summary(ur.df(enti.ts,type=c("trend"),lags=0))
# HP#
#*********************** 
HodrickPrescott<-hpfilter(enti.ts,freq=14400,type="lambda",drift=FALSE)

hpRes<-(enti.ts-(HodrickPrescott$trend))
sd(hpRes)
qqnormPlot(hpRes)
acf(hpRes)
title="hpRes_14400"
write.table((HodrickPrescott$trend),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/ENTI/HP14400Enti.csv",append=FALSE,sep=",",row.names=FALSE)
shapiro.test(hpRes)

t.test(hpRes,alternative = c("two.sided"),mu=0)
Box.test(hpRes)
#*********************** 
HodrickPrescott<-hpfilter(enti.ts,freq=86400,type="lambda",drift=FALSE)

hpRes<-(enti.ts-HodrickPrescott$trend )
sd(hpRes)
qqnormPlot(hpRes)
acf(hpRes)
write.table((HodrickPrescott$trend),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/ENTI/HP86400Enti.csv",append=FALSE,sep=",",row.names=FALSE)

shapiro.test(hpRes)
t.test(hpRes,alternative = c("two.sided"),mu=0)
Box.test(hpRes)
#*********************** 
HodrickPrescott<-hpfilter(enti.ts,freq=129600,type="lambda",drift=FALSE)

hpRes<-(enti.ts-(HodrickPrescott$trend ))
sd(hpRes)
qqnormPlot(hpRes)
acf(hpRes)
write.table((HodrickPrescott$trend),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/ENTI/HP129600Enti.csv",append=FALSE,sep=",",row.names=FALSE)

shapiro.test(hpRes)
t.test(hpRes,alternative = c("two.sided"),mu=0)
Box.test(hpRes)
#*********************** RNDWALK PURO #***********************  #
RndWalk<-StructTS(enti.ts, type = c( "level"), init = NULL,  fixed = c(0,NA), optim.control = NULL)
if (RndWalk$code != 0) stop("non converge")

cat("Transitional variance:", RndWalk$coef["level"],
    "\n", "Observational variance:", RndWalk$coef["epsilon"],
    "\n", "Initial level:", RndWalk$model0$a, "\n")
tsdiag(RndWalk)
qqnormPlot(RndWalk$residuals)
shapiro<-shapiro.test((enti.ts-RndWalk$fitted))
if(shapiro$p.value<=0.1) wilcox.test((enti.ts-RndWalk$fitted),y=NULL)
if(shapiro$p.value>0.1)  t.test( (enti.ts-RndWalk$fitted),alternative = c("two.sided"),mu=0)

Box.test((enti.ts-RndWalk$fitted))
write.table((RndWalk$fitted),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/ENTI/RndWalkEnti.csv",append=FALSE,sep=",",row.names=FALSE)

#*********************** TiME INVARIANT #*********************** #
structTInvariant<-StructTS(enti.ts, type = c( "level") )


if (structTInvariant$code != 0) stop("non converge")

cat("Transitional variance:", structTInvariant$coef["level"],
    "\n", "Observational variance:", structTInvariant$coef["epsilon"],
    "\n", "Initial level:", structTInvariant$model0$a, "\n")
tsdiag(structTInvariant)
shapiro.test(structTInvariant$residuals)
qqnormPlot(structTInvariant$residuals)
smoothKTI<- KalmanSmooth(enti.ts, structTInvariant$model)
sd((enti.ts-smoothKTI$smooth[,1]))

plot.ts(pf.ts)
plot.ts(smoothKTI$smooth[,1],col='red')
plot.ts(enti.ts-smoothKTI$smooth[,1])

require(dlm)

s <- dlmSmooth(pf.ts, dlmModPoly(1,  dV = 20000, dW = 100))
lines(dropFirst(s$s), col = "red")

plot.ts((pf.ts-s$s))
#acf((enti.ts-s$s))
summary(ur.df(enti.ts-s$s,type=c("none"),lags=0))

sd(pf.ts-s$s)

summary(ur.df((enti.ts-smoothKTI$smooth[,1]),type=c("none"),lags=0))
shapiro<-shapiro.test((enti.ts-smoothKTI$smooth[,1]))
if(shapiro$p.value<=0.1) wilcox.test((enti.ts-smoothKTI$smooth[,1]),y=NULL)
if(shapiro$p.value>0.1)  t.test((enti.ts-smoothKTI$smooth[,1]),alternative = c("two.sided"),mu=0)

write.table(smoothKTI,"KSmoothTimeInvariantEnti.csv",append=FALSE,sep=",",row.names=FALSE)
write.table((structTInvariant$fitted),"KFilterTimeInvariantEnti.csv",append=FALSE,sep=",",row.names=FALSE)
structTInvariant$fitted
#*********************** TiME VARYING #*********************** #

structTVarying<-StructTS(enti.ts, type = c( "trend") )
if (structTVarying$code != 0) stop("optimizer did not converge")
tsdiag(structTVarying)
cat("Transitional variance:", structTVarying$coef["level"],
    "\n", "Slope variance:", structTVarying$coef["slope"],
    "\n", "Observational variance:", structTVarying$coef["epsilon"],
    "\n", "Initial level of m:", structTVarying$model0$a[1],
    "\n", "Initial level of beta:", structTVarying$model0$a[2],
    "\n")
tsdiag(structTVarying)

smoothKTV<- KalmanSmooth(enti.ts, structTVarying$model)
shapiro<-shapiro.test((enti.ts-smoothKTV$smooth[,1]))
if(shapiro$p.value<=0.1) wilcox.test((enti.ts-smoothKTV$smooth[,1]),y=NULL)
if(shapiro$p.value>0.1)  t.test((enti.ts-smoothKTV$smooth[,1]),alternative = c("two.sided"),mu=0)

write.table((structTVarying$fitted),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/ENTI/KFilterTimeVaryingEnti.csv",append=FALSE,sep=",",row.names=FALSE)


###############################################################
            # KC #
###############################################################

# UNIT ROOT #
summary(ur.df(kc.ts,type=c("none"),lags=0))
summary(ur.df(kc.ts,type=c("drift"),lags=0))
summary(ur.df(kc.ts,type=c("trend"),lags=0))
# HP#
#*********************** HP
HodrickPrescott<-hpfilter(kc.ts,freq=14400,type="lambda",drift=FALSE)

hpRes<-(kc.ts-(HodrickPrescott$trend))
write.table((HodrickPrescott$trend),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/KC/HP14400KC.csv",append=FALSE,sep=",",row.names=FALSE)
shapiro.test(hpRes)
t.test(hpRes,alternative = c("two.sided"),mu=0)
Box.test(hpRes)
qqnormPlot(hpRes)
acf(hpRes)
#*********************** 
HodrickPrescott<-hpfilter(kc.ts,freq=86400,type="lambda",drift=FALSE)

hpRes<-(kc.ts-(HodrickPrescott$trend ))
qqnormPlot(hpRes)
acf(hpRes)
write.table((HodrickPrescott$trend),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/KC/HP86400KC.csv",append=FALSE,sep=",",row.names=FALSE)

shapiro.test(hpRes)
t.test(hpRes,alternative = c("two.sided"),mu=0)
Box.test(hpRes)
qqnormPlot(hpRes)
#*********************** 
HodrickPrescott<-hpfilter(kc.ts,freq=129600,type="lambda",drift=FALSE)

hpRes<-(kc.ts-(HodrickPrescott$trend ))
qqnormPlot(hpRes)
acf(hpRes)
write.table((HodrickPrescott$trend),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/KC/HP129600KC.csv",append=FALSE,sep=",",row.names=FALSE)

shapiro.test(hpRes)
t.test(hpRes,alternative = c("two.sided"),mu=0)
Box.test(hpRes)
#*********************** RNDWALK PURO #***********************  #
RndWalk<-StructTS(kc.ts, type = c( "level"), init = NULL,  fixed = c(0,NA), optim.control = NULL)
if (RndWalk$code != 0) stop("non converge")

cat("Transitional variance:", RndWalk$coef["level"],
    "\n", "Observational variance:", RndWalk$coef["epsilon"],
    "\n", "Initial level:", RndWalk$model0$a, "\n")
tsdiag(RndWalk)
qqnormPlot(RndWalk$residuals)
shapiro<-shapiro.test((kc.ts-RndWalk$fitted))
if(shapiro$p.value<=0.1) wilcox.test((kc.ts-RndWalk$fitted),y=NULL)
if(shapiro$p.value>0.1)  t.test( (kc.ts-RndWalk$fitted),alternative = c("two.sided"),mu=0)

Box.test((kc.ts-RndWalk$fitted))
write.table((RndWalk$fitted),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/KC/RndWalkKC.csv",append=FALSE,sep=",",row.names=FALSE)

#*********************** TiME INVARIANT #*********************** #
structTInvariant<-StructTS(kc.ts, type = c( "level") )


if (structTInvariant$code != 0) stop("non converge")

cat("Transitional variance:", structTInvariant$coef["level"],
    "\n", "Observational variance:", structTInvariant$coef["epsilon"],
    "\n", "Initial level:", structTInvariant$model0$a, "\n")
tsdiag(structTInvariant)
qqnormPlot(structTInvariant$residuals)
smoothKTI<- KalmanSmooth(kc.ts, structTInvariant$model)

shapiro<-shapiro.test((structTInvariant$residuals))
if(shapiro$p.value<=0.1) wilcox.test((kc.ts-smoothKTI$smooth[,1]),y=NULL)
if(shapiro$p.value>0.1)  t.test((kc.ts-smoothKTI$smooth[,1]),alternative = c("two.sided"),mu=0)

write.table((smoothKTI),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/KSmoothTimeInvariantKC.csv",append=FALSE,sep=",",row.names=FALSE)
write.table((structTInvariant$fitted),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/KC/KFilterTimeInvariantKC.csv",append=FALSE,sep=",",row.names=FALSE)
#*********************** TiME VARYING #*********************** #

structTVarying<-StructTS(kc.ts, type = c( "trend") )
if (structTVarying$code != 0) stop("optimizer did not converge")
tsdiag(structTVarying)
cat("Transitional variance:", structTVarying$coef["level"],
    "\n", "Slope variance:", structTVarying$coef["slope"],
    "\n", "Observational variance:", structTVarying$coef["epsilon"],
    "\n", "Initial level of m:", structTVarying$model0$a[1],
    "\n", "Initial level of beta:", structTVarying$model0$a[2],
    "\n")
tsdiag(structTVarying)

smoothKTV<- KalmanSmooth(kc.ts, structTVarying$model)
shapiro<-shapiro.test((kc.ts-smoothKTV$smooth[,1]))
if(shapiro$p.value<=0.1) wilcox.test((kc.ts-smoothKTV$smooth[,1]),y=NULL)
if(shapiro$p.value>0.1)  t.test((kc.ts-smoothKTV$smooth[,1]),alternative = c("two.sided"),mu=0)

write.table((structTVarying$fitted),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/KC/KFilterTimeVaryingKC.csv",append=FALSE,sep=",",row.names=FALSE)



###############################################################
                    # PF #
###############################################################
summary(ur.df(pf.ts,type=c("none"),lags=0))
summary(ur.df(pf.ts,type=c("drift"),lags=0))
summary(ur.df(pf.ts,type=c("trend"),lags=0))


# HP#
#*********************** HP
HodrickPrescott<-hpfilter(pf.ts,freq=14400,type="lambda",drift=FALSE)

hpRes<-(pf.ts-(HodrickPrescott$trend))
qqnormPlot(hpRes)
acf(hpRes)
write.table((HodrickPrescott$trend),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/PF/HP14400PF.csv",append=FALSE,sep=",",row.names=FALSE)
shapiro.test(hpRes)
acf(hpRes)
qqnormPlot(hpRes)
if(shapiro$p.value<=0.1) wilcox.test((hpRes),y=NULL)
if(shapiro$p.value>0.1)  t.test(hpRes,alternative = c("two.sided"),mu=0)
Box.test(hpRes)
qqnormPlot(hpRes)
#*********************** 
HodrickPrescott<-hpfilter(pf.ts,freq=86400,type="lambda",drift=FALSE)

hpRes<-(pf.ts-(HodrickPrescott$trend ))
write.table((HodrickPrescott$trend),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/PF/HP86400PF.csv",append=FALSE,sep=",",row.names=FALSE)
hpRes<-(pf.ts-(HodrickPrescott$trend))
qqnormPlot(hpRes)
acf(hpRes)
shapiro.test(hpRes)
t.test(hpRes,alternative = c("two.sided"),mu=0)
Box.test(hpRes)
qqnormPlot(hpRes)
#*********************** 
HodrickPrescott<-hpfilter(pf.ts,freq=129600,type="lambda",drift=FALSE)
HodrickPrescott$
hpRes<-(pf.ts-(HodrickPrescott$trend ))
qqnormPlot(hpRes)
acf(hpRes)
write.table((HodrickPrescott$trend),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/PF/HP129600PF.csv",append=FALSE,sep=",",row.names=FALSE)

shapiro.test(hpRes)
t.test(hpRes,alternative = c("two.sided"),mu=0)
Box.test(hpRes)
#*********************** RNDWALK PURO #***********************  #
RndWalk<-StructTS(pf.ts, type = c( "level"), init = NULL,  fixed = c(0,NA), optim.control = NULL)
if (RndWalk$code != 0) stop("non converge")

cat("Transitional variance:", RndWalk$coef["level"],
    "\n", "Observational variance:", RndWalk$coef["epsilon"],
    "\n", "Initial level:", RndWalk$model0$a, "\n")
tsdiag(RndWalk)
qqnormPlot(RndWalk$residuals)

shapiro<-shapiro.test((RndWalk$residuals))
if(shapiro$p.value<=0.1) wilcox.test((pf.ts-RndWalk$fitted),y=NULL)
if(shapiro$p.value>0.1)  t.test( (pf.ts-RndWalk$fitted),alternative = c("two.sided"),mu=0)


write.table((RndWalk$fitted),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/PF/RndWalkPF.csv",append=FALSE,sep=",",row.names=FALSE)

#*********************** TiME INVARIANT #*********************** #
structTInvariant<-StructTS(pf.ts, type = c( "level") )


if (structTInvariant$code != 0) stop("non converge")

cat("Transitional variance:", structTInvariant$coef["level"],
    "\n", "Observational variance:", structTInvariant$coef["epsilon"],
    "\n", "Initial level:", structTInvariant$model0$a, "\n")
tsdiag(structTInvariant)
qqnormPlot(structTInvariant$residuals)
smoothKTI<- KalmanSmooth(pf.ts, structTInvariant$model)

shapiro<-shapiro.test((pf.ts-smoothKTI$smooth))
if(shapiro$p.value<=0.1) wilcox.test((pf.ts-smoothKTI$smooth[,1]),y=NULL)
if(shapiro$p.value>0.1)  t.test((pf.ts-smoothKTI$smooth[,1]),alternative = c("two.sided"),mu=0)

write.table((smoothKTI),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/KSmoothTimeInvariantKPF.csv",append=FALSE,sep=",",row.names=FALSE)
write.table((structTInvariant$fitted),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/PF/KFilterTimeInvariantKPF.csv",append=FALSE,sep=",",row.names=FALSE)
#*********************** TiME VARYING #*********************** #

structTVarying<-StructTS(pf.ts, type = c( "trend") )
if (structTVarying$code != 0) stop("optimizer did not converge")
tsdiag(structTVarying)
cat("Transitional variance:", structTVarying$coef["level"],
    "\n", "Slope variance:", structTVarying$coef["slope"],
    "\n", "Observational variance:", structTVarying$coef["epsilon"],
    "\n", "Initial level of m:", structTVarying$model0$a[1],
    "\n", "Initial level of beta:", structTVarying$model0$a[2],
    "\n")
tsdiag(structTVarying)

smoothKTV<- KalmanSmooth(pf.ts, structTVarying$model)
shapiro<-shapiro.test((pf.ts-smoothKTV$smooth[,1]))
if(shapiro$p.value<=0.1) wilcox.test((pf.ts-smoothKTV$smooth[,1]),y=NULL)
if(shapiro$p.value>0.1)  t.test((pf.ts-smoothKTV$smooth[,1]),alternative = c("two.sided"),mu=0)

write.table((structTVarying$fitted),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/PF/KFilterTimeVaryingPF.csv",append=FALSE,sep=",",row.names=FALSE)

###############################################################
                  # PMI #
###############################################################
summary(ur.df(pmi.ts,type=c("none"),lags=0))
summary(ur.df(pmi.ts,type=c("drift"),lags=0))
summary(ur.df(pmi.ts,type=c("trend"),lags=0))


# HP#
#*********************** HP
HodrickPrescott<-hpfilter(pmi.ts,freq=14400,type="lambda",drift=FALSE)

hpRes<-(pmi.ts-(HodrickPrescott$trend))
qqnormPlot(hpRes)
acf(hpRes)
write.table((HodrickPrescott$trend),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/PMI/HP14400PMI.csv",append=FALSE,sep=",",row.names=FALSE)
shapiro.test(hpRes)

if(shapiro$p.value<=0.1) wilcox.test((hpRes),y=NULL)
if(shapiro$p.value>0.1)  t.test(hpRes,alternative = c("two.sided"),mu=0)
Box.test(hpRes)
qqnormPlot(hpRes)
#*********************** 
HodrickPrescott<-hpfilter(pmi.ts,freq=86400,type="lambda",drift=FALSE)

hpRes<-(pmi.ts-(HodrickPrescott$trend ))

qqnormPlot(hpRes)
acf(hpRes)
write.table((HodrickPrescott$trend),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/PMI/HP86400PMI.csv",append=FALSE,sep=",",row.names=FALSE)

shapiro.test(hpRes)
t.test(hpRes,alternative = c("two.sided"),mu=0)
Box.test(hpRes)
qqnormPlot(hpRes)
#*********************** 
HodrickPrescott<-hpfilter(pmi.ts,freq=129600,type="lambda",drift=FALSE)

hpRes<-(pmi.ts-(HodrickPrescott$trend ))
qqnormPlot(hpRes)
acf(hpRes)
write.table((HodrickPrescott$trend),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/PMI/HP129600PMI.csv",append=FALSE,sep=",",row.names=FALSE)

shapiro.test(hpRes)
t.test(hpRes,alternative = c("two.sided"),mu=0)
Box.test(hpRes)
#*********************** RNDWALK PURO #***********************  #
RndWalk<-StructTS(pmi.ts, type = c( "level"), init = NULL,  fixed = c(0,NA), optim.control = NULL)
if (RndWalk$code != 0) stop("non converge")

cat("Transitional variance:", RndWalk$coef["level"],
    "\n", "Observational variance:", RndWalk$coef["epsilon"],
    "\n", "Initial level:", RndWalk$model0$a, "\n")
tsdiag(RndWalk)
qqnormPlot(RndWalk$residuals)

shapiro<-shapiro.test((pmi.ts-RndWalk$fitted))
if(shapiro$p.value<=0.1) wilcox.test((pmi.ts-RndWalk$fitted),y=NULL)
if(shapiro$p.value>0.1)  t.test( (pmi.ts-RndWalk$fitted),alternative = c("two.sided"),mu=0)

Box.test((pf.ts-RndWalk$fitted))
write.table((RndWalk$fitted),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/PMI/RndWalkPMI.csv",append=FALSE,sep=",",row.names=FALSE)

#*********************** TiME INVARIANT #*********************** #
structTInvariant<-StructTS(pmi.ts, type = c( "level") )


if (structTInvariant$code != 0) stop("non converge")

cat("Transitional variance:", structTInvariant$coef["level"],
    "\n", "Observational variance:", structTInvariant$coef["epsilon"],
    "\n", "Initial level:", structTInvariant$model0$a, "\n")
tsdiag(structTInvariant)
qqnormPlot(structTInvariant$residuals)
smoothKTI<- KalmanSmooth(pmi.ts, structTInvariant$model)
acf((pmi.ts-smoothKTI$smooth))
shapiro<-shapiro.test((structTInvariant$residuals))
if(shapiro$p.value<=0.1) wilcox.test((pmi.ts-smoothKTI$smooth[,1]),y=NULL)
if(shapiro$p.value>0.1)  t.test((pmi.ts-smoothKTI$smooth[,1]),alternative = c("two.sided"),mu=0)
Box.test((pmi.ts-smoothKTI$smooth[,1]))
write.table((smoothKTI),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/KSmoothTimeInvariantKPMI.csv",append=FALSE,sep=",",row.names=FALSE)
write.table((structTInvariant$fitted),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/PMI/KFilterTimeInvariantKPMI.csv",append=FALSE,sep=",",row.names=FALSE)
#*********************** TiME VARYING #*********************** #

structTVarying<-StructTS(pmi.ts, type = c( "trend") )
if (structTVarying$code != 0) stop("optimizer did not converge")
tsdiag(structTVarying)
cat("Transitional variance:", structTVarying$coef["level"],
    "\n", "Slope variance:", structTVarying$coef["slope"],
    "\n", "Observational variance:", structTVarying$coef["epsilon"],
    "\n", "Initial level of m:", structTVarying$model0$a[1],
    "\n", "Initial level of beta:", structTVarying$model0$a[2],
    "\n")
tsdiag(structTVarying)

smoothKTV<- KalmanSmooth(pmi.ts, structTVarying$model)
shapiro<-shapiro.test((pmi.ts-smoothKTV$smooth[,1]))
if(shapiro$p.value<=0.1) wilcox.test((pmi.ts-smoothKTV$smooth[,1]),y=NULL)
if(shapiro$p.value>0.1)  t.test((pmi.ts-smoothKTV$smooth[,1]),alternative = c("two.sided"),mu=0)
Box.test((pmi.ts-smoothKTV$smooth[,1]))

Box.test((pmi.ts-smoothKTV$smooth[,1]))
write.table((structTVarying$fitted),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/PMI/KFilterTimeVaryingPMI.csv",append=FALSE,sep=",",row.names=FALSE)

###############################################################
                  # PRIVATE #
###############################################################
summary(ur.df(private.ts,type=c("none"),lags=0))
summary(ur.df(private.ts,type=c("drift"),lags=0))
summary(ur.df(private.ts,type=c("trend"),lags=0))


# HP#
#*********************** HP
HodrickPrescott<-hpfilter(private.ts,freq=14400,type="lambda",drift=FALSE)

hpRes<-(private.ts-(HodrickPrescott$trend))
qqnormPlot(hpRes)
acf(hpRes)
write.table((HodrickPrescott$trend),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/PRIVATE/HP14400PRIVATE.csv",append=FALSE,sep=",",row.names=FALSE)
shapiro.test(hpRes)

if(shapiro$p.value<=0.1) wilcox.test((hpRes),y=NULL)
if(shapiro$p.value>0.1)  t.test(hpRes,alternative = c("two.sided"),mu=0)
Box.test(hpRes)

qqnormPlot(hpRes)
#*********************** 
HodrickPrescott<-hpfilter(private.ts,freq=86400,type="lambda",drift=FALSE)

hpRes<-(private.ts-(HodrickPrescott$trend ))
qqnormPlot(hpRes)
acf(hpRes)
write.table((HodrickPrescott$trend),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/PRIVATE/HP86400PRIVATE.csv",append=FALSE,sep=",",row.names=FALSE)

shapiro.test(hpRes)
t.test(hpRes,alternative = c("two.sided"),mu=0)
Box.test(hpRes)
qqnormPlot(hpRes)
#*********************** 
HodrickPrescott<-hpfilter(private.ts,freq=129600,type="lambda",drift=FALSE)

hpRes<-(private.ts-(HodrickPrescott$trend ))
qqnormPlot(hpRes)
acf(hpRes)
write.table((HodrickPrescott$trend),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/PRIVATE/HP129600PRIVATE.csv",append=FALSE,sep=",",row.names=FALSE)

shapiro.test(hpRes)
wilcox.test((hpRes),y=NULL)
t.test(hpRes,alternative = c("two.sided"),mu=0)
Box.test(hpRes)
#*********************** RNDWALK PURO #***********************  #
RndWalk<-StructTS(private.ts, type = c( "level"), init = NULL,  fixed = c(0,NA), optim.control = NULL)
if (RndWalk$code != 0) stop("non converge")

cat("Transitional variance:", RndWalk$coef["level"],
    "\n", "Observational variance:", RndWalk$coef["epsilon"],
    "\n", "Initial level:", RndWalk$model0$a, "\n")
tsdiag(RndWalk)
qqnormPlot(RndWalk$residuals)
acf(RndWalk$residuals)
shapiro<-shapiro.test((private.ts-RndWalk$fitted))
if(shapiro$p.value<=0.1) wilcox.test((private.ts-RndWalk$fitted),y=NULL)
if(shapiro$p.value>0.1)  t.test( (private.ts-RndWalk$fitted),alternative = c("two.sided"),mu=0)

Box.test((private.ts-RndWalk$fitted))
write.table((RndWalk$fitted),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/PRIVATE/RndWalkPRIVATE.csv",append=FALSE,sep=",",row.names=FALSE)

#*********************** TiME INVARIANT #*********************** #
structTInvariant<-StructTS(private.ts, type = c( "level") )


if (structTInvariant$code != 0) stop("non converge")

cat("Transitional variance:", structTInvariant$coef["level"],
    "\n", "Observational variance:", structTInvariant$coef["epsilon"],
    "\n", "Initial level:", structTInvariant$model0$a, "\n")
tsdiag(structTInvariant)
smoothKTI<- KalmanSmooth(private.ts, structTInvariant$model)
qqnormPlot((structTInvariant$residuals))
acf((structTInvariant$residuals))
shapiro<-shapiro.test((private.ts-smoothKTI$smooth))
if(shapiro$p.value<=0.1) wilcox.test((private.ts-smoothKTI$smooth[,1]),y=NULL)
if(shapiro$p.value>0.1)  t.test((private.ts-smoothKTI$smooth[,1]),alternative = c("two.sided"),mu=0)
Box.test((private.ts-smoothKTI$smooth[,1]))
write.table((smoothKTI),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/KSmoothTimeInvariantKPRIVATE.csv",append=FALSE,sep=",",row.names=FALSE)
write.table((structTInvariant$fitted),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/PRIVATE/KFilterTimeInvariantKPRIVATE.csv",append=FALSE,sep=",",row.names=FALSE)

#*********************** TiME VARYING #*********************** #

structTVarying<-StructTS(private.ts, type = c( "trend") )
if (structTVarying$code != 0) stop("optimizer did not converge")
tsdiag(structTVarying)
cat("Transitional variance:", structTVarying$coef["level"],
    "\n", "Slope variance:", structTVarying$coef["slope"],
    "\n", "Observational variance:", structTVarying$coef["epsilon"],
    "\n", "Initial level of m:", structTVarying$model0$a[1],
    "\n", "Initial level of beta:", structTVarying$model0$a[2],
    "\n")
tsdiag(structTVarying)

smoothKTV<- KalmanSmooth(private.ts, structTVarying$model)
shapiro<-shapiro.test((private.ts-smoothKTV$smooth[,1]))
if(shapiro$p.value<=0.1) wilcox.test((private.ts-smoothKTV$smooth[,1]),y=NULL)
if(shapiro$p.value>0.1)  t.test((private.ts-smoothKTV$smooth[,1]),alternative = c("two.sided"),mu=0)
Box.test((private.ts-smoothKTV$smooth[,1]))

Box.test((private.ts-smoothKTV$smooth[,1]))
write.table((structTVarying$fitted),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/PRIVATE/KFilterTimeVaryingPRIVATE.csv",append=FALSE,sep=",",row.names=FALSE)

###############################################################
                # SB #
###############################################################
summary(ur.df(sb.ts,type=c("none"),lags=0))
summary(ur.df(sb.ts,type=c("drift"),lags=0))
summary(ur.df(sb.ts,type=c("trend"),lags=0))

# HP#
#*********************** HP
HodrickPrescott<-hpfilter(sb.ts,freq=14400,type="lambda",drift=FALSE)

hpRes<-(sb.ts-(HodrickPrescott$trend))
qqnormPlot(hpRes)
acf(hpRes)
write.table((HodrickPrescott$trend),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/SB/HP14400SB.csv",append=FALSE,sep=",",row.names=FALSE)
shapiro.test(hpRes)

if(shapiro$p.value<=0.1) wilcox.test((hpRes),y=NULL)
if(shapiro$p.value>0.1)  t.test(hpRes,alternative = c("two.sided"),mu=0)
acf(hpRes)

qqnormPlot(hpRes)
#*********************** 
HodrickPrescott<-hpfilter(sb.ts,freq=86400,type="lambda",drift=FALSE)

hpRes<-(sb.ts-(HodrickPrescott$trend ))
qqnormPlot(hpRes)
acf(hpRes)
write.table((HodrickPrescott$trend),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/SB/HP86400SB.csv",append=FALSE,sep=",",row.names=FALSE)

shapiro.test(hpRes)
t.test(hpRes,alternative = c("two.sided"),mu=0)
wilcox.test((hpRes),y=NULL)
acf(hpRes)
Box.test(hpRes)
qqnormPlot(hpRes)
#*********************** 
HodrickPrescott<-hpfilter(sb.ts,freq=129600,type="lambda",drift=FALSE)

hpRes<-(sb.ts-(HodrickPrescott$trend ))
qqnormPlot(hpRes)
acf(hpRes)
write.table((HodrickPrescott$trend),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/SB/HP129600SB.csv",append=FALSE,sep=",",row.names=FALSE)

shapiro.test(hpRes)
wilcox.test((hpRes),y=NULL)
acf(hpRes)
t.test(hpRes,alternative = c("two.sided"),mu=0)
Box.test(hpRes)
#*********************** RNDWALK PURO #***********************  #
RndWalk<-StructTS(sb.ts, type = c( "level"), init = NULL,  fixed = c(0,NA), optim.control = NULL)
if (RndWalk$code != 0) stop("non converge")

cat("Transitional variance:", RndWalk$coef["level"],
    "\n", "Observational variance:", RndWalk$coef["epsilon"],
    "\n", "Initial level:", RndWalk$model0$a, "\n")
tsdiag(RndWalk)
qqnormPlot(RndWalk$residuals)
shapiro<-shapiro.test((sb.ts-RndWalk$fitted))
if(shapiro$p.value<=0.1) wilcox.test((sb.ts-RndWalk$fitted),y=NULL)
if(shapiro$p.value>0.1)  t.test( (sb.ts-RndWalk$fitted),alternative = c("two.sided"),mu=0)

Box.test((sb.ts-RndWalk$fitted))
write.table((RndWalk$fitted),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/SB/RndWalkSB.csv",append=FALSE,sep=",",row.names=FALSE)

#*********************** TiME INVARIANT #*********************** #
structTInvariant<-StructTS(sb.ts, type = c( "level") )


if (structTInvariant$code != 0) stop("non converge")

cat("Transitional variance:", structTInvariant$coef["level"],
    "\n", "Observational variance:", structTInvariant$coef["epsilon"],
    "\n", "Initial level:", structTInvariant$model0$a, "\n")
tsdiag(structTInvariant)
qqnormPlot(structTInvariant$residuals)

smoothKTI<- KalmanSmooth(sb.ts, structTInvariant$model)
acf((sb.ts-smoothKTI$smooth))
shapiro<-shapiro.test((sb.ts-smoothKTI$smooth))
if(shapiro$p.value<=0.1) wilcox.test((sb.ts-smoothKTI$smooth[,1]),y=NULL)
if(shapiro$p.value>0.1)  t.test((sb.ts-smoothKTI$smooth[,1]),alternative = c("two.sided"),mu=0)
Box.test((sb.ts-smoothKTI$smooth[,1]))
write.table((smoothKTI),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/KSmoothTimeInvariantKSB.csv",append=FALSE,sep=",",row.names=FALSE)
write.table((structTInvariant$fitted),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/SB/KFilterimeInvariantKSB.csv",append=FALSE,sep=",",row.names=FALSE)

#*********************** TiME VARYING #*********************** #

structTVarying<-StructTS(sb.ts, type = c( "trend") )
if (structTVarying$code != 0) stop("optimizer did not converge")
tsdiag(structTVarying)
cat("Transitional variance:", structTVarying$coef["level"],
    "\n", "Slope variance:", structTVarying$coef["slope"],
    "\n", "Observational variance:", structTVarying$coef["epsilon"],
    "\n", "Initial level of m:", structTVarying$model0$a[1],
    "\n", "Initial level of beta:", structTVarying$model0$a[2],
    "\n")
tsdiag(structTVarying)

smoothKTV<- KalmanSmooth(sb.ts, structTVarying$model)
shapiro<-shapiro.test((sb.ts-smoothKTV$smooth[,1]))
if(shapiro$p.value<=0.1) wilcox.test((sb.ts-smoothKTV$smooth[,1]),y=NULL)
if(shapiro$p.value>0.1)  t.test((sb.ts-smoothKTV$smooth[,1]),alternative = c("two.sided"),mu=0)
Box.test((sb.ts-smoothKTV$smooth[,1]))

Box.test((sb.ts-smoothKTV$smooth[,1]))
write.table((structTVarying$fitted),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/SB/KFilterTimeVaryingSB.csv",append=FALSE,sep=",",row.names=FALSE)

###############################################################
                # DR #
###############################################################
summary(ur.df(dr.ts,type=c("none"),lags=0))
summary(ur.df(dr.ts,type=c("drift"),lags=0))
summary(ur.df(dr.ts,type=c("trend"),lags=0))

lambda=86400
HodrickPrescott<-hpfilter(dr.ts,freq=lambda,type="lambda",drift=FALSE)
hpRes<-(dr.ts-(HodrickPrescott$trend))
BoxTest=Box.test(hpRes)
shapiro.test(hpRes)


lambda=22258
HodrickPrescott<-hpfilter(dr.ts,freq=lambda,type="lambda",drift=FALSE)
hpRes<-(dr.ts-(HodrickPrescott$trend))
BoxTest=Box.test(hpRes)
shapiro=shapiro.test(hpRes)

plot(HodrickPrescott$trend)
while(BoxTest$p.value<0.01 ) {
  lambda=lambda+1
  HodrickPrescott<-hpfilter(dr.ts,freq=lambda,type="lambda",drift=FALSE)
  hpRes<-(dr.ts-(HodrickPrescott$trend))
  shapiro=shapiro.test(hpRes)
  BoxTest=Box.test(hpRes)}

shapiro.test(hpRes)
Box.test(hpRes)
# HP#
write.table((HodrickPrescott$trend),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/DR/HP14400DR.csv",append=FALSE,sep=",",row.names=FALSE)
#*********************** HP
HodrickPrescott<-hpfilter(dr.ts,freq=14400,type="lambda",drift=FALSE)

hpRes<-(dr.ts-(HodrickPrescott$trend))
acf( hpRes)
qqnormPlot( hpRes)
write.table((HodrickPrescott$trend),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/DR/HP14400DR.csv",append=FALSE,sep=",",row.names=FALSE)
shapiro.test(hpRes)

if(shapiro$p.value<=0.1) wilcox.test((hpRes),y=NULL)
if(shapiro$p.value>0.1)  t.test(hpRes,alternative = c("two.sided"),mu=0)
Box.test(hpRes)
acf(hpRes)
qqnormPlot(hpRes)
#*********************** 
HodrickPrescott<-hpfilter(dr.ts,freq=86400,type="lambda",drift=FALSE)

hpRes<-(dr.ts-(HodrickPrescott$trend ))
acf( hpRes)
qqnormPlot( hpRes)
write.table((HodrickPrescott$trend),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/DR/HP86400DR.csv",append=FALSE,sep=",",row.names=FALSE)

shapiro.test(hpRes)
t.test(hpRes,alternative = c("two.sided"),mu=0)
Box.test(hpRes)
qqnormPlot(hpRes)
#*********************** 
HodrickPrescott<-hpfilter(dr.ts,freq=129600,type="lambda",drift=FALSE)

hpRes<-(dr.ts-(HodrickPrescott$trend ))
acf( hpRes)
qqnormPlot( hpRes)
write.table((HodrickPrescott$trend),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/DR/HP129600DR.csv",append=FALSE,sep=",",row.names=FALSE)

shapiro.test(hpRes)
wilcox.test((hpRes),y=NULL)
t.test(hpRes,alternative = c("two.sided"),mu=0)
Box.test(hpRes)
acf(hpRes)

#*********************** RNDWALK PURO #***********************  #
RndWalk<-StructTS(dr.ts, type = c( "trend"), init = NULL,  fixed = c(0,NA), optim.control = NULL)
if (RndWalk$code != 0) stop("non converge")

cat("Transitional variance:", RndWalk$coef["level"],
    "\n", "Observational variance:", RndWalk$coef["epsilon"],
    "\n", "Initial level:", RndWalk$model0$a, "\n")
tsdiag(RndWalk)
qqnormPlot(RndWalk$residuals)

shapiro<-shapiro.test((dr.ts-RndWalk$fitted))
if(shapiro$p.value<=0.1) wilcox.test((dr.ts-RndWalk$fitted),y=NULL)
if(shapiro$p.value>0.1)  t.test( (dr.ts-RndWalk$fitted),alternative = c("two.sided"),mu=0)
acf((dr.ts-RndWalk$fitted))
Box.test((dr.ts-RndWalk$fitted))
write.table((RndWalk$fitted),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/DR/RndWalkDR.csv",append=FALSE,sep=",",row.names=FALSE)

#*********************** TiME INVARIANT #*********************** #
structTInvariant<-StructTS(dr.ts, type = c( "level") )


if (structTInvariant$code != 0) stop("non converge")

cat("Transitional variance:", structTInvariant$coef["level"],
    "\n", "Observational variance:", structTInvariant$coef["epsilon"],
    "\n", "Initial level:", structTInvariant$model0$a, "\n")
tsdiag(structTInvariant)
qqnormPlot(structTInvariant$residuals)
smoothKTI<- KalmanSmooth(dr.ts, structTInvariant$model)
smoothKTI<- tsSmooth(structTInvariant)
acf((dr.ts-smoothKTI$smooth))
shapiro<-shapiro.test((dr.ts-smoothKTI$smooth))
if(shapiro$p.value<=0.1) wilcox.test((dr.ts-smoothKTI$smooth[,1]),y=NULL)
if(shapiro$p.value>0.1)  t.test((dr.ts-smoothKTI$smooth[,1]),alternative = c("two.sided"),mu=0)
Box.test((dr.ts-smoothKTI$smooth[,1]))
write.table((smoothKTI),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/KSmoothTimeInvariantKDR.csv",append=FALSE,sep=",",row.names=FALSE)
write.table((structTInvariant$fitted),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/DR/KFilterTimeInvariantKDR.csv",append=FALSE,sep=",",row.names=FALSE)
#*********************** TiME VARYING #*********************** #

structTVarying<-StructTS(dr.ts, type = c( "trend") )
if (structTVarying$code != 0) stop("optimizer did not converge")
tsdiag(structTVarying)
cat("Transitional variance:", structTVarying$coef["level"],
    "\n", "Slope variance:", structTVarying$coef["slope"],
    "\n", "Observational variance:", structTVarying$coef["epsilon"],
    "\n", "Initial level of m:", structTVarying$model0$a[1],
    "\n", "Initial level of beta:", structTVarying$model0$a[2],
    "\n")
tsdiag(structTVarying)

smoothKTV<- KalmanSmooth(dr.ts, structTVarying$model)
shapiro<-shapiro.test((dr.ts-smoothKTV$smooth[,1]))
if(shapiro$p.value<=0.1) wilcox.test((dr.ts-smoothKTV$smooth[,1]),y=NULL)
if(shapiro$p.value>0.1)  t.test((dr.ts-smoothKTV$smooth[,1]),alternative = c("two.sided"),mu=0)
Box.test((dr.ts-smoothKTV$smooth[,1]))
acf((dr.ts-smoothKTV$smooth[,1]))
Box.test((dr.ts-smoothKTV$smooth[,1]))
write.table((smoothKTV),"/mnt/R/labdata/TEMP/CorsoR/SettoreAlm/ALM/output/kalman/DR/KFilterTimeVaryingDR.csv",append=FALSE,sep=",",row.names=FALSE)
