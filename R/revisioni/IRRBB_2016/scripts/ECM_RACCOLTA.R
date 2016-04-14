#Initialize()
library(quadprog)
library(zoo)
library(lmtest)
library(tseries)
library(stats)
#library(bstats)
library(urca)
library(package="mFilter") #,lib.loc=g_RLIB_DIR) #pacchetto installato successivamente
library(vars)
library(FactoMineR)
library(lubridate)

# ********************************* ******************
# *********** ORDINE DI INTEGRAZIONE ***********
# ********************************* ******************
# ********************************* ******************
TS_Conitegrazione<- read.csv("ECM_RACCOLTA_INPUT.csv",header = TRUE, sep = ";")
attach(TS_Conitegrazione)
euribor1m.ts<-ts(TS_Conitegrazione[,9],start=c(2008,2),end=c(2015,7),frequency = 12)
cds.ts<-ts(TS_Conitegrazione[,10],start=c(2008,2),end=c(2015,7),frequency = 12)

# ***************** Euribor 1M (avg monthly)  ******************
euribor1m.ts.adf.test   <- ur.df(euribor1m.ts,type="drift",selectlags="AIC")
euribor1m.ts.adf.test.d <- ur.df(diff(euribor1m.ts,1),type="drift",selectlags="AIC")
summary(euribor1m.ts.adf.test)
summary(euribor1m.ts.adf.test.d)


print("Augmented Dickey-Fuller Test (Serie originaria)")
euribor1m.ts.adf.test@teststat
euribor1m.ts.adf.test@cval
print("Augmented Dickey-Fuller Test (Differenze prime)")
euribor1m.ts.adf.test.d@teststat
euribor1m.ts.adf.test.d@cval

# ***************** CDS MPS Snr 5Y  (avg monthly)******************

cds.ts.adf.test<-ur.df(cds.ts,type="drift",selectlags="AIC")
cds.ts.adf.test.d<-ur.df(diff(cds.ts,1),type="none",selectlags="AIC")
summary(cds.ts.adf.test)
summary(cds.ts.adf.test.d)
print("Augmented Dickey-Fuller Test (Serie originaria)")
cds.ts.adf.test@teststat
cds.ts.adf.test@cval

print("Augmented Dickey-Fuller Test (Differenze prime)")
cds.ts.adf.test.d@teststat
cds.ts.adf.test.d@cval


# *******************VAR DIPENDENTI ************************

# *******************KEY CLIENT *****************

kc.ts<-ts(TS_Conitegrazione[,2],start=c(2008,2),end=c(2015,7),frequency = 12)
kc.ts.adf.test<-ur.df(kc.ts,type="drift",selectlags="AIC")
kc.ts.adf.test.d<-ur.df(diff(kc.ts,1),type="drift",selectlags="AIC")
summary(kc.ts.adf.test)
summary(kc.ts.adf.test.d)


print("Augmented Dickey-Fuller Test (Serie originaria)")
kc.ts.adf.test@teststat
kc.ts.adf.test@cval

print("Augmented Dickey-Fuller Test (Differenze prime)")
kc.ts.adf.test.d@teststat
kc.ts.adf.test.d@cval

# ****************** ENTI *****************
enti.ts<-ts(TS_Conitegrazione[,3],start=c(2008,2),end=c(2015,7),frequency = 12)
enti.ts.adf.test<-ur.df(enti.ts,type="drift",selectlags="AIC")
enti.ts.adf.test.d<-ur.df(diff(enti.ts,1),type="drift",selectlags="AIC")
summary(enti.ts.adf.test)
summary(enti.ts.adf.test.d)

print("Augmented Dickey-Fuller Test (Serie originaria)")
enti.ts.adf.test@teststat
enti.ts.adf.test@cval

print("Augmented Dickey-Fuller Test (Differenze prime)")
enti.ts.adf.test.d@teststat
enti.ts.adf.test.d@cval

# *******************PMI *****************
pmi.ts<-ts(TS_Conitegrazione[,4],start=c(2008,2),end=c(2015,7),frequency = 12)
pmi.ts.adf.test<-ur.df(pmi.ts,type="drift",selectlags="AIC")
pmi.ts.adf.test.d<-ur.df(diff(pmi.ts,1),type="drift",selectlags="AIC")
summary(pmi.ts.adf.test)
summary(pmi.ts.adf.test.d)

print("Augmented Dickey-Fuller Test (Serie originaria)")
pmi.ts.adf.test@teststat
pmi.ts.adf.test@cval

print("Augmented Dickey-Fuller Test (Differenze prime)")
pmi.ts.adf.test.d@teststat
pmi.ts.adf.test.d@cval

# *******************PRIVATE *****************
private.ts<-ts(TS_Conitegrazione[,5],start=c(2008,2),end=c(2015,7),frequency = 12)
private.ts.adf.test<-ur.df(private.ts,type="drift",selectlags="AIC")
private.ts.adf.test.d<-ur.df(diff(private.ts,1),type="drift",selectlags="AIC")
summary(private.ts.adf.test)
summary(private.ts.adf.test.d)

