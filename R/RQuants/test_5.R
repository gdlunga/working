
params <- list(tradeDate=as.Date('2014-10-24'),
               settleDate=as.Date('2014-10-24'),
               dt=.25,
               interpWhat="discount",
               interpHow="loglinear")

setEvaluationDate(as.Date("2014-10-24"))

tsQuotes <- list(flat=0.02)
times    <- seq(0,10,.1)# Loglinear interpolation of discount factors
curves   <- DiscountCurve(params, tsQuotes, times)



