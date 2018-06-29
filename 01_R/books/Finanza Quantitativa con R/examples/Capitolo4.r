

# ==============================================================================
#
#                                 CAPITOLO 4
#
#                       VALUTAZIONE DI STRUMENTI FINANZIARI
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
#  La funzione costruisce il grafico ad albero relativo all'evoluzione del prez-
# zo di uno strumento derivato o di un asset.
#  Il codice che segue corrisponde a quello della funzione "BinomialTreePlot" 
# del pacchetto "fOptions" a cui sono state apportate alcune modifiche.
#
# Input:
# MatrAlbero - [matrix-num] Matrice fornita in output dalla funzione 
#              "Sottostante" (di seguito definita) o dalla funzione 
#              "BinomialTreeOption" del pacchetto "fOptions";
# dx         - [num] offset orizzontale dei numeri del grafico rispetto ai rela-
#              tivi nodi;
# dy         - [num] offset verticale dei numeri del grafico rispetto ai relati-
#              vi nodi;
# digits     - [int] Numero massimo di decimali da rappresentare nei nodi del
#              grafico.
#
# Output:    - NESSUNO -
#
# Esempio:     Vedi le funzioni relative alle Figure 4.

Albero<- function(MatrAlbero,dx=-0.025,dy=0.8,digits=2) 
{ 
  # Diamo le impostazioni della finestra grafica
  IGS()
  # Arrotondiamo i valori dei nodi 
  Matr<- round(MatrAlbero,digits=digits)
  # Tracciamo l'albero
  n<- ncol(Matr)
  plot(x=c(0,n-1),y=c(-n+1,n-1+dy),type='n',main='',xlab='',ylab='',axes=FALSE)
  if (n>5) {
    labx<- pretty(0:(n-1))
    laby<- pretty((1-n):(n-1),min.n=4)
  }
  else {
    labx<- 0:(n-1)
    laby<- (1-n):(n-1) 
  }
  # Aggiungiamo assi e riquadro del grafico
  axis(1,at=labx)
  axis(2,at=laby)
  box()
  # Aggiungiamo i punti ed i valori del derivato (o dell'asset)
  points(x=0,y=0,pch=19)
  text(0+dx,0+dy,deparse(Matr[1,1]),cex=0.8)
  for (i in 1:(n-1)) {
    y<- seq(from=-i,by=2,length.out=i+1)
    x<- rep(i,length(y)) 
    for (j in 1:length(x))
      text(x[j]+dx,y[j]+dy,deparse(Matr[length(x)+1-j,i+1]),cex=0.8)   
    y<- (-i):i
    x<- rep(c(i+1,i),times=2*i)[1:length(y)]-1
    lines(x,y,col='gray60')
    points(x,y,pch=19)
  }
}


#
# Spiegazione:
#  Ricava la matrice dell'albero relativa all'evoluzione di un asset.
#
# Input:
# S0       - [num] Prezzo iniziale dell'asset;
# T1       - [num] Arco temporale coperto dall'albero;
# r        - [num] Tasso d'interesse risk-free;
# sigma    - [num] Volatilità del processo che descrive l'evoluzione del prezzo 
#            dell'asset;
# n        - [int] Numero di intervalli in cui suddividere l'arco temporale.
#
# Output:    [matrix-num] Matrice dell'albero dell'asset costruita secondo le
#            regole con cui è costruita quella fornita in output dalla funzione
#            "BinomialTreeOption".
#
# Esempio:   Vedi la funzione relativa alla Figura 4.3.

Sottostante<- function(S0,T1,r,sigma,n)
{
  # Costruiamo l'intera matrice dell'albero inizializzando i suoi elementi a ze-
  # ro
  out<- matrix(0,n+1,n+1)
  # Calcoliamo i parametri "u" e "d"
  u<- exp(sigma*sqrt(T1/n))
  d<- exp(-sigma*sqrt(T1/n))
  # Calcoliamo i coefficienti di tutto l'albero
  for (i in 1:(n+1)) {
    for (j in 1:(n+1)) {
      if (i<=j) { out[i,j]<- u^(j-i)*d^(i-1) }
    }
  }
  # Moltiplicando per il prezzo iniziale otteniamo l'albero definitivo
  out<- out*S0
  # Restituiamo l'output
  out
}
# ==============================================================================



