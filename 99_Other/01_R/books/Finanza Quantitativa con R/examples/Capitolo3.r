

# ==============================================================================
#
#                                 CAPITOLO 3
#
#                 DISTRIBUZIONE DI PROBABILITÀ DEI RENDIMENTI
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
#                               FUNZIONI COMUNI
# ==============================================================================
#
# Spiegazione:
#  La funzione calcola e restituisce in output ed a video la funzione di auto-
# correlazione totale o parziale di un generico processo ARMA(p,q).
#
# Input:
# coeffar  - [num] Vettore dei coefficienti autoregressivi. Essendo NULL il va-
#            lore predefinito, se il parametro non viene inizializzato, il pro-
#            cesso ARMA(p,q) ha ordine autoregressivo nullo (e quindi si ha
#            p=0);
# coeffma  - [num] Vettore dei coefficienti a media mobile. Essendo NULL il va-
#            lore predefinito, se il parametro non viene inizializzato, il pro-
#            cesso ARMA(p,q) ha ordine a media mobile nullo (e quindi si ha
#            q=0);
# parz     - [logical] Parametro per specificare se calcolare la funzione di au-
#            tocorrelazione totale (FALSE) o parziale (TRUE). Valore predefini-
#            to: autocorrelazione totale (FALSE);
# k        - [int] Ordine massimo da calcolare e tracciare nel grafico della
#            funzione di autocorrelazione (valore predefinito: 20);
# nfile    - [character] Stringa contenente il nome del file con cui salvare il
#            grafico dato in output.
#
# Output:    [named-num] Vettore "named" contenente la funzione di autocorrela-
#            zione calcolata.
#
# Esempio:   Vedi le funzioni relative alle Figure 3.1, 3.2, 3.3.

figuraARMAacf<- function(coeffar=NULL,coeffma=NULL,parz=FALSE,k=20,
  nfile='ARMAacf')
{
  # Diamo le impostazioni della finestra grafica
  IGS(1)
  # Calcoliamo la funzione di autocorrelazione
  out<- ARMAacf(ar=coeffar,ma=coeffma,lag.max=k,pacf=parz)
  # Tracciamo il grafico a barre
  depo<- rep(0,k+1-parz)
  depo[1:length(out)]<- out
  plot(parz:k,depo,type='h',lwd=20,lend=1,ylim=c(-1,1),axes=FALSE,xlab='',
    ylab='',main='')
  # Aggiungiamo l'asse delle ascisse, gli assi del grafico ed il riquadro
  abline(h=0)
  axis(1,parz:k)
  axis(2,seq(-1,1,length.out=9))
  box()  
  # Salvataggio
  savePlot(nfile,'pdf')
  # Restituiamo in output la funzione di autocorrelazione
  invisible(out)
}


# Spiegazione:
#  La funzione calcola e restituisce a video il correlogramma totale o parziale
# di una generica serie storica data in input.
#
# Input:
# SSt      - [timeSeries] Serie storica di cui calcolare il correlogramma;
# parz     - [logical] Variabile booleana (TRUE/FALSE). Se posta a TRUE traccia
#            il grafico del correlogramma totale, se inizializzata a FALSE (va-
#            lore predefinito) dà in output il correlogramma parziale;
# k        - [int] Ordine massimo del correlogramma (valore predefinito: 20);
# nfile    - [character] Stringa contenente il nome del file con cui salvare il
#            grafico dato in output.
#
# Output:  - NESSUNO -
#
# Esempio:   Vedi le funzioni relative alle Figure 3.4, 3.7, 3.8, 3.10, 3.16.

figuraCorrSSt<- function(SSt,parz=FALSE,k=20,nfile='acfSSt')
{
  # Diamo le impostazioni della finestra grafica
  IGS(1)
  # Tracciamo il correlogramma
  if (parz) { depo<- 'partial' }
  else { depo<- 'correlation' }
  acf(SSt,lag.max=k,type=depo,lwd=20,lend=1,xlab='',ylab='',main='',
    ci.col='gray60')
  # Salvataggio  
  savePlot(nfile,'pdf')
}


