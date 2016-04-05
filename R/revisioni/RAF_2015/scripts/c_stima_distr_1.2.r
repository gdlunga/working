#____________________________________________________________________________________________________
#
# Modulo         :  
# Descrizione    : Calcoo Stime ML, Criteri Informativi e Test KS
# Autore         : Audit Risk Model
# Versione       : 1.2
# Data           : 24 novembre 2015
# Modifiche      : reingegnerizzazione della procedura di calcolo ed inserimento parametri
#
# Note           : Su questo output scelte soggettive per decidere distribuzione che si adattano
#                  meglio ai dati, da inserire manualmente in un csv che è input a var marginali
#____________________________________________________________________________________________________




#####################################################################################################
# IMPORTAZIONE DATI E VERSIONI
#####################################################################################################

# IMPORTARE DATI DA PDL
setwd("/mnt/R/labdata/Audit/RAF/R/src_bin")
library(CogUtils)
library(MASS)
library(QRM)
library(xlsx)
Initialize()

#g_INPUT_DIR  = "C:/Lavoro/RAF/R/input" # serve per lavorare in locale
#g_OUTPUT_DIR = "C:/Lavoro/RAF/R"       # serve per lavorare in locale

version_file = "0"
estension    = ".csv"

input_file   = paste("output_", version_file, estension, sep="")
file_ind     = paste(input_file,sep="") 
dati         = read.csv2(file=paste(g_INPUT_DIR,file_ind,sep="/"),1)

# PREDISPOSIZIONE DATA FRAME
rownames(dati) = dati[,1]            #assegno la prima colonna (anno) come indice di riga
dati           = dati[2:ncol(dati)]  #elimino la prima colonna




#####################################################################################################
# DEFINIZIONE FUNZIONI
#####################################################################################################

# Criteri Informativi (AICC,AIC,BIC)
calc_akaike <- function(n, k, loglik){

  AICC      = 2*k*n/(n - k - 1) - 2*loglik 
  AIC       = 2*k - 2*loglik
  BIC       = k*log(n) - 2*loglik

  return(c(AICC, AIC,BIC))
}

# Test Kolmogorov - Smirnov
kolm_smir <- function(x,y) {
  TEST_KS     = ks.test(x,y)
  
  return(as.vector(c(TEST_KS$statistic,TEST_KS$p.value)))
}



#####################################################################################################
# PARAMETRI
#####################################################################################################

