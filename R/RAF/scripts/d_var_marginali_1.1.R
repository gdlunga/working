#____________________________________________________________________________________________________
#
# Modulo         :  
# Descrizione    : Calcolo VaR variabili casuali marginali
# Autore         : Audit Risk Model
# Versione       : 1.1
# Data           : 25 novembre 2015
# Modifiche      : reingegnerizzazione della procedura di calcolo ed inserimento parametri
#
# Note           : si parte dalle distribuzioni con relativi parametri, calcolati nella procedura 
#                  c_stima_distr, selezionati manualmente e salvati in un csv (disribuzioni_versione.csv 
#                  e param_distribuzioni_versione.csv)
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


#####################################################################################################
# PARAMETRI
#####################################################################################################

n        = 13    # numero indicatori 
alfa     = 0.005 # quantile osservato
scen     = 10 # numero scenari
versione = "1_0"
n_par    = 9



#####################################################################################################
# DEFINIZIONE FUNZIONI
#####################################################################################################

distribution <- function(name, scen, params) {
  
  switch(name,
         "normal" = {
           x <- rnorm    (scen, mean = params[1], sd = params[2])
         },
         "lognormal" = {
           x <- rlnorm   (scen, meanlog = params[1], sdlog = params[2])
         },
         "t-Student" = {
           x <- rt       (scen, df = params[1], ncp = params[2])
         },
         "weibull" = {
           x <- rweibull (scen, shape = params[1], scale = params[1])
         },
         "exponential" = {
           x <- rexp     (scen, rate = params[1])
         },
         stop("controllo errore")
  )
  return(x)
}

# PREDISPOSIZIONE DATA FRAME

file_ind  = paste("/param_distribuzioni_", versione, ".csv", sep="") 
params    = read.csv2(file=paste(g_INPUT_DIR,file_ind,sep="/"),1)

file_ind  = paste("/distribuzioni_", versione, ".csv", sep="") 
distr     = read.csv2(file=paste(g_INPUT_DIR,file_ind,sep="/"),1)

rownames(params) = params[,1]                # serve per eliminare la prima colonna che contiene 
params           = params[2:ncol(params)]    # i nomi delle righe (distr, par1, par2)
#pippo=as.character(distr)
#####################################################################################################
# VAR VARIABILI CASUALI
#####################################################################################################

# CALCOLO QUANTILI VAR SIMULAZIONE V.C.
#Credito
sim=matrix(0, nrow= scen, ncol=n)

#p1<-c(16,0.2)
#p2<-c(0.0,1.0)
#A <- distribution("weibull",100, p1)
#B <- distribution("normal", 100, p2)


for (i in 1:n) {
  sim[,i] <- distribution (as.character(distr[1,i]), scen, params[,i])
}
   
   
   
