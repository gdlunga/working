rm(list=ls())

library("stats", lib.loc="D:/R/R-3.2.2/library")
load('D:/git/working/R/statistica con R/dati1.rda')

# figura 2.7 pag. 42
dev.new()
plot(ecdf(Z), main='Funzione di ripartizione')

# figura 2.8 pag 43
classi<-c(40,50,58,70,95,100)
Fi<-cumsum(table(cut(W, classi)))/length(W)
Fi<-c(0, Fi)
dev.new()
plot(classi, Fi, type = 'b', axes = FALSE, main = 'Funzione di ripartizione')
axis(2,Fi)
axis(1,classi)
box()

