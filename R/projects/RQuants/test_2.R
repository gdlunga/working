#library("RQuantLib", lib.loc="~/R/win-library/3.2")
library(RQuantLib)

# This data is taken from sample code shipped with QuantLib 0.3.10.
params <- list(tradeDate=as.Date('2002-2-15'),
               settleDate=as.Date('2002-2-19'),
               payFixed=TRUE,
               strike=.04,method="HWAnalytic",
               interpWhat="discount",
               interpHow="loglinear")
# Market data used to construct the term structure of interest rates
# tsQuotes <- list(d1w =0.0382,
#                  d1m =0.0372,
#                  fut1=96.2875,
#                  fut2=96.7875,
#                  fut3=96.9875,
#                  fut4=96.6875,
#                  fut5=96.4875,
#                  fut6=96.3875,
#                  fut7=96.2875,
#                  fut8=96.0875,
#                  s3y =0.0398,
#                  s5y =0.0443,
#                  s10y =0.05165,
#                  s15y =0.055175)
# Use this to compare with the Bermudan swaption example from QuantLib
tsQuotes <- list(flat=0.04875825)
# Swaption volatility matrix with corresponding maturities and tenors
swaptionMaturities <- c(1,2,3,4,5)
swapTenors <- c(1,2,3,4,5)
volMatrix <- matrix(
  c(0.1490, 0.1340, 0.1228, 0.1189, 0.1148,
    0.1290, 0.1201, 0.1146, 0.1108, 0.1040,
    0.1149, 0.1112, 0.1070, 0.1010, 0.0957,
    0.1047, 0.1021, 0.0980, 0.0951, 0.1270,
    0.1000, 0.0950, 0.0900, 0.1230, 0.1160),
  ncol=5, byrow=TRUE)
# Price the Bermudan swaption
pricing <- BermudanSwaption(params, tsQuotes,
                            swaptionMaturities, swapTenors, volMatrix)
summary(pricing)
pricing$price/10