
file_path = '/Users/giovanni/git_repository/working/R/appunti'
file_name = 'SerieVolumi.csv'

file_name = paste(file_path,file_name,sep='/')

Log_Nb<- read.csv(file_name,header = TRUE, sep = ";")
attach(Log_Nb)




