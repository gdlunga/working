library(mFilter)

file_path = '/Users/giovanni/git_repository/working/R/appunti'
file_name = 'SerieVolumi.csv'

file_name = paste(file_path,file_name,sep='/')

Log_Nb<- read.csv(file_name,header = TRUE, sep = ";")
attach(Log_Nb)

# to display column names use the command: names(Log_Nb)

enti.ts    <- ts(Log_Nb[,which(names(Log_Nb)=='BMPS_CC_RACC_ENTI')]   ,start=c(2008,2),end=c(2016,7),frequency=12)
kc.ts      <- ts(Log_Nb[,which(names(Log_Nb)=='BMPS_CC_RACC_KC')]     ,start=c(2008,2),end=c(2016,7),frequency=12)
pf.ts      <- ts(Log_Nb[,which(names(Log_Nb)=='BMPS_CC_RACC_PF')]     ,start=c(2008,2),end=c(2016,7),frequency=12)
pmi.ts     <- ts(Log_Nb[,which(names(Log_Nb)=='BMPS_CC_RACC_PMI')]    ,start=c(2008,2),end=c(2016,7),frequency=12)
private.ts <- ts(Log_Nb[,which(names(Log_Nb)=='BMPS_CC_RACC_PRIVATE')],start=c(2008,2),end=c(2016,7),frequency=12)
sb.ts      <- ts(Log_Nb[,which(names(Log_Nb)=='BMPS_CC_RACC_SB')]     ,start=c(2008,2),end=c(2016,7),frequency=12)
dr.ts      <- ts(Log_Nb[,which(names(Log_Nb)=='BMPS_DR_RACC')]        ,start=c(2008,2),end=c(2016,7),frequency=12)

ts = pf.ts

HodrickPrescott_1 <- hpfilter(ts,freq=129600,type="lambda",drift=FALSE)
HodrickPrescott_2 <- hpfilter(ts,freq=14400 ,type="lambda",drift=FALSE)

hpRes_1<-(ts-(HodrickPrescott_1$trend))
hpRes_2<-(ts-(HodrickPrescott_2$trend))

sd(hpRes_1)
sd(hpRes_2)

plot.ts(ts)
lines(HodrickPrescott_1$trend, col='red')
lines(HodrickPrescott_2$trend, col='blue')

require(dlm)

s <- dlmSmooth(ts, dlmModPoly(1, dV = 20000, dW = 100))
lines(dropFirst(s$s), col = "green")