print("Augmented Dickey-Fuller Test (Serie originaria)")
private.ts.adf.test@teststat
private.ts.adf.test@cval

print("Augmented Dickey-Fuller Test (Differenze prime)")
private.ts.adf.test.d@teststat
private.ts.adf.test.d@cval

# *******************SMALL BUSINESS *****************
sb.ts<-ts(TS_Conitegrazione[,6],start=c(2008,2),end=c(2015,7),frequency = 12)
sb.ts.adf.test<-ur.df(sb.ts,type="drift",selectlags="AIC")
sb.ts.adf.test.d<-ur.df(diff(sb.ts,1),type="drift",selectlags="AIC")
summary(sb.ts.adf.test)
summary(sb.ts.adf.test.d)

print("Augmented Dickey-Fuller Test (Serie originaria)")
sb.ts.adf.test@teststat
sb.ts.adf.test@cval

print("Augmented Dickey-Fuller Test (Differenze prime)")
sb.ts.adf.test.d@teststat
sb.ts.adf.test.d@cval

# *******************PF *****************
pf.ts<-ts(TS_Conitegrazione[,7],start=c(2008,2),end=c(2015,7),frequency = 12)
pf.ts.adf.test<-ur.df(pf.ts,type="drift",selectlags="AIC")
pf.ts.adf.test.d<-ur.df(diff(pf.ts,1),type="drift",selectlags="AIC")
summary(pf.ts.adf.test)
summary(pf.ts.adf.test.d)

print("Augmented Dickey-Fuller Test (Serie originaria)")
pf.ts.adf.test@teststat
pf.ts.adf.test@cval

print("Augmented Dickey-Fuller Test (Differenze prime)")
pf.ts.adf.test.d@teststat
pf.ts.adf.test.d@cval


# *******************DR ********************
dr.ts<-ts(TS_Conitegrazione[,8],start=c(2008,2),end=c(2015,7),frequency = 12)
dr.ts.adf.test<-ur.df(dr.ts,type="drift",selectlags="AIC")
dr.ts.adf.test.d<-ur.df(diff(dr.ts,1),type="drift",selectlags="AIC")
summary(dr.ts.adf.test)
summary(dr.ts.adf.test.d)

print("Augmented Dickey-Fuller Test (Serie originaria)")
dr.ts.adf.test@teststat
dr.ts.adf.test@cval

print("Augmented Dickey-Fuller Test (Differenze prime)")
dr.ts.adf.test.d@teststat
dr.ts.adf.test.d@cval

# *******************PF FIX*****************
pf_fix.ts<-ts(TS_Conitegrazione[,11],start=c(2008,2),end=c(2015,7),frequency = 12)
pf_fix.ts.adf.test<-ur.df(pf_fix.ts,type="drift",selectlags="AIC")
pf_fix.ts.adf.test.d<-ur.df(diff(pf_fix.ts,1),type="drift",selectlags="AIC")
summary(pf_fix.ts.adf.test)
summary(pf_fix.ts.adf.test.d)

print("Augmented Dickey-Fuller Test (Serie originaria)")
pf_fix.ts.adf.test@teststat
pf_fix.ts.adf.test@cval

print("Augmented Dickey-Fuller Test (Differenze prime)")
pf_fix.ts.adf.test.d@teststat
pf_fix.ts.adf.test.d@cval


# *******************PF FLOAT*****************
pf_flt.ts<-ts(TS_Conitegrazione[,12],start=c(2008,2),end=c(2015,7),frequency = 12)
pf_flt.ts.adf.test<-ur.df(pf_flt.ts,type="drift",selectlags="AIC")
pf_flt.ts.adf.test.d<-ur.df(diff(pf_flt.ts,1),type="drift",selectlags="AIC")
summary(pf_flt.ts.adf.test)
summary(pf_flt.ts.adf.test.d)

print("Augmented Dickey-Fuller Test (Serie originaria)")
pf_flt.ts.adf.test@teststat
pf_flt.ts.adf.test@cval

print("Augmented Dickey-Fuller Test (Differenze prime)")
pf_flt.ts.adf.test.d@teststat
pf_flt.ts.adf.test.d@cval

############################################################################################## 
############################### ECM #############################################
###############################  VIA SINGOLA EQUAZIONE ###########################################
############################################################################################## 


################# KC ################# 
lm_KC_EURIBOR_CDS<-lm(formula=kc.ts~0+euribor1m.ts+cds.ts,data=TS_Conitegrazione)
summary(lm_KC_EURIBOR_CDS)
res_kc<-lm_KC_EURIBOR_CDS$residuals[1:length(lm_KC_EURIBOR_CDS$residuals)-1]
delta_tasso<-diff(kc.ts)
gamma<-diff(euribor1m.ts,1)
rho<-diff(cds.ts,1)
lm_ECM_KC<-lm(formula=delta_tasso~0+res_kc+gamma,data=TS_Conitegrazione)
summary(lm_ECM_KC) 



################# ENTI ################# 