# Spiegazione:
#  La funzione calcola il test di Ljung-Box e restituisce a video un grafico che
# mette in relazione l'ordine cui si riferisce il test al relativo p-value.
#
# Input:
# nfile    - [character] Stringa contenente il nome del file con cui salvare il
#            grafico dato in output;
# ...      - Tutti i parametri ricevuti in input dalla funzione LjungBoxTest.
#
# Output:  - NESSUNO -
#
# Esempio:   Vedi le funzioni relative alle Figure 3.5, 3.9, 3.11, 3.17.

figuraLjungBox<- function(nfile='LBT',...)
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(FitAR)    
  # Diamo le impostazioni della finestra grafica
  IGS(1)
  # Eseguiamo il test di Ljung e Box
  depo<- LjungBoxTest(...)
  # Individuiamo i limiti del grafico e lo tracciamo
  lim<- seq(0,1,0.2)[-1]
  lim<- lim[min(which(lim>max(depo[,3])))]
  plot(depo[,1],depo[,3],main='',xlab='',ylab='',ylim=c(0,lim),pch=19,cex=2)
  # Aggiungiamo l'asse delle ascisse e i livelli critici del p-value (10%, 5% ed
  # 1%)
  abline(h=0)
  abline(h=c(0.1,0.05,0.01),lty=2)
  # Salvataggio
  savePlot(nfile,'pdf')
}
# ==============================================================================



# ==============================================================================
# FIGURE 3.1 - Funzioni di autocorrelazione totale e parziale per due processi
#              a media mobile
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p1a()

