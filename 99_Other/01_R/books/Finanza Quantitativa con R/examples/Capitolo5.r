

# ==============================================================================
#
#                                 CAPITOLO 5
#
#                       MISURAZIONE DEL RISCHIO FINANZIARIO
#
# ==============================================================================



# ==============================================================================
#
#  NOTA:    I file di codice R di ogni capitolo contengono tutte le funzioni ne- 
#         cessarie a generare i risultati relativi alle tabelle presentate negli
#         esempi etutti i grafici presenti nel libro.
#           I file sono organizzati in sezioni contenenti il codice di ciascuna
#         funzione necessaria a riprodurre una figura od un risultato di una ta-
#         bella o di un esempio.
#           All'inizio di ogni file possono essere presenti le sezioni denomina-
#         te "FUNZIONI GRAFICHE COMUNI" e "FUNZIONI COMUNI". Entrambe contengono
#         funzioni che vengono richiamate in più sezioni del file e che quindi
#         sono comuni a più di una figura o di un esempio.
#           Il codice è strutturato in modo da consentire all'utente di ottenere
#         una figura o un risultato semplicemente richiamando (nel modo opportu-
#         no) la funzione d'interesse, senza doversi preoccupare delle librerie
#         da caricare in memoria, delle impostazioni grafiche di finestre già
#         attive o della presenza dei dati in memoria. Per queste ragioni, ogni
#         funzione controlla che le librerie necessarie siano state caricate (in
#         caso contrario provvede in automatico) e carica in automatico i dati 
#         necessari alle elaborazioni. A tal proposito avvisiamo il lettore che,
#         per una questione di praticità d'uso, le funzioni ipotizzano di avere
#         i file di dati da caricare disponibili nella cartella di lavoro. Il
#         lettore deve quindi provvedere a copiare nella cartella di lavoro i
#         file dati "S&P500.RData", "ENI.RData", "oprisk.RData" disponibili sul
#         sito internet del libro.
#           Ricordiamo al lettore che l'indirizzo della cartella di lavoro di R
#         può essere recuperato mediante la funzione "getwd" e modificato attra-
#         verso la funzione "setwd".
#
#                                                    Buon lavoro!
#
#                                                  M. Bee, F. Santi
#
# ==============================================================================



# ==============================================================================
#                         FUNZIONI GRAFICHE COMUNI
# ==============================================================================
#
# Questa funzione definisce le impostazioni standard per tutti i grafici.

IGS<- function(tipo=0,quad=FALSE)
{
  graphics.off()   
  if (!quad) { windows(width=7,height=14/3) }
  if (tipo==0) { par(las=1,cex.axis=0.8,tck=-0.01,mar=c(3,3,2,2)+0.1) }
  if (tipo==1) { par(las=0,cex.axis=1.8,tck=-0.01,mar=c(3,3,2,2)+0.1) }
  if (tipo==2) { par(las=1,cex.axis=0.8,cex.lab=0.8,tck=-0.01,mar=c(4,4,4,2)
    +0.1) }
}
# ==============================================================================



# ==============================================================================
# ESEMPIO 5.3 - Stima non parametrica di VaR ed ES
# ==============================================================================
#
# Input:
# Serie    - [timeSeries] Serie storica dei prezzi (se "Rend" è FALSE) o dei 
#            rendimenti (se "Rend" è TRUE) del titolo ;
# conf     - [num] Livello di confidenza da adottare per il caldolo delle misure
#            di rischio. Valore predefinito: 0.99;
# VaR      - [logical] Scelta della misura di rischio da calcolare tra VaR
#            (TRUE) ed ES (FALSE). Valore predefinito: VaR (TRUE);
# Rend     - [logical] Indicatore per i dati contenuti nel parametro "Serie":
#            serie storica dei rendimenti se TRUE, serie storica dei prezzi se 
#            FALSE.
#
# Output:   [num] Stima puntuale della misura di rischio.
#
# Esempio: 
#
# > out<- esempio5p3(SSt,0.99,TRUE,FALSE)
   
esempio5p3<- function(Serie,conf=0.99,VaR=TRUE,Rend=FALSE)
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Memorizziamo in "camp" la serie dei tassi di perdita dai rendimenti logarit-
  # mici
  if (Rend) { camp<- -Serie }
  else { camp<- -returns(Serie) }
  # Selezioniamo il periodo temporale di stima
  camp<- window(camp,start='2002-05-08',end='2009-05-07')
  # Trasformiamo la serie storica in vettore numerico ed ordiniamo il campione
  camp<- sort(as.vector(camp))
  # Calcoliamo il VaR
  out<- camp[ceiling(conf*length(camp))]
  # Se VaR==FALSE calcoliamo l'ES sulla base del VaR memorizzato nella variabile 
  # "out"
  if (!VaR) { out<- mean(camp[camp>out]) }
  # Restituiamo l'output della funzione
  out
}
# ==============================================================================



# ==============================================================================
# ESEMPIO 5.4 - Stima di VaR ed ES sotto l'ipotesi di normalità
# ==============================================================================
#
# Input:
# Serie    - [timeSeries] Serie storica dei prezzi (se "Rend" è FALSE) o dei
#            rendimenti (se "Rend" è TRUE) del titolo ;
# conf     - [num] Livello di confidenza da adottare per il caldolo delle misure
#            di rischio. Valore predefinito: 0.99;
# VaR      - [logical] Scelta della misura di rischio da calcolare tra VaR
#            (TRUE) ed ES (FALSE). Valore predefinito: VaR (TRUE);
# Rend     - [logical] Indicatore per i dati contenuti nel parametro "Serie":
#            serie storica dei rendimenti se TRUE, serie storica dei prezzi se
#            FALSE.
#
# Output:    [num] Stima puntuale della misura di rischio.
#
# Esempio:
#
# > out<- esempio5p4(SSt,0.95,FALSE,TRUE) 
   
