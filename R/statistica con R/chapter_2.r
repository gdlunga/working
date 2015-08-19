library("stats", lib.loc="D:/R/R-3.2.2/library")

# functions -----------------------------------------------------------------------------------------------

hist.pf <- function(x, br){
  if(missing(br))
    ist <- hist(x)
  else
    ist <- hist(x, breaks = br)
  
  if(ist$equidist)
    lines(c(min(ist$breaks),ist$mids,max(ist$breaks)),c(0,ist$counts,0))
  else
    lines(c(min(ist$breaks),ist$mids,max(ist$breaks)),c(0,ist$density,0))
}

skew <- function(x){
  n  <- length(x)
  s3 <- sqrt(var(x)*(n-1)/n)^3
  mx <- mean(x)
  sk <- sum((x - mx)^3)/s3
  sk/n
}

kurt <- function(x){
  n  <- length(x)
  s4 <- sqrt(var(x)*(n-1)/n)^4
  mx <- mean(x)
  kt <- sum((x - mx)^4)/s4
  kt/n
}

# indice di gini e curva di lorentz
gini <- function(x, plot=TRUE, add=FALSE, col="black") {
  
  n <- length(x) 
  x <- sort(x) 
  P <- (0:n)/n 
  Q <- c(0,cumsum(x)/sum(x)) 
  G <- 2*sum(P-Q)/(n-1) 
  
  IG <- list(G, (n-1)*G/n,P,Q) 
  names (IG) <- c("G","R","P","Q") 
  
  if (plot) { 
    angle=45 
    if(!add) { 
      plot(P,Q,type="l", axes = FALSE, asp=1, main ="curva di Lorenz") 
      axis(1); axis(2); rect(0,0,1,1) 
      lines(c(1,(n-1)/n),c(1,0),lty=2) 
      angle=90 
    }
    polygon(P,Q, density=10,angle=angle,col=col) 
  } 
  IG
}

# 2.2 La matrice dei dati ---------------------------------------------------------------------------------

x<-c(1,4,3,3,2,1,2,2,3,1,1,1,4,2,1,2,3,4,2,2)
x<-factor(x)
levels(x)<-c("N","C","V","S")

y<-c(4,2,1,2,4,3,3,2,4,2,3,1,3,3,3,4,2,2,3,3)
y<-factor(y)
levels(y)<-c("A","O","S","L")

z <- c(0,1,3,4,1,1,0,2,3,0,1,0,1,4,3,0,2,2,4,4)
w <- c(72.5,54.28,50.02,88.88,62.3,45.21,57.5,78.4,75.13,58,53.7,91.29,74.7,41.22,65.2,63.58,48.27,52.52,69.5,85.98)

dati<-data.frame(X=x,Y=y,Z=z,W=w)
attach(dati)
rm(x, y, z, w)
save(file="D:\\git\\working\\R\\statistica con R\\dati1.rda", dati)
#save(file="/Users/giovanni/git_repository/working/R/statistica con R/dati1.rda", dati)

# 2.3 Distribuzioni di frequenza --------------------------------------------------------------------------

#load('/Users/giovanni/git_repository/working/R/statistica con R/dati1.rda')
load('D:/git/working/R/statistica con R/dati1.rda')
attach(dati)

table(X)
table(X)/length(X)
100*table(X)/length(X)

table(Y)
table(Y)/length(Y)
100*table(Y)/length(Y)

cumsum(table(Y))
cumsum(table(Y)/length(Y))
cumsum(100*table(Y)/length(Y))

table(Z)
table(Z)/length(Z)
100*table(Z)/length(Z)

table(cut(W, breaks=c(40,50,60,70,80,90,100)))

# 2.4 Rappresentazioni grafiche ---------------------------------------------------------------------------

h=hist(W, c(40,50,60,70,80,90,100))
str(h)

plot(X)
plot(table(X))
pie(table(X))
hist(W, c(40,50,58,70,95))
hist(W, main = "Sturges")
hist(W, breaks="Scott", main = "Scott")

# figura 2.7 pag. 42
dev.new()
plot(ecdf(Z), main='Funzione di ripartizione')

# figura 2.8 pag 43
classi<-c(40,50,58,70,95,100)
Fi<-cumsum(table(cut(W, classi)))/length(W)
Fi<-c(0, Fi)
#dev.new()
plot(classi, Fi, type = 'b', axes = FALSE, main = 'Funzione di ripartizione')
axis(2,Fi)
axis(1,classi)
box()

# figura 2.9 pag. 44
classi<-c(40,50,58,70,95)
hist.pf(W)
hist.pf(W, classi)

# 2.7 La forma delle distribuzioni -----------------------------------------------------------------------
x<-c(0.75, 2.27, 5.19, 4.8, 1.6, 3.5, 11.19, 3.42, 4.38, 6.64, 5.41, 3.12, 9.45, 4.38, 4.77, 4.98, 3.74, 2.81, 2.04, 8.34) 
y<-c(13.79, 12.11, 8.85, 14.01, 9.71, 11.08, 12.34, 12.16, 7.52, 14.02, 9.75, 14.15, 12.84, 14.73, 12.88, 10.40, 12.78, 13.19, 9.59, 12.16) 
boxplot(x,y,names=c("x","y"))
skew(x)
skew(y)
kurt(x)
kurt(y)

# 2.8 La concentrazione ----------------------------------------------------------------------------------
x <- c(1,1,1,4,4,5,7,10)
sum(x)
y <- c(1,1,1,1,1,4,4,4,5,9,100,100,200)
sum(y)
# calcolo dell'indice di concentrazione di Gini e disegno della curva di Lorenz
gini(x,col="blue") 
# stessa cosa per "y" sovrapponendo alla precedente la nuova curva di concentrazione
gini(y,add=TRUE,col="red") 

#2.10 Dall'istogramma alla stima della densita' ----------------------------------------------------------

