# An R script to load transcripts from the U.S. presidential debate on Monday, Sept. 26, 2016, and produce wordclouds of each word spoken by candidates Hillary Clinton and Donald Trump and moderator Lester Holt.
# Output will be three .PNG files, one for each candidate.
# Created by David H. Montgomery of the St. Paul Pioneer Press.

# Load necessary libraries
library(tm)
library(RColorBrewer)
library(wordcloud)
library(stringr)
library(Hmisc)

names <- c("clinton","trump","holt") # Establish the three candidates

# For each of the three candidates... 
for (i in 1:3) {
	# Load the transcripts
	assign(
		names[i],
		read.delim(
			file=paste0(names[i],".txt"),
			sep="\n", 
			stringsAsFactors = F, 
			header = FALSE))
	
	# Process the transcripts
	assign(
		names[i],
		unlist(
			lapply(get(names[i]), function(x) { str_split(x, "\n")})))
	assign(names[i], Corpus(VectorSource(get(names[i]))))
	assign(names[i], tm_map(get(names[i]), content_transformer(tolower))) ## Make everything lowercase
	assign(names[i], tm_map(get(names[i]), removeWords,stopwords("english"))) ## Remove common English words like "and" and "the".
	assign(names[i], tm_map(get(names[i]), removePunctuation)) ## Remove punctuation
	assign(names[i], tm_map(get(names[i]), stripWhitespace)) ## Strip out unnecessary whitespace.
	assign(paste0(names[i],".tdm"), TermDocumentMatrix(get(names[i]))) # Convert into the necessary format for a word cloud
	
	# Create the word cloud
	png(paste0(names[i],".png"), width=1000, height=1000, res=110) # Create the image file
	layout(matrix(c(1, 2), nrow=2), heights=c(.5, 4)) ## Lay out the image.
	par(mar=rep(0, 4)) # Set the margins
	plot.new() ## Specify a new plot, just in case.
	text(x=0.5, y=0.5, paste(capitalize(names[i]),"word frequency in 9/26/2016 presidential debate"), cex=2, font=2) ## Title.
	text(x=0.5, y=0.1, "Pioneer Press graphic by David H. Montgomery", cex=1) ## Subtitle/credit.
	wordcloud(get(names[i]), max.words = 250, random.order= FALSE, colors=brewer.pal(8,"Dark2"), rot.per=0) # Make the actual word cloud
	dev.off() # Print out the image.
}