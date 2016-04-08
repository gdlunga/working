shift<-function(x,shift_by){
  stopifnot(is.numeric(shift_by))
  stopifnot(is.numeric(x))
  
  if (length(shift_by)>1)
    return(sapply(shift_by,shift, x=x))
  
  out<-NULL
  abs_shift_by=abs(shift_by)
  if (shift_by > 0 )
    out<-c(tail(x,-abs_shift_by),rep(NA,abs_shift_by))
  else if (shift_by < 0 )
    out<-c(rep(NA,abs_shift_by), head(x,-abs_shift_by))
  else
    out<-x
  out
}

w = rnorm(1000)
ww = shift(w,1)

cov(w[1:999],ww[1:999])


# create a time series variable
y1 <- ts(1:10)
# create lead variable
y1.lead <- lag(y1, k=2)
# create lag variable
y1.lag <- lag(y1, k=-2)