lm_ENTI_EURIBOR_CDS<-lm(formula=enti.ts~0+euribor1m.ts+cds.ts,data=TS_Conitegrazione)
summary(lm_ENTI_EURIBOR_CDS)
res_enti<-lm_ENTI_EURIBOR_CDS$residuals[1:length(lm_ENTI_EURIBOR_CDS$residuals)-1]
delta_tasso<-diff(enti.ts)
gamma<-diff(euribor1m.ts,1)
rho<-diff(cds.ts,1)
lm_ECM_ENTI<-lm(formula=delta_tasso~0+res_enti+gamma,data=TS_Conitegrazione)
summary(lm_ECM_ENTI)


################# PMI ################# 

lm_PMI_EURIBOR_CDS<-lm(formula=pmi.ts~0+euribor1m.ts+cds.ts,data=TS_Conitegrazione)
summary(lm_PMI_EURIBOR_CDS)
res_pmi<-lm_PMI_EURIBOR_CDS$residuals[1:length(lm_PMI_EURIBOR_CDS$residuals)-1]
delta_tasso<-diff(pmi.ts)
gamma<-diff(euribor1m.ts,1)
rho<-diff(cds.ts,1)
lm_ECM_PMI<-lm(formula=delta_tasso~0+res_pmi+gamma,data=TS_Conitegrazione)
summary(lm_ECM_PMI)




################# SB ################# 

lm_SB_EURIBOR_CDS<-lm(formula=sb.ts~0+euribor1m.ts+cds.ts,data=TS_Conitegrazione)
summary(lm_SB_EURIBOR_CDS)
res_sb<-lm_SB_EURIBOR_CDS$residuals[1:length(lm_SB_EURIBOR_CDS$residuals)-1]
delta_tasso<-diff(sb.ts)
gamma<-diff(euribor1m.ts,1)
rho<-diff(cds.ts,1)
lm_ECM_SB<-lm(formula=delta_tasso~0+res_sb+gamma,data=TS_Conitegrazione)
summary(lm_ECM_SB)


################# PRIVATE ################# 

lm_PRIVATE_EURIBOR_CDS<-lm(formula=private.ts~0+euribor1m.ts+cds.ts,data=TS_Conitegrazione)
summary(lm_PRIVATE_EURIBOR_CDS)
res_private<-lm_PRIVATE_EURIBOR_CDS$residuals[1:length(lm_PRIVATE_EURIBOR_CDS$residuals)-1]
delta_tasso<-diff(private.ts)
gamma<-diff(euribor1m.ts,1)
rho<-diff(cds.ts,1)
lm_ECM_PRIVATE<-lm(formula=delta_tasso~0+res_private+gamma,data=TS_Conitegrazione)
summary(lm_ECM_PRIVATE)



################# PF FIX ################# 

lm_PF_FIX_EURIBOR_CDS<-lm(formula=pf_fix.ts~0+euribor1m.ts+cds.ts,data=TS_Conitegrazione)
summary(lm_PF_FIX_EURIBOR_CDS)
res_pf_fix<-lm_PF_FIX_EURIBOR_CDS$residuals[1:length(lm_PF_FIX_EURIBOR_CDS$residuals)-1]
delta_tasso<-diff(pf_fix.ts)
gamma<-diff(euribor1m.ts,1)
rho<-diff(cds.ts,1)
lm_ECM_PF_FIX<-lm(formula=delta_tasso~0+res_pf_fix+gamma,data=TS_Conitegrazione)
summary(lm_ECM_PF_FIX)



################# PF FLOAT ################# 

lm_PF_FLOAT_EURIBOR_CDS<-lm(formula=pf_flt.ts~euribor1m.ts+cds.ts,data=TS_Conitegrazione)
summary(lm_PF_FLOAT_EURIBOR_CDS)
res_pf_flt_appo<-pf_flt.ts-replace(lm_PF_FLOAT_EURIBOR_CDS$fitted.values,lm_PF_FLOAT_EURIBOR_CDS$fitted.values<0,0)
res_pf_flt<-res_pf_flt_appo[1:length(res_pf_flt_appo)-1]
delta_tasso<-diff(pf_flt.ts)
gamma<-diff(euribor1m.ts,1)
rho<-diff(cds.ts,1)
lm_ECM_PF_FLT<-lm(formula=delta_tasso~0+res_pf_flt+gamma,data=TS_Conitegrazione)
summary(lm_ECM_PF_FLT)



################# DR ################# 

lm_DR_EURIBOR_CDS<-lm(formula=dr.ts~0+euribor1m.ts+cds.ts,data=TS_Conitegrazione)
summary(lm_DR_EURIBOR_CDS)
res_dr<-lm_DR_EURIBOR_CDS$residuals[1:length(lm_DR_EURIBOR_CDS$residuals)-1]
delta_tasso<-diff(dr.ts)
gamma<-diff(euribor1m.ts,1)
rho<-diff(cds.ts,1)
lm_ECM_DR<-lm(formula=delta_tasso~0+res_dr+gamma,data=TS_Conitegrazione)
summary(lm_ECM_DR)


