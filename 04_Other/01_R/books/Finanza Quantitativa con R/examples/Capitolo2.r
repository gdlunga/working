

# ==============================================================================
#
#                                 CAPITOLO 2
#
#                   ANALISI STATISTICA DI PREZZI E RENDIMENTI
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
# FIGURA 2.1 - Rendimenti giornalieri dell'indice S&P500
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura2p1()

figura2p1<- function()
{            
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Diamo le impostazioni della finestra grafica
  IGS()
  # Tracciamo il grafico ed aggiungiamo la griglia
  plot(returns(SP500),xlab='',ylab='',main='')
  depo<- seq(time(SP500)[2],time(SP500)[length(SP500)],length.out=6)
  abline(v=depo,lty=2,col='lightgray')
  grid(NA,NULL,lty=2,col='lightgray')
  # Salvataggio
  savePlot('rendSP500','pdf')
}
# ==============================================================================



# ==============================================================================
# FIGURA 2.2 - Rendimenti giornalieri del titolo ENI
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura2p2()

figura2p2<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Carichiamo il file con la serie storica delle quotazioni
  load('ENI.RData')
  # Diamo le impostazioni della finestra grafica
  IGS()
  # Tracciamo il grafico ed aggiungiamo la griglia
  plot(returns(ENI),xlab='',ylab='',main='')
  depo<- seq(time(ENI)[2],time(ENI)[length(ENI)],length.out=6)
  abline(v=depo,lty=2,col='lightgray')
  grid(NA,NULL,lty=2,col='lightgray')
  # Salvataggio
  savePlot('rendENI','pdf')
}
# ==============================================================================



# ==============================================================================
# FIGURA 2.3 - Grafico quantile-quantile per i rendimenti dell'indice S&P500
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura2p3()

figura2p3<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Diamo le impostazioni della finestra grafica ed inizializziamo le variabili
  IGS()
  # Calcoliamo la serie dei rendimenti e tracciamo il grafico
  SP500r<- returns(SP500)
  qqnorm(SP500r,main='',xlab='',ylab='',pch=19)
  qqline(SP500r,main='',xlab='',ylab='')
  # Salvataggio
  savePlot('QQplotSP500','pdf')
}
# ==============================================================================



# ==============================================================================
# ESEMPIO 2.3 - Correlogramma dei rendimenti dello S&P500
# ==============================================================================
#
# Spiegazione:
#  Calcola la funzione di autocorrelazione empirica per i rendimenti di una
# serie storica fornendo in output anche le bande di confidenza e le osservazio-
# ni che le violano in base a due livelli di significatività specificati in
# input.
#
# Input:
# SSt      - [timeSeries] Serie storica dei prezzo dell'asset;
# alpha1   - [num] Primo livello di confidenza delle bande e di significatività
#            per lei volazioni;
# alpha2   - [num] Secondo livello di confidenza delle bande e di significativi-
#            tà per lei volazioni.
#
# Output:    [list] Lista a cinque componenti. La prima componente contiene la
#            funzione di autocorrelazione stimata (correlogramma); la seconda e
#            la terza contengono le bande di confidenza calcolater rispetto ai
#            valori "alpha1" ed "alpha2" dati in input; la quarta e la quinta
#            contengono le osservazioni esterne alle bande di confidenza.
#
# Esempio:
#
# > out<- esempio2p3()

esempio2p3<- function(SSt,alpha1,alpha2)
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Calcoliamo la serie dei rendimenti ed il numero di osservazioni
  rend<- returns(SSt)
  N<- length(rend)
  # Calcoliamo e ricaviamo le autocorrelazioni empiriche
  ace<- acf(rend,plot=FALSE)     
  acf.val<- ace[[1]]
  # Calcoliamo i valori critici delle bande di confidenza
  LL1<- qnorm(alpha1/2)/sqrt(N)
  UL1<- qnorm(1-alpha1/2)/sqrt(N)
  LL2<- qnorm(alpha2/2)/sqrt(N)
  UL2<- qnorm(1-alpha2/2)/sqrt(N)
  # Calcoliamo gli intervalli di confidenza
  CI1<- c(LL1,UL1)
  CI2<- c(LL2,UL2)                         
  # Individuiamo le osservazioni che violano le bande
  exc1<- acf.val[abs(acf.val)>UL1]
  exc2<- acf.val[abs(acf.val)>UL2]
  # Strutturiamo l'output in un oggetto list
  out<- list(acf.val,CI1,CI2,exc1,exc2)
  # Restituiamo l'output
  out
}
# ==============================================================================



