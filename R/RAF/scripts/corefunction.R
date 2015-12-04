# Sample of User Script created by R code [2015/06/04-08:07:52]
# Non va mai messa esplicitamete !!! -> rm(list=ls(all=TRUE))
library(CogUtils)
# La funzione di inizializzazione:
#	1. controlla ed eventualmente crea il filesystem di progetto
#	2. fornisce le variabili per accederci
#	3. controlla ed eventualmente crea il file di configurazione
#	4. fornisce le funzioni per gestirlo
#	5. fornisce una funzione di logging
Initialize()
writelog('Hello world')
#esempio di lettura da conf di una chiave esistente
val = getCfgVal2('CFG_TIME_CREATED')
if (is.nan(val)) {cat('Chiave non presente\n')}
cat(paste('val = ', val, '\n'))
#esempio di lettura da conf di una chiave NON esistente
val = getCfgVal2('NOTPRESENT')
if (is.nan(val)) {cat('Chiave non presente\n')}
cat(paste('val = ', val, '\n'))
#scrittura di un warning nel log
writelog('Questo è un warning', 2)
#scrittura di un error nel log
writelog('Questo è un error', 3)
# stampa la configurazione
printconfig()
writelog('Bye world')
