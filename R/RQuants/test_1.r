library("RQuantLib", lib.loc="/Library/Frameworks/R.framework/Versions/3.2/Resources/library")

params <- list(effectiveDate=as.Date("2004-11-30"), 
               maturityDate=as.Date("2008-11-30"), 
               period='Semiannual', 
               calendar ='UnitedStates/GovernmentBond', 
               businessDayConvention='Unadjusted', 
               terminationDateConvention = 'Unadjusted', 
               dateGeneratio='Forward', 
               endOfMonth = 1)
Schedule(params)

AmericanOptionImpliedVolatility(type="call", value=11.10, underlying=100,
                                strike=100, dividendYield=0.01, riskFreeRate=0.03,
                                maturity=0.5, volatility=0.4)