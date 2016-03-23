#_______________________________________________________________________________________________________________________________
#
# function			: working.dir 
# description		: restituisce il path in cui si trova il folder di lavoro degli script R
# last version	    :
# note				:
#
working.dir <- function(){
  # individuazione path git
  require(stringr)
  if(Sys.info()[1] == 'Windows'){
    if(Sys.info()[4] == 'CL103006940047')
      git_dir <- str_trim('C:/Users/t004314/Documents/git')
    else
      git_dir <- str_trim('C:/Users/User/Documents/GitHub')
  }else{
    git_dir <- str_trim('/Users/giovanni/git_repository')
  }
  working_dir <- paste(git_dir, 'R/Rquants', sep="/") 
}