figura3p1a<- function()
{
  figuraARMAacf(coeffma=0.8,nfile='acfpacfMAt1')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p1b()

figura3p1b<- function()
{
  figuraARMAacf(coeffma=c(0.8,-0.7,0.3),nfile='acfpacfMAt3')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p1c()

figura3p1c<- function()
{
  figuraARMAacf(coeffma=0.8,parz=TRUE,nfile='acfpacfMAp1')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p1d()

figura3p1d<- function()
{
  figuraARMAacf(coeffma=c(0.8,-0.7,0.3),parz=TRUE,nfile='acfpacfMAp3')
}
# ==============================================================================



# ==============================================================================
# FIGURE 3.2 - Funzioni di autocorrelazione totale e parziale per due processi
#              autoregressivi
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p2a()
  
figura3p2a<- function()
{
  figuraARMAacf(coeffar=0.7,nfile='acfpacfARt1')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p2b()

figura3p2b<- function()
{
  figuraARMAacf(coeffar=c(0.8,-0.2),nfile='acfpacfARt2')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p2c()

figura3p2c<- function()
{
  figuraARMAacf(coeffar=0.7,parz=TRUE,nfile='acfpacfARp1')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p2d()

figura3p2d<- function()
{
  figuraARMAacf(coeffar=c(0.8,-0.2),parz=TRUE,nfile='acfpacfARp2')
}
# ==============================================================================



# ==============================================================================
# FIGURE 3.3 - Funzioni di autocorrelazione totale e parziale per due processi
#              ARMA
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p3a()

figura3p3a<- function()
{
  figuraARMAacf(coeffar=0.6,coeffma=0.5,nfile='acfpacfARMAt11')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p3b()

figura3p3b<- function()
{
  figuraARMAacf(coeffar=c(-0.6,0.3),coeffma=0.4,nfile='acfpacfARMAt21')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p3c()

figura3p3c<- function()
{
  figuraARMAacf(coeffar=0.6,coeffma=0.5,parz=TRUE,nfile='acfpacfARMAp11')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p3d()

figura3p3d<- function()
{
  figuraARMAacf(coeffar=c(-0.6,0.3),coeffma=0.4,parz=TRUE,nfile='acfpacfARMAp21')
}
# ==============================================================================



# ==============================================================================
# FIGURE 3.4 - Correlogrammi totali e parziali relativi ai rendimenti dello
#              S&P500 e dei residui del modello ARMA(1,1) stimato
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p4a()

figura3p4a<- function()
{ 
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Calcoliamo la serie dei rendimenti
  X<- returns(SP500)
  # Tracciamo il correlogrammma
  figuraCorrSSt(X,FALSE,nfile='acfSP500')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p4b()

figura3p4b<- function()
{ 
  # Ci assicuriamo che i pacchetti necessari siano stati caricati  
  require(timeSeries)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Calcoliamo la serie dei rendimenti e stimiamo il modello ARMA
  X<- returns(SP500)  
  Modello<- arima(X,c(1,0,1))
  # Tracciamo il correlogrammma dei residui
  figuraCorrSSt(Modello$residuals,FALSE,nfile='acfSP500mod')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p4c()

figura3p4c<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Calcoliamo la serie dei rendimenti
  X<- returns(SP500)
  # Tracciamo il correlogrammma parziale
  figuraCorrSSt(X,TRUE,nfile='pacfSP500')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p4d()

figura3p4d<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Calcoliamo la serie dei rendimenti e stimiamo il modello ARMA
  X<- returns(SP500)
  Modello<- arima(X,c(1,0,1))
  # Tracciamo il correlogrammma parziale dei residui
  figuraCorrSSt(Modello$residuals,TRUE,nfile='pacfSP500mod')
}
# ==============================================================================



# ==============================================================================
# FIGURE 3.5 - Test di Ljung-Box sui rendimenti dello S&P500 ed i residui del
#              modello ARMA(1,1) stimato
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p5a()

figura3p5a<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData') 
  # Calcoliamo la serie dei rendimenti e stimiamo il modello ARMA 
  X<- returns(SP500)
  # Eseguiamo il test di Ljung-Box
  figuraLjungBox(res=X,lag.max=20,nfile='LBTSP500')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p5b()

figura3p5b<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries) 
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')                                              
  # Calcoliamo la serie dei rendimenti e stimiamo il modello ARMA 
  X<- returns(SP500)
  Modello<- arima(X,c(1,0,1))
  # Eseguiamo il test di Ljung-Box
  figuraLjungBox(res=Modello$residuals,lag.max=20,k=2,nfile='LBTSP500res')
}
# ==============================================================================



# ==============================================================================
# FIGURA 3.6 - Previsioni per un processo ARMA
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   [list] Lista a due componenti. Nella componente "pred" (di tipo
#           Times-Series) sono contenute le previsioni puntuali, mentre nella
#           componente "se" (anch'essa di tipo Time-Series) l'errore di previ-
#           sione.
#
# Esempio:
#
# > figura3p6()

figura3p6<- function()
{ 
  # Inizializziamo il seme delle procedure di estrazione di numeri pseudocasuali
  set.seed(95918013)
  # Simuliamo il processo ARMA
  SSt<- 0.08+arima.sim(list(ar=c(0.7,-0.6),ma=0.5),3500,sd=0.2)
  # Stimiamo i parametri del processo
  Modello<- arima(SSt,c(2,0,1))
  # Ricaviamo le previsioni
  Prev<- predict(Modello,20) 
  # Diamo le impostazioni della finestra grafica
  IGS()
  # Tracciamo il grafico delle previsioni puntuali ed intervallari e del valore
  # atteso incondizionato 
  plot(0,0,type='n',ylim=c(-1,1),xlim=c(3501,3520),xlab='',ylab='',main='')
  abline(h=0.08,lwd=2,col='gray60')
  lines(Prev$pred,lwd=2)
  lines(Prev$pred+qnorm(0.975)*Prev$se,lty=2,lwd=2,col='gray60')
  lines(Prev$pred-qnorm(0.975)*Prev$se,lty=2,lwd=2,col='gray60')
  # Aggiungiamo la griglia
  grid(lty=2,col='lightgray')
  # Salvataggio
  savePlot('predictARMA','pdf')
  # Restituiamo in output le previsioni
  invisible(Prev)
}
# ==============================================================================



# ==============================================================================
# FIGURE 3.7 - Correlogrammi totali e parziali relativi ai rendimenti al quadra-
#              to dello S&P500
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p7a()

figura3p7a<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Calcoliamo la serie dei rendimenti
  X<- returns(SP500)
  # Tracciamo il correlogramma dei rendimenti al quadrato
  figuraCorrSSt(X^2,FALSE,nfile='acfsqSP500')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p7b()

figura3p7b<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Calcoliamo la serie dei rendimenti  
  X<- returns(SP500)
  # Tracciamo il correlogramma parziale dei rendimenti al quadrato 
  figuraCorrSSt(X^2,TRUE,nfile='pacfsqSP500')
}
# ==============================================================================



# ==============================================================================
# FIGURE 3.8 - Correlogrammi totali e parziali relativi ai residui standardizza-
#              ti del modello ARMA(1,1)-GARCH(1,1) stimato e dei loro quadrati
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p8a()

figura3p8a<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries) 
  require(fGarch)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData') 
  # Calcoliamo la serie dei rendimenti e stimiamo il modello ARMA-GARCH
  X<- returns(SP500)
  Mod1<- garchFit(formula=~arma(1,1)+garch(1,1),data=X,cond.dist='QMLE',
    trace=FALSE)
  # Ricaviamo i residui standardizzati
  Z<- residuals(Mod1,TRUE)
  # Tracciamo il correlogramma dei residui standardizzati
  figuraCorrSSt(Z,FALSE,nfile='acfSP500AG1acf')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p8b()

figura3p8b<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries) 
  require(fGarch)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData') 
  # Calcoliamo la serie dei rendimenti e stimiamo il modello ARMA-GARCH  
  X<- returns(SP500)
  Mod1<- garchFit(formula=~arma(1,1)+garch(1,1),data=X,cond.dist='QMLE',
    trace=FALSE)
  # Ricaviamo i residui standardizzati
  Z<- residuals(Mod1,TRUE)
  # Tracciamo il correlogramma dei residui standardizzati al quadrato
  figuraCorrSSt(Z^2,FALSE,nfile='acfSP500AG1acfsq')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p8c()

figura3p8c<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries) 
  require(fGarch) 
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Calcoliamo la serie dei rendimenti e stimiamo il modello ARMA-GARCH
  X<- returns(SP500)
  Mod1<- garchFit(formula=~arma(1,1)+garch(1,1),data=X,cond.dist='QMLE',
    trace=FALSE)
  # Ricaviamo i residui standardizzati
  Z<- residuals(Mod1,TRUE)
  # Tracciamo il correlogramma parziale dei residui standardizzati
  figuraCorrSSt(Z,TRUE,nfile='acfSP500AG1pacf')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p8d()

figura3p8d<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries) 
  require(fGarch) 
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Calcoliamo la serie dei rendimenti e stimiamo il modello ARMA-GARCH
  X<- returns(SP500)
  Mod1<- garchFit(formula=~arma(1,1)+garch(1,1),data=X,cond.dist='QMLE',
    trace=FALSE)
  # Ricaviamo i residui standardizzati
  Z<- residuals(Mod1,TRUE)
  # Tracciamo il correlogramma parziale dei residui standardizzati al quadrato
  figuraCorrSSt(Z^2,TRUE,nfile='acfSP500AG1pacfsq')
}
# ==============================================================================



# ==============================================================================
# FIGURE 3.9 - Test di Ljung-Box sui residui standardizzati e sui quadrati 
#              del modello ARMA(1,1)-GARCH(1,1) stimato sui rendimenti dello
#              S&P500
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p9a()

figura3p9a<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries) 
  require(fGarch)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData') 
  # Calcoliamo la serie dei rendimenti e stimiamo il modello ARMA-GARCH
  X<- returns(SP500)
  Mod1<- garchFit(formula=~arma(1,1)+garch(1,1),data=X,cond.dist='QMLE',
    trace=FALSE)
  # Ricaviamo i residui standardizzati
  Z<- residuals(Mod1,TRUE)
  # Eseguiamo il test di Ljung-Box sui residui standardizzati
  figuraLjungBox(res=Z,lag.max=20,k=0,nfile='LBTSP500AG1res')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p9b()

figura3p9b<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries) 
  require(fGarch) 
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Calcoliamo la serie dei rendimenti e stimiamo il modello ARMA-GARCH
  X<- returns(SP500)
  Mod1<- garchFit(formula=~arma(1,1)+garch(1,1),data=X,cond.dist='QMLE',
    trace=FALSE)
  # Ricaviamo i residui standardizzati
  Z<- residuals(Mod1,TRUE)
  # Eseguiamo il test di Ljung-Box sui residui standardizzati al quadrato
  figuraLjungBox(res=Z,lag.max=20,k=0,Squared=TRUE,nfile='LBTSP500AG1ressq')
}
# ==============================================================================



