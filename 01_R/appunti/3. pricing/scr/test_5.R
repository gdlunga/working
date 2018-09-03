#
#-----------------------------------------------------------------------------------------------------------
#
require(RQuantLib)

params <- list(tradeDate=as.Date('2014-01-01'),
               settleDate=as.Date('2014-01-01'),
               dt=.25,
               interpWhat="discount",
               interpHow="loglinear")

setEvaluationDate(as.Date("2014-01-01"))

tsQuotes        <- list(flat=0.02)
times           <- seq(0,10,.1)# Loglinear interpolation of discount factors
discountCurve   <- DiscountCurve(params, tsQuotes, times)
#
#-----------------------------------------------------------------------------------------------------------
#
# price a fixed rate coupon bond
#
#-----------------------------------------------------------------------------------------------------------
#
bond <- list(settlementDays=1, issueDate=as.Date("2014-01-30"),
             faceAmount=100, accrualDayCounter='Thirty360',
             paymentConvention='Unadjusted')

schedule <- list(effectiveDate=as.Date("2014-01-30"),
                 maturityDate=as.Date("2024-01-30"),
                 period='Semiannual',
                 calendar='UnitedStates/GovernmentBond',
                 businessDayConvention='Unadjusted',
                 terminationDateConvention='Unadjusted',
                 dateGeneration='Forward',
                 endOfMonth=1)

calc=list(dayCounter='Actual360', compounding='Compounded',
          freq='Annual', durationType='Modified')

rates <- c(0.02)

FixedRateBond(bond, rates, schedule, calc, discountCurve=discountCurve)
#
#-----------------------------------------------------------------------------------------------------------
#
# price a floating rate bond
#
#-----------------------------------------------------------------------------------------------------------
#
bondparams <- list(faceAmount=100, 
                   issueDate=as.Date("2014-01-15"),
                   maturityDate=as.Date("2024-01-15"), 
                   redemption=100,
                   effectiveDate=as.Date("2014-01-15"))

dateparams <- list(settlementDays=1, 
                   calendar="UnitedStates/GovernmentBond",
                   dayCounter = 1, 
                   period=2, 
                   businessDayConvention = 1,
                   terminationDateConvention=1, 
                   dateGeneration=0, 
                   endOfMonth=0,
                   fixingDays = 1)

gearings <- spreads <- caps <- floors <- vector()

liborCurve <- DiscountCurve(params,list(flat=0.05), times)
libor      <- list(type="USDLibor", 
                   length=6, 
                   inTermOf="Month",
                   term=liborCurve)

FloatingRateBond(bondparams, gearings, spreads, caps, floors,
                 libor, discountCurve, dateparams)

