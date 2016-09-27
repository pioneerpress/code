require(tm)
require(RColorBrewer)
require(wordcloud)
require(stringr)

clinton <- read.delim(file="Clinton.txt", sep="\n", stringsAsFactors = F)
trump <- read.delim(file="Trump.txt", sep="\n", stringsAsFactors = F)
holt <- read.delim(file="Holt.txt", sep="\n", stringsAsFactors = F)

clinton <- unlist(lapply(clinton, function(x) { str_split(x, "\n")}))
trump <- unlist(lapply(trump, function(x) { str_split(x, "\n")}))
holt <- unlist(lapply(holt, function(x) { str_split(x, "\n")})) 

clinton <- Corpus(VectorSource(clinton))
trump <- Corpus(VectorSource(trump))
holt <- Corpus(VectorSource(holt))


clinton <- tm_map(clinton, content_transformer(tolower)) ## Make everything lowercase
clinton <- tm_map(clinton, removeWords,stopwords("english")) ## Remove common English words like "and" and "the".
clinton <- tm_map(clinton, removePunctuation) ## Remove punctuation
clinton <- tm_map(clinton, stripWhitespace) ## Strip out unnecessary whitespace.


trump <- tm_map(trump, content_transformer(tolower)) ## Make everything lowercase
trump <- tm_map(trump, removeWords,stopwords("english")) ## Remove common English words like "and" and "the".
trump <- tm_map(trump, removePunctuation) ## Remove punctuation
trump <- tm_map(trump, stripWhitespace) ## Strip out unnecessary whitespace.


holt <- tm_map(holt, content_transformer(tolower)) ## Make everything lowercase
holt <- tm_map(holt, removeWords,stopwords("english")) ## Remove common English words like "and" and "the".
holt <- tm_map(holt, removePunctuation) ## Remove punctuation
holt <- tm_map(holt, stripWhitespace) ## Strip out unnecessary whitespace.

clinton.tdm <- TermDocumentMatrix(clinton)
trump.tdm <- TermDocumentMatrix(trump)
holt.tdm <- TermDocumentMatrix(holt)

png("clinton.png", width=1000, height=1000, res=110) ## Create the image file.
layout(matrix(c(1, 2), nrow=2), heights=c(.5, 4)) ## Lay out the image.
par(mar=rep(0, 4))
plot.new() ## Specify a new plot, just in case.
text(x=0.5, y=0.5, "Clinton word frequency in 9/26/2016 presidential debate", cex=2, font=2) ## Title.
text(x=0.5, y=0.1, "Pioneer Press graphic by David H. Montgomery", cex=1) ## Subtitle/credit.
wordcloud(clinton, max.words = 250, random.order= FALSE, colors=brewer.pal(8,"Dark2"), rot.per=0)
dev.off()

png("trump.png", width=1000, height=1000, res=110) ## Create the image file.
layout(matrix(c(1, 2), nrow=2), heights=c(.5, 4)) ## Lay out the image.
par(mar=rep(0, 4))
plot.new() ## Specify a new plot, just in case.
text(x=0.5, y=0.5, "Trump word frequency in 9/26/2016 presidential debate", cex=2, font=2) ## Title.
text(x=0.5, y=0.1, "Pioneer Press graphic by David H. Montgomery", cex=1) ## Subtitle/credit.
wordcloud(trump, max.words = 250, random.order= FALSE, colors=brewer.pal(8,"Dark2"), rot.per=0)
dev.off()


png("holt.png", width=1000, height=1000, res=110) ## Create the image file.
layout(matrix(c(1, 2), nrow=2), heights=c(.5, 4)) ## Lay out the image.
par(mar=rep(0, 4))
plot.new() ## Specify a new plot, just in case.
text(x=0.5, y=0.5, "Holt word frequency in 9/26/2016 presidential debate", cex=2, font=2) ## Title.
text(x=0.5, y=0.1, "Pioneer Press graphic by David H. Montgomery", cex=1) ## Subtitle/credit.
wordcloud(holt, max.words = 250, random.order= FALSE, colors=brewer.pal(8,"Dark2"), rot.per=0)
dev.off()