# ==============================================================================
# FIGURA 2.4 - Correlogramma dei rendimenti dell'indice S&P500
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura2p4()

figura2p4<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Diamo le impostazioni della finestra grafica ed inizializziamo le variabili
  IGS()  
  # Tracciamo il correlogramma dei rendimenti
  acf(returns(SP500),lwd=12,lend=1,xlab='',ylab='',main='',ci.col='gray60')
  # Salvataggio
  savePlot('acfSP500c2','pdf')
}
# ==============================================================================



# ==============================================================================
# FIGURA 2.5 - Correlogramma dei rendimenti al quadrato dell'indice S&P500
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura2p5()

figura2p5<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(timeSeries)
  # Carichiamo il file con la serie storica delle quotazioni
  load('S&P500.RData')
  # Diamo le impostazioni della finestra grafica ed inizializziamo le variabili
  IGS()
  # Tracciamo il correlogramma dei rendimenti al quadrato  
  acf(returns(SP500)^2,lwd=12,lend=1,xlab='',ylab='',main='',ci.col='gray60')
  # Salvataggio
  savePlot('acfSP5002','pdf')
}
# ==============================================================================



# ==============================================================================
# FIGURA 2.6 - Esempio di moto browniano standard e moto browniano generalizzato
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura2p6()

figura2p6<- function()
{
  # Diamo le impostazioni della finestra grafica ed inizializziamo le variabili
  IGS()
  # Inizializziamo le variabili relative ai parametri dei moti
  T1<- 8
  n<- 40000
  mu<- 0.3
  X0<- 1
  sigma<- 2.5
  # Inizializziamo le variabili grafiche
  colori<- c('gray60','black','gray60')
  linee<- c(1,2)    
  # Inizializziamo il seme delle procedure di estrazione di numeri pseudocasuali
  set.seed(78947988)
  # Simuliamo i due moti
  u<- rnorm(n,0,sqrt(T1/n))
  Wt<- c(0,cumsum(u))
  temp<- seq(0,T1,length.out=n+1)
  Xt<- X0+mu*temp+sigma*Wt
  # Tracciamo il grafico dei due moti
  plot(temp,Wt,type='l',ylim=c(-2,9),col=colori[1])
  lines(temp,Xt,col=colori[2])
  # Aggiungiamo la griglia e l'asse delle ascisse
  lines(c(0,T1),c(X0,X0+mu*T1),col=colori[3],lty=2,lwd=2)
  grid(lty=2,col='lightgray')
  abline(h=0)
  # Aggiungiamo la legenda
  tleg<- c('Moto browniano standard','Moto browniano generalizzato',
    'Valore atteso del moto browniano generalizzato ')
  legend('topright',legend=tleg,col=colori,lty=c(1,1,2),lwd=2,bg='white',
    cex=0.8)
  # Salvataggio
  savePlot('motoBrowniano','pdf')
}
# ==============================================================================



# ==============================================================================
# FIGURA 2.7 - Esempio di 10 realizzazioni di un moto browniano geometrico
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura2p7()

figura2p7<- function()
{
  # Diamo le impostazioni della finestra grafica ed inizializziamo le variabili
  IGS()
  # Inizializziamo le variabili relative ai parametri del moto
  T1<- 5
  n<- 10000
  mu<- 0.15
  S0<- 10
  sigma<- 0.3               
  m<- 10
  # Inizializziamo il seme delle procedure di estrazione di numeri pseudocasuali
  set.seed(70967993)
  # Simuliamo le realizzazioni del moto (percorsi)
  MotiBr<- matrix(c(rep(0,m),rnorm(m*n,0,sqrt(T1/n))),m,n+1,byrow=FALSE)
  MotiBr<- apply(MotiBr,1,cumsum)
  temp<- seq(0,T1,length.out=n+1)
  MotiBr<- (mu-sigma^2/2)*temp+sigma*MotiBr
  MotiBr<- S0*t(apply(MotiBr,2,exp))
  # Tracciamo il grafico
  plot(temp,MotiBr[1,],type='l',ylim=c(0,max(MotiBr)),xlab='',ylab='',
    col='gray60')
  for (i in 2:m) {
    lines(temp,MotiBr[i,],col='gray60')
  }
  # Aggiungiamo la curva del valore atteso, la griglia e l'asse delle ascisse
  curve(S0*exp((mu-sigma^2/2)*x),add=TRUE,lty=2,lwd=2)
  grid(lty=2,col='lightgray')
  abline(h=0)
  # Salvataggio
  savePlot('motoBrGeo','pdf')
}
# ==============================================================================
