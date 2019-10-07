#--------------------------------------------------------------------------------------------------------
update <- FALSE
#
# Update R section (only for windows os!!!) ... just in case ... 
#
# installing/loading the package:
if(update){
  if(!require(installr)) {
    #load / install+load installr
    install.packages("installr"); require(installr)
  } 
  # using the package:
  # this will start the updating process of your R installation.  
  # It will check for newer versions, and if one is available, 
  # will guide you through the decisions you'd need to make.
  #
  updateR() 
}
#
#--------------------------------------------------------------------------------------------------------

if(!require(tm)) install.packages("tm") 
if(!require(qdap)) install.packages("qdap")
if(!require(qdapDictionaries)) install.packages("qdapDictionaries")
if(!require(dplyr)) install.packages("dplyr")
if(!require(RColorBrewer)) install.packages("RColorBrewer")
if(!require(ggplot2)) install.packages("ggplot2")
if(!require(scales)) install.packages("scales")
if(!require(SnowballC)) install.packages("SnowballC")
if(!require(Rgraphviz)) {
  source("https://bioconductor.org/biocLite.R")
  biocLite("Rgraphviz")
}

library(tm)
library(qdap)
library(qdapDictionaries)
library(dplyr)
library(RColorBrewer)
library(ggplot2)
library(scales)
library(Rgraphviz)
library(SnowballC)

# windows
file_path      = 'C:/Users/T004314/Documents/Data'
# mac os
# file_path      = '/Users/giovanni/git_repository/working/R/esempi/corpus/pdf'

setwd(file_path)

files = list.files(path = file_path, pattern = "pdf$")

Rpdf <- readPDF(control = list(text = "-layout"))

opinions     <- Corpus(URISource(files), readerControl = list(reader = Rpdf))
opinions.tdm <- TermDocumentMatrix(opinions, control = list(removePunctuation = TRUE,
                                                            stopwords = TRUE,
                                                            tolower = TRUE,
                                                            stemming = TRUE,
                                                            removeNumbers = TRUE,
                                                            bounds = list(global = c(3, Inf)))) 
 

inspect(opinions.tdm[1:10,]) 
findFreqTerms(opinions.tdm, lowfreq = 100, highfreq = Inf)

#-----------------------------------------------------
  
file_path      = '/Users/giovanni/git_repository/working/R/esempi/corpus/txt'
file_path      = file.path(file_path)

dir(file_path)

docs <- Corpus(DirSource(file_path))
summary(docs)

docs = tm_map(docs, content_transformer(tolower))