# ==============================================================================
# FIGURE 3.10 - Correlogrammi totali e parziali relativi ai residui standardiz-
#               zati del modello ARMA(1,1)-GARCH(2,1) stimato e dei loro quadra-
#               ti
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p10a()

figura3p10a<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Calcoliamo la serie dei rendimenti e stimiamo il modello ARMA-GARCH
  X<- returns(SP500)
  Mod2<- garchFit(formula=~arma(1,1)+garch(2,1),data=X,cond.dist='QMLE',
    trace=FALSE)
  # Ricaviamo i residui standardizzati
  Z<- residuals(Mod2,TRUE)
  # Tracciamo il correlogramma dei residui standardizzati
  figuraCorrSSt(Z,FALSE,nfile='acfSP500AG2acf')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p10b()

figura3p10b<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Calcoliamo la serie dei rendimenti e stimiamo il modello ARMA-GARCH
  X<- returns(SP500)
  Mod2<- garchFit(formula=~arma(1,1)+garch(2,1),data=X,cond.dist='QMLE',
    trace=FALSE)
  # Ricaviamo i residui standardizzati
  Z<- residuals(Mod2,TRUE)
  # Tracciamo il correlogramma dei residui standardizzati al quadrato
  figuraCorrSSt(Z^2,FALSE,nfile='acfSP500AG2acfsq')
}

# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p10c()

figura3p10c<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Calcoliamo la serie dei rendimenti e stimiamo il modello ARMA-GARCH
  X<- returns(SP500)
  Mod2<- garchFit(formula=~arma(1,1)+garch(2,1),data=X,cond.dist='QMLE',
    trace=FALSE)
  # Ricaviamo i residui standardizzati
  Z<- residuals(Mod2,TRUE)
  # Tracciamo il correlogramma parziale dei residui standardizzati
  figuraCorrSSt(Z,TRUE,nfile='acfSP500AG2pacf')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p10d()

figura3p10d<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Calcoliamo la serie dei rendimenti e stimiamo il modello ARMA-GARCH
  X<- returns(SP500)
  Mod2<- garchFit(formula=~arma(1,1)+garch(2,1),data=X,cond.dist='QMLE',
    trace=FALSE)
  # Ricaviamo i residui standardizzati
  Z<- residuals(Mod2,TRUE)
  # Tracciamo il correlogramma parziale dei residui standardizzati al quadrato
  figuraCorrSSt(Z^2,TRUE,nfile='acfSP500AG2pacfsq')
}
# ==============================================================================



# ==============================================================================
# FIGURE 3.11 - Test di Ljung-Box sui residui standardizzati e sui quadrati 
#               del modello ARMA(1,1)-GARCH(2,1) stimato sui rendimenti dello
#               S&P500
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p11a()

figura3p11a<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries) 
  require(fGarch) 
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Calcoliamo la serie dei rendimenti e stimiamo il modello ARMA-GARCH
  X<- returns(SP500)
  Mod2<- garchFit(formula=~arma(1,1)+garch(2,1),data=X,cond.dist='QMLE',
    trace=FALSE)
  # Ricaviamo i residui standardizzati
  Z<- residuals(Mod2,TRUE)
  # Eseguiamo il test di Ljung-Box sui residui standardizzati
  figuraLjungBox(res=Z,lag.max=20,k=0,nfile='LBTSP500AG2res')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p11b()

figura3p11b<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries) 
  require(fGarch)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData') 
  # Calcoliamo la serie dei rendimenti e stimiamo il modello ARMA-GARCH
  X<- returns(SP500)
  Mod2<- garchFit(formula=~arma(1,1)+garch(2,1),data=X,cond.dist='QMLE',
    trace=FALSE)
  # Ricaviamo i residui standardizzati
  Z<- residuals(Mod2,TRUE)
  # Eseguiamo il test di Ljung-Box sui residui standardizzati al quadrato
  figuraLjungBox(res=Z,lag.max=20,k=0,Squared=TRUE,nfile='LBTSP500AG2ressq')
}
# ==============================================================================



# ==============================================================================
# FIGURA 3.12 - Previsioni per un processo ARMA-GARCH
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p12()

