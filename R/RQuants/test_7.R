require(RQuantLib)
#
#-----------------------------------------------------------------------------------------------------------
#
FixedLeg <- function(params, schedule, calc, rates)
{
  thisEnv <- environment()
  
  me <- list(
    params = params,
    schedule = schedule,
    calc = calc,
    rates = rates,

    price = function(discountCurve){
      zcb_params <- list(faceAmount=100, 
                         issueDate=params$issueDate,
                         maturityDate=schedule$maturityDate, 
                         redemption=100)
      zcb_dateparams <-list(settlementDays=1,
                            calendar="UnitedStates/GovernmentBond",
                            businessDayConvention=4)
      redemption <- ZeroCouponBond(zcb_params, discountCurve=discountCurve, zcb_dateparams)
      dummy<-FixedRateBond(params, 
                           rates, 
                           schedule, 
                           calc, 
                           discountCurve=discountCurve)
      return (dummy[1]$NPV - redemption[1]$NPV)
    }
  )

  assign('this',me,envir=thisEnv)
  class(me) <- append(class(me),"FixedLeg")
  return(me)
}
#
#-----------------------------------------------------------------------------------------------------------
#
FloatingLeg <- function(params, schedule)
{
  thisEnv <- environment()

  me <- list(
    params = params,
    schedule = schedule,

    price = function(discountCurve, liborCurve)
    {
      gearings <- spreads <- caps <- floors <- vector()
      libor    <- list(type="USDLibor", 
                       length=6, 
                       inTermOf="Month",
                       term=liborCurve)
      zcb_params <- list(faceAmount=100, 
                         issueDate=params$issueDate,
                         maturityDate=params$maturityDate, 
                         redemption=100)
      zcb_dateparams <-list(settlementDays=1,
                            calendar="UnitedStates/GovernmentBond",
                            businessDayConvention=4)
      redemption <- ZeroCouponBond(zcb_params, discountCurve=discountCurve, zcb_dateparams)
      dummy      <- FloatingRateBond(params, gearings, spreads, caps, floors,libor, discountCurve, schedule)
      return (dummy[1]$NPV - redemption[1]$NPV)
    }
  )
  
  assign('this',me,envir=thisEnv)
  class(me) <- append(class(me),"FloatingLeg")
  return(me)
}
#
#-----------------------------------------------------------------------------------------------------------
#
SwapPV <- function(nominalExchange=FALSE, fixedLeg, floatingLeg)
{
  thisEnv <- environment()
  
  me <- list(
    ## Define the environment where this list is defined so
    ## that I can refer to it later.
    thisEnv = thisEnv,
    
    hasNominalExchange = nominalExchange,
    fixedLeg = fixedLeg,
    floatingLeg = floatingLeg,
    
    price = function(discountCurve){
      return (fixedLeg$price(discountCurve))
    }
  )
  
  ## Define the value of the list within the current environment.
  assign('this',me,envir=thisEnv)
  
  ## Set the name for the class
  class(me) <- append(class(me),"SwapPV")
  return(me)
}
#
#-----------------------------------------------------------------------------------------------------------
#
leg_1_params   <- list(settlementDays=1, 
                       issueDate=as.Date("2014-01-15"),
                       faceAmount=100, 
                       accrualDayCounter='Thirty360',
                       paymentConvention='Unadjusted')

leg_1_schedule <- list(effectiveDate=as.Date("2014-01-15"),
                       maturityDate=as.Date("2024-01-15"),
                       period='Semiannual',
                       calendar='UnitedStates/GovernmentBond',
                       businessDayConvention='Unadjusted',
                       terminationDateConvention='Unadjusted',
                       dateGeneration='Forward',
                       endOfMonth=1)

leg_1_calc     <- list(dayCounter='Actual360', 
                       compounding='Compounded',
                       freq='Annual', 
                       durationType='Modified')

leg_1_rates    <- c(0.02)
#
#-----------------------------------------------------------------------------------------------------------
#
leg_2_params   <- list(faceAmount=100, 
                       issueDate=as.Date("2014-01-15"),
                       maturityDate=as.Date("2024-01-15"), 
                       redemption=100,
                       effectiveDate=as.Date("2014-01-15"))

leg_2_schedule <- list(settlementDays=1, 
                       calendar="UnitedStates/GovernmentBond",
                       dayCounter = 1, 
                       period=3, 
                       businessDayConvention = 1,
                       terminationDateConvention=1, 
                       dateGeneration=0, 
                       endOfMonth=0,
                       fixingDays = 1)
#
#-----------------------------------------------------------------------------------------------------------
#
params <- list(tradeDate=as.Date('2014-01-01'),
               settleDate=as.Date('2014-01-01'),
               dt=.25,
               interpWhat="discount",
               interpHow="loglinear")

setEvaluationDate(as.Date("2014-01-01"))

tsQuotes        <- list(flat=0.02)
times           <- seq(0,10,.1)# Loglinear interpolation of discount factors
discountCurve   <- DiscountCurve(params, tsQuotes, times)
liborCurve      <- DiscountCurve(params,list(flat=0.05), times)
#
#-----------------------------------------------------------------------------------------------------------
#
fixedLeg        <- FixedLeg   (leg_1_params, leg_1_schedule, leg_1_calc, leg_1_rates)
floatingLeg     <- FloatingLeg(leg_2_params, leg_2_schedule)

mySwap          <- SwapPV(FALSE, fixedLeg, floatingLeg)

fl<-mySwap$floatingLeg
fx<-mySwap$fixedLeg
fl$price(discountCurve, liborCurve)


