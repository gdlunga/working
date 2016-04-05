require(astsa)
require(zoo)

Dirname <- "/working/R/IRRBB/data"
Dirs <- list.dirs(path=file.path("~"),recursive=T)
dir_wd <- names(unlist(sapply(Dirs,grep,pattern=Dirname))[1])
setwd(dir_wd)

# import del file contenente i dati relativi all'indice S&P MIB
file_name = paste(getwd(),'hist_euribor.csv',sep='/')

euribor <- read.csv(file_name, sep=';')
euribor$Date = as.Date(euribor$Date)

# serie giornaliere
euribor1M = zoo(x=euribor$X1.Month, order.by=euribor$Date) 
euribor6M = zoo(x=euribor$X6.Month, order.by=euribor$Date) 
euribor1Y = zoo(x=euribor$X12.Month, order.by=euribor$Date) 


euribor1M$yearmon = as.yearmon(euribor$Date,"%Y %b")


plot(euribor1M)
lines(euribor6M,col='red')
lines(euribor1Y, col='blue')

e1m = euribor$X1.Month


w   = rnorm(length(e1m),0,1)
alpha  = .2
beta   = .25
sigma  = 0.01
z   = alpha + beta*e1m + sigma*w


plot.ts(e1m)
lines(z,col='red')

y<-lm(z~e1m)

