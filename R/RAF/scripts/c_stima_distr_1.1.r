#____________________________________________________________________________________________________
#
# Modulo         :  
# Descrizione    :  
# Autore         : Audit Risk Model
# Versione       : 1.1
# Data           : 
# Note           : 
# Modifiche      : nessuna
#____________________________________________________________________________________________________
#
calc_akaike <- function(n, k, loglik){

  AICC_N      = 2*k*n/(n - k - 1) - 2*loglik 
  AIC_N       = 2*k - 2*loglik
  BIC_N       = k*log(n) - 2*loglik

  return(c(AICC_N, AIC_N,BIC_N))
}

# IMPORTARE DATI DA PDL
#setwd("/mnt/R/labdata/Audit/RAF/R/src_bin")
#library(CogUtils)
#Initialize()

g_INPUT_DIR  = "C:/Lavoro/RAF/R/input"
g_OUTPUT_DIR = "C:/Lavoro/RAF/R"

version_file = "1"
estension    = ".csv"

input_file   = paste("output_", version_file, estension, sep="")
file_ind     = paste(input_file,sep="") 
dati         = read.csv2(file=paste(g_INPUT_DIR,file_ind,sep="/"),1)

# PREDISPOSIZIONE DATA FRAME
rownames(dati) = dati$Anno
dati           = dati[2:ncol(dati)]
n_indicatori   = ncol(dati)

#SEZIONE STIMA DISTRIBUZIONI
library(MASS)
library(QRM)

#PER ALCUNE DISTRIBUZIONI SERVONO DATI POSITIVI, PERTANTO INDIVIDUO IL MIN DI TUTTI I DATI E POI TRASLO
trasl=round(abs(min(dati)),digits=1) + 0.1
if (min(dati) < 0) dati_trasl = dati + trasl

#####################################################################################################
# STIMA MASSIMA VEROSIMIGLIANZA
#####################################################################################################

stime             = matrix(0, nrow=10,ncol=n_indicatori)
colnames(stime)   = colnames(dati)
akaike            = matrix(0, nrow=15,ncol=n_indicatori)
colnames(akaike)  = colnames(dati)
test_ks           = matrix(0, nrow=10,ncol=n_indicatori)
colnames(test_ks) = colnames(dati)

