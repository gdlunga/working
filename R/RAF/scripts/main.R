#Main created by R code [2015/06/04-08:07:52]
library(CogUtils)
rm(list=ls(all=TRUE))
#funzione di usage
usage <- function(){
  print('usage da file:')
  print('programma -c filediconf:')
}
str_stop <- 'BAD EXIT'
#recupero argomenti
args <- commandArgs(TRUE);
#controllo numerosità argomenti
if ((length(args) <= 0) || ((length(args) %% 2) != 0)){
  usage();
  stop(str_stop);
}
#parsing argomenti
for (i in seq(1,length(args),2))
{
  if (args[i] == '-c') {
    cfg_pathfile <<- args[i + 1]
  }
}
if (cfg_pathfile != ''){
  cat('Confpathfile:[',cfg_pathfile ,']\n');
} else {
  usage();
  stop(str_stop);
}
Maincore(cfg_pathfile)
detach('package:CogUtils', unload=TRUE)