figura3p12<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(fGarch)  
  # Definiamo tutti i parametri del processo ARMA-GARCH e della simulazione
  ProcGen<- garchSpec(list(mu=0.01,ar=c(0.8,-0.6),ma=0.25,omega=0.000003,
    alpha=0.25,beta=c(0.1,0.63),shape=3),cond.dist='std',rseed=84968013)
  # Simuliamo il processo ARMA-GARCH
  SSt<- garchSim(ProcGen,n=3000)
  # Stimiamo i parametri del processo ARMA-GARCH
  Modello<- garchFit(~arma(2,1)+garch(1,2),data=SSt,cond.dist='QMLE',
    trace=FALSE)
  # Ricaviamo le previsioni disabilitando preventivamente i warnings e riabili-
  # tando successivamente le impostazioni originali (la ragione di ciò è lega-
  # ta al funzionamento del metodo "predict" del pacchetto "fGarch", rassicuria-
  # mo il lettore sul fatto che ciò non ha effetti sui risultati)
  depo<- getOption('warn')
  options(warn=-1)
  Prev<- predict(Modello,20,plot=TRUE,conf=0.9)
  options(warn=depo)
  # Diamo le impostazioni della finestra grafica
  IGS()
  # Tracciamo il grafico delle ultime osservazioni registrate e delle previsioni
  # puntuali ed intervallari
  plot(0,0,type='n',xlim=c(-9,20),ylim=c(-0.02,0.05),xlab='',ylab='',main='')
  polygon(c(0:20,20:0),c(SSt[3000],Prev$lowerInterval,rev(Prev$upperInterval),
    SSt[3000]),col='gray93',density=-12,border=NA)
  grid(lty=2,col='lightgray')
  lines(0:20,c(SSt[3000],Prev$upperInterval),lty=2,lwd=2,col='gray60')
  lines(0:20,c(SSt[3000],Prev$lowerInterval),lty=2,lwd=2,col='gray60')
  lines(-9:0,SSt[2991:3000],lwd=2) 
  lines(0:20,c(SSt[3000],Prev$meanForecast),lwd=2)
  abline(h=0,lty=2)
  # Salvataggio
  savePlot('predictARMAGARCH','pdf')
  invisible(Modello)
}
# ==============================================================================



# ==============================================================================
# FIGURA 3.13 - Rendimenti dell'indice S&P500 e processo stimato della media 
#               condizionata
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p13()

figura3p13<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  require(fGarch)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Calcoliamo la serie dei rendimenti e stimiamo il modello ARMA-GARCH
  X<- returns(SP500)
  Modello<- garchFit(~arma(0,1)+garch(2,1),data=X,cond.dist='QMLE',trace=FALSE)
  # Creiamo la serie storica con il processo della media condizionata
  hmut<- Modello@fitted
  depo<- cbind(X,hmut)
  # Diamo le impostazioni della finestra grafica
  IGS()
  # Tracciamo il grafico delle due serie storiche
  plot(depo[-1,],plot.type='single',col=rev(c('black','grey60')),xlab='',
    ylab='',main='')
  # Aggiungiamo la griglia
  depo<- seq(time(SP500)[2],time(SP500)[length(SP500)],length.out=6)
  abline(v=depo,lty=2,col='lightgray')
  grid(NA,NULL,lty=2,col='lightgray')
  # Salvataggio
  savePlot('MediaCond','pdf')
}
# ==============================================================================



# ==============================================================================
# FIGURA 3.14 - Rendimenti dell'indice S&P500 e processo della volatilità condi-
#               zionata stimato mediante l'approccio EWMA di RiskMetrics
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p14()

figura3p14<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  require(fGarch)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Creiamo l'oggetto timeSeries in cui memorizzare le due serie
  out<- cbind(returns(SP500),NA)
  colnames(out)<- c('Rend','sigma_t')
  # Applichiamo il metodo EWMA di RiskMetrics
  w<- 0.94^(0:74)
  out$sigma_t[76]<- sum(w*out$Rend[75:1]^2)/sum(w)
  for (i in 77:length(out[,1]))
  {
    out$sigma_t[i]<- 0.94*out$sigma_t[i-1]+0.06*out$Rend[i-1]^2
  }
  out$sigma_t<- sqrt(out$sigma_t)
  # Diamo le impostazioni della finestra grafica
  IGS()
  # Tracciamo il grafico delle due serie storiche
  plot(out,plot.type='single',col=c('grey60','black'),xlab='',ylab='',main='')
  # Aggiungiamo la griglia
  depo<- seq(time(SP500)[2],time(SP500)[length(SP500)],length.out=6)
  abline(v=depo,lty=2,col='lightgray')
  grid(NA,NULL,lty=2,col='lightgray')
  # Salvataggio
  savePlot('EWMA','pdf')
}
# ==============================================================================