if(versione=="0_0"){
  trasl = 0.2
  # weibull	normal	weibull	lognorm	weibull	lognorm	weibull	weibull	lognorm	lognorm	lognorm	weibull	normal
  sim[,1]<-rweibull (scen, shape=param[1,1],scale=param[2,1]) -trasl
  sim[,2]<-rnorm    (scen, mean=param[1,2],sd=param[2,2]) -trasl
  sim[,3]<-rweibull (scen, shape=param[1,3],scale=param[2,3]) -trasl
  sim[,4]<-rlnorm   (scen, meanlog=param[1,4],sdlog=param[2,4]) -trasl
  sim[,5]<-rweibull (scen, shape=param[1,5], scale=param[2,5]) -trasl
  sim[,6]<- rlnorm   (scen, meanlog=param[1,6],sdlog=param[2,6]) -trasl
  sim[,7]<- rweibull (scen, shape=param[1,7],scale=param[2,7]) -trasl
  sim[,8]<- rweibull (scen, shape=param[1,8],scale=param[2,8]) -trasl
  sim[,9]<- rlnorm   (scen, meanlog=param[1,9],sdlog=param[2,9]) -trasl
  sim[,10]<-rlnorm   (scen, meanlog=param[1,10],sdlog=param[2,10]) -trasl
  sim[,11]<-rlnorm   (scen, meanlog=param[1,11],sdlog=param[2,11]) -trasl
  sim[,12]<-rweibull (scen, shape=param[1,12], scale =param[1,12]) -trasl
  sim[,13]<-rnorm    (scen, mean=param[1,13],sd=param[2,13])-trasl
}
if(versione=="1_1"){
  trasl = 0.6
  # weibull	weibull	weibull	weibull	normale	weibull	weibull	normale	weibull	weibull	weibull	weibull	weibull
  sim[,1]<-rweibull (scen, shape=param[1,1],scale=param[2,1]) -trasl
  sim[,2]<-rweibull    (scen, shape=param[1,2],scale=param[2,2]) -trasl
  sim[,3]<-rweibull (scen, shape=param[1,3],scale=param[2,3]) -trasl
  sim[,4]<-rweibull   (scen, shape=param[1,4],scale=param[2,4]) -trasl
  sim[,5]<-rnorm (scen, mean=param[1,5], sd=param[2,5]) -trasl
  sim[,6]<- rweibull   (scen, shape=param[1,6],scale=param[2,6]) -trasl
  sim[,7]<- rweibull (scen, shape=param[1,7],scale=param[2,7]) -trasl
  sim[,8]<- rnorm (scen, mean=param[1,8],sd=param[2,8]) -trasl
  sim[,9]<- rweibull   (scen, shape=param[1,9],scale=param[2,9]) -trasl
  sim[,10]<-rweibull   (scen, shape=param[1,10],scale=param[2,10]) -trasl
  sim[,11]<-rweibull   (scen, shape=param[1,11],scale=param[2,11]) -trasl
  sim[,12]<-rweibull (scen, shape=param[1,12], scale =param[1,12]) -trasl
  sim[,13]<-rweibull    (scen, shape=param[1,13],scale=param[2,13])-trasl
}
if(versione=="1_0")
{
  trasl = 0.5
  # weibull	weibull	weibull	lognormal	weibull	lognormal	weibull	lognormal	lognormal	weibull	weibull	weibull	weibull
  sim[,1]<-rweibull (scen, shape=param[1,1],scale=param[2,1]) -trasl
  sim[,2]<-rweibull    (scen, shape=param[1,2],scale=param[2,2]) -trasl
  sim[,3]<-rweibull (scen, shape=param[1,3],scale=param[2,3]) -trasl
  sim[,4]<-rlnorm   (scen, meanlog=param[1,4],sdlog=param[2,4]) -trasl
  sim[,5]<-rweibull (scen, shape=param[1,5], scale=param[2,5]) -trasl
  sim[,6]<- rlnorm   (scen, meanlog=param[1,6],sdlog=param[2,6]) -trasl
  sim[,7]<- rweibull (scen, shape=param[1,7],scale=param[2,7]) -trasl
  sim[,8]<- rlnorm (scen, meanlog=param[1,8],sdlog=param[2,8]) -trasl
  sim[,9]<- rlnorm   (scen, meanlog=param[1,9],sdlog=param[2,9]) -trasl
  sim[,10]<-rweibull   (scen, shape=param[1,10],scale=param[2,10]) -trasl
  sim[,11]<-rweibull   (scen, shape=param[1,11],scale=param[2,11]) -trasl
  sim[,12]<-rweibull (scen, shape=param[1,12], scale =param[1,12]) -trasl
  sim[,13]<-rweibull    (scen, shape=param[1,13],scale=param[2,13])-trasl
}

hist(sim[,n_par])

# nome colonne
colnames(sim) <- c("RBC","CBC","PFC","CCC","CCM","RBT","CBT","PFT","CCT","RBO","CBO","PFO","CCO")

# MEDIE DELLE 13 VARIABILI SULLE 40000 OSSERVAZIONI
mean_sim=c()
for (i in 1:n) { 
  mean_sim[i]=mean(sim[,i])
}

# CALCOLO DEI 13 VAR SULLE 13 VARIABILI SIMULATE (40000 obs)
# ASSUNTO FONDAMENTALE DEI 13 VAR E' L'INDIPENDENZA DELLE 13 VARIABILI
# i pesi in questo caso sono pari ad uno
mu=c()
sd=c()
var_sim=c()
sigma=c()
q_std=c()
VAR_VC_ATTUALE=c()
for (i in 1:n) {
  mu[i]             = mean(sim[,i])
  sd[i]             = sd(sim[,i])
  var_sim[i]        = (scen-1)/scen*var(sim[,i])
  sigma[i]          = sqrt(var_sim[i])
  q_std[i]          = quantile((sim[,i] - mu[i])/sd[i],probs=alfa)
  VAR_VC_ATTUALE[i] = mu[i] + sigma[i]*q_std[i] 
}
names(VAR_VC_ATTUALE) <- c("RBC","CBC","PFC","CCC","CCM","RBT","CBT","PFT","CCT","RBO","CBO","PFO","CCO")
VAR_VC_ATTUALE

file_exp        = paste("esp_attuale_", versione, ".csv",sep="") 
esposizioni     = read.csv2(file=paste(g_INPUT_DIR,file_exp,sep="/"),1)

out = data.frame(esposizioni, VAR_VC_ATTUALE, mu)
write.csv2(out, paste(g_OUTPUT_DIR, "/output/var_mu_", versione, ".csv", sep=""),row.names=TRUE)

