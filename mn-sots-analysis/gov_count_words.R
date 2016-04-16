## Creates CSV files with the frequency of each significant word used in the State of the State speeches of each Minnesota governor since State of the State speeches began in 1969. One CSV file will be created per governor, showing the combined frequency of all his speeches.

## This code assumes your starting working directory is one folder up from the governors-texts folder, because that upper directory is the one that contains the .R files in this Github.
wd <- getwd()
setwd(paste0(wd,"/governors-texts/"))
library(tm)
library(SnowballC)

## Take the text file containing each governor's State of the State speeches, reduce it to just significant words, and for each governor output a CSV contained a count of how often each word appears in his combined State of the State addresses.
govs <- c("anderson", "carlson", "dayton", "levander", "pawlenty", "perpich", "quie", "ventura")

sots_analysis <- function(governor){
docs <- Corpus(DirSource(getwd(),pattern=paste0(governor,".txt"))) 
## Preprocessing      
docs <- tm_map(docs, removePunctuation)   # *Removing punctuation:*    
docs <- tm_map(docs, removeNumbers)      # *Removing numbers:*    
docs <- tm_map(docs, tolower)   # *Converting to lowercase:*  
docs <- tm_map(docs, removeWords, stopwords("english"))   # *Removing "stopwords"  
docs <- tm_map(docs, stripWhitespace)   # *Stripping whitespace   
docs <- tm_map(docs, PlainTextDocument)
tdm <- TermDocumentMatrix(docs)
m <- as.matrix(tdm)   
dim(m)   
write.csv(m, file=paste0(governor,".csv"))}

for (i in 1:8){sots_analysis(govs[i])} ## Call the function for each of the governors

setwd("..")

## Resets the working director to the parent directory, so govwordcloud.R can be run without resetting the working directory.