# ==============================================================================
# FIGURA 3.15 - Stime della volatilità condizionata calcolate sulla base del mo-
#               dello ARMA-GARCH e del metodo EWMA di RiskMetrics a confronto
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p15()

figura3p15<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  require(fGarch)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Calcoliamo la serie dei rendimenti e stimiamo il modello ARMA-GARCH
  X<-returns(SP500)
  Modello<- garchFit(~arma(0,1)+garch(2,1),data=X,cond.dist='QMLE',trace=FALSE)
  # Creiamo l'oggetto timeSeries in cui memorizzare le serie
  out<- cbind(SP500,c(NA,X),NA,NA)
  depo<- length(SP500)-length(Modello@sigma.t)
  out[-(1:depo),3]<- Modello@sigma.t    
  colnames(out)<- c('Prezzi','Rend','ARMAGARCH','EWMA')
  # Applichiamo il metodo EWMA di RiskMetrics
  w<- 0.94^(0:74)
  out$EWMA[77]<- sum(w*out$Rend[76:2]^2)/sum(w)
  for (i in 78:length(SP500))
  { 
    out$EWMA[i]<- 0.94*out$EWMA[i-1]+0.06*out$Rend[i-1]^2
  }           
  out$EWMA<- sqrt(out$EWMA)
  # Diamo le impostazioni della finestra grafica
  IGS()
  # Tracciamo il grafico delle due serie storiche della volatilità condizionata
  plot(out[,3:4],plot.type='single',col=c('grey60','black'),xlab='',
    ylab='',main='',ylim=c(0,0.06))
  # Aggiungiamo la griglia e l'asse delle ascisse
  depo<- seq(time(SP500)[2],time(SP500)[length(SP500)],length.out=6)
  abline(v=depo,lty=2,col='lightgray') 
  grid(NA,NULL,lty=2,col='lightgray')
  abline(h=0) 
  # Aggiungiamo la legenda
  tleg<- c('Volatilità ARMA-GARCH ','Volatilità EWMA')
  legend('topright',legend=tleg,col=c('gray60','black'),lwd=2,bg='white',cex=0.8)
  # Salvataggio
  savePlot('cfrEWMA','pdf')
}
# ==============================================================================



# ==============================================================================
# FIGURE 3.16 - Correlogrammi totali e parziali relativi ai residui standardiz-
#               zati del modello EWMA di RiskMetrics
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p16a()

figura3p16a<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Creiamo l'oggetto timeSeries in cui memorizzare le serie
  out<- cbind(returns(SP500),NA)
  colnames(out)<- c('Rend','sigma_t')
  # Applichiamo il metodo EWMA di RiskMetrics
  w<- 0.94^(0:74)
  out$sigma_t[76]<- sum(w*out$Rend[75:1]^2)/sum(w)
  for (i in 77:length(out[,1]))
  {
    out$sigma_t[i]<- 0.94*out$sigma_t[i-1]+0.06*out$Rend[i-1]^2
  }
  out$sigma_t<- sqrt(out$sigma_t)
  # Ricaviamo i residui standardizzati
  X<- out[,1]/out[,2]
  X<- X[-(1:75),]
  # Tracciamo il correlogramma dei residui standardizzati
  figuraCorrSSt(X,FALSE,nfile='acfSP500EWMA')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p16b()

figura3p16b<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Creiamo l'oggetto timeSeries in cui memorizzare le serie
  out<- cbind(returns(SP500),NA)
  colnames(out)<- c('Rend','sigma_t')
  # Applichiamo il metodo EWMA di RiskMetrics
  w<- 0.94^(0:74)
  out$sigma_t[76]<- sum(w*out$Rend[75:1]^2)/sum(w)
  for (i in 77:length(out[,1]))
  {
    out$sigma_t[i]<- 0.94*out$sigma_t[i-1]+0.06*out$Rend[i-1]^2
  }
  out$sigma_t<- sqrt(out$sigma_t)
  # Ricaviamo i residui standardizzati
  X<- out[,1]/out[,2]
  X<- X[-(1:75),]
  # Tracciamo il correlogramma dei residui standardizzati al quadrato
  figuraCorrSSt(X^2,FALSE,nfile='acfSP500EWMAsq')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p16c()

