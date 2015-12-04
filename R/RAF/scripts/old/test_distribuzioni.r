library(MASS)
library(QRM)
library(xlsx)

g_INPUT_DIR  = "C:/Users/t004314/Documents/git/working/R/statistica con R/data" # serve per lavorare in locale
g_OUTPUT_DIR = "C:/Lavoro/RAF/R"       # serve per lavorare in locale

version_file = 0
version_form = 0
estension    = ".csv"

input_file   = paste("output_", version_file, "_", version_form, estension, sep="")
dati         = read.csv2(file=paste(g_INPUT_DIR,input_file,sep="/"),1)

# PREDISPOSIZIONE DATA FRAME
rownames(dati) = dati[,1]            #assegno la prima colonna (anno) come indice di riga
dati           = dati[2:ncol(dati)]  #elimino la prima colonna

x         = dati[,1]
ylim_max  = 3.5
hist(x, ylim=c(0,ylim_max))
#axis(1, c(mean(x)), c(expression(bar(x))))
#lines(density(x), col="red")

mx = mean(x)
s2 = var(x)
n  = length(x)

l.inf = t.test(x)$conf.int[1]
l.sup = t.test(x)$conf.int[2]

lines(c(l.inf,l.inf), c(0,ylim_max), lty=2, col="blue")
lines(c(l.sup,l.sup), c(0,ylim_max), lty=2, col="blue")
lines(c(mx,mx),       c(0,ylim_max), lty=3, col="red")

fit_norm   = fitdistr(x, densfun = "normal")
loglike    = fit_norm$loglik
estimate   = fit_norm$estimate

nsim      = 10
mu        = estimate[1]
sigma     = estimate[2]
y         = mu + sigma*rnorm(nsim)
ylim_max  = 1.1*max(hist(y)$count)

hist(y, ylim=c(0,ylim_max))

l.inf = t.test(y)$conf.int[1]
l.sup = t.test(y)$conf.int[2]

lines(c(l.inf,l.inf), c(0,ylim_max), lty=2, col="blue")
lines(c(l.sup,l.sup), c(0,ylim_max), lty=2, col="blue")
lines(c(mu,mu),       c(0,ylim_max), lty=3, col="red")
