library(quantmod)

getSymbols("GOOG",src="yahoo",from="2016-01-01",to="2016-09-30")
getSymbols("AAPL",src="yahoo",from="2016-01-01",to="2016-09-30")
getSymbols("MSFT",src="yahoo",from="2016-01-01",to="2016-09-30")

retGOOG = dailyReturn(GOOG)
retAAPL = dailyReturn(AAPL)
retMSFT = dailyReturn(MSFT)

plot(retGOOG)
lines(retAAPL, col = 'red')
lines(retMSFT, col = 'blue')