esempio5p4<- function(Serie,conf=0.99,VaR=TRUE,Rend=FALSE)
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Memorizziamo in "camp" la serie dei tassi di perdita dai rendimenti logarit-
  # mici
  if (Rend) { camp<- -Serie }
  else { camp<- -returns(Serie) }
  # Selezioniamo il periodo temporale di stima
  camp<- window(camp,start='2002-05-08',end='2009-05-07')
  # Trasformiamo la serie storica in vettore numerico
  camp<- as.vector(camp)
  # Calcoliamo media e deviazione standard
  me<- mean(camp)
  ds<- sd(camp)
  # Se VaR==TRUE calcoliamo il VaR, altrimenti l'ES
  if (VaR) { out<- me+ds*qnorm(conf) }
  else { out<- me+ds*dnorm(qnorm(conf))/(1-conf) }
  # Restituiamo l'output della funzione
  out
}
# ==============================================================================



# ==============================================================================
# ESEMPIO 5.6 - Stima di VaR ed ES mediante la t di Student
# ==============================================================================
#
# Input:
# Serie    - [timeSeries] Serie storica dei prezzi (se "Rend" è FALSE) o dei
#            rendimenti (se "Rend" è TRUE) del titolo ;
# conf     - [num] Livello di confidenza da adottare per il caldolo delle misure
#            di rischio. Valore predefinito: 0.99;
# VaR      - [logical] Scelta della misura di rischio da calcolare tra VaR
#            (TRUE) ed ES (FALSE). Valore predefinito: VaR (TRUE);
# iniz     - [num[1:3]] Vettore per l'inizializzazione dei parametri nelle
#            procedure di ottimizzazione numerica. Valore predefinito: me=0,
#            ds=1, nu=1;
# Rend     - [logical] Indicatore per i dati contenuti nel parametro "Serie":
#            serie storica dei rendimenti se TRUE, serie storica dei prezzi se
#            FALSE.
#
# Output:    [num] Stima puntuale della misura di rischio.
#
# Esempio:
#
# > out<- esempio5p6(SSt,0.99,TRUE,c(0,1,1),FALSE)

# Definiamo la funzione di densità di probabilità
funzDens<- function(x,me,ds,nu)
{
  out<- 1/ds*dt((x-me)/ds,nu)
  out
}
   
esempio5p6<- function(Serie,conf=0.99,VaR=TRUE,iniz=c(0,1,1),Rend=FALSE)
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  require(MASS)
  # Memorizziamo in "camp" la serie dei tassi di perdita dai rendimenti logarit-
  # mici
  if (Rend) { camp<- -Serie }
  else { camp<- -returns(Serie) }
  # Selezioniamo il periodo temporale di stima
  camp<- window(camp,start='2002-05-08',end='2009-05-07')
  # Trasformiamo la serie storica in vettore numerico
  camp<- as.vector(camp)
  # Stimiamo i parametri
  Stime<- fitdistr(camp,funzDens,start=list(me=iniz[1],ds=iniz[2],nu=iniz[3]))
  # Se VaR==TRUE calcoliamo il VaR, altrimenti l'ES
  if (VaR) { 
    out<- Stime$estimate[1]+Stime$estimate[2]*qt(conf,Stime$estimate[3])
  }
  else {
    # Calcoliamo l'ES per una t di Student con i gradi di libertà stimati 
    # mediante l'equazione (5.5) dopo aver verificato che la stima dei gradi di
    # libertà è superiore ad 1
    if (Stime$estimate[3]>1) {
      depo<- dt(qt(conf,Stime$estimate[3]),Stime$estimate[3])/(1-conf)
      depo<- depo*(Stime$estimate[3]+(qt(conf,Stime$estimate[3]))^2)/
        (Stime$estimate[3]-1)
    }
    else { depo<- NA }
    # Applichiamo l'equazione (5.3)
    out<- Stime$estimate[1]+Stime$estimate[2]*depo
  }
  # Restituiamo l'output della funzione in formato numerico (senza etichette)
  as.numeric(out)
}
# ==============================================================================



# ==============================================================================
# FIGURA 5.1 - Rendimenti giornalieri dell'indice S&P500 e stime del VaR incon-
#              dizionato a vari livelli di confidenza
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura5p1()

figura5p1<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Inizializziamo le variabili grafiche
  colori<- c('gray60','black')
  linee<- c(1,1,2,4)
  # Diamo le impostazioni della finestra grafica
  IGS()    
  # Tracciamo il grafico dei rendimenti
  plot(returns(SP500),xlab='',ylab='',col=colori[1])
  # Aggiungiamo le stime del VaR incondizionato basate sulla modellizzazione
  # della t di Student a tre differenti livelli di confidenza
  abline(h=-esempio5p6(SP500,0.9),lty=linee[2],col=colori[2],lwd=2)
  abline(h=-esempio5p6(SP500,0.99),lty=linee[3],col=colori[2],lwd=2)
  abline(h=-esempio5p6(SP500,0.995),lty=linee[4],col=colori[2],lwd=2)
  # Aggiungiamo la griglia   
  depo<- seq(time(SP500)[2],time(SP500)[length(SP500)],length.out=6)
  abline(v=depo,lty=2,col='lightgray')
  grid(NA,NULL,lty=2,col='lightgray')
  # Aggiungiamo la legenda
  tleg<- c('Rendimenti S&P500','VaR 95.0% (negativo)',
    'VaR 99.0% (negativo)','VaR 99.5% (negativo)')
  legend('topright',legend=tleg,col=c(colori[1],rep(colori[2],3)),
    lty=linee,lwd=2,bg='white',cex=0.8)
  # Salvataggio
  savePlot('inVaRSP500','pdf')
} 
# ==============================================================================