# STIMA PARAMETRI
for (i in 1:n_indicatori) {
  # Normale
  esito = tryCatch({
     fit_norm   = fitdistr(dati_trasl[,i], densfun = "normal")
     loglike    = fit_norm$loglik
     estimate   = fit_norm$estimate
     # parametri distribuzione
     stime[1:length(estimate),i] = estimate
     # akaike
     akaike[1:3, i] = calc_akaike(length(dati_trasl[,i]), length(fit_N), logL_N) 
     # k-s
     
  }, error=function(err){
    return(-99)
  })


    # Normale - kolmogorov - smirnov
  if (fit_N[1] !=-99) {
    Norm_Sim <- fit_N[1] + fit_N[2]*rnorm(1000000)   #- 0.2
    ks_N = ks.test(Norm_Sim, dati_2[,i])
    ks_N = as.vector(c(ks_N$statistic,ks_N$p.value))
    for (j in 1:length(ks_N)) {
      test_ks[j,i]=ks_N[j]
    } 
  }
  
  # Log Normale
  fit_LN = c()
  fit_LN=tryCatch({(fitdistr(dati_2[,i],densfun="log-normal"))$estimate},error=function(err){return(-99)})
  if (fit_LN != -99) {
    for (j in 1:length(fit_LN)) {
      stime[j+2,i]=fit_LN[j]
    }
  }
  
  # lOG Normale - akaike
  logL_LN=tryCatch({(fitdistr(dati_2[,i],densfun="log-normal"))$loglik},error=function(err){return(-99)})
  if (logL_LN != -99){
    akaike[4:6,i] = calc_akaike(length(dati_2[,i]), length(fit_LN), logL_LN)
  }
  
  # LOG Normale - kolmogorov - smirnov
  if (fit_LN[1] !=-99) {
    LogNorm_Sim<-rlnorm(1000000, fit_LN[1] , fit_LN[2])   #- 0.2   
    ks_LN=ks.test(LogNorm_Sim, dati_2[,i])
    ks_LN=as.vector(c(ks_LN$statistic,ks_LN$p.value))
    for (j in 1:length(ks_LN)) {test_ks[j+2,i]=ks_LN[j]} 
  }

    # T Student
  fit_T = 0
  fit_T = tryCatch({(fit.mst(dati_2[,i]))}, error= function(err) {return(-99)})
  if (fit_T[1] != - 99) {
    fit_T=c(as.numeric(fit_T[[1]]),as.numeric(fit_T[[2]]),as.numeric(fit_T[[3]]))
    for (j in 1:length(fit_T)) {
      stime[j+4,i]=fit_T[j]
    }
  }  
  
  # T Student - akaike
  logL_T=tryCatch({(fit.mst(dati_2[,i]))$Sigma},error=function(err){return(-99)})
  logL_T=as.numeric(logL_T[1])
  if (logL_T !=-99) {
    akaike[7:9,i] = calc_akaike(length(dati_2[,i]), length(fit_T), logL_T) 
  }

    # T Student - kolmogorov - smirnov
  if (fit_T[1] != -99) {
    T_Sim<-fit_T[1] + fit_T[2]*rt(1000000, fit_T[3]) # - 0.2  
    ks_T=ks.test(T_Sim, dati_2[,i])
    ks_T=as.vector(c(ks_T$statistic,ks_T$p.value))
    for (j in 1:length(ks_T)) {
      test_ks[j+4,i]=ks_T[j]
    } 
  }
  # Weibull
  fit_W = c()
  fit_W=tryCatch({(fitdistr(dati_2[,i], densfun = "weibull"))$estimate}, error= function(err) {return(-99)})
  if (fit_W !=-99) {
    for (j in 1:length(fit_W)) {
      stime[j+7,i]=fit_W[j]
    }
  }
  
  # Weibull - akaike
  logL_W=tryCatch({(fitdistr(dati_2[,i],densfun="weibull"))$loglik},error=function(err){return(-99)})

  if (logL_W != -99) {
    akaike[10:12,i]= calc_akaike(length(dati_2[,i]), length(fit_W), logL_W) 
  }

  # Weibull - kolmogorov - smirnov
  if (fit_W[1] != -99) {
    Weib_Sim<-rweibull(1000000,fit_W[1],fit_W[2])   #- 0.2  
    ks_W=ks.test(Weib_Sim, dati_2[,i])
    ks_W=as.vector(c(ks_W$statistic,ks_W$p.value))
    for (j in 1:length(ks_W)) {
      test_ks[j+6,i]=ks_W[j]
    }
  }
  # Esponenziale 
  fit_Exp = c()
  fit_Exp=tryCatch({(fitdistr(dati_2[,i],densfun="exponential"))$estimate}, error=function(err) {return(-99)})
  if (fit_Exp !=-99) {
    for (j in 1:length(fit_Exp)) {
      stime[j+9,i]=fit_Exp[j]
    }
  }
  
  # Esponenziale - akaike
  logL_Exp=tryCatch({(fitdistr(dati_2[,i],densfun="exponential"))$loglik},error=function(err){return(-99)})
  if (logL_Exp != -99) {
    akaike[13:15,i]=calc_akaike(length(dati_2[,i]), length(fit_Exp), logL_Exp) 
  }

  # Esponenziale - kolmogorov - smirnov
  if (fit_Exp[1] != -99) {
    Exp_Sim =  rexp(n = 1000000, rate = fit_Exp) #-0.2  
    ks_Exp=ks.test(Exp_Sim, dati_2[,i])
    ks_Exp=as.vector(c(ks_Exp$statistic,ks_Exp$p.value))
    for (j in 1:length(ks_Exp)) {
      test_ks[j+8,i]=ks_Exp[j]
    }
  }
}

rownames(stime) = c("N_mean","N_sd","LN_meanlog","LN_sdlog","T_df","T_m","T_s","W_shape","W_scale","Exp_rate")
stime  
rownames(akaike) = c("AICC_N","AIC_N","BIC_N","AICC_LN","AIC_LN","BIC_LN","AICC_T","AIC_T","BIC_T"
                     ,"AICC_W","AIC_W","BIC_W","AICC_Exp","AIC_Exp","BIC_Exp") 
akaike
rownames(test_ks) = c("N_D","N_pvalue","logN_D","logN_pvalue","T_D","T_pvalue","W_D","W_pvalue"
                      ,"Exp_D","Exp_pvalue")
test_ks

write.xlsx(stime,   paste(g_OUTPUT_DIR, "/output/scelta_distribuzioni_", version_file, ".xlsx", sep=""),sheetName = "stime",append=F)
write.xlsx(akaike,  paste(g_OUTPUT_DIR, "/output/scelta_distribuzioni_", version_file, ".xlsx", sep=""),sheetName = "AIC"  ,append=T)
write.xlsx(test_ks, paste(g_OUTPUT_DIR, "/output/scelta_distribuzioni_", version_file, ".xlsx", sep=""),sheetName = "KS"   ,append=T)