# ==============================================================================
# FIGURA 4.1 - Payoff a scadenza di un'opzione call e di un'opzione put europee
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura4p1()

figura4p1<- function()
{
  # Diamo le impostazioni della finestra grafica
  IGS()
  # Inizializziamo i parametri    
  colori<- c('black','gray60')
  K<- 40 
  # Tracciamo il payoff dell'opzione call
  curve(pmax(x-K,0),xlim=c(K-10,K+10),ylim=c(-.1,10),main='',xlab='',ylab='',
    col=colori[1])
  # Aggiungiamo il payoff dell'opzione put
  curve(pmax(K-x,0),add=TRUE,col=colori[2],lty=2)
  # Aggiungiamo la legenda
  leg.txt<- c('Payoff call','Payoff put')
  legend('topright',legend=leg.txt,col=colori,lty=1:2,bg='white',cex=0.8)
  # Salvataggio
  savePlot('payoff','pdf')
}

# ==============================================================================



# ==============================================================================
# FIGURA 4.2 - Payoff a scadenza e prezzo di una call europea in funzione del
#              prezzo del sottostante per due livelli di volatilità
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura4p2()

figura4p2<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(fOptions)
  # Diamo le impostazioni della finestra grafica
  IGS()
  # Inizializziamo i parametri del sottostante e dell'opzione
  colori<- c('black','gray60','gray30')
  K<- 40
  AssetPrice<- 39
  Int_rate<- 0.02
  Time<- 0.5
  sigma1<- 0.2
  sigma2<- 0.3
  # Tracciamo il grafico del payoff a scadenza dell'opzione
  curve(pmax(x-K,0),xlim=c(K-10,K+10),ylim=c(-.1,10),main='',xlab='',ylab='',
    col=colori[1])
  # Aggiungiamo la funzione del prezzo dell'opzione con la volatitlità al 20%
  curve(GBSOption(TypeFlag='c',S=x,X=K,Time=Time,r=Int_rate,b=Int_rate,
    sigma=sigma1)@price,add=TRUE,col=colori[2])
  # Aggiungiamo la funzione del prezzo dell'opzione con la volatitlità al 30%
  curve(GBSOption(TypeFlag='c',S=x,X=K,Time=Time,r=Int_rate,b=Int_rate,
    sigma=sigma2)@price,add=TRUE,col=colori[3])
  # Aggiungiamo la legenda
  leg.txt <- c('Payoff a scadenza',eval(bquote(expression(sigma[1]==.(sigma1),
    sigma[2]==.(sigma2)))))
  legend('topleft',legend=leg.txt,lty=1,col=colori,bg='white',cex=0.8)
  # Salvataggio
  savePlot('prez_opz','pdf')
}    
# ==============================================================================



# ==============================================================================
# FIGURA 4.3 - Albero binomiale per il prezzo del sottostante
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura4p3()

figura4p3<- function()
{  
  # Inizializziamo i parametri del sottostante
  K<- 40
  St<- 39
  r<- 0.02
  Time<- 0.5
  sigma<- 0.2
  n<- 12
  # Calcoliamo l'albero del sottostante
  PP<- Sottostante(St,Time,r,sigma,n)
  # Rappresentiamo l'albero a video
  Albero(PP,dy=1)
  # Salvataggio
  savePlot('Albero','pdf')
}    
# ==============================================================================



# ==============================================================================
# FIGURA 4.4 - Albero binomiale per il prezzo di una call europea
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura4p4()

figura4p4<- function()
{           
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(fOptions)
  # Inizializziamo i parametri del sottostante e dell'opzione
  K<- 40
  AssetPrice<- 39
  Int_rate<- 0.02
  Time<- 0.5
  sigma<- 0.2
  Strike<- 40
  n<- 2
  # Calcoliamo l'albero dell'opzione
  CRRTree<- BinomialTreeOption(TypeFlag='ce',AssetPrice,Strike,Time,Int_rate,
    Int_rate,sigma,n)
  # Rappresentiamo l'albero a video
  Albero(CRRTree,dy=0.2,dx=0)
  # Salvataggio
  savePlot('bintree1','pdf')
}
# ==============================================================================