# ==============================================================================
# FIGURA 5.2 - Rendimenti giornalieri dell'indice S&P500 e stime del VaR condi-
#              zionato al 99%
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura5p2()

figura5p2<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  require(fGarch)
  require(MASS)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Calcoliamo la serie dei rendimenti e stimiamo il modello ARMA-GARCH
  X<- returns(SP500)
  Modello<-garchFit(~arma(0,1)+garch(2,1),data=X,cond.dist='QMLE')
  # Ricaviamo le serie storiche della media e della varianza condizionate e
  mu_t<- Modello@fitted
  sigma_t<- volatility(Modello)
  # Ricaviamo la serie storica del negativo dei residui standardizzati
  Z<- -residuals(Modello,TRUE)
  # Stimiamo il VaR incondizionato sul negativo dei residui standardizzati
  Stime<- fitdistr(Z,'t')
  VaR_Z<- Stime$estimate[1]+Stime$estimate[2]*qt(0.99,Stime$estimate[3])
  # Calcoliamo le stime del VaR condizionato
  VaR<- as.timeSeries(-mu_t+sigma_t*VaR_Z)
  # Diamo le impostazioni della finestra grafica
  IGS() 
  # Tracciamo le serie storiche dei rendimenti e del VaR condizionato   
  plot(X,ylim=c(-0.15,0.12),xlab='',ylab='',col='gray60')
  lines(-VaR,col='black')   
  # Aggiungiamo la griglia
  depo<- seq(time(SP500)[2],time(SP500)[length(SP500)],length.out=6)
  abline(v=depo,lty=2,col='lightgray')
  grid(NA,NULL,lty=2,col='lightgray')
  # Aggiungiamo la legenda
  tleg<- c('Rendimenti S&P500','VaR 99.0% (negativo)')
  legend('topright',legend=tleg,col=c('gray60','black'),lwd=2,bg='white',
    cex=0.8)
  # Salvataggio
  savePlot('cVaRSP500','pdf')
} 
# ==============================================================================



# ==============================================================================
# FIGURA 5.3 - Funzione di densità di probabilità e coda destra
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura5p3()

figura5p3<- function()
{ 
  # Diamo le impostazioni della finestra grafica   
  graphics.off()
  windows(width=7,height=4)
  par(las=1,cex.axis=0.8,tck=-0.01,mar=c(3,3,2,2)+0.1)
  # Inizializziamo i parametri del grafico
  n<- 100
  u<- 9
  supx<- 15
  # Tracciamo la curva di densità di probabilità
  curve(dchisq(x,5),xlim=c(0,supx),n=500,axes=FALSE,xlab='',ylab='')
  # Aggiungiamo gli assi
  depo<- seq(0,supx,3)
  axis(1,at=depo,labels=c('','','','u','',''),pos=0)
  depo<- seq(0,0.15,0.03)
  axis(2,at=depo,labels=rep('',length(depo)),pos=0)
  # Coloriamo la regione della coda destra
  depo<- seq(u,supx,length.out=n)
  xx<- c(depo,rev(depo)) 
  yy<- c(dchisq(depo,5),rep(0,n))
  polygon(xx,yy,col='lightgray',density=-30,border='black')
  # Salvataggio
  savePlot('eot','pdf') 
}
# ==============================================================================



# ==============================================================================
# FIGURE 5.4 - Mean excess function campionaria
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura5p4a()

