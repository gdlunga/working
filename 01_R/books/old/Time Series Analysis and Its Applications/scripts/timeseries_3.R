require(astsa)
require(dynlm)

par(mfrow=c(1,1))

fit<-lm(gtemp~time(gtemp))
summary(fit)
plot(gtemp, type='o', ylab='global temperature deviation')
abline(fit,col='red')

plot(resid(fit))
plot(diff(gtemp))





par(mfrow=c(1,1))
plot(cmort, main='Cardiovascular Mortality')
plot(gtemp, main='global temperature deviation')
plot(part, main='Particulates')

dev.new()
pairs(cbind(Mortality=cmort, Temperature=tempr, Particulates=part))

temp  = tempr-mean(tempr)
temp2 = temp^2
trend = time(cmort)

fit= lm(cmort~trend+temp+temp2 + part)

plot(fit)

summary(fit)


dynlm(rec~L(soi,6))


plot(soi)
lines(ksmooth(time(soi),soi,'normal', bandwidth=1),lwd=2,col=2)

y= ksmooth(time(soi),soi,'normal', bandwidth=1)

I<-abs(fft(y$y)^2)/453
P=(4/453)*I[1:250]
f=0:249/453
plot(f,P,type='l')

y = arima.sim(list(order=c(1,0,0), ar=-0.9),n=500)
plot.ts(y)

I<-abs(fft(y)^2)/500
P=(4/500)*I[1:500]
f=0:499/500
plot(f,P,type='l')


y = arima.sim(list(order=c(0,0,1), ma=.5),n=100)
plot.ts(y)


