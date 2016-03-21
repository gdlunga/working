# DETERMINAZIONE FRONTIERA AMMISSIBILE ED EFFICIENTE
# Matrice di Correlazione
CM<-cor(dati)
CM

#Correzione matrice di correlazione Corretta
#in caso non sia semi-definita positiva
n <- dim(var(CM))[1L]
E <- eigen(CM)
CM1 <- E$vectors %*% tcrossprod(diag(pmax(E$values, 0.0001), n), E$vectors)
Balance <- diag(1/sqrt(diag(CM1)))
CM2 <- Balance %*% CM1 %*% Balance  
varcov_dati=(dim(dati)[1]-1)/dim(dati)[1]*var(dati) 
st_dev=sqrt(diag(varcov_dati))
st_dev2=matrix(0,13,13)
diag(st_dev2)=st_dev
st_dev2
Dmat=st_dev2%*%CM2%*%st_dev2
varcov_dati #come riprova. Dmat e varcov_dati devono essere simili

Amat=matrix(0,13,15) 
# 8 pesi dipendenti, 5 indipendenti (runif), 1 somma pari a 1, 1 il rendimento
# il vincolo del maggiore di zero va messo all'estrema destra (per ultimo)
# funzione meq = 10
Amat[,1]=1
Amat
b0=rep(0,15)
b0[1]=1
b0[2]=0.006
dvec=rep(0,13)
# con lo storico medie degli indicator su 7 dati, con le simulate medie su 40000 
# creazione dei vincoli
Amat[,2]=mean_dati
Amat[1,3]=1
Amat[6,3]=-0.873
Amat[2,4]=1
Amat[7,4]=-0.873
Amat[3,5]=1
Amat[8,5]=-0.873
Amat[4,6]=1
Amat[9,6]=-0.873
Amat[6,7]=-1
Amat[10,7]=1
Amat[7,8]=-1
Amat[11,8]=1
Amat[8,9]=-1
Amat[12,9]=1
Amat[9,10]=-1
Amat[5,10]=-1
Amat[13,10]=1
Amat[5,11]=1 
Amat[6,12]=1
Amat[7,13]=1
Amat[8,14]=1
Amat[9,15]=1

# iterazioni
n=1000
front=matrix( , nrow=n, ncol=15)
pesi=matrix( , nrow=n, ncol=13 )
min=-0.01
max=0.01
for (i in 1:n) {
  Frontiera$solution=0
  pesi[i,]=0
  mu_p_ammissibile=0
  sigma_p_ammissibile=0
  rendim=seq(-0.01,0.01,by=(max-min)/(n-1))
  b0[2]=rendim[i]
  try(Frontiera<-solve.QP(Dmat,dvec,Amat,bvec=b0,meq=10)) 
  try(pesi[i,]<-Frontiera$solution)
  try(mu_p_ammissibile<-mean_dati%*%pesi[i,])
  try(sigma_p_ammissibile<-sqrt(t(pesi[i,])%*%varcov_dati%*%pesi[i,]))
  try(front[i,]<-c(pesi[i,],mu_p_ammissibile,sigma_p_ammissibile))
}


#tengo 6 decimali per evitare che la matrice non sia simmetrica
CM3<-round(CM2,6)
CM3