figura5p4a<- function()
{ 
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  require(evir)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Diamo le impostazioni della finestra grafica  
  IGS(1,TRUE)
  # Calcoliamo la serie storica dei rendimenti
  X<- returns(SP500)
  # Selezioniamo il periodo temporale d'interesse
  X<- window(X,start='2002-05-08',end='2009-05-07')
  # Tracciamo il grafico
  meplot(-X[X<0],30,labels=FALSE,pch=19,col='grey60')
  # Salvataggio
  savePlot('mefSP500sx','pdf')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura5p4b()

figura5p4b<- function()
{ 
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  require(evir)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Diamo le impostazioni della finestra grafica
  IGS(1,TRUE)
  # Calcoliamo la serie storica dei rendimenti
  X<- returns(SP500)
  # Selezioniamo il periodo temporale d'interesse
  X<- window(X,start='2002-05-08',end='2009-05-07')
  # Tracciamo il grafico
  meplot(X[X>0],50,labels=FALSE,pch=19,col='grey60')
  # Salvataggio
  savePlot('mefSP500dx','pdf')
}

# ==============================================================================



# ==============================================================================
# FIGURE 5.5 - Mean excess function campionaria
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura5p5a()

figura5p5a<- function()
{ 
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  require(evir)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Diamo le impostazioni della finestra grafica
  IGS(1,TRUE)
  # Calcoliamo la serie storica dei rendimenti
  X<- returns(SP500)
  # Selezioniamo il periodo temporale d'interesse
  X<- window(X,start='2002-05-08',end='2007-05-07')
  # Tracciamo il grafico
  meplot(-X[X<0],25,labels=FALSE,pch=19,col='grey60')
  # Salvataggio
  savePlot('mef2SP500sx','pdf')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura5p5b()

figura5p5b<- function()
{ 
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  require(evir)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Diamo le impostazioni della finestra grafica
  IGS(1,TRUE)
  # Calcoliamo la serie storica dei rendimenti
  X<- returns(SP500)
  # Selezioniamo il periodo temporale d'interesse
  X<- window(X,start='2002-05-08',end='2007-05-07')
  # Tracciamo il grafico
  meplot(X[X>0],25,labels=FALSE,pch=19,col='grey60')
  # Salvataggio
  savePlot('mef2SP500dx','pdf')
}

# ==============================================================================



# ==============================================================================
# FIGURA 5.6 - Stima di massima verosimiglianza per il parametro di forma della
#              GPD al variare della soglia
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura5p6()

figura5p6<- function()
{ 
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  require(evir)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Calcoliamo la serie storica dei rendimenti  
  X<- returns(SP500)
  # Selezioniamo il periodo temporale d'interesse
  X<- window(X,start='2002-05-08',end='2007-05-07')
  # Diamo le impostazioni della finestra grafica
  IGS(2)
  # Calcoliamo le stime del parametro di forma
  out<- shape(-X,200,15,500,reverse=FALSE)
  # Tracciamo il grafico
  plot(out[4,],out[2,],type='l',ylim=c(-0.9,0.3),lwd=2,xlab='Numero di eccessi',
    axes=FALSE,ylab='Parametro di forma',main='')
  # Aggiungiamo gli assi
  depo<- seq(1,length(out[4,]),length.out=6)
  axis(1,at=out[4,depo],labels=out[4,depo])
  axis(2,at=pretty(out[2,]))
  axis(3,at=out[4,depo],labels=round(out[1,depo],4))
  mtext('Soglia',side=3,line=3,cex=0.8)
  # Aggiungiamo il riquadro
  box()
  # Aggiungiamo le bande di confidenza
  lines(out[4,],out[2,]+qnorm(0.975)*out[3,],lty=5,lwd=2,col='grey60')
  lines(out[4,],out[2,]-qnorm(0.975)*out[3,],lty=5,lwd=2,col='grey60')
  # Aggiungiamo la griglia
  abline(h=pretty(out[2,]),v=out[4,depo],lty=2,col='lightgray')
  # Salvataggio
  savePlot('shapeSP500','pdf')
} 
# ==============================================================================



# ==============================================================================
# ESEMPIO 5.10 - Stima di VaR ed ES mediante il modello POT
# ==============================================================================
#
# Input:
# Serie      - [timeSeries] Serie storica dei prezzi (se "Rend" è FALSE) o dei 
#              rendimenti (se "Rend" è TRUE) del titolo;
# conf       - [num] Livello di confidenza da adottare per il caldolo delle mi-
#              sure di rischio. Valore predefinito: 0.99;
# VaR        - [logical] Scelta della misura di rischio da calcolare tra VaR 
#              (TRUE) ed ES (FALSE). Valore predefinito: VaR (TRUE);
# soglia     - [num] Soglia rispetto a cui calcolare gli eccessi;
# Rend       - [logical] Indicatore per i dati contenuti nel parametro "Serie": 
#              serie storica dei rendimenti se TRUE, serie storica dei prezzi se 
#              FALSE.
#
# Output:      [num] Stima puntuale della misura di rischio.
#
# Esempio:
#
# > out<- esempio5p10(SSt,0.995,TRUE,0.007,FALSE)
   
esempio5p10<- function(Serie,conf=0.99,VaR=TRUE,soglia,Rend=FALSE)
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  require(evir)
  # Memorizziamo in "camp" la serie dei tassi di perdita dai rendimenti logarit-
  # mici
  if (Rend) { camp<- -Serie }
  else { camp<- -returns(Serie) }
  # Selezioniamo il periodo temporale di stima
  camp<- window(camp,start='2002-05-08',end='2009-05-07')
  # Trasformiamo la serie storica in vettore numerico
  camp<- as.vector(camp)
  # Stimiamo i parametri
  Stime<- gpd(camp,threshold=soglia,method='ml') 
  # Calcoliamo le misure di rischio
  out<- riskmeasures(Stime,conf)
  # Se VaR==TRUE restituiamo in output il VaR, altrimenti l'ES  
  if (VaR) { out<- out[1,2] }
  else { out<- out[1,3] }
  # Restituiamo l'output della funzione in formato numerico (senza etichette)
  as.numeric(out)
}
# ==============================================================================



# ==============================================================================
# ESEMPIO 5.11 - Backtesting del VaR incondizionato
# ==============================================================================
#
# Input:
# Serie    - [timeSeries] Serie storica dei prezzi del titolo;
# conf     - [num] Livello di confidenza da adottare per il caldolo delle misure 
#            di rischio. Valore predefinito: 0.99;
# metodo   - [num] Scelta del metodo di calcolo del VaR: 1. Non parametrico (va-
#            lore predefinito); 2. Basato sulla normalità dei rendimenti; 3. Ba- 
#            sato sull'ipotesi di distribuzione dei rendimenti standardizzati 
#            secondo una t di Student; 4. Semi parametrico (metodo POT);
# ...      - altri parametri da passare alle varie funzioni per la stima del VaR
#            ("iniz" per il metodo basato sulla t di Student e "soglia" per il 
#            metodo POT); 
#
# Output:    [array-num] Vettore named contenente la frquenza di violazione del
#            VaR condizionato nel campione di backtesting ed il relativo
#            p-value.
#
# Esempio:  
#
# > out<- esempio5p11(SSt,0.99,metodo=4,soglia=0.004)
   
esempio5p11<- function(Serie,conf=0.99,metodo=1,...)
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # In base al valore del parametro "metodo" stimiamo il VaR servendoci delle
  # funzioni già sviluppate per gli altri esempi ricordando che tali funzioni
  # selezionano autonomamente il campione di stima corretto
  if (metodo==1) { VaR<- esempio5p3(Serie,conf,TRUE,Rend=FALSE) }
  if (metodo==2) { VaR<- esempio5p4(Serie,conf,TRUE,Rend=FALSE) }
  if (metodo==3) { VaR<- esempio5p9(Serie,conf,TRUE,Rend=FALSE,...) }
  if (metodo==4) { VaR<- esempio5p10(Serie,conf,TRUE,Rend=FALSE,...) }
  # Calcoliamo la serie dei tassi di perdita dai rendimenti logaritmici e sele-
  # zioniamo il campione su cui eseguire il backtesting
  X<- -returns(Serie)
  XBt<- window(X,start='2009-05-08',end='2012-05-07')
  # Contiamo le violazioni ed eseguiamo il backtest
  w<- sum(XBt>VaR)
  out<- binom.test(w,length(XBt),1-conf,'t')
  # Restituiamo in output un vettore di tipo "named" contenente il VaR stimato,
  # la frequenza violazione del VaR nel campione XBt ed il p-value del test
  out<- c(VaR,out$estimate,out$p.value)
  names(out)<- c('VaR stimato','Freq. Violazione','p-value')
  out
}
# ==============================================================================



