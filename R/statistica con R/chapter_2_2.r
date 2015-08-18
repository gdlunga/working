rm(list=ls())

library("stats", lib.loc="D:/R/R-3.2.2/library")
load('/Users/giovanni/git_repository/working/R/statistica con R/dati1.rda')
#load('D:/git/working/R/statistica con R/dati1.rda')

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

# esempio utilizzo funzioni
source('/Users/giovanni/git_repository/working/R/statistica con R/stats_extension.r')
classi<-c(40,50,58,70,95)
hist.pf(W)
hist.pf(W, classi)


# 2.7 La forma delle distribuzioni
x<-c(0.75, 2.27, 5.19, 4.8, 1.6, 3.5, 11.19, 3.42, 4.38, 6.64, 5.41, 3.12, 9.45, 4.38, 4.77, 4.98, 3.74, 2.81, 2.04, 8.34) 
y<-c(13.79, 12.11, 8.85, 14.01, 9.71, 11.08, 12.34, 12.16, 7.52, 14.02, 9.75, 14.15, 12.84, 14.73, 12.88, 10.40, 12.78, 13.19, 9.59, 12.16) 
boxplot(x,y,names=c("x","y"))
skew(x)
skew(y)
kurt(x)
kurt(y)

# 2.8 La concentrazione
x <- c(1,1,1,4,4,5,7,10)
sum(x)
y <- c(1,1,1,1,1,4,4,4,5,9,100,100,200)
sum(y)
gini(x,col="blue") # calcolo dell'indice di concentrazione di Gini e disegno della curva di Lorenz

gini(y,add=TRUE,col="red") # stessa cosa per "y" sovrapponendo alla precedente la nuova curva di concentrazione

