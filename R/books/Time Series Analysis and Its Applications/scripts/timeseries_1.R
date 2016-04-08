require(astsa)

# import del file contenente i dati relativi all'indice S&P MIB
file_name = paste(getwd(),'ts_sp_mib.csv',sep='/')

ts <- read.csv(file_name, sep=';')
ts$Date = as.Date(ts$Date)
attach(ts)

mydata = as.ts(ts$Price)
mydata = ts(mydata, start = ts$Date[length(ts$Date)])
mydata = ts(mydata, end   = ts$Date[1])


plot(mydata)