
options(repr.plot.width=10, repr.plot.height=4)

require(astsa)
plot(gtemp,type="o",ylab="Global Temperature Deviations")
# regress gtemp on time
fit = lm(gtemp ~ time(gtemp))
# view results
summary(fit)
# This function adds one or more straight lines through the current plot.
abline(fit, col='red')

options(repr.plot.width=10, repr.plot.height=10)
par(mfrow=c(3,1))
# plot the data
plot(cmort, main='Cardiovascular Mortality')
#lines(tempr, col='red')
plot(tempr, main='Temperature')
plot(part , main='Particulates')

pairs(cbind(Mortality=cmort, Temperature=tempr, Particulates=part))