# ==============================================================================
# FIGURA 4.5 - Albero binomiale per il prezzo di una call europea
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura4p5()

figura4p5<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(fOptions)  
  # Inizializziamo i parametri del sottostante e dell'opzione
  K<- 40
  AssetPrice<- 39
  Int_rate<- 0.02
  Time<- 0.5
  sigma<- 0.2
  Strike<- 40
  n<- 12
  # Calcoliamo l'albero dell'opzione
  CRRTree<- BinomialTreeOption(TypeFlag='ce',AssetPrice,Strike,Time,Int_rate,
    Int_rate,sigma,n)
  # Rappresentiamo l'albero a video
  Albero(CRRTree,dy=1)
  # Salvataggio
  savePlot('bintree2','pdf')
}
# ==============================================================================



# ==============================================================================
# FIGURA 4.6 - Albero binomiale per il prezzo di una put europea
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura4p6()

figura4p6<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(fOptions)
  # Inizializziamo i parametri del sottostante e dell'opzione
  sigma<- 0.3               
  AssetPrice<- 50          
  Strike<- 50
  IntRate<- 0.03
  Time<- 1/3
  n<- 12
  # Calcoliamo l'albero dell'opzione
  CRRTree<- BinomialTreeOption(TypeFlag='pe',AssetPrice,Strike,Time,IntRate,
    IntRate,sigma,n)
  # Rappresentiamo l'albero a video
  Albero(CRRTree,dy=1)
  # Salvataggio
  savePlot('bintree3','pdf')
}  

# ==============================================================================



# ==============================================================================
# FIGURA 4.7 - Albero binomiale per il prezzo di una put americana
# ==============================================================================
#
# Input:    - NESSUNO -
#
# Output:   - NESSUNO -
#
# Esempio:
#
# > figura4p7()

figura4p7<- function()
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(fOptions)
  # Inizializziamo i parametri del sottostante e dell'opzione
  sigma<- 0.3               
  AssetPrice<- 50          
  Strike<- 50
  IntRate<- 0.03
  Time<- 1/3
  n<- 12
  # Calcoliamo l'albero dell'opzione
  CRRTree<- BinomialTreeOption(TypeFlag='pa',AssetPrice,Strike,Time,IntRate,
    IntRate,sigma,n)  
  # Rappresentiamo l'albero a video
  Albero(CRRTree,dy=1)
  # Salvataggio
  savePlot('bintree4','pdf')
}

# ==============================================================================



# ==============================================================================
# ESEMPIO 4.11 - Simulazione Monte Carlo per un'opzione europea
# ==============================================================================
#
# Spiegazione:
#  Dati in input i parametri del sottostante e dell'opzione, la funzione resti-
# tuisce in output la stima del prezzo, il suo intervallo di confidenza ed il
# tempo di calcolo.
#
# Input:
# B          - [int] Numerosità del campione per la simulazione Monte Carlo;
# sigma      - [num] Volatilità del sottostante;
# AssetPrice - [num] Prezzo iniziale del sottostante;
# Strike     - [num] Prezzo strike dell'opzione;
# IntRate    - [num] Tasso d'interesse risk-free;
# Time       - [num] Scadenza dell'opzione;
# alpha      - [num] Livello di confidenza per la stima intervallare del prezzo.
#
# Output:      [list] Lista a tre componenti. La componente "Prezzo" contiene la
#              stima puntuale del prezzo dell'opzione; la componente "CI" con-
#              tiene l'intervallo di confidenza per il prezzo dell'opzione; la
#              componente "Tempo" contiene il tempo di calcolo del prezzo.
#
# Esempio:  
#
# > out<- esempio4p11(B,sigma,AssetPrice,Strike,IntRate,Time,alpha)

