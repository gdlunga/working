require(astsa)
require(tseries)

Dirname <- "/working/R/IRRBB/data"
Dirs <- list.dirs(path=file.path("~"),recursive=T)
dir_wd <- names(unlist(sapply(Dirs,grep,pattern=Dirname))[1])
setwd(dir_wd)

# import del file contenente i dati relativi all'indice S&P MIB
file_name = paste(getwd(),'hist_euribor.csv',sep='/')

euribor <- read.csv(file_name, sep=';')
euribor$Date = as.Date(euribor$Date)

acf(euribor$X1.Month, 4000)
adf.test(euribor$X1.Month)

