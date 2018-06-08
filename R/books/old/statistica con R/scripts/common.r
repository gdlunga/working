#_______________________________________________________________________________________________________________________________
#
# function			: working.dir 
# description		: restituisce il path in cui si trova il folder di lavoro degli script R
# last version	    :
# note				:
#
working.dir <- function(){
  require(stringr)
  if(Sys.info()[1] == 'Windows'){
    if(Sys.info()[4] == 'CL100400200004')
      working_dir <- str_trim('D:/git/working/R/')
    else
      working_dir <- str_trim('C:/git/working/R/')
  }else{
    working_dir <- str_trim('/Users/giovanni/git_repository/working/R/')
  }
}