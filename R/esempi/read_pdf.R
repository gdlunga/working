#
# Update R section ... just in case ... 
#
# installing/loading the package:
#if(!require(installr)) {
#  install.packages("installr"); require(installr)} #load / install+load installr

# using the package:
#updateR() # this will start the updating process of your R installation.  It will check for newer versions, and if one is available, will guide you through the decisions you'd need to make.


#install.packages("tm") # only need to do once
#install.packages("qdap")
#install.packages("qdapDictionaries")
#install.packages("dplyr")
#install.packages("RColorBrewer")
#install.packages("ggplot2")
#install.packages("scales")
#source("https://bioconductor.org/biocLite.R")
#biocLite("Rgraphviz")

library(tm)
library(qdap)
library(qdapDictionaries)
library(dplyr)
library(RColorBrewer)
library(ggplot2)
library(scales)
library(Rgraphviz)

file_path      = 'C:/Users/T004314/Documents/Data'
setwd(file_path)


files          = list.files(path = file_path, pattern = "pdf$")

Rpdf <- readPDF(control = list(text = "-layout"))

opinions <- Corpus(URISource(files), readerControl = list(reader = Rpdf))

opinions.tdm <- TermDocumentMatrix(opinions, control = list(removePunctuation = TRUE,
                                                            stopwords = TRUE,
                                                            tolower = TRUE,
                                                            stemming = TRUE,
                                                            removeNumbers = TRUE,
                                                            bounds = list(global = c(3, Inf)))) 
 

inspect(opinions.tdm[1:10,]) 
findFreqTerms(opinions.tdm, lowfreq = 100, highfreq = Inf)



setwd(script.dir <- dirname(sys.frame(1)$ofile))

cname <- paste(getwd(),'corpus','pdf',sep='/')
files = list.files(path = cname, pattern = "pdf$")
files
