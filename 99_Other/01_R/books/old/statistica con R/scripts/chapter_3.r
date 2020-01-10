#
# functions -----------------------------------------------------------------------------------------------
#
bubbleplot <- function(tab, joint = TRUE, magnify=1, filled=TRUE, main="bubble plot"){ 
  if(! is.table(tab)){ 
    warning("L'input non e' una tabella") 
    return 
  } 
  if(joint) 
    z <- prop.table(tab) 
  else 
    z <- prop.table(tab,l) 
  h <- dim(z)[[1]]
  k <- dim(z)[[2]] 
  
  area   <- h*k 
  raggio <- pi*magnify*area*sqrt(as.vector(z)/pi) 
  # raggio <- magnify*sqrt(as.vector(z)/pi) raggio[which(raggio==0)] <- NA 
  colori <- numeric(h*k) 
  if(filled) 
    colori <- rep(rainbow(h),k) 
  
  asse.y <- rep(1:h,k) 
  asse.x <- numeric(0) 
  for(i in 1:k) 
    asse.x <- c(asse.x,rep(i,h)) 
  
  var <- names(dimnames(z)) 
  
  plot(0:(k+1),c(0,h+1,rep(0,k)),type="n", 
       axes.FALSE,ylab=var[1],xlab=var[2],main=main) 
  axis(1,0:(k+1),c("",dimnames(z)[[2]],"")) 
  axis(2,0:(h+1),c("",dimnames(z)[[1]],"")) 
  points(asse.x,asse.y, pch.21, cex = raggio, bg = colori) 
  # symbols(asse.x,asse.y,raggio,inches=FALSE, add.TRUE, bg = colori) 
} 

# 3.1 Analisi di dipendenza: la connessione -------------------------------------------------------------------

x<-c("O","O","S","B","S","O","B","B","S","B","O","B","B","O","S")
y<-c("O","B","B","B","S","S","O","O","B","B","O","S","B","S","B")
x<-ordered(x,levels=c("S","B","O"))
y<-ordered(y,levels=c("S","B","O"))
table(x,y) -> tabella

# condizionate di Y ad X
tabella[1,]    # Y | X=S
tabella[2,]    # Y | X=B
tabella[3,]    # Y | X=O

# condizionate di X a Y
tabella[,1]    # X | Y=S
tabella[,2]    # X | Y=B
tabella[,3]    # X | Y=O

# marginale di X
margin.table(tabella, 1)

# marginale di y
margin.table(tabella, 2)

# tabelle delle distribuzioni condizionate
tab2 <- tabella
tab2[1,] = tab2[1,]/sum(tab2[1,])
tab2[2,] = tab2[2,]/sum(tab2[2,])
tab2[3,] = tab2[3,]/sum(tab2[3,])
print(tab2, digits=2) # Y|X

tab3 <- tabella
tab3[,1] = tab3[,1]/sum(tab3[,1])
tab3[,2] = tab3[,2]/sum(tab3[,2])
tab3[,3] = tab3[,3]/sum(tab3[,3])
print(tab3, digits=2) # X|Y

# distribuzione doppia relativa
prop.table(tabella)

# marginali relative di Y|X (come sopra)
prop.table(tabella, 1)

# marginali relative di X|Y (come sopra)
prop.table(tabella, 2)

s        = summary(tabella)
chi2     = s$statistic
chi2_max = length(x)*min(nrow(tabella)-1,ncol(tabella)-1)
chi2_nor = chi2/chi2_max

# Il caso del Titanic
data("Titanic")
ftable(Titanic)
# somma di tutti i passeggeri suddivisi per eta e sesso
apply(Titanic, c(2,3), sum)

# come sopra separando sopravvisuti e deceduti
apply(Titanic, c(2,3,4), sum)

# 3.2 Dipendenza in media ----------------------------------------------------------------------------------

# 3.3 Analisi di regressione -------------------------------------------------------------------------------

# 3.3.1 I grafici di dispersione e la covarianza
dev.new()
x <- c(2,3,4,2,5,4,5,3,4,1)
y <- c(5,4,3,6,2,5,3,5,3,3)
plot(x,y,axes=FALSE)
axis(1,c(mean(x),0:6),c(expression(bar(x)),0:6))
axis(2,c(mean(y),0,1,2,3,5,6),c(expression(bar(y)),0,1,2,3,5,6))
box()
# il primo argomento e' il vettore delle coordinate x, il secondo il vettore delle y
lines(c(2,2,0),c(0,5,5),lty=2)
# posiziona un punto con indicatore a croce all'incontro delle linee precedentemente tracciate
points(2,5,pch=3,cex=3,col='red',lty=2)
# si generano due linee tratteggiate in corrispondenza delle coordinate <x>, <y>
lines(c(3.3,3.3,0), c(0,3.9,3.9), lty=3)
# inserimento di una label indicante le coordinate del punto di incontro (per migliorare la visibilita'
# la posizione della label e' spostata a destra rispetto al valore del punto)
text(3.6, 3.9, expression((list(bar(x)[n],bar(y)[n]))))
# posizionamento di un marker sul punto
points(mean(x),mean(y),pch=4,cex=3,col='red',lty=2)

# 3.3.2 La retta di regressione
x <- c(11,8,28,17,9,4,28,5,12,23,6,24,18,21,6,22, 27,17,27,6,29,9,3,12,9,23,5,27,20,13) 
y <- c(28,21,63,42,28,2,80,19,33,60,14,58,54,67, 18,64,65,68,77, 17,95,12,1,30,34,67,20,75,59,55) 
cor(x,y)
lm(y~x) -> model
dev.new()
plot(x,y)
abline(model, col="red", lwd=2)
a = model$coefficients[1]
b = model$coefficients[2]
text(10,80,labels=bquote(y[i] ==.(a)+.(b)*x[i]))


