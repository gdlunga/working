#Needed <- c("tm", "SnowballCC", "RColorBrewer", "ggplot2", "wordcloud", "biclust", "cluster", "igraph", "fpc")   
#install.packages(Needed, dependencies=TRUE)   
#install.packages("Rcampdf", repos = "http://datacube.wu.ac.at/", type = "source")    

# On a PC, save the folder to your C: drive and use the following code chunk:

cname <- file.path("C:/Users/T004314/Documents/GitHub", "working/R/appunti/text_mining/corpus/txt")   
cname   
dir(cname)  

# Load the R package for text mining and then load your texts into R

library(tm)   
docs <- Corpus(DirSource(cname))   

summary(docs)  

#inspect(docs[1])

docs <- tm_map(docs, removePunctuation)   

for(j in seq(docs))   
{   
  docs[[j]] <- gsub("/", " ", docs[[j]])   
  docs[[j]] <- gsub("@", " ", docs[[j]])   
  docs[[j]] <- gsub("\\|", " ", docs[[j]])   
}   

# removing numbers
docs <- tm_map(docs, removeNumbers)   
# converting to lowercase
docs <- tm_map(docs, tolower)   
# removing stop words
docs <- tm_map(docs, removeWords, stopwords("italian"))   
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
dtm <- DocumentTermMatrix(docs)   
dtm 

freq <- colSums(as.matrix(dtm))   
length(freq)   

ord <- order(freq)  

# If you prefer to export the matrix to Excel:   

m <- as.matrix(dtm)   
dim(m)   
write.csv(m, file="dtm.csv")   

#  Start by removing sparse terms:   
dtms <- removeSparseTerms(dtm, 0.1) # This makes a matrix that is 10% empty space, maximum.   
inspect(dtms)  

freq[head(ord)] 
freq[tail(ord)] 

freq <- colSums(as.matrix(dtms))   
freq   

wf <- data.frame(word=names(freq), freq=freq)   
head(wf)  

library(ggplot2)   
p <- ggplot(subset(wf, freq>50), aes(word, freq))    
p <- p + geom_bar(stat="identity")   
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))   
p   


findAssocs(dtm, c("alessandro" , "profumo"), corlimit=0.98)


library(wordcloud) 

dev.new()
set.seed(142)   
wordcloud(names(freq), freq, min.freq=25)   


set.seed(142)   
wordcloud(names(freq), freq, min.freq=20, scale=c(5, .1), colors=brewer.pal(6, "Dark2"))   

dtmss <- removeSparseTerms(dtm, 0.15) # This makes a matrix that is only 15% empty space, maximum.   
inspect(dtmss)   


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
