install.packages("stringr", dependencies=TRUE)
require(stringr)

if(Sys.info()[1] == 'Windows'){
  working_dir <- str_trim('C:/git/working/R/credit risk modelling')
}else{
  working_dir <- str_trim('/Users/giovanni/git_repository/working/R/credit risk modelling/')
}

# import del file contenente le scale di rating
file_name = paste(working_dir, 'rating_scale.csv', sep="/")
r_scale <- read.csv(file_name)
attach(r_scale)

#import del file contenente i dati di transizione degli emittenti
file_name = paste(working_dir, 'tr_matrix.csv', sep="/")
transitions <- read.csv(file_name)
transitions$Date = as.Date(transitions$Date)

attach(transitions)

