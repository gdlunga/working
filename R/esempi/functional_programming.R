f = Sepal.Length  ~ Petal.Length
plot(f, data=iris,pch=5,main="sepal len Vs petal len")
res=lm(f, data=iris)
abline(res,col='blue')

boot.lm <- function(formula,data){
  function(){
    lm(formula=formula, data=data[sample(nrow(data), replace=TRUE),])
  }
}

iris.boot <- boot.lm(Sepal.Length ~ Petal.Length, iris)  

ptm<-proc.time()
bstrap <- sapply(X=1:10000, FUN=function(x) iris.boot()$coef)
proc.time()- ptm


Point(x,y) %as% list(x=x,y=y)
Polar(r,theta) %as% list(r=r,theta=theta)
