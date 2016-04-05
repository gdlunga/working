# IMPORTARE DATI DA MAC
# dati<= read.csv("~/Desktop/dati.csv", sep=";", dec=",")
# View(dati)

# IMPORTARE DATI DA PDL
#setwd("/mnt/R/labdata/Audit/RAF/R/src_bin")
#library(CogUtils)
#Initialize()

g_INPUT_DIR="/Users/giovanni/Google Drive/Programming/R/RAF/input"
file_ind=paste("dati.csv",sep="") 
dati=read.csv2(file=paste(g_INPUT_DIR,file_ind,sep="/"),1)

# PREDISPOSIZIONE DATA FRAME
rownames(dati)=dati$Anno
dati=dati[2:14]
dati_m=as.matrix(dati)

#SEZIONE STIMA DISTRIBUZIONI
library(MASS)

#PER ALCUNE DISTRIBUZIONI SERVONO DATI POSITIVI, PERTANTO INDIVIDUO IL MIN DI TUTTI I DATI E POI TRASLO
trasl=round(abs(min(dati)),digits=1) + 0.1
if (min(dati) <0) dati_2=dati+trasl



#####################################################################################################
# STIMA MASSIMA VEROSIMIGLIANZA
#####################################################################################################
stime = matrix( , nrow=10,ncol=13)
colnames(stime) = colnames(dati)
akaike=matrix( , nrow=15,ncol=13)
colnames(akaike) = colnames(dati)
test_ks = matrix( , nrow=10,ncol=13)
colnames(test_ks) = colnames(dati)
# STIMA PARAMETRI
for (i in 1:13) {
  # Normale - Parametri
  fit_N = c()
  fit_N=tryCatch({(fitdistr(dati_2[,i],densfun="normal"))$estimate},error=function(err){return(-99)})
  fit_N=as.vector(fit_N)
  if (fit_N[1]==-99) stime[1,i]=stime[2,i]=0 else for (j in 1:length(fit_N)) {stime[j,i]=fit_N[j]}
  # Normale - akaike
  logL_N=tryCatch({(fitdistr(dati_2[,i],densfun="normal"))$loglik},error=function(err){return(-99)})
  if (logL_N==-99) akaike[1,i]=akaike[2,i]=akaike[3,i]=0 else {
    k_N<-length(fit_N)
    n_N<-length(dati_2[,i])
    AICC_N = 2*k_N*n_N / (n_N-k_N-1 )  -   2*logL_N 
    akaike[1,i] = AICC_N
    AIC_N<- 2*k_N - 2*logL_N
    akaike[2,i] = AIC_N
    BIC_N<- k_N*log(n_N) - 2*logL_N
    akaike[3,i] = BIC_N
  }
  # Normale - kolmogorov - smirnov
  if (fit_N[1]==-99) test_ks[1,i]=test_ks[2,i]=0 else {
    Norm_Sim<-fit_N[1] + fit_N[2]*rnorm(1000000)   #- 0.2
    ks_N=ks.test(Norm_Sim, dati_2[,i])
    ks_N=as.vector(c(ks_N$statistic,ks_N$p.value))
    for (j in 1:length(ks_N)) {test_ks[j,i]=ks_N[j]} 
  }
  # Log Normale
  fit_LN = c()
  fit_LN=tryCatch({(fitdistr(dati_2[,i],densfun="log-normal"))$estimate},error=function(err){return(-99)})
  if (fit_LN==-99) stime[3,i]=stime[4,i]=0 else for (j in 1:length(fit_LN)) {stime[j+2,i]=fit_LN[j]}
  # lOG Normale - akaike
  logL_LN=tryCatch({(fitdistr(dati_2[,i],densfun="log-normal"))$loglik},error=function(err){return(-99)})
  if (logL_LN==-99) akaike[4,i]=akaike[5,i]=akaike[6,i]=0 else {
    k_LN<-length(fit_LN)
    n_LN<-length(dati_2[,i])
    AICC_LN = 2*k_LN*n_LN / (n_LN-k_LN-1 )  -   2*logL_LN 
    akaike[4,i] = AICC_LN
    AIC_LN<- 2*k_LN - 2*logL_LN
    akaike[5,i] = AIC_LN
    BIC_LN<- k_LN*log(n_LN) - 2*logL_LN
    akaike[6,i] = BIC_LN
  }
  # LOG Normale - kolmogorov - smirnov
  if (fit_LN[1]==-99) test_ks[3,i]=test_ks[4,i]=0 else {
    LogNorm_Sim<-rlnorm(1000000, fit_LN[1] , fit_LN[2])   #- 0.2   
    ks_LN=ks.test(LogNorm_Sim, dati_2[,i])
    ks_LN=as.vector(c(ks_LN$statistic,ks_LN$p.value))
    for (j in 1:length(ks_LN)) {test_ks[j+2,i]=ks_LN[j]} 
  }
  # T Student
  fit_T = c()
  fit_T=tryCatch({(fitdistr(dati_2[,i], densfun = "t"))$estimate}, error= function(err) {return(-99)})
  if (fit_T==-99) stime[5,i]=stime[6,i]=stime[7,i]=0 else for (j in 1:length(fit_T)) {stime[j+4,i]=fit_T[j]}
  # T Student - akaike
  logL_T=tryCatch({(fitdistr(dati_2[,i],densfun="t"))$loglik},error=function(err){return(-99)})
  if (logL_T==-99) akaike[7,i]=akaike[8,i]=akaike[9,i]=0 else {
    k_T<-length(fit_T)
    n_T<-length(dati_2[,i])
    AICC_T = 2*k_T*n_T / (n_T-k_T-1 )  -   2*logL_T 
    akaike[7,i] = AICC_T
    AIC_T<- 2*k_T - 2*logL_T
    akaike[8,i] = AIC_T
    BIC_T<- k_T*log(n_T) - 2*logL_T
    akaike[9,i] = BIC_T
  }
  # T Student - kolmogorov - smirnov
  if (fit_T[1]==-99) test_ks[5,i]=test_ks[6,i]=0 else {
    T_Sim<-fit_T[1] + fit_T[2]*rt(1000000, fit_T[3]) # - 0.2  
    ks_T=ks.test(T_Sim, dati_2[,i])
    ks_T=as.vector(c(ks_T$statistic,ks_T$p.value))
    for (j in 1:length(ks_T)) {test_ks[j+4,i]=ks_T[j]} 
  }
  # Weibull
  fit_W = c()
  fit_W=tryCatch({(fitdistr(dati_2[,i], densfun = "weibull"))$estimate}, error= function(err) {return(-99)})
  if (fit_W==-99) stime[8,i]=stime[9,i]=0 else for (j in 1:length(fit_W)) {stime[j+7,i]=fit_W[j]}
  # Weibull - akaike
  logL_W=tryCatch({(fitdistr(dati_2[,i],densfun="weibull"))$loglik},error=function(err){return(-99)})
  if (logL_W==-99) akaike[10,i]=akaike[11,i]=akaike[12,i]=0 else {
    k_W<-length(fit_W)
    n_W<-length(dati_2[,i])
    AICC_W = 2*k_W*n_W / (n_W-k_W-1 )  -   2*logL_W 
    akaike[10,i] = AICC_W
    AIC_W<- 2*k_W - 2*logL_W
    akaike[11,i] = AIC_W
    BIC_W<- k_W*log(n_W) - 2*logL_W
    akaike[12,i] = BIC_W
  }
  # Weibull - kolmogorov - smirnov
  if (fit_W[1]==-99) test_ks[7,i]=test_ks[8,i]=0 else {
    Weib_Sim<-rweibull(1000000,fit_W[1],fit_W[2])   #- 0.2  
    ks_W=ks.test(Weib_Sim, dati_2[,i])
    ks_W=as.vector(c(ks_W$statistic,ks_W$p.value))
    for (j in 1:length(ks_W)) {test_ks[j+6,i]=ks_W[j]}
  }
  # Esponenziale 
  fit_Exp = c()
  fit_Exp=tryCatch({(fitdistr(dati_2[,i],densfun="exponential"))$estimate}, error=function(err) {return(-99)})
  if (fit_Exp==-99) stime[10,i]=0 else for (j in 1:length(fit_Exp)) {stime[j+9,i]=fit_Exp[j]}
  # Esponenziale - akaike
  logL_Exp=tryCatch({(fitdistr(dati_2[,i],densfun="exponential"))$loglik},error=function(err){return(-99)})
  if (logL_Exp==-99) akaike[13,i]=akaike[14,i]=akaike[15,i]=0 else {
    k_Exp<-length(fit_Exp)
    n_Exp<-length(dati_2[,i])
    AICC_Exp = 2*k_Exp*n_Exp / (n_Exp-k_Exp-1 )  -   2*logL_Exp 
    akaike[13,i] = AICC_Exp
    AIC_Exp<- 2*k_Exp - 2*logL_Exp
    akaike[14,i] = AIC_Exp
    BIC_Exp<- k_Exp*log(n_Exp) - 2*logL_Exp
    akaike[15,i] = BIC_Exp
  }
  # Esponenziale - kolmogorov - smirnov
  if (fit_Exp[1]==-99) test_ks[9,i]=test_ks[10,i]=0 else {
    Exp_Sim =  rexp(n = 1000000, rate = fit_Exp) #-0.2  
    ks_Exp=ks.test(Exp_Sim, dati_2[,i])
    ks_Exp=as.vector(c(ks_Exp$statistic,ks_Exp$p.value))
    for (j in 1:length(ks_Exp)) {test_ks[j+8,i]=ks_Exp[j]}
  }
}
rownames(stime) = c("N_mean","N_sd","LN_meanlog","LN_sdlog","T_m","T_s","T_df","W_shape","W_scale","Exp_rate")
stime  
rownames(akaike) = c("AICC_N","AIC_N","BIC_N","AICC_LN","AIC_LN","BIC_LN","AICC_T","AIC_T","BIC_T"
                     ,"AICC_W","AIC_W","BIC_W","AICC_Exp","AIC_Exp","BIC_Exp") 
akaike
rownames(test_ks) = c("N_D","N_pvalue","logN_D","logN_pvalue","T_D","T_pvalue","W_D","W_pvalue"
                      ,"Exp_D","Exp_pvalue")
test_ks
 
#write.xlsx(stime,"../output/Stime.xlsx",sheetName="stime",row.names=T)
#write.xlsx(akaike,"../output/Criteri_inf.xlsx",sheetName="AIC",row.names=T)
#write.xlsx(test_ks,"../output/Test_KS.xlsx",sheetName="KS",row.names=T)
