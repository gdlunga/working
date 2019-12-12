library(tm)
library(SnowballC)
library(wordcloud)
library(stringr)
library(e1071)
library(gmodels)

convert_counts <- function(x) {
  x <- ifelse(x > 0, "Yes", "No")
}

# Definition of Working Folder

Dirname <- "/working/01_Machine_Learning/01_Appunti"
Dirs <- list.dirs(path=file.path("~"),recursive=T)
dir_wd <- names(unlist(sapply(Dirs,grep,pattern=Dirname))[1])
dir_wd <- paste(dir_wd,'Dati',sep='/')
setwd(dir_wd)
cat("Current working folder is ' : ", getwd())

sms_raw <- read.csv("sms_spam.csv", stringsAsFactors = FALSE)
sms_raw$type <- factor(sms_raw$type)
table(sms_raw$type)

sms_corpus <- VCorpus(VectorSource(sms_raw$text))
sms_corpus_clean <- tm_map(sms_corpus,content_transformer(tolower))
as.character(sms_corpus[[3]])
as.character(sms_corpus_clean[[3]])

sms_corpus_clean <- tm_map(sms_corpus_clean, removeNumbers)
sms_corpus_clean <- tm_map(sms_corpus_clean,removeWords, stopwords())
sms_corpus_clean <- tm_map(sms_corpus_clean, removePunctuation)
sms_corpus_clean <- tm_map(sms_corpus_clean, stemDocument)
sms_corpus_clean <- tm_map(sms_corpus_clean, stripWhitespace)

wordcloud(sms_corpus_clean, min.freq = 50, random.order = FALSE)

sms_dtm <- DocumentTermMatrix(sms_corpus_clean)
sms_dtm

sms_dtm_train <- sms_dtm[1:4169, ]
sms_dtm_test  <- sms_dtm[4170:5559, ]

sms_train_labels <- sms_raw[1:4169, ]$type
sms_test_labels  <- sms_raw[4170:5559, ]$type

prop.table(table(sms_train_labels))
prop.table(table(sms_test_labels))

spam <- subset(sms_raw, type == "spam")
ham <- subset(sms_raw, type == "ham")

usableTextSpam <- str_replace_all(spam$text,"[^[:graph:]]", " ") 
usableTextHam  <- str_replace_all(ham$text,"[^[:graph:]]", " ") 

wordcloud(usableTextSpam, max.words = 50, scale = c(3, 0.5), random.color=TRUE, random.order = FALSE)
wordcloud(usableTextHam,  max.words = 50, scale = c(2, 0.5), random.color=TRUE, random.order = FALSE)

sms_freq_words <- findFreqTerms(sms_dtm_train, 5)
sms_dtm_freq_train <- sms_dtm_train[ , sms_freq_words]
sms_dtm_freq_test  <- sms_dtm_test [ , sms_freq_words]

sms_train <- apply(sms_dtm_freq_train, MARGIN = 2, convert_counts)
sms_test  <- apply(sms_dtm_freq_test,  MARGIN = 2, convert_counts)

sms_classifier <- naiveBayes(sms_train, sms_train_labels)
sms_test_pred <- predict(sms_classifier, sms_test)

sms_classifier2 <- naiveBayes(sms_train, sms_train_labels,
                              laplace = 1)
sms_test_pred2 <- predict(sms_classifier2, sms_test)
CrossTable(sms_test_pred2, sms_test_labels,
           prop.chisq = FALSE, prop.t = FALSE, prop.r = FALSE,
           dnn = c('predicted', 'actual'))
