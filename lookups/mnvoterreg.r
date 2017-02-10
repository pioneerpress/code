library(RCurl)
library(dplyr)
library(rvest)

url <- "http://www.sos.state.mn.us/election-administration-campaigns/data-maps/voter-registration-counts/" # Set the URL
mnvoterreg <- url %>% read_html() %>% html_nodes(xpath='//*[@id="highlightSearchText"]/div/table') %>% html_table(fill = TRUE)
	mnvoterreg <- mnvoterreg[[1]]
	mnvoterreg <- mnvoterreg[-88,]
	colnames(mnvoterreg)[2] <- "voter.reg"
	mnvoterreg$voter.reg <- as.numeric(gsub(",","",mnvoterreg$voter.reg))

	#mnvoterreg <- read.csv("mnvoterreg.csv", stringsAsFactors = F)
	#mnvoterreg$County <- gsub(" County Totals:","",mnvoterreg$County)
	mnvoterreg$County <- gsub("St. ","Saint ",mnvoterreg$County)
	mnvoterreg$County <- gsub("qui ","Qui ",mnvoterreg$County)
	mnvoterreg$County <- gsub("Mcleod","McLeod",mnvoterreg$County)
	mnvoterreg$County <- gsub("Of The","of the",mnvoterreg$County)