esempio4p11<- function(B,sigma,AssetPrice,Strike,IntRate,Time,alpha)
{
  # Inizializziamo il seme delle procedure di estrazione di numeri pseudocasuali
  set.seed(58)
  # Memorizziamo l'istante in cui viene iniziata la procedura di calcolo
  ptm<- proc.time()
  # Generiamo il campione con i prezzi del sottostante a scadenza
  S<- rlnorm(B,log(AssetPrice)+(IntRate-sigma^2/2)*Time,sigma*sqrt(Time))
  # Calcoliamo i payoff a scadenza per ognuno dei prezzi del sottostante
  PF<- rep(0,B)
  PF[S>Strike]<- S[S>Strike]-Strike
  # Calcoliamo la stima puntuale del prezzo dell'opzione
  CallPrice<- exp(-IntRate*Time)*mean(PF)
  # Ricaviamo il tempo di calcolo delle precedenti operazioni
  tempo<- proc.time()-ptm
  # Stimiamo la deviazione standard del valore attualizzato del payoff della
  # opzione
  sigmahat<- sqrt(sum((exp(-IntRate*Time)*PF-CallPrice)^2)/(B-1))
  # Ricaviamo gli estremi dell'intervallo di confidenza
  CI_low<- CallPrice-qnorm(1-alpha/2)*sigmahat/sqrt(B)
  CI_up<- CallPrice+qnorm(1-alpha/2)*sigmahat/sqrt(B)
  CI<- c(CI_low,CI_up)
  # Strutturiamo l'output in un oggetto list
  out<- list(Prezzo=CallPrice,CI=CI,Tempo=tempo)
  # Restituiamo l'output
  out
}
# ==============================================================================



# ==============================================================================
# ESEMPIO 4.13 - Calcolo della numerosità minima
# ==============================================================================
#
# Spiegazione:
#  Determinazione della numerosità campionaria che faccia sì che l'errore stan-
# dard del prezzo sia inferiore ad una certa soglia.
#
# Input:
# sigma      - [num] Volatilità del sottostante;
# AssetPrice - [num] Prezzo iniziale del sottostante;
# Strike     - [num] Prezzo strike dell'opzione;
# IntRate    - [num] Tasso d'interesse risk-free;
# Time       - [num] Scadenza dell'opzione;
# d          - [num] Tetto massimo accettabile per l'errore standard della stima
#              del prezzo dell'opzione.
#
# Output:      [int] Numerosità minima che per la quale l'errore standard della
#              stima è inferiore alla soglia "d" data in input.
#
# Esempio:  
#  
# > out<- esempio4p13(sigma,AssetPrice,Strike,IntRate,Time,d)

esempio4p13<- function(sigma,AssetPrice,Strike,IntRate,Time,d)
{
  # Inizializziamo il seme delle procedure di estrazione di numeri pseudocasuali
  set.seed(58)  
  # Inizializziamo la numerosità iniziale ed i vettori iniziali dei payoff e dei
  # prezzi a scadenza
  n0<- 100
  PF<- rep(0,n0)
  S<- rlnorm(n0,log(AssetPrice)+(IntRate-sigma^2/2)*Time,sigma*sqrt(Time))
  # Apriamo un ciclo infinito
  while (2>1)
  {
    # Simuliamo un nuovo prezzo a scadenza e lo aggiungiamo al campione
    S_temp<- rlnorm(1,log(AssetPrice)+(IntRate-sigma^2/2)*Time,sigma*sqrt(Time))
    S<- c(S,S_temp)
    # Calcoliamo i payoff
    PF<- c(PF,0)
    PF[S>Strike]<- S[S>Strike]-Strike
    # Stimiamo il prezzo dell'opzione
    CallPrice<- exp(-IntRate*Time)*mean(PF)
    # Stimiamo la deviazione standard del valore attualizzato del payoff della
    # opzione
    sigmahat<- sqrt(sum((exp(-IntRate*Time)*PF-CallPrice)^2)/length(S))
    # Definiamo la condizione di uscita dal ciclo (discesa dell'errore standar
    # al di sotto della soglia "d")
    if (sigmahat/sqrt(length(S))<d) { break }
  }
  # Ricaviamo la numerosità campionaria raggiunta
  out<- length(S)
  # Restituiamo l'output
  out
} 
# ==============================================================================