# ==============================================================================
# ESEMPIO 5.12 - Backtesting del VaR condizionato (Tabella 5.7)
# ==============================================================================
#
# Input:
# Serie    - [timeSeries] Serie storica dei prezzi del titolo;
# conf     - [num] Livello di confidenza da adottare per il caldolo delle misure 
#            di rischio. Valore predefinito: 0.99;
# metodo   - [num] Scelta del metodo di calcolo del VaR: 1. Non parametrico (va-
#            lore predefinito); 2. Basato sulla normalità dei rendimenti; 3. Ba- 
#            sato sull'ipotesi di distribuzione dei rendimenti standardizzati 
#            secondo una t di Student; 4. Semi parametrico (metodo POT);
# ...      - altri parametri da passare alle varie funzioni per la stima del VaR
#            ("iniz" per il metodo basato sulla t di Student e "soglia" per il 
#            metodo POT). 
#
# Output:    [array-num] Vettore named contenente la frquenza di violazione del
#            VaR condizionato nel campione di backtesting ed il relativo
#            p-value.
#
# Esempio:
#
# > out<- tabella5p7(SSt,conf=0.99,metodo=2)  
   
tabella5p7<- function(Serie,conf=0.99,metodo=1,...)
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  require(fGarch)
  # Calcoliamo la serie dei rendimenti logaritmici e strutturiamo la variabile
  # "SSt" di tipo timeSeries
  SSt<- cbind(Prezzo_t=Serie,X_t=c(NA,returns(Serie)),mu_t=NA,sigma_t=NA,VaR=NA)
  # Selezioniamo il campione di stima
  XSt<- window(SSt[,2],start='2002-05-08',end='2009-05-07')
  # Stimiamo il modello ARMA-GARCH
  Modello<- garchFit(~arma(0,1)+garch(2,1),data=XSt,cond.dist='QMLE',
    trace=FALSE)
  # Ricaviamo la serie storica dei residui standardizzati
  Z_t<- as.timeSeries(residuals(Modello,TRUE))
  rownames(Z_t)<- rownames(XSt)
  # In base al valore del parametro "metodo" stimiamo il VaR servendoci delle
  # funzioni già sviluppate per gli altri esempi ricordando che tali funzioni
  # selezionano autonomamente il campione di stima corretto
  if (metodo==1) { VaR_Z<- esempio5p3(-Z_t,conf,VaR=TRUE,Rend=TRUE) }
  if (metodo==2) { VaR_Z<- esempio5p4(-Z_t,conf,VaR=TRUE,Rend=TRUE) }
  if (metodo==3) { VaR_Z<- esempio5p6(-Z_t,conf,VaR=TRUE,Rend=TRUE,...) }
  if (metodo==4) { VaR_Z<- esempio5p10(-Z_t,conf,VaR=TRUE,Rend=TRUE,...) }
  # Ricaviamo le numerosità dell'intera serie storica e del campione di stima
  Nt<- length(SSt[,1])
  Ns<- length(XSt[,1])
  # Ricaviamo la serie della media e della volatilià condizionate
  SSt$mu_t[2:(Ns+1)]<- Modello@fitted
  SSt$sigma_t[2:(Ns+1)]<- Modello@sigma.t^2
  # Inizializziamo i parametri per la previsione dei processi della media e del-
  # la volatilità condizionate
  depo<- coef(Modello)
  m<- 0
  n<- 1
  p<- 2
  q<- 1
  depo<- coef(Modello)
  mu<- depo[1]
  thetaj<- depo[(m+2):(m+n+1)]
  alpha0<- depo[m+n+2]
  alphaj<- depo[(m+n+3):(m+n+p+2)]
  betaj<- depo[(m+n+p+3):(m+n+p+q+2)]
  # Calcoliamo le previsioni puntuali dei processi della media e della volatili-
  # tà condizionate
  for(s in (Ns+2):Nt)
  {
    SSt$mu_t[s]<- mu+sum(thetaj*(SSt$X_t[(s-1):(s-n)]-SSt$mu_t[(s-1):(s-n)]))
    SSt$sigma_t[s]<- alpha0+sum(alphaj*
      (SSt$X_t[(s-1):(s-p)]-SSt$mu_t[(s-1):(s-p)])^2)+
      sum(betaj*SSt$sigma_t[(s-1):(s-q)])
  }
  SSt$sigma_t<- sqrt(SSt$sigma_t)
  # Ricaviamo le previsioni per il VaR condizionato
  SSt$VaR<- -SSt$mu_t+SSt$sigma_t*VaR_Z
  # Contiamo le violazioni ed eseguiamo il backtest
  w<- sum(SSt$X_t[(Ns+2):Nt]<(-SSt$VaR[(Ns+2):Nt]))
  out<- binom.test(w,Nt-Ns,1-conf,'t')
  # Restituiamo in output un vettore di tipo "named" contenente il VaR stimato,
  # la frequenza violazione del VaR nel campione XBt ed il p-value del test
  out<- c(out$estimate,out$p.value)
  names(out)<- c('Freq. Violazione','p-value')
  out
}
# ==============================================================================



