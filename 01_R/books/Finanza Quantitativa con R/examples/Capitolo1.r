

# ==============================================================================
#
#                                 CAPITOLO 1
#
#             PREREQUISITI: STATISTICA, FINANZA E RISCHIO FINANZIARIO
#
# ==============================================================================



# ==============================================================================
#
#  NOTA:    I file di codice R di ogni capitolo contengono tutte le funzioni ne- 
#         cessarie a generare i risultati relativi alle tabelle presentate negli
#         esempi e tutti i grafici presenti nel libro.
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
# FIGURA 1.1 - Capitalizzazione annuale, mensile e continua
# ==============================================================================
#
# Input:  - NESSUNO -
#
# Output: - NESSUNO -
#
# Esempio:
#
# > figura1p1()

figura1p1<- function()
{
  # Diamo le impostazioni della finestra grafica ed inizializziamo le variabili
  IGS()
  # Inizializziamo i paramtetri
  colori<- c('gray30','gray60','black')
  R<- 0.4
  x<- 1
  # Calcoliamo la serie dei montanti secondo la capitalizzazione annuale 
  tt<- 1:10
  f1<- x*(1+R)^tt
  # Calcoliamo la serie dei montanti secondo la capitalizzazione mensile     
  t1<- 12:120
  R1<- R/12
  f2<- x*(1+R1)^t1
  indici<- c(1,13,25,37,49,61,73,85,97,109)
  # Calcoliamo la serie dei montanti secondo la capitalizzazione continua
  t3<- seq(1,10,by=0.01)
  f3<- x*exp(R*t3)
  # Tracciamo il grafico ed aggiungiamo la legenda
  plot(tt,f1,type='l',lty=1,col=colori[1],main='',xlab='',ylab='',ylim=c(0,60))
  lines(tt,f2[indici],lty=2,col=colori[2],lwd=2,type='l')
  lines(t3,f3,lty=3,colori[3],lwd=2,type='l')
  leg.txt<- c('Annuale','Mensile','Continua')
  legend('topleft',leg.txt,lty=c(1,2,3),col=colori,lwd=2)
  # Salvataggio
  savePlot('capit','pdf')
}
# ==============================================================================
