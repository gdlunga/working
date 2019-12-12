#Needed <- c("tm", "SnowballCC", "RColorBrewer", "ggplot2", "wordcloud", "biclust", "cluster", "igraph", "fpc")   
#install.packages(Needed, dependencies=TRUE)   

library(tm)
library(SnowballC)
library(RColorBrewer)
library(ggplot2)
library(wordcloud)
library(biclust)
library(cluster)
library(igraph)
library(fpc)

#setwd('C:\\Users\\T004314\\Documents\\GitHub\\working\\01_R\\appunti\\2. text_mining')

# individuazione percorsi file dati
data_path = 'C:\\Users\\T004314\\Documents\\Working\\03_MyTools'

cname <- file.path(data_path, "txt")   
cname   
dir(cname)  

# Load the R package for text mining and then load your texts into R

library(tm)   
docs <- VCorpus(DirSource(cname))   

summary(docs)  

#write(docs[[1]]$content, file='prova.txt')

text1 <- docs[[1]]$content
#text2 <- docs[[2]]$content
#text3 <- docs[[3]]$content

#inspect(docs[1])

# removing numbers
docs <- tm_map(docs, removeNumbers)   
# converting to lowercase
docs <- tm_map(docs, tolower)   
# removing stop words
docs <- tm_map(docs, removeWords, stopwords("it"))   
docs <- tm_map(docs, removePunctuation)   

for(j in seq(docs))   
{   
  docs[[j]] <- gsub("/", " ", docs[[j]])   
  docs[[j]] <- gsub("@", " ", docs[[j]])   
  docs[[j]] <- gsub("\\|", " ", docs[[j]])   
}   

# removing particular words
# docs <- tm_map(docs, removeWords, c("department", "email"))   
# combing words that should stay together
#for (j in seq(docs))
#{
#  docs[[j]] <- gsub("qualitative research", "QDA", docs[[j]])
#  docs[[j]] <- gsub("qualitative studies", "QDA", docs[[j]])
#  docs[[j]] <- gsub("qualitative analysis", "QDA", docs[[j]])
#  docs[[j]] <- gsub("research methods", "research_methods", docs[[j]])
#}

# Stripping unnecesary whitespace from your documents
docs <- tm_map(docs, stripWhitespace)  

docs <- tm_map(docs, PlainTextDocument)   
dtm  <- DocumentTermMatrix(docs)   
dtm 

# If you prefer to export the matrix to Excel:   
m <- as.matrix(dtm)   
dim(m)   
write.csv(m, file="dtm.csv")   

tdm  <- TermDocumentMatrix(docs)
t <- as.matrix(tdm)
write.csv(t, file="tdm.csv")   


#  Start by removing sparse terms:   
dtms <- removeSparseTerms(dtm, 0.1) # This makes a matrix that is 10% empty space, maximum.   
#inspect(dtms)  

tdms <- removeSparseTerms(tdm, 0.1) # This makes a matrix that is 10% empty space, maximum.   
#inspect(tdms)  

t <- as.matrix(tdms)
write.csv(t, file="tdm.csv")   


freq <- colSums(as.matrix(dtm))   
length(freq)   
ord <- order(freq, decreasing=TRUE)  
freq[head(ord)] 
freq[tail(ord)] 

findFreqTerms(dtm,lowfreq = 80)

findAssocs(dtm,'operazione',.99)


freq <- colSums(as.matrix(dtms))   
freq   

wf <- data.frame(word=names(freq), freq=freq)   
head(wf)  

library(ggplot2)   
p <- ggplot(subset(wf, freq>80), aes(word, freq))    
p <- p + geom_bar(stat="identity")   
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))   
p   

dev.new()
plot(dtm,corThreshold = .9)

terms=names(findAssocs(dtm, 'unanimit?', corlimit=0.99)[['unanimit?']])

plot(dtm,terms=names(findAssocs(dtm, 'unanimit?', corlimit=0.99)[['unanimit?']]),corThreshold = .99)

dev.new()
plot(dtm, terms=c('unanimit?','votare','cfo','collegio','finanziamenti','dringoli'), corThreshold = .9)

library(wordcloud) 


#dev.new()
set.seed(142)   
wordcloud(names(freq), freq, min.freq=25)   


set.seed(142)   
wordcloud(names(freq), freq, min.freq=20, scale=c(5, .1), colors=brewer.pal(6, "Dark2"))   

dtmss <- removeSparseTerms(dtm, 0.01) # This makes a matrix that is only 15% empty space, maximum.   
#inspect(dtmss)   


library(cluster)   
d <- dist(t(dtmss), method="euclidian")   
fit <- hclust(d=d, method="ward")   
fit   

dev.new()
plot(fit, hang=-1)

groups <- cutree(fit, k=5)   # "k=" defines the number of clusters you are using   
rect.hclust(fit, k=5, border="red") # draw dendogram with red borders around the 5 clusters   

library(fpc)   
d <- dist(t(dtmss), method="euclidian")   
kfit <- kmeans(d, 2)   
clusplot(as.matrix(d), kfit$cluster, color=T, shade=T, labels=2, lines=0)   