# ==============================================================================
# ESEMPIO 5.12 - Backtesting del VaR condizionato (Tabella 5.8)
# ==============================================================================
#
# Input:
# Serie    - [timeSeries] Serie storica dei prezzi del titolo;
# conf     - [num] Livello di confidenza da adottare per il caldolo delle misure 
#            di rischio. Valore predefinito: 0.99;
# metodo   - [num] Scelta del metodo di calcolo del VaR: 1. Non parametrico (va-
#            lore predefinito); 2. Basato sulla normalità dei rendimenti; 3. Ba- 
#            sato sull'ipotesi di distribuzione dei rendimenti standardizzati 
#            secondo una t di Student; 4. Semi parametrico (metodo POT);
# ...      - altri parametri da passare alle varie funzioni per la stima del VaR
#            ("iniz" per il metodo basato sulla t di Student e "soglia" per il 
#            metodo POT). 
#
# Output:    [array-num] Vettore named contenente la frquenza di violazione del
#            VaR condizionato nel campione di backtesting ed il relativo
#            p-value.
#
# Esempio:
#
# > out<- tabella5p8(SSt,0.99,metodo=3,iniz=c(0,1,4))  
   
tabella5p8<- function(Serie,conf=0.99,metodo=1,...)
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Calcoliamo la serie dei rendimenti logaritmici e strutturiamo la variabile
  # "SSt" di tipo timeSeries
  SSt<- cbind(Prezzo_t=Serie,X_t=c(NA,returns(Serie)),mu_t=NA,sigma_t=NA,VaR=NA)
  # Selezioniamo il campione di stima
  XSt<- window(SSt[,2],start='2002-05-08',end='2009-05-07')
  # Stimiamo il modello ARMA-GARCH
  Modello<- garchFit(~garch(1,1),data=XSt,cond.dist='QMLE',trace=FALSE)
  # Ricaviamo la serie storica dei residui standardizzati
  Z_t<- as.timeSeries(residuals(Modello,TRUE))
  rownames(Z_t)<- rownames(XSt)
  # In base al valore del parametro "metodo" stimiamo il VaR servendoci delle
  # funzioni già sviluppate per gli altri esempi ricordando che tali funzioni
  # selezionano autonomamente il campione di stima corretto
  if (metodo==1) { VaR_Z<- esempio5p3(-Z_t,conf,VaR=TRUE,Rend=TRUE) }
  if (metodo==2) { VaR_Z<- esempio5p4(-Z_t,conf,VaR=TRUE,Rend=TRUE) }
  if (metodo==3) { VaR_Z<- esempio5p9(-Z_t,conf,VaR=TRUE,Rend=TRUE,...) }
  if (metodo==4) { VaR_Z<- esempio5p10(-Z_t,conf,VaR=TRUE,Rend=TRUE,...) }
  # Ricaviamo le numerosità dell'intera serie storica e del campione di stima
  Nt<- length(SSt[,1])
  Ns<- length(XSt[,1])
  # Ricaviamo la serie della media e della volatilià condizionate
  SSt$mu_t[2:(Ns+1)]<- Modello@fitted
  SSt$sigma_t[2:(Ns+1)]<- Modello@sigma.t^2
  # Inizializziamo i parametri per la previsione dei processi della media e del-
  # la volatilità condizionate
  depo<- coef(Modello)
  m<- 0
  n<- 0
  p<- 1
  q<- 1
  depo<- coef(Modello)
  mu<- depo[1]
  alpha0<- depo[m+n+2]
  alphaj<- depo[(m+n+3):(m+n+p+2)]
  betaj<- depo[(m+n+p+3):(m+n+p+q+2)]
  SSt$mu_t<- mu
  # Calcoliamo le previsioni puntuali dei processi della media e della volatili-
  # tà condizionate
  for(s in (Ns+2):Nt)
  {
    SSt$sigma_t[s]<- alpha0+sum(alphaj*
      (SSt$X_t[(s-1):(s-p)]-SSt$mu_t[(s-1):(s-p)])^2)+
      sum(betaj*SSt$sigma_t[(s-1):(s-q)])
  }
  SSt$sigma_t<- sqrt(SSt$sigma_t)
  # Ricaviamo le previsioni per il VaR condizionato
  SSt$VaR<- -SSt$mu_t+SSt$sigma_t*VaR_Z
  # Contiamo le violazioni ed eseguiamo il backtest
  w<- sum(SSt$X_t[(Ns+2):Nt]<(-SSt$VaR[(Ns+2):Nt]))
  out<- binom.test(w,Nt-Ns,1-conf,'t')
  # Restituiamo in output un vettore di tipo "named" contenente il VaR stimato,
  # la frequenza violazione del VaR nel campione XBt ed il p-value del test
  out<- c(out$estimate,out$p.value)
  names(out)<- c('Freq. Violazione','p-value')
  out
}
# ==============================================================================



