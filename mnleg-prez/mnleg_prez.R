# A function to look up the share of the 2016 two-party presidential vote Hillary Clinton and Donald Trump received in a specified Minnesota legislative district.
# Takes two inputs: district (either a number or a string, depending on the chamber) and house (a boolean that defaults to T)
# If house = T, then district must be a string in the form "10A" or "10B" — a number between 1 and 67 with "A" or "B" appended at the end. Single-digit districts should be entered WITHOUT a leading zero.
# If house = F, then district must be a bare, unquoted number between 1 and 67.
# Output will be a string giving the share of the vote received in that district by Clinton and Trump in a sentence.
# Created by David H. Montgomery of the St. Paul Pioneer Press.

library(RCurl)
library(tidyverse)

mnleg_prez <- function(district, house = T) {
	if(house == T & is.numeric(district)) {stop("Senate District number given for House district. Check your number and specify if house = T.")}
	if(house == F & (!(district %in% seq(1, 67, by = 1)))) {stop("House District number given for Senate district. Check your number and specify if house = F. Senate districts must be unquoted numbers.")}
	if(house == F) {district <- c(paste0(district, "A"), paste0(district, "B"))}
	prezvotes <- read.table(
		"http://electionresults.sos.state.mn.us/Results/MediaResult/100?mediafileid=52",
		sep = ";",
		colClasses=c(
			"factor",
			"integer",
			rep("factor",3),
			"integer",
			rep("factor",5),
			rep("numeric",5)
		))
	
	prezvotes <- prezvotes[,c(1:8,11:16)]
	colnames(prezvotes) <- c("State","CountyID","PrecinctNumber","OfficeID","OfficeName ","District","CandidateID","CandidateName","Party","PrecinctsReporting","TotalPrecincts","CandidateVotes","Percentage","TotalVotes")
	
	fips <- read.csv("https://raw.githubusercontent.com/pioneerpress/code/master/lookups/mncountypop.csv") %>% select(CountyID = 1, FIPS = 3)
	prezvotes <- left_join(prezvotes, fips, by = "CountyID")
	prezvotes$VTD <- paste0(prezvotes$FIPS,prezvotes$PrecinctNumber)
	
	prezvoteswide <- prezvotes %>% select(-c(1:5,7:8,13)) %>% spread(Party, CandidateVotes)
	
	precincts <- read.table(
		"http://electionresults.sos.state.mn.us/Results/MediaSupportResult/100?mediafileid=4",
		sep=";",
		quote = "\"",
		colClasses=c(
			"integer",
			rep("factor",8)
		)) %>% select(-10)
	
	colnames(precincts) <- c("CountyID", "PrecinctID", "PrecinctName", "CD", "LD", "CountyComm", "Judicial", "Soil", "FIPS")
	keydist <- precincts %>% select(-FIPS) %>% left_join(fips, by = "CountyID") %>% mutate(VTD = paste0(FIPS, PrecinctID)) %>% filter(LD %in% district)
	
	keydist <- keydist %>% left_join(prezvoteswide, by = "VTD")
	
	
	dfl <- sum(keydist$DFL)
	gop <- sum(keydist$R)
	total <- sum(dfl, gop)
	
	fulldist <- if(house == T) {paste0("House District ", district)} else {paste0("Senate District ", substr(district[1], 1, 2))}
	paste0(
		"Hillary Clinton got ",
		round((dfl/total)*100, 2),
		"% of the two-party vote in Minnesota ",
		fulldist,
		" and Donald Trump got ",
		round((gop/total)*100, 2),
		"%."
	)
}
