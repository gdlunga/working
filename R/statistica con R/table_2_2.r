rm(list=ls())

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

h=hist(W, c(40,50,60,70,80,90,100))
str(h)

plot(X)
plot(table(X))
pie(table(X))
hist(W, c(40,50,58,70,95))
hist(W, main = "Sturges")
hist(W, breaks="Scott", main = "Scott")




