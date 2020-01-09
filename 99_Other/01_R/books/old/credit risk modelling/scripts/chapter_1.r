#____________________________________________________________________________________________________
#
# Modulo         : Credit Risk Modelling
# Descrizione    : R Data Analysis Examples: Logit Regression
# Autore         : Giovanni Della Lunga
# Versione       : 1.0
# Data           : 25/08/2015
# Note           : http://www.ats.ucla.edu/stat/r/dae/logit.htm
#                  This page uses the following packages. 
#                  library(aod)
#                  library(ggplot2)
#                  If you do not have a package installed, run:
#                  install.packages("aod")
#                  install.packages("ggplot2")
# Modifiche      : nessuna
#____________________________________________________________________________________________________
#
mydata <- read.csv("http://www.ats.ucla.edu/stat/data/binary.csv")
## view the first few rows of the data
head(mydata)
summary(mydata)
sapply(mydata, sd)

#write.table(mydata,"D:/tmp/mydata.csv",sep=";",row.names=FALSE)
## two-way contingency table of categorical outcome and predictors we want
## to make sure there are not 0 cells
xtabs(~admit + rank, data = mydata)

mydata$rank <- factor(mydata$rank)

mylogit <- glm(admit ~ gre + gpa + rank, data = mydata, family = "binomial")
summary(mylogit)

# dati esempio da foglio credit modelling

require(XLConnect)
require(rms)

wb    <- loadWorkbook("D:/tmp/credit_data.xlsx")
myDf  <- readWorksheet(wb, sheet = "Sheet1", header = TRUE)
myDf  <- read.csv("/Users/giovanni/git_repository/working/R/credit risk modelling/default_data.csv") 
attach(myDf)

# Model 1
mylogit <- glm(Default ~ WC.TA + RE.TA + EBIT.TA + ME.TL + S.TA, data = myDf, family = "binomial")
summary(mylogit)
confint(mylogit)
mod1b <- lrm(Default ~ WC.TA + RE.TA + EBIT.TA + ME.TL + S.TA)
print(mod1b)

# Model 2
mylogit <- glm(Default ~ RE.TA + EBIT.TA + ME.TL, data = myDf, family = "binomial")
summary(mylogit)
confint(mylogit)
mod1b <- lrm(Default ~ RE.TA + EBIT.TA + ME.TL)
print(mod1b)

# wald.test(b = coef(mylogit), Sigma = vcov(mylogit), Terms = c(1,5))

summary(myDf)
w = ME.TL
hist(w, seq(-3,3,.01))
dev.new()
plot(density(w), main="stima della densita'",xlab="W",xlim=c(-3.0,3.0))

