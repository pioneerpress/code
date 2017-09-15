# Script that will download roll call data for the Minnesota House of Representatives from openstates.org and calculate W-NOMINATE roll call ideology estimates for every lawmaker in the 2017 Minnesota House of Represdentatives.
# Inputs required: none
# Outputs produced: "nomscores.csv", a spreadsheet containing each lawmaker and their ideology estimate. This can be used in the companion scripts, "nominate-elex.r" and "nominate-rank.r, to produce graphs of the results.
# Note that these are ideology estimates only, and running sequential trials will likely produce slightly different results. This is fine. (If trials produce dramatically different results, something is likely wrong.)
# This script can be customized for other years and states available on the OpenStates bulk data site (http://openstates.org/downloads/). HOWEVER, this will require care and trial & error. Different states code their data differently, and this script is designed for Minnesota's particular coding. Data may be missing from the legislator file for non-active legislators in other Minnesota years — this script includes manual coding to fill in information for three lawmakers who left the Minnesota House during the two-year session.
# Code by David H. Montgomery for the Pioneer Press, subject to the MIT License.
# Uses WNOMINATE package by Poole, Keith, Jeffrey Lewis, James Lo, and Royce Carroll. 2011, from "Scaling Roll Call Votes with wnominate in R", http://www.jstatsoft.org/v42/i14/paper.

library(RCurl)
library(wnominate)
library(tidyverse)

temp <- tempfile(fileext = ".zip") # Open a temporary file to store the ZIP
download.file("http://s.openstates.org/downloads/2017-06-02-mn-csv.zip",temp) # Download the ZIP into the temporary file

# Extract bill_votes.csv from the ZIP, put it in a data frame, and subset it to just the list of votes in the current legislative session.
billvotes <- read_csv(unzip(temp, files = "mn_bill_votes.csv")) %>% filter(session == "2017-2018") %>% dplyr::select(vote_id)

# Extract the list of votes by legislator, and filter it to just those votes we highlighted in the prior step.
votesin <- read_csv(unzip(temp, files = "mn_bill_legislator_votes.csv")) %>% semi_join(billvotes, by = "vote_id")

trump <- read.table("http://electionresults.sos.state.mn.us/Results/MediaResult/100?mediafileid=54", sep = ";") %>% filter(V7 %in% c(301,401)) %>% dplyr::select(V6, V11, V14) %>% spread(V11, V14, 2:3) %>% mutate(Dpct = DFL/(DFL+R), Rpct = R/(DFL+R)) %>% dplyr::select(district = V6, R.margin = Rpct)
trump$district <- gsub("^0+([1-9])","\\1",trump$district)

for(i in 1:nrow(votesin)) {
	if(is.na(votesin$leg_id[i])) {
		if(votesin$name[i] == "Maye Quade") {votesin$leg_id[i] <- "MNL000736"}
		if(votesin$name[i] == "Considine") {votesin$leg_id[i] <- "MNL000589"}
	}
}


# Load the legislator directory
info <- read.csv(unzip(temp, files = "mn_legislators.csv"), stringsAsFactors = FALSE)
# Code "Democratic-Farmer-Labor" to "DFL"
info$party <- gsub("Democratic-Farmer-Labor","DFL",info$party)
info <- filter(info, chamber == "lower", leg_id != "MNL000782") %>% # Fix Rep. Considine's double ID
	inner_join(trump, by= "district") # Subset to just active members, then sort by last and first name. Important!
info$last_name <- str_replace_all(info$last_name, "Quade", "Maye Quade") # Fix Rep. Maye Quade's last name
info <- arrange(info, last_name, first_name)



unlink(temp) # Unlink the ZIP



dir <- unique(votesin[,2:3]) %>% arrange(name)
v <- unique(votesin$vote_id)
n <- dir$name
id <- dir[,1]

# Go through votes and add in missing votes as "NA"
# This will take a while
for (i in 1:length(v)) {
	for (j in 1:nrow(n)) {
		if(!(n[j,1] %in% subset(votesin, vote_id == v[i])$name)) {
			votesin <- rbind(votesin,data.frame(
				"vote_id"=v[i],
				"leg_id"=dir[j,1],
				"name"=dir[j,2],
				"vote"=NA)
			)
		}
	}
}

votesin <- arrange(votesin, vote_id, name) # Sort. Important!

# Produce matrix from roll calls.
votesout <- matrix(
	votesin$vote,
	nrow = length(unique(votesin$name)),
	ncol = length(unique(votesin$vote_id)),
	dimnames = list(c(unique(votesin$name)),unique(votesin$vote_id))
)

# Create a 'rollcall' object, combining with a legislator directory..
mnlegvotes <- rollcall(
	votesout, # The matrix to base the rollcall on.
	yea = "yes", # How yeas are coded
	nay = "no", # How nays are coded
	missing = NA, # How missing votes are coded
	legis.names = n, # List of legislative names
	vote.names = v, # List of vote names
	legis.data = info # Legislative directory
)

# 1-dimensional ranking
mnlegnom <- wnominate(mnlegvotes, dims = 1, polarity = "Drazkowski")

# Save as CSV
nomscores <- mnlegnom$legislators %>% rownames_to_column(var = "legname") %>% dplyr::select(legname, district, party, coord1D, R.margin)
write.csv(mnlegnom$legislators[,c(11,12,23,16)],"nomscores.csv", row.names = F)