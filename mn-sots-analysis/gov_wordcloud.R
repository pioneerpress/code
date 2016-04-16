## Creates wordclouds showing the most common words used in each governor's State of the State speeches since State o the State speeches began in 1969. One wordcloud will be created per governor, showing the word use pattern for all his speeches.

## This code assumes your starting working directory is one folder up from the governors-texts folder, because that upper directory is the one that contains the .R files in this Github.
wd <- getwd()
setwd(paste0(wd,"/governors-texts/"))
library(tm)
library(SnowballC)
library(RColorBrewer)
library(wordcloud)

## Take the text file containing each governor's State of the State speeches, reduce it to just significant words, and for each governor output a wordcloud of their combined State of the State addresses.
govs <- c("anderson", "carlson", "dayton", "levander", "pawlenty", "perpich", "quie", "ventura")

sots_analysis <- function(governor){
docs <- Corpus(DirSource(getwd(),pattern=paste0(governor,".txt"))) 
## Preprocessing 
docs <- tm_map(docs, removePunctuation) # *Removing punctuation:* 
docs <- tm_map(docs, removeNumbers) # *Removing numbers:* 
docs <- tm_map(docs, tolower) # *Converting to lowercase:* 
docs <- tm_map(docs, removeWords, stopwords("english")) # *Removing "stopwords" 
docs <- tm_map(docs, stripWhitespace) # *Stripping whitespace 
docs <- tm_map(docs, PlainTextDocument)
dtm <- DocumentTermMatrix(docs) 
dtms <- removeSparseTerms(dtm, 0.5) # Prepare the data (max 15% empty space) 
freq <- colSums(as.matrix(dtm)) # Find word frequencies 
dark2 <- brewer.pal(6, "Dark2")
png(paste0(governor,".png"))
wordcloud(names(freq), freq, max.words=100, rot.per=0.2, colors=dark2) 
dev.off()

}

for (i in 1:8){sots_analysis(govs[i])} ## Call the function for each of the governors

setwd("..") ## Resets the working director to the parent directory, so gov_count_words.R can be run without resetting the working directory.