textfile <- "pg100.txt"
if (!file.exists(textfile)) {
        download.file("http://www.gutenberg.org/cache/epub/100/pg100.txt", destfile = textfile)
}

shakespeare <- readLines(textfile)
length(shakespeare)
head(shakespeare)

shakespeare = shakespeare[-(1:173)]
shakespeare = shakespeare[-(124195:length(shakespeare))]
shakespeare = paste(shakespeare, collapse = " ")
nchar(shakespeare)


shakespeare = strsplit(shakespeare, "<<[^>]*>>")[[1]]
length(shakespeare)

(dramatis.personae <- grep("Dramatis Personae", shakespeare, ignore.case = TRUE))
shakespeare = shakespeare[-dramatis.personae]
length(shakespeare)

library(tm)
doc.vec <- VectorSource(shakespeare)
doc.corpus <- Corpus(doc.vec)
summary(doc.corpus)


doc.corpus <- tm_map(doc.corpus, tolower)
doc.corpus <- tm_map(doc.corpus, removePunctuation)
doc.corpus <- tm_map(doc.corpus, removeNumbers)
doc.corpus <- tm_map(doc.corpus, removeWords, stopwords("english"))

library(SnowballC)

doc.corpus <- tm_map(doc.corpus, stemDocument)
doc.corpus <- tm_map(doc.corpus, stripWhitespace)

TDM <- TermDocumentMatrix(doc.corpus)
TDM

inspect(TDM[1:10,1:10])

DTM <- DocumentTermMatrix(doc.corpus)
inspect(DTM[1:10,1:10])

findFreqTerms(TDM, 1000)
findFreqTerms(TDM, 2000, 2050)

findAssocs(TDM, "love", 0.8)