n_indicatori  = ncol(dati)
trasl         = round(abs(min(dati)),digits=1) + 0.1 #Per alcune distribuzioni servono dati positivi
simulazioni   = 1000000
#distribuzioni = c("normal","log-normal","student","weibull","exponential")



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
if (min(dati) < 0) dati_trasl = dati + trasl # dati traslati
last_index_stime = 0
for (i in 1:n_indicatori) {
  # Normale
  esito = tryCatch({
     fit_norm   = fitdistr(dati_trasl[,i], densfun = "normal")
     loglike    = fit_norm$loglik
     estimate   = fit_norm$estimate
     # parametri distribuzione
     stime[1:length(estimate),i] = estimate
     last_index_stime = length(estimate)       
     # akaike
     akaike[1:3, i] = calc_akaike(length(dati_trasl[,i]), length(estimate), loglike)  
     last_index_ak  = 3
     # k-s
     norm_sim       = estimate[1] + estimate[2]*rnorm(simulazioni)
     test_ks[1:2,i] = kolm_smir(norm_sim,dati_trasl[,i])
     last_index_ks  = 2
     
  }, error=function(err){
    return(-99)
  })

  # Log Normale
  esito = tryCatch({
    fit_lnorm   = fitdistr(dati_trasl[,i], densfun = "log-normal")
    loglike     = fit_lnorm$loglik
    estimate    = fit_lnorm$estimate
    # parametri distribuzione
    ini_stime                        = last_index_stime + 1
    fine_stime                       = last_index_stime + length(estimate) 
    stime[(ini_stime: fine_stime),i] = estimate
    last_index_stime                 = fine_stime        
    # akaike
    ini_ak                    = last_index_ak + 1 
    fine_ak                   = last_index_ak + 3
    akaike[ini_ak:fine_ak, i] = calc_akaike(length(dati_trasl[,i]), length(estimate), loglike)
    last_index_ak             = fine_ak
    # k-s
    ini_ks                    = last_index_ks + 1 
    fine_ks                   = last_index_ks + 2
    lnorm_sim                 = rlnorm(simulazioni, estimate[1] , estimate[2])
    test_ks[ini_ks:fine_ks,i] = kolm_smir(lnorm_sim,dati_trasl[,i])
    last_index_ks             = fine_ks
    
  }, error=function(err){
    return(-99)
  })

  # T Student
  esito = tryCatch({
    fit_t       = fit.mst(dati_trasl[,i])
    loglike     = fit_t$ll.max
    estimate    = c(as.numeric(fit_t$df),as.numeric(fit_t$mu),as.numeric(fit_t$Sigma[1]))
    # parametri distribuzione
    ini_stime                        = last_index_stime + 1
    fine_stime                       = last_index_stime + length(estimate) 
    stime[(ini_stime: fine_stime),i] = estimate
    last_index_stime                 = fine_stime   
    # akaike
    ini_ak                    = last_index_ak + 1 
    fine_ak                   = last_index_ak + 3
    akaike[ini_ak:fine_ak, i] = calc_akaike(length(dati_trasl[,i]), length(estimate), loglike)
    last_index_ak             = fine_ak
    # k-s
    #t_sim          = estimate[2] + estimate[3]*rt(simulazioni, estimate[1]) formula alternativa
    ini_ks                    = last_index_ks + 1 
    fine_ks                   = last_index_ks + 2
    lnorm_sim                 = rlnorm(simulazioni, estimate[1] , estimate[2])
    test_ks[ini_ks:fine_ks,i] = kolm_smir(lnorm_sim,dati_trasl[,i])
    last_index_ks             = fine_ks
  
  }, error=function(err){
    return(-99)
  })
  
  
  # Weibull
  esito = tryCatch({
    fit_w       = fitdistr(dati_trasl[,i], densfun="weibull")
    loglike     = fit_w$loglik
    estimate    = fit_w$estimate
    # parametri distribuzione
    ini_stime                        = last_index_stime + 1
    fine_stime                       = last_index_stime + length(estimate) 
    stime[(ini_stime: fine_stime),i] = estimate
    last_index_stime                 = fine_stime        
    # akaike
    ini_ak                    = last_index_ak + 1 
    fine_ak                   = last_index_ak + 3
    akaike[ini_ak:fine_ak, i] = calc_akaike(length(dati_trasl[,i]), length(estimate), loglike)
    last_index_ak             = fine_ak
    # k-s
    ini_ks                    = last_index_ks + 1 
    fine_ks                   = last_index_ks + 2
    w_sim                     = rweibull(simulazioni, estimate[1] , estimate[2])
    test_ks[ini_ks:fine_ks,i] = kolm_smir(w_sim,dati_trasl[,i])
    last_index_ks             = fine_ks
  
  }, error=function(err){
    return(-99)
  })
  

  # Esponenziale 
  esito = tryCatch({
    fit_exp     = fitdistr(dati_trasl[,i], densfun="exponential")
    loglike     = fit_exp$loglik
    estimate    = fit_exp$estimate
    # parametri distribuzione
    ini_stime                        = last_index_stime + 1
    fine_stime                       = last_index_stime + length(estimate) 
    stime[(ini_stime: fine_stime),i] = estimate
    last_index_stime                 = fine_stime        
    # akaike
    ini_ak                    = last_index_ak + 1 
    fine_ak                   = last_index_ak + 3
    akaike[ini_ak:fine_ak, i] = calc_akaike(length(dati_trasl[,i]), length(estimate), loglike)
    last_index_ak             = fine_ak
    # k-s
    ini_ks                    = last_index_ks + 1 
    fine_ks                   = last_index_ks + 2
    exp_sim                   = rexp(simulazioni, estimate[1])
    test_ks[ini_ks:fine_ks,i] = kolm_smir(exp_sim,dati_trasl[,i])
    last_index_ks             = fine_ks
    
  }, error=function(err){
    return(-99)
  })
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