# ==============================================================================
# ESEMPIO 4.15 - Simulazione Monte Carlo per un'opzione call lookback a strike 
#                variabile
# ==============================================================================
#
# Spiegazione:
#  Dati in input i parametri del sottostante e dell'opzione lookback, la funzio-
# ne restituisce in output la stima del prezzo, il suo intervallo di confidenza 
# ed il tempo di calcolo.
#
# Input:
# B          - [int] Numerosità del campione per la simulazione Monte Carlo;
# sigma      - [num] Volatilità del sottostante;
# AssetPrice - [num] Prezzo iniziale del sottostante;
# IntRate    - [num] Tasso d'interesse risk-free;
# Time       - [num] Scadenza dell'opzione;
# alpha      - [num] Livello di confidenza per la stima intervallare del prezzo.
#
# Output:      [list] Lista a tre componenti. La componente "Prezzo" contiene la
#              stima puntuale del prezzo dell'opzione; la componente "CI" con-
#              tiene l'intervallo di confidenza per il prezzo dell'opzione; la
#              componente "Tempo" contiene il tempo di calcolo del prezzo.
#
# Esempio:  
#
# > out<- esempio4p15(B,sigma,AssetPrice,IntRate,Time,alpha)

esempio4p15<- function(B,sigma,AssetPrice,IntRate,Time,alpha)
{
  # Inizializziamo il seme delle procedure di estrazione di numeri pseudocasuali
  set.seed(58)
  # Inizializziamo la variabili necessarie alla procedura
  n<- 10000
  minimi<- rep(0,B)
  finale<- rep(0,B) 
  temp<- (0:n)/n*Time
  # Memorizziamo l'istante in cui viene iniziata la procedura di calcolo
  ptm<- proc.time()
  # Apriamo il ciclo per i "B" percorsi
  for (i in 1:B)
  {
    # Simuliamo un moto browniano geometrico
    u<- rnorm(n,0,sqrt(Time/n))
    Wt<- diffinv(u)
    Xt<- (IntRate-sigma^2/2)*temp+sigma*Wt
    S<- AssetPrice*exp(Xt)
    # Memorizziamo il valore minimo e quello finale del moto simulato
    minimi[i]<- min(S)
    finale[i]<- S[length(S)]
  }
  # Stimiamo la deviazione standard del valore attualizzato del payoff della
  # opzione
  sigmahat<- sd(finale*exp(-IntRate*Time))
  # Stimiamo il prezzo dell'opzione
  media_min<- mean(finale-minimi)
  prezzo_call<- exp(-IntRate*Time)*media_min
  # Ricaviamo gli estremi dell'intervallo di confidenza
  CI_low<- prezzo_call+qnorm(alpha/2)*sigmahat/sqrt(B)
  CI_up<- prezzo_call+qnorm(1-alpha/2)*sigmahat/sqrt(B)
  CI<- c(CI_low,CI_up)
  # Ricaviamo il tempo di calcolo delle precedenti operazioni
  tempo<- proc.time()-ptm
  # Strutturiamo l'output in un oggetto list
  out<- list(Prezzo=prezzo_call,CI=CI,Tempo=tempo)
  # Restituiamo l'output
  out
}
# ==============================================================================



# ==============================================================================
# ESEMPIO 4.16 - Simulazione Monte Carlo per un'opzione call a barriera
#                down-and-in
# ==============================================================================
#
# Spiegazione:
#  Dati in input i parametri del sottostante e dell'opzione call a barriera 
# down-and-in, la funzione restituisce in output la stima del prezzo, il suo
# intervallo di confidenza ed il tempo di calcolo.
#
# Input:
# B          - [int] Numerosità del campione per la simulazione Monte Carlo;
# sigma      - [num] Volatilità del sottostante;
# AssetPrice - [num] Prezzo iniziale del sottostante;
# Strike     - [num] Prezzo strike dell'opzione;
# IntRate    - [num] Tasso d'interesse risk-free;
# Time       - [num] Scadenza dell'opzione;
# V          - [num] Prezzo barriera;
# alpha      - [num] Livello di confidenza per la stima intervallare del prezzo.
#
# Output:      [list] Lista a tre componenti. La componente "Prezzo" contiene la
#              stima puntuale del prezzo dell'opzione; la componente "CI" con-
#              tiene l'intervallo di confidenza per il prezzo dell'opzione; la
#              componente "Tempo" contiene il tempo di calcolo del prezzo.
#
# Esempio:  
#
# > out<- esempio4p16(B,sigma,AssetPrice,Strike,IntRate,Time,V,alpha)

