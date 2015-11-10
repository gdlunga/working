# IMPORTARE DATI DA MAC
#dati<= read.csv("~/Desktop/dati.csv", sep=";", dec=",")
#View(dati)

# IMPORTARE DATI DA PDL
setwd("/mnt/R/labdata/Audit/RAF/R/src_bin")
library(CogUtils)
Initialize()
file_ind=paste("dati.csv",sep="") 
dati=read.csv2(file=paste(g_INPUT_DIR,file_ind,sep="/"),1)

# PREDISPOSIZIONE DATA FRAME
rownames(dati)=dati$Anno
dati=dati[2:14]
#dati=dati[1,] # da utilizzare soltanto per il calcolo del rendimento attuale

# PESI 2014
esp2=c(50918000000,51003000000,64000000,9246000000,33283000000,58319141484,58416496585
       ,73302664,10589944267,58319141484,58416496585,73302664,43872944267)
a=esp2/sum(esp2)
a

# ESP x PONDERAZIONE VAR x CALCOLO FI
esp=c(58319141484,58416496585,73302664,43872944267) #4 esp. rischio op. 2014, tab36, p.30

# CAPITALE INTERNO - Building Block
c_b=sum(c(3657000000,977000000,258000000,708000000)) 
c_b

# MATRICE VARIANZA COVARIANZA (CORRETTA) - DATI STORICI
varcov=6/7*var(dati)

# VARIANZA DI PORTAFOGLIO - VOLATILITA' PORTAFOGLIO
sigma_p= as.numeric(sqrt(t(a)%*%varcov%*%a))
sigma_p

# Calcolo valore attuale
mu_attuale=sum(dati[1,]*a)

########################################################################################
# HYBRID VAR
########################################################################################

# MEDIE DELLE 13 VARIABILI SULLE 7 OSSERVAZIONI STORICHE
mean_dati=c()
for (i in 1:13) {
  mean_dati[i]=mean(dati[,i])
}

# CALCOLO VAR i
var_i=c()
for (i in 1:13) {
  var_i[i]=quantile(dati[,i],probs=0.005)
}
var_i

# PROCESSO DI CALCOLO DI MU,HVAR E COEFFICIENTE FI
# Definizione Funzione
Calcolo_Fi=function (w) {
  d=0
  for (i in 1:13) {
    for (j in 1:13) {
      d=d+(w[i]*(var_i[i]-mean_dati[i])*(var_i[j]-mean_dati[j])*w[j])
    }             #  d rappresenta il termine sotto radice 
  }               #  della formula H-Var (cfr. par. 11.6 pag 6 del manuale)
  sigma_q=sqrt(d)
  mu_p=as.numeric(mean_dati%*%w)  # mu_p rappresenta la redditività attesa (cfr. come sopra)
  H_VAR=abs(mu_p)+abs(sigma_q)
  c_ind=abs(sum(esp)*H_VAR)
  fi=c_ind/c_b
  scenario_h_var=matrix( , nrow=1,ncol=5)
  return(c(sigma_q,mu_p,H_VAR,c_ind,fi))
}

Fi_atteso=matrix( , nrow=1,ncol=5)
colnames(Fi_atteso)=c("SIGMA_Q","MU_P","H_VAR","C_IND","FI")
Fi_atteso[1,]=Calcolo_Fi(a)
Fi_atteso

#Tabella 78 
riepilogo_HVAR=matrix(, nrow=2,ncol=3)
colnames(riepilogo_HVAR)=c("Atteso","Attuale","Var")
rownames(riepilogo_HVAR)=c("Varianza","Media")
riepilogo_HVAR[1,]=sigma_p
riepilogo_HVAR[2,3]=-Fi_atteso[,3]
riepilogo_HVAR[2,2]=mu_attuale
riepilogo_HVAR[2,1]=Fi_atteso[,2]
riepilogo_HVAR

