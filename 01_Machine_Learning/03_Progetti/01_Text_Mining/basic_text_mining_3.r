library(tm)
library(SnowballC)
library(wordcloud)
#
# vedi script basic_text_mining_0
#
# individuazione percorsi file dati
data_path = 'C:\\Users\\T004314\\Documents\\Working\\03_MyTools'
file_path_orig = file.path(data_path, 'pdf')
file_path_dest = file.path(data_path, 'txt')

data = Corpus(DirSource(file_path_dest), readerControl = list(language = 'it'))
#
# cleaning
#
data_clean <- tm_map(data,content_transformer(tolower))
data_clean <- tm_map(data_clean, removeNumbers)
data_clean <- tm_map(data_clean,removeWords, stopwords(kind='it'))
data_clean <- tm_map(data_clean,removeWords, stopwords(kind='en'))
data_clean <- tm_map(data_clean, removePunctuation)
#
# stemming
#
data_clean <- tm_map(data_clean, stemDocument, language='italian')
data_clean <- tm_map(data_clean, stripWhitespace)

dev.new(width = 1000, height = 1000, unit = "px")
wordcloud(data_clean, max.words =100,min.freq=3,scale=c(4,.5), 
          random.order = FALSE,vfont=c("sans serif","plain"),colors=palette())
#
# tokenizing
#
data_dtm        <- DocumentTermMatrix(data_clean)
data_freq_words <- findFreqTerms(data_dtm, 5)
data_dtm_freq   <- data_dtm[, data_freq_words]
