Dirname <- "/working/R"
Dirs <- list.dirs(path=file.path("~"),recursive=T)
dir_wd <- names(unlist(sapply(Dirs,grep,pattern=Dirname))[1])
dir_wd
dir_wd <- paste(dir_wd,'revisioni/IRRBB_2016/data',sep='/')
dir_wd
setwd(dir_wd)

install.packages("forecast")
require(zoo)
library(forecast)

# import del file contenente i dati relativi all'indice S&P MIB
file_name = paste(getwd(),'hist_euribor.csv',sep='/')

euribor <- read.csv(file_name, sep=';')
euribor$Date = as.Date(euribor$Date)

# serie giornaliere
euribor1M = zoo(x=euribor$X1.Month, order.by=euribor$Date) 
euribor6M = zoo(x=euribor$X6.Month, order.by=euribor$Date) 
euribor1Y = zoo(x=euribor$X12.Month, order.by=euribor$Date) 

# estraggo i dati dell'euribor a 1 mese su una finestra temporale
# euribor1M_2015 = window(euribor1M, start='2014-01-01', end='2015-12-01')
# plot(euribor1M_2015)
# mod <- auto.arima(euribor1M_2015, stationary=FALSE, seasonal = FALSE, ic='aic')
# mod
# tsdiag(mod)
# 
# jf_adf <- ur.df(euribor1M_2015, type = "drift")
# summary(jf_adf)
# 
# plot(mod$x)
# lines(fitted(mod), col='red')

# creo un nuovo indice aggregando per mese-anno le date presenti originariamente
m_index      <- as.Date(as.yearmon(time(euribor1Y)))
# creo una nuova serie aggregando i dati di euribor1M sul nuovo indice temporale
# (base mensile) e calcolando la media
m_euribor1M  <- aggregate(euribor1M, m_index, mean)
write.zoo(m_euribor1M, file = "hist_euribor_1MM.csv",sep=';')

plot(m_euribor1M, typ='l')
#lines(euribor6M,col='red')
#lines(euribor1Y, col='blue')

#ret_simple <- diff(euribor1M) / lag(euribor1M, k = -1) * 100
#plot.ts(ret_simple)
#lines(.1*ret_simple,col='red')
#hist(ret_simple, breaks=1000, main = "Histogram of Simple Returns", xlab="%",xlim=c(-5,5))

#mod <- auto.arima(euribor1M, stationary=TRUE, seasonal = FALSE, ic='aic')
#mod
#tsdiag(mod)

w      = rnorm(length(m_euribor1M))
alpha  = 1
beta   = .67
lambda = 0.05
deposit = alpha + beta*m_euribor1M + lambda*w

plot(m_euribor1M, typ='l')
lines(deposit, col='red')

# controllo se l'euribor 1M è stazionario
jf_adf <- ur.df(euribor1M, type = "drift")
summary(jf_adf)


mod_static <- summary(lm(deposit ~ m_euribor1M))
errors     <- residuals(mod_static)
error_cadf <- ur.df(error, type="none")
summary(error_cadf)

djf <- diff(deposit)
dho <- diff(m_euribor1M)
error_lag <- lag(errors, k=-1)
mod_ecm <- lm(djf ~ dho + error_lag)

summary(mod_ecm)

djf <- deposit
dho <- m_euribor1M
mod_ecm <- lm(djf ~ dho)

summary(mod_ecm)