# ==============================================================================
# ESEMPIO 5.12 - Backtesting del VaR condizionato (Tabelle 5.9 e 5.10)
# ==============================================================================
#
# Input:
# Serie    - [timeSeries] Serie storica dei prezzi del titolo;
# conf     - [num] Livello di confidenza da adottare per il caldolo delle misure 
#            di rischio. Valore predefinito: 0.99;
# metodo   - [num] Scelta del metodo di calcolo del VaR: 1. Non parametrico (va-
#            lore predefinito); 2. Basato sulla normalità dei rendimenti; 3. Ba-
#            sato sull'ipotesi di distribuzione dei rendimenti standardizzati 
#            secondo una t di Student; 4. Semi parametrico (metodo POT);
# ...      - altri parametri da passare alle varie funzioni per la stima del VaR
#            ("iniz" per il metodo basato sulla t di Student e "soglia" per il 
#            metodo POT); 
#
# Output:    [array-num] Vettore named contenente la frquenza di violazione del
#            VaR condizionato nel campione di backtesting ed il relativo
#            p-value.
#
# Esempio:
#
# > out<- tabellaEWMA(SSt,0.95,metodo=1)  
   
tabellaEWMA<- function(Serie,conf=0.99,metodo=1,...)
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Calcoliamo la serie dei rendimenti logaritmici e strutturiamo la variabile
  # "SSt" di tipo timeSeries
  SSt<- cbind(Prezzo_t=Serie,X_t=c(NA,returns(Serie)),sigma_t=NA,VaR=NA)
  # Ricaviamo le numerosità dell'intera serie storica e del campione di stima
  Nt<- length(SSt[,1])
  Ns<- length(window(SSt[,2],start='2002-05-08',end='2009-05-07'))
  # Calcoliamo la serie della volatilià condizionata
  w<- 0.94^(0:74)
  SSt$sigma_t[77]<- sum(w*SSt$X_t[76:2]^2)/sum(w)
  for (s in 78:Nt)
  {
    SSt$sigma_t[s]<- 0.94*SSt$sigma_t[s-1]+0.06*SSt$X_t[s-1]^2
  }
  SSt$sigma_t<- sqrt(SSt$sigma_t)
  # Ricaviamo la serie storica dei residui standardizzati
  Z_t<- as.timeSeries(SSt$X_t[77:Ns]/SSt$sigma_t[77:Ns])
  rownames(Z_t)<- rownames(SSt)[77:Ns] 
  # In base al valore del parametro "metodo" stimiamo il VaR servendoci delle
  # funzioni già sviluppate per gli altri esempi ricordando che tali funzioni
  # selezionano autonomamente il campione di stima corretto
  if (metodo==1) { VaR_Z<- esempio5p3(-Z_t,conf,VaR=TRUE,Rend=TRUE) }
  if (metodo==2) { VaR_Z<- esempio5p4(-Z_t,conf,VaR=TRUE,Rend=TRUE) }
  if (metodo==3) { VaR_Z<- esempio5p9(-Z_t,conf,VaR=TRUE,Rend=TRUE,...) }
  if (metodo==4) { VaR_Z<- esempio5p10(-Z_t,conf,VaR=TRUE,Rend=TRUE,...) }
  # Ricaviamo le previsioni per il VaR condizionato
  SSt$VaR<- SSt$sigma_t*VaR_Z
  # Contiamo le violazioni ed eseguiamo il backtest
  w<- sum(SSt$X_t[(Ns+1):Nt]<(-SSt$VaR[(Ns+1):Nt]))
  out<- binom.test(w,Nt-Ns,1-conf,'t')
  # Restituiamo in output un vettore di tipo "named" contenente il VaR stimato,
  # la frequenza violazione del VaR nel campione XBt ed il p-value del test
  out<- c(out$estimate,out$p.value)
  names(out)<- c('Freq. Violazione','p-value')
  out
}
# ==============================================================================
 
 

# ==============================================================================
# ESEMPIO 5.15 - Calcolo della PD tramite il modello di Merton
# ==============================================================================
#
# Input:  
# S0        - [num] Prezzo iniziale dell'attivo;
# mu        - [int] Drift del moto browniano geometrico che descrive l'evoluzio-
#             ne dell'attivo;
# sigma     - [num] Volatilità dell'attivo;     
# T1        - [num] Orizzonte temporale di riferimento
# soglia    - [num] Soglia di default (valore del capitale netto);
# num_paths - [num] Numerosità del campione per la simulazione Monte Carlo.
#
# Output:     [list] Lista a due componenti. La prima componente contiene la 
#             probabilità di default esatta; la seconda quella stimata secondo 
#             il metodo Monte Carlo.
#
# Esempio: 
#
# > out<- esempio5p15(S0,mu,sigma,T1,soglia,num_paths)