# Calcolo 40000 scenari
p=matrix( , nrow=13,ncol=40000)
s=c()
w=matrix( , nrow=13,ncol=40000)
scenario_h_var=matrix ( , nrow=40000,ncol=5)
colnames(scenario_h_var)=c("SIGMA_Q","MU_P","H_VAR","C_IND","FI")
for (i in 1:40000) {
  p[5,i]=runif(1)       #CCM
  p[6,i]=runif(1)       #RBT  
  p[7,i]=runif(1)       #CBT
  p[8,i]=runif(1)       #PFT
  p[9,i]=runif(1)       #CCT
  p[1,i]=p[6,i]*0.873   #RBC
  p[2,i]=p[7,i]*0.873   #CBC
  p[3,i]=p[8,i]*0.873   #PFC
  p[4,i]=p[9,i]*0.873   #CCC
  p[10,i]=p[6,i]        #RBO
  p[11,i]=p[7,i]        #CBO
  p[12,i]=p[8,i]        #PFO
  p[13,i]=p[5,i]+p[9,i] #CCO 
  s[i]=sum(p[,i])
  w[,i]=p[,i]/s[i]
  #w[,1]=a
  scenario_h_var[i,]=Calcolo_Fi(w[,i])
}
hist(scenario_h_var[,5], breaks=100
summary(scenario_h_var[,5])

FI=matrix(, nrow=6,ncol=5)
FI[,1]=(summary(scenario_h_var[,5]))
colnames(FI)=c("HVAR","NVAR","VAR_VC","VAR_COP_N","VAR_COP_T")
rownames(FI)=names(summary(scenario_h_var[,5]))
FI

########################################################################################
# NORMAL VAR
########################################################################################

# MEDIE DELLE 13 VARIABILI SULLE 7 OSSERVAZIONI STORICHE
mean_dati=c()
for (i in 1:13) {
  mean_dati[i]=mean(dati[,i])
}

# CALCOLO DEI VAR i
var_i=c()
for (i in 1:13) {
  var_i[i]=qnorm(0.005, mean=mean(dati[,i])
                 ,sd=sqrt((length(dati[,i])-1)/(length(dati[,i]))*var(dati[,i])))
}
var_i

# PROCESSO DI CALCOLO DI MU,N-VAR E COEFFICIENTE FI
# Definizione Funzione
Calcolo_Fi=function (w) {
  d=0
  for (i in 1:13) {
    for (j in 1:13) {
      d=d+(w[i]*(var_i[i]-mean_dati[i])*(var_i[j]-mean_dati[j])*w[j])
    }
  }
  sigma_q=sqrt(d)
  mu_p=as.numeric(mean_dati%*%w)
  N_VAR=abs(mu_p)+abs(sigma_q)
  c_ind=abs(sum(esp)*N_VAR)
  fi=c_ind/c_b
  scenario_N_var=matrix( , nrow=1,ncol=5)
  return(c(sigma_q,mu_p,N_VAR,c_ind,fi))
}

Fi_atteso=matrix( , nrow=1,ncol=5)
colnames(Fi_atteso)=c("SIGMA_Q","MU_P","N_VAR","C_IND","FI")
Fi_atteso[1,]=Calcolo_Fi(a)
Fi_atteso
Calcolo_Fi(a)

#TABELLA 113 DEL MANUALE 
riepilogo_NVAR=matrix(, nrow=2,ncol=3)
colnames(riepilogo_NVAR)=c("Atteso","Attuale","Var")
rownames(riepilogo_NVAR)=c("Varianza","Media")
riepilogo_NVAR[1,]=sigma_p
riepilogo_NVAR[2,3]=-Fi_atteso[,3]
riepilogo_NVAR[2,2]=mu_attuale
riepilogo_NVAR[2,1]=Fi_atteso[,2]
riepilogo_NVAR

# Calcolo 40000 scenari
p=matrix( , nrow=13,ncol=40000)
s=c()
w=matrix( , nrow=13,ncol=40000)
scenario_N_var=matrix ( , nrow=40000,ncol=5)
colnames(scenario_N_var)=c("SIGMA_Q","MU_P","N_VAR","C_IND","FI")
for (i in 1:40000) {
  p[5,i]=runif(1)
  p[6,i]=runif(1)
  p[7,i]=runif(1)
  p[8,i]=runif(1)
  p[9,i]=runif(1)
  p[1,i]=p[6,i]*0.873
  p[2,i]=p[7,i]*0.873
  p[3,i]=p[8,i]*0.873
  p[4,i]=p[9,i]*0.873
  p[10,i]=p[6,i]
  p[11,i]=p[7,i]
  p[12,i]=p[8,i]
  p[13,i]=p[5,i]+p[9,i]  
  s[i]=sum(p[,i])
  w[,i]=p[,i]/s[i]
  #w[,1]=a
  scenario_N_var[i,]=Calcolo_Fi(w[,i])
}
hist(scenario_N_var[,5], breaks=100)
summary(scenario_N_var[,5])

FI[,2]=(summary(scenario_N_var[,5]))
FI


########################################################################################
# VAR VARIABILI CASUALI
########################################################################################

# CALCOLO QUANTILI VAR SIMULAZIONE V.C.
#Credito
sim=matrix( , nrow= 40000, ncol=13)
sim[,1]=rweibull(40000,shape=16.0413,scale=0.2022)-0.2
sim[,2]=rnorm(40000,mean=0.1804,sd=0.03567)-0.2
sim[,3]=rweibull(40000,shape=12.1903,scale=0.2360)-0.2
sim[,4]=rlnorm(40000,meanlog=-1.5858,sdlog=0.1025)-0.2
#Mercato
sim[,5]=rweibull(40000, shape=50.9369, scale = 0.1987) -0.2 
#Tasso 
sim[,6]=rlnorm(40000, meanlog = -1.6344, sdlog = 0.03146) - 0.2 
sim[,7]=rweibull(40000, shape=69.3246, scale = 0.2001) -0.2 
sim[,8]=rweibull(40000, shape=22.7963, scale = 0.2520) -0.2 
sim[,9]=rlnorm(40000, meanlog=-1.6261 , sdlog = 0.06728) -0.2 
#Operativo 
sim[,10]=rlnorm(40000, meanlog = -1.6625, sdlog = 0.008081) - 0.2 
sim[,11]=rlnorm(40000, meanlog = -1.6228, sdlog = 0.002514) - 0.2 
sim[,12]=rweibull(40000, shape=7.3210, scale = 0.1711) -0.2 
sim[,13]=rnorm(40000, mean = 0.1974, sd = 0.002014)-0.2
# nome colonne
colnames(sim)=colnames(dati)

# MEDIE DELLE 13 VARIABILI SULLE 40000 OSSERVAZIONI
mean_sim=c()
for (i in 1:13) { 
  mean_sim[i]=mean(sim[,i])
}

# TOTAL LOSS - DISTRIBUZIONE
congiunta=sim%*%(a)

# TOTAL LOSS - media scarto e quantile
mu_c=mean(congiunta)
sd_c=sd(congiunta)
q=quantile(congiunta,probs=0.005)

# QUANTILE SULLA DISTRIBUZIONE CONGIUNTA STD
q_std=(q-mu_c)/sd_c #1° metodo
q_std=quantile((congiunta-mu_c)/sd_c,probs=0.005) #2° metodo

# PROCESSO DI CALCOLO DI MU,HVAR E COEFFICIENTE FI
# Definizione Funzione
Calcolo_Fi=function (w) {
  d=0
  for (i in 1:13) {
    for (j in 1:13) {
      d=d+(w[i]*(varcov[j,i])*w[j])
    }             #  d rappresenta il termine sotto radice 
  }               #  della formula H-Var (cfr. par. 11.6 pag 6 del manuale)
  sigma_p=sqrt(d)
  mu_p=as.numeric(mean_sim%*%w)  # mu_p rappresenta la redditività attesa (cfr. come sopra)
  MC_VAR=abs(mu_p)+abs((sigma_p)*(q_std))
  c_ind=abs(sum(esp)*MC_VAR)
  fi=c_ind/c_b
  scenario_mc_var=matrix( , nrow=1,ncol=5)
  return(c(sigma_p,mu_p,q_std,MC_VAR,c_ind,fi))
}

Fi_atteso=matrix( , nrow=1,ncol=6)
colnames(Fi_atteso)=c("SIGMA_P","MU_P","Q_STD","MC_VAR","C_IND","FI")
Fi_atteso[1,]=Calcolo_Fi(a)
Fi_atteso

#TABELLA 122 DEL MANUALE 
riepilogo_VCVAR=matrix(, nrow=2,ncol=3)
colnames(riepilogo_VCVAR)=c("Atteso","Attuale","Var")
rownames(riepilogo_VCVAR)=c("Varianza","Media")
riepilogo_VCVAR[1,]=sigma_p
riepilogo_VCVAR[2,3]=-Fi_atteso[,4]
riepilogo_VCVAR[2,2]=mu_attuale
riepilogo_VCVAR[2,1]=Fi_atteso[,2]
riepilogo_VCVAR

# Calcolo 40000 scenari
p=matrix( , nrow=13,ncol=40000)
s=c()
w=matrix( , nrow=13,ncol=40000)
scenario_MC_var=matrix ( , nrow=40000,ncol=6)
colnames(scenario_MC_var)=c("SIGMA_P","MU_P","Q_STD","MC_VAR","C_IND","FI")
for (i in 1:40000) {
  p[5,i]=runif(1)
  p[6,i]=runif(1)
  p[7,i]=runif(1)
  p[8,i]=runif(1)
  p[9,i]=runif(1)
  p[1,i]=p[6,i]*0.873
  p[2,i]=p[7,i]*0.873
  p[3,i]=p[8,i]*0.873
  p[4,i]=p[9,i]*0.873
  p[10,i]=p[6,i]
  p[11,i]=p[7,i]
  p[12,i]=p[8,i]
  p[13,i]=p[5,i]+p[9,i]  
  s[i]=sum(p[,i])
  w[,i]=p[,i]/s[i]
  #w[,1]=a
  scenario_MC_var[i,]=Calcolo_Fi(w[,i])
}
hist(scenario_MC_var[,6], breaks=100)
summary(scenario_MC_var[,6])

FI[,3]=(summary(scenario_MC_var[,6]))
FI

########################################################################################
# VAR COPULA NORMALE
########################################################################################

#Matrice di correlazione
CM<-cor(dati)
CM

#Correzione matrice di correlazione Corretta
#in caso non sia semi-definita positiva
n <- dim(var(CM))[1]
E <- eigen(CM)
CM1 <- E$vectors %*% tcrossprod(diag(pmax(E$values, 0.0001), n), E$vectors)
Balance <- diag(1/sqrt(diag(CM1)))
CM2 <- Balance %*% CM1 %*% Balance 

# funzione isSymmetric per testare la simmetria
isSymmetric(CM2,tol=0.000000000000001)

#tengo 6 decimali per evitare che la matrice non sia simmetrica
CM3<-round(CM2,6)
CM3

#librerie utili 
library(QRM)
library(MASS)

#simulazione copula Normale con matrice di correlazione Sigma
rgc <- rcopula.gauss(100000,Sigma=CM3)

#la densità delle marginali è uniforme
plot(density(rgc[,1]))
cor(rgc)

#Applicazioni funzione quantile (Funzione ripartizione inversa) delle marginali precedentemente stimate
X<-matrix(NA,nrow(rgc),ncol(rgc))
#Credito
X[,1]<-qweibull(p=rgc[,1], shape=16.0413,scale=0.2022) -0.2
X[,2]<-qnorm(p=rgc[,2], mean=0.1804,sd=0.03567) -0.2
X[,3]<-qweibull(p=rgc[,3], shape=12.1903,scale=0.2360) -0.2
X[,4]<-qlnorm(  p=rgc[,4], meanlog=-1.5858,sdlog=0.1025) - 0.2
#Mercato
X[,5]<-qweibull(p=rgc[,5], shape=50.9369, scale = 0.1987) -0.2
#Tasso
X[,6]<- qlnorm(  p=rgc[,6], meanlog = -1.6344, sdlog = 0.03146) - 0.2
X[,7]<- qweibull(p=rgc[,7], shape=69.3246, scale = 0.2001) -0.2
X[,8]<- qweibull(p=rgc[,8], shape=22.7963, scale = 0.2520) -0.2
X[,9]<- qlnorm(p=rgc[,9], meanlog=-1.6261 , sdlog = 0.06728) -0.2
#Operativo
X[,10]<-qlnorm(  p=rgc[,10], meanlog = -1.6625, sdlog = 0.008081) - 0.2
X[,11]<-qlnorm(  p=rgc[,11], meanlog = -1.6228, sdlog = 0.002514) - 0.2
X[,12]<-qweibull(p=rgc[,12], shape=7.3210, scale = 0.1711) -0.2
X[,13]<-qnorm(   p=rgc[,13], mean = 0.1974, sd = 0.002014)-0.2

# CALCOLO MU_P
mean_sim=c()
for (i in 1:13) { 
  mean_sim[i]=mean(X[,i])
}
mu_p=as.numeric(mean_sim%*%a)

# CALCOLO DELLA CONGIUNTA
XX<-X%*%a
dim(XX)

#Standardizzazione Total Loss
XX_std<-(XX - mean(XX))/sd(XX)
mean(XX_std)
sd(XX_std)
q_std=quantile(XX_std,0.005)

#VaR con matrice di Correlazione dei dati originari
VaR_CopulaN<-mu_p + sigma_p*quantile(XX_std,0.005)
VaR_CopulaN

# PROCESSO DI CALCOLO DI MU,HVAR E COEFFICIENTE FI
# Definizione Funzione
Calcolo_Fi=function (w) {
  d=0
  for (i in 1:13) {
    for (j in 1:13) {
      d=d+(w[i]*(varcov[j,i])*w[j])
    }             #  d rappresenta il termine sotto radice 
  }               #  della formula H-Var (cfr. par. 11.6 pag 6 del manuale)
  sigma_p=sqrt(d)
  mu_p=as.numeric(mean_sim%*%w)  # mu_p rappresenta la redditività attesa (cfr. come sopra)
  COPN_VAR=abs(mu_p)+abs((sigma_p)*(q_std))
  c_ind=abs(sum(esp)*COPN_VAR)
  fi=c_ind/c_b
  scenario_copn_var=matrix( , nrow=1,ncol=5)
  return(c(sigma_p,mu_p,q_std,COPN_VAR,c_ind,fi))
}

Fi_atteso=matrix( , nrow=1,ncol=6)
colnames(Fi_atteso)=c("SIGMA_P","MU_P","Q_STD","COPN_VAR","C_IND","FI")
Fi_atteso[1,]=Calcolo_Fi(a)
Fi_atteso

#TABELLA pag.184 DEL MANUALE 
riepilogo_VAR_COP_N=matrix(, nrow=2,ncol=3)
colnames(riepilogo_VAR_COP_N)=c("Atteso","Attuale","Var")
rownames(riepilogo_VAR_COP_N)=c("Varianza","Media")
riepilogo_VAR_COP_N[1,]=sigma_p
riepilogo_VAR_COP_N[2,3]=-Fi_atteso[,4]
riepilogo_VAR_COP_N[2,2]=mu_attuale
riepilogo_VAR_COP_N[2,1]=Fi_atteso[,2]
riepilogo_VAR_COP_N

# Calcolo 40000 scenari
p=matrix( , nrow=13,ncol=40000)
s=c()
w=matrix( , nrow=13,ncol=40000)
scenario_COPN_var=matrix ( , nrow=40000,ncol=6)
colnames(scenario_COPN_var)=c("SIGMA_P","MU_P","Q_STD","COPN_VAR","C_IND","FI")
for (i in 1:40000) {
  p[5,i]=runif(1)
  p[6,i]=runif(1)
  p[7,i]=runif(1)
  p[8,i]=runif(1)
  p[9,i]=runif(1)
  p[1,i]=p[6,i]*0.873
  p[2,i]=p[7,i]*0.873
  p[3,i]=p[8,i]*0.873
  p[4,i]=p[9,i]*0.873
  p[10,i]=p[6,i]
  p[11,i]=p[7,i]
  p[12,i]=p[8,i]
  p[13,i]=p[5,i]+p[9,i]  
  s[i]=sum(p[,i])
  w[,i]=p[,i]/s[i]
  #w[,1]=a
  scenario_COPN_var[i,]=Calcolo_Fi(w[,i])
}
hist(scenario_COPN_var[,6], breaks=100)
summary(scenario_COPN_var[,6])

FI[,4]=(summary(scenario_COPN_var[,6]))
FI

########################################################################################
# VAR COPULA T STUDENT
########################################################################################

#Matrice di correlazione
CM<-cor(dati)
CM

#Correzione matrice di correlazione Corretta
#in caso non sia semi-definita positiva
n <- dim(var(CM))[1]
E <- eigen(CM)
CM1 <- E$vectors %*% tcrossprod(diag(pmax(E$values, 0.0001), n), E$vectors)
Balance <- diag(1/sqrt(diag(CM1)))
CM2 <- Balance %*% CM1 %*% Balance 

# funzione isSymmetric per testare la simmetria
isSymmetric(CM2,tol=0.000000000000001)

#tengo 6 decimali per evitare che la matrice non sia simmetrica
CM3<-round(CM2,6)
CM3

#librerie utili 
library(QRM)
library(MASS)

#simulazione copula Normale con matrice di correlazione Sigma
# GRADI DI LIBERTA' DA STIMAREEEE!!!!!!!!!!!!
rgc <- rcopula.t(100000,df=4,Sigma=CM3)

#la densità delle marginali è uniforme
plot(density(rgc[,1]))
cor(rgc)

#Applicazioni funzione quantile (Funzione ripartizione inversa) delle marginali precedentemente stimate
X<-matrix(NA,nrow(rgc),ncol(rgc))
#Credito
X[,1]<-qweibull(p=rgc[,1], shape=16.0413,scale=0.2022) -0.2
X[,2]<-qnorm(p=rgc[,2], mean=0.1804,sd=0.03567) -0.2
X[,3]<-qweibull(p=rgc[,3], shape=12.1903,scale=0.2360) -0.2
X[,4]<-qlnorm(  p=rgc[,4], meanlog=-1.5858,sdlog=0.1025) - 0.2
#Mercato
X[,5]<-qweibull(p=rgc[,5], shape=50.9369, scale = 0.1987) -0.2
#Tasso
X[,6]<- qlnorm(  p=rgc[,6], meanlog = -1.6344, sdlog = 0.03146) - 0.2
X[,7]<- qweibull(p=rgc[,7], shape=69.3246, scale = 0.2001) -0.2
X[,8]<- qweibull(p=rgc[,8], shape=22.7963, scale = 0.2520) -0.2
X[,9]<- qlnorm(p=rgc[,9], meanlog=-1.6261 , sdlog = 0.06728) -0.2
#Operativo
X[,10]<-qlnorm(  p=rgc[,10], meanlog = -1.6625, sdlog = 0.008081) - 0.2
X[,11]<-qlnorm(  p=rgc[,11], meanlog = -1.6228, sdlog = 0.002514) - 0.2
X[,12]<-qweibull(p=rgc[,12], shape=7.3210, scale = 0.1711) -0.2
X[,13]<-qnorm(   p=rgc[,13], mean = 0.1974, sd = 0.002014)-0.2

# CALCOLO MU_P
mean_sim=c()
for (i in 1:13) { 
  mean_sim[i]=mean(X[,i])
}
mu_p=as.numeric(mean_sim%*%a)

# CALCOLO DELLA CONGIUNTA
XX<-X%*%a
dim(XX)

#Standardizzazione Total Loss
XX_std<-(XX - mean(XX))/sd(XX)
mean(XX_std)
sd(XX_std)
q_std=quantile(XX_std,0.005)

#VaR con matrice di Correlazione dei dati originari
VaR_CopulaT<-mu_p + sigma_p*quantile(XX_std,0.005)
VaR_CopulaT

# PROCESSO DI CALCOLO DI MU,HVAR E COEFFICIENTE FI
# Definizione Funzione
Calcolo_Fi=function (w) {
  d=0
  for (i in 1:13) {
    for (j in 1:13) {
      d=d+(w[i]*(varcov[j,i])*w[j])
    }             #  d rappresenta il termine sotto radice 
  }               #  della formula H-Var (cfr. par. 11.6 pag 6 del manuale)
  sigma_p=sqrt(d)
  mu_p=as.numeric(mean_sim%*%w)  # mu_p rappresenta la redditività attesa (cfr. come sopra)
  COPT_VAR=abs(mu_p)+abs((sigma_p)*(q_std))
  c_ind=abs(sum(esp)*COPT_VAR)
  fi=c_ind/c_b
  scenario_copt_var=matrix( , nrow=1,ncol=5)
  return(c(sigma_p,mu_p,q_std,COPT_VAR,c_ind,fi))
}

Fi_atteso=matrix( , nrow=1,ncol=6)
colnames(Fi_atteso)=c("SIGMA_P","MU_P","Q_STD","COPT_VAR","C_IND","FI")
Fi_atteso[1,]=Calcolo_Fi(a)
Fi_atteso

#TABELLA pag.184 DEL MANUALE 
riepilogo_VAR_COP_T=matrix(, nrow=2,ncol=3)
colnames(riepilogo_VAR_COP_T)=c("Atteso","Attuale","Var")
rownames(riepilogo_VAR_COP_T)=c("Varianza","Media")
riepilogo_VAR_COP_T[1,]=sigma_p
riepilogo_VAR_COP_T[2,3]=-Fi_atteso[,4]
riepilogo_VAR_COP_T[2,2]=mu_attuale
riepilogo_VAR_COP_T[2,1]=Fi_atteso[,2]
riepilogo_VAR_COP_T

# Calcolo 40000 scenari
p=matrix( , nrow=13,ncol=40000)
s=c()
w=matrix( , nrow=13,ncol=40000)
scenario_COPT_var=matrix ( , nrow=40000,ncol=6)
colnames(scenario_COPN_var)=c("SIGMA_P","MU_P","Q_STD","COPT_VAR","C_IND","FI")
for (i in 1:40000) {
  p[5,i]=runif(1)
  p[6,i]=runif(1)
  p[7,i]=runif(1)
  p[8,i]=runif(1)
  p[9,i]=runif(1)
  p[1,i]=p[6,i]*0.873
  p[2,i]=p[7,i]*0.873
  p[3,i]=p[8,i]*0.873
  p[4,i]=p[9,i]*0.873
  p[10,i]=p[6,i]
  p[11,i]=p[7,i]
  p[12,i]=p[8,i]
  p[13,i]=p[5,i]+p[9,i]  
  s[i]=sum(p[,i])
  w[,i]=p[,i]/s[i]
  #w[,1]=a
  scenario_COPT_var[i,]=Calcolo_Fi(w[,i])
}
hist(scenario_COPT_var[,6], breaks=100)
summary(scenario_COPT_var[,6])

FI[,5]=(summary(scenario_COPT_var[,6]))
FI