figura3p16c<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Creiamo l'oggetto timeSeries in cui memorizzare le serie
  out<- cbind(returns(SP500),NA)
  colnames(out)<- c('Rend','sigma_t')
  # Applichiamo il metodo EWMA di RiskMetrics
  w<- 0.94^(0:74)
  out$sigma_t[76]<- sum(w*out$Rend[75:1]^2)/sum(w)
  for (i in 77:length(out[,1]))
  {
    out$sigma_t[i]<- 0.94*out$sigma_t[i-1]+0.06*out$Rend[i-1]^2
  }
  out$sigma_t<- sqrt(out$sigma_t)
  # Ricaviamo i residui standardizzati
  X<- out[,1]/out[,2]
  X<- X[-(1:75),]
  # Tracciamo il correlogramma parziale dei residui standardizzati
  figuraCorrSSt(X,TRUE,nfile='pacfSP500EWMA')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p16d()

figura3p16d<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Creiamo l'oggetto timeSeries in cui memorizzare le serie
  out<- cbind(returns(SP500),NA)
  colnames(out)<- c('Rend','sigma_t')
  # Applichiamo il metodo EWMA di RiskMetrics
  w<- 0.94^(0:74)
  out$sigma_t[76]<- sum(w*out$Rend[75:1]^2)/sum(w)
  for (i in 77:length(out[,1]))
  {
    out$sigma_t[i]<- 0.94*out$sigma_t[i-1]+0.06*out$Rend[i-1]^2
  }
  out$sigma_t<- sqrt(out$sigma_t)
  # Ricaviamo i residui standardizzati
  X<- out[,1]/out[,2]
  X<- X[-(1:75),]
  # Tracciamo il correlogramma parziale dei residui standardizzati al quadrato
  figuraCorrSSt(X^2,TRUE,nfile='pacfSP500EWMAsq')
}
# ==============================================================================



# ==============================================================================
# FIGURE 3.17 - Test di Ljung-Box sui residui standardizzati del modello EWMA di
#               RiskMetrics
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p17a()

figura3p17a<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Creiamo l'oggetto timeSeries in cui memorizzare le serie
  out<- cbind(returns(SP500),NA)
  colnames(out)<- c('Rend','sigma_t')
  # Applichiamo il metodo EWMA di RiskMetrics
  w<- 0.94^(0:74)
  out$sigma_t[76]<- sum(w*out$Rend[75:1]^2)/sum(w)
  for (i in 77:length(out[,1]))
  {
    out$sigma_t[i]<- 0.94*out$sigma_t[i-1]+0.06*out$Rend[i-1]^2
  }
  out$sigma_t<- sqrt(out$sigma_t)
  # Ricaviamo i residui standardizzati
  X<- out[,1]/out[,2]
  X<- X[-(1:75),]
  # Eseguiamo il test di Ljung-Box sui residui standardizzati
  figuraLjungBox(res=X,lag.max=20,nfile='LBTSP500EWMA')
}


# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura3p17b()

figura3p17b<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Creiamo l'oggetto timeSeries in cui memorizzare le serie
  out<- cbind(returns(SP500),NA)
  colnames(out)<- c('Rend','sigma_t')
  # Applichiamo il metodo EWMA di RiskMetrics
  w<- 0.94^(0:74)
  out$sigma_t[76]<- sum(w*out$Rend[75:1]^2)/sum(w)
  for (i in 77:length(out[,1]))
  {
    out$sigma_t[i]<- 0.94*out$sigma_t[i-1]+0.06*out$Rend[i-1]^2
  }
  out$sigma_t<- sqrt(out$sigma_t)
  # Ricaviamo i residui standardizzati
  X<- out[,1]/out[,2]
  X<- X[-(1:75),]
  # Eseguiamo il test di Ljung-Box sui residui standardizzati al quadrato
  figuraLjungBox(res=X,SquaredQ=TRUE,lag.max=20,nfile='LBTSP500EWMAsq')
}
# ==============================================================================