esempio5p15<- function(S0,mu,sigma,T1,soglia,num_paths)
{
  # Inizializziamo il seme delle procedure di estrazione di numeri pseudocasuali
  set.seed(58)
  # Inizializziamo i parametri necessari alla simulazione Monte Carlo
  n<- 10000
  ultimo<- matrix(0,num_paths,1)
  # Apriamo il ciclo per i "num_paths" percorsi
  for (i in 1:num_paths)
  {
    # Simuliamo un moto browniano geometrico
    u<- rnorm(n,0,sqrt(T1/n))
    Wt<- diffinv(u)
    temp<- (0:n)/n*T1
    Xt<- (mu-sigma^2/2)*temp+sigma*Wt
    S<- S0*exp(Xt)
    # Ricaviamo il valore finale del percorso
    ultimo[i]<- S[length(S)]
  }
  # Calcoliamo la probabilità di default teorica
  PD<- pnorm((log(soglia/S0)-(mu-sigma^2/2))/(sigma*sqrt(T1)),0,1)
  # Stimiamo la probabilità di default mediante il metodo Monte Carlo
  PD_MC<- length(ultimo[ultimo<soglia])/num_paths
  # Strutturiamo l'output in un oggetto list
  out<- list(PD,PD_MC)
  # Restituiamo l'output
  out
}
# ==============================================================================



# ==============================================================================
# FIGURA 5.7 - Probabilità di default condizionata in funzione del fattore y
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura5p7()

figura5p7<- function()
{
  # Diamo le impostazioni della finestra grafica
  IGS()
  # Inizializziamo le variabili
  pi<- 0.003
  R<- 0.2
  y<- seq(-4,4,by=0.005)
  # Calcoliamo le probabilità di default
  pi_y<- pnorm((qnorm(pi)-y*R^.5)/(1-R)^.5)
  # Tracciamo il grafico
  plot(y,pi_y,col='black',xlim=c(-4,4),ylim=c(0,.15),type='l',ylab='')
  # Salvataggio
  savePlot('PDvasicek1','pdf')
} 
# ==============================================================================



# ==============================================================================
# FIGURA 5.8 - Probabilità di default condizionata in funzione di quella incon-
#              dizionata
# ==============================================================================

#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura5p8()

figura5p8<- function()
{
  # Diamo le impostazioni della finestra grafica
  IGS()
  # Inizializziamo le variabili
  pi<- seq(0,1,by=0.001)
  y<- 1
  R<- 0.2
  # Calcoliamo le probabilità di default
  pi_y<- pnorm((qnorm(pi)-y*R^.5)/(1-R)^.5)
  # Tracciamo il grafico
  plot(pi,pi_y,col='black',xlim=c(0,1),ylim=c(0,1),type='l',xlab='', ylab='')
  # Salvataggio
  savePlot('PDvasicek2','pdf')
} 
# ==============================================================================



# ==============================================================================
# ESEMPIO 5.17 - Stima e simulazione della distribuzione di perdita nell'approc-
#                cio AMA al rischio operativo
# ==============================================================================
#
# Input:
# y        - [array-num] Vettore delle perdite storiche;
# alpha    - [num] Livello di confidenza a cui calcolare VaR ed ES;
# nsim     - [int] Numerosità del campione per la simulazione Monte Carlo.
#
# Output:    [list] Lista a quattro componenti. La componente "Stime" contiene 
#            le stime dei parametri della distribuzione di perdita; la componen-
#            te "Perdite" contiene il vettore delle perdite; le componenti "VaR"
#            ed "ES" contengono rispettivamente le stime del VaR e dell'ES.
#
# Esempio: 
#
# > out<- esempio5p17(y,alpha,nsim)            

esempio5p17<- function(y,alpha,nsim)
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(MASS)
  # Inizializziamo il seme delle procedure di estrazione di numeri pseudocasuali
  set.seed(58)
  # Inizializziamo il vettore delle perdite
  L<- rep(0,nsim)
  # Stimiamo i parametri della distribuzione di perdita lognormale
  results<- fitdistr(y,'lognormal')
  parshat<- results$estimate
  # Ricaviamo le stime dei parametri su base giornaliera e le memorizziamo in un
  # vettore
  lambda<- length(y)/260
  mu<- parshat[1]
  sigma<- parshat[2]
  stime<- c(lambda,mu,sigma)
  # Procediamo alla simulazione Monte Carlo delle perdite
  for (i in 1:nsim)
  {
    K<- rpois(1,lambda)
    x<- rlnorm(K,mu,sigma)
    L[i]<- sum(x)
  }
  # Stimiamo le misure di rischio
  VaR<- quantile(L,alpha)
  exc<- L[L>VaR]
  ES<- mean(exc)
  # Strutturiamo l'output in un oggetto list
  out<- list(Stime=stime,Perdite=L,VaR=VaR,ES=ES)
  # Restituiamo l'output  
  out
}
# ==============================================================================



# ==============================================================================
# FIGURA 5.9
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura5p9()

figura5p9<- function()
{
  # Diamo le impostazioni della finestra grafica
  IGS()
  # Carichiamo il file con il campione delle perdite
  load('oprisk.Rdata')
  # Simuliamo la distribuzione di perdita
  out<- esempio5p17(y,.995,10000)
  # Tracciamo l'istogramma
  hist(log(out[[2]]),main='',xlab='',ylab='',xlim=c(0,18),ylim=c(0,1200))
  # Aggiungiamo il riquadro
  box()
  # Salvataggio
  savePlot('oprisk_loss','pdf')
} 
# ==============================================================================
