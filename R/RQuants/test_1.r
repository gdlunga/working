params <- list(effectiveDate=as.Date("2004-11-30"), 
               maturityDate=as.Date("2008-11-30"), 
               period='Semiannual', 
               calendar ='UnitedStates/GovernmentBond', 
               businessDayConvention='Unadjusted', 
               terminationDateConvention = 'Unadjusted', 
               dateGeneratio='Forward', 
               endOfMonth = 1)
Schedule(params)