esempio4p16<- function(B,sigma,AssetPrice,Strike,IntRate,Time,V,alpha)
{
  # Inizializziamo il seme delle procedure di estrazione di numeri pseudocasuali
  set.seed(58)
  # Inizializziamo la variabili necessarie alla procedura
  n<- 10000
  finale<- rep(0,B)      
  temp<- (0:n)/n*Time 
  # Memorizziamo l'istante in cui viene iniziata la procedura di calcolo
  ptm<- proc.time()
  # Apriamo il ciclo per i "B" percorsi
  for (i in 1:B)
  {
    # Simuliamo un moto browniano geometrico
    u<- rnorm(n,0,sqrt(Time/n))
    Wt<- diffinv(u)
    Xt<- (IntRate-sigma^2/2)*temp+sigma*Wt
    S<- AssetPrice*exp(Xt)
    # Calcoliamo il payoff a scadenza dell'opzione in caso di sfondamento della
    # barriera (diversamente resta nullo)
    if (min(S)<V) finale[i]<- max(c(S[length(S)]-Strike,0))
  }
  # Stimiamo la deviazione standard del valore attualizzato del payoff della
  # opzione
  sigmahat<- sd(finale*exp(-IntRate*Time))
  # Stimiamo il prezzo dell'opzione
  media<- mean(finale)
  prezzo_call<- exp(-IntRate*Time)*media
  # Ricaviamo gli estremi dell'intervallo di confidenza
  CI_low<- prezzo_call+qnorm(alpha/2)*sigmahat/sqrt(B)
  CI_up<- prezzo_call+qnorm(1-alpha/2)*sigmahat/sqrt(B)
  CI<- c(CI_low,CI_up)
  # Ricaviamo il tempo di calcolo delle precedenti operazioni
  tempo<- proc.time()-ptm
  # Strutturiamo l'output in un oggetto list
  out<- list(Prezzo=prezzo_call,CI=CI,Tempo=tempo)
  # Restituiamo l'output
  out
}
# ==============================================================================



# ==============================================================================
# ESEMPIO 4.17 - Volatilità implicita per un'opzione call europea
# ==============================================================================
#
# Spiegazione:
#  Dati in input i parametri del sottostante e dell'opzione call europea la fun-
# zione restituisce in output la stima della volatilità implicita.
#
# Input:
# P        - [num] Prezzo di mercato dell'opzione;
# S        - [num] Prezzo iniziale del sottostante;
# K        - [num] Prezzo strike dell'opzione;
# r        - [num] Tasso d'interesse risk-free;
# T1       - [num] Scadenza dell'opzione.
#
# Output:    [list] Lista a due componenti. La componente "fOpt" contiene la
#            stima della volatilità implicita ottenuta mediante la funzione
#            "GBSVolatility" del pacchetto "fOptions"; la componente "unir" con-
#            tiene la stima della volatilità implicita ricavata attraverso la
#            funzione "uniroot".
#
# Esempio:  
#
# > esempio4p17(OptionPrice,AssetPrice,Strike,IntRate,Time)

esempio4p17<- function(P,S,K,r,T1)
{
  # Ci assicuriamo che i pacchetti necessari siano stati caricati
  require(fOptions)
  # Ricaviamo la volatilità implicita direttamente mediante la funzione
  # "GBSVolatility"
  Volatility<- GBSVolatility(price=P,TypeFlag='c',S=S,X=K,Time=T1,r=r,b=r)
  # Definiamo la funzione di cui trovare lo zero
  f<- function (x,S,K,r,T1) {
    S*pnorm((log(S/K)+(r+x^2/2)*T1)/(x*sqrt(T1)))-
      K*exp(-r*T1)*pnorm((log(S/K)+(r-x^2/2)*T1)/(x*sqrt(T1)))-P
  }
  # Cerchiamo lo zero della funzione
  xmin<- uniroot(f, c(0.01, 10),tol=.Machine$double.eps,S,K,r,T1)
  # Strutturiamo l'output in un oggetto list
  out<- list(fOpt=Volatility,unir=xmin$root)
  # Restituiamo l'output
  out
}  
# ==============================================================================
