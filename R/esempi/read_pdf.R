#install.packages("tm") # only need to do once
library(tm)


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
