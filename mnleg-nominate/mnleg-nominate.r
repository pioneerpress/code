# Script that will download roll call data for the Minnesota House of Representatives from openstates.org and calculate W-NOMINATE roll call ideology estimates for every lawmaker in the 2015-2016 Legislature.
# Inputs required: none
# Outputs produced: "nomscores.csv", a spreadsheet containing each lawmaker and their ideology estimate. This can be used in the companion scripts, "nominate-elex.r" and "nominate-rank.r, to produce graphs of the results.
# Note that these are ideology estimates only, and running sequential trials will likely produce slightly different results. This is fine. (If trials produce dramatically different results, something is likely wrong.
# This script can be customized for other years and states available on the OpenStates bulk data site (http://openstates.org/downloads/). HOWEVER, this will require care and trial & error. Different states code their data differently, and this script is designed for Minnesota's particular coding. Data may be missing from the legislator file for non-active legislators in other Minnesota years — this script includes manual coding to fill in information for three lawmakers who left the Minnesota House during the two-year session.
# Code by David H. Montgomery for the Pioneer Press, subject to the MIT License.

library(RCurl)
library(dplyr)
library(wnominate)

temp <- tempfile() # Open a temporary file to store the ZIP
download.file("http://static.openstates.org/downloads/2016-06-08-mn-csv.zip",temp) # Download the ZIP into the temporary file

# Extract bill_votes.csv from the ZIP, put it in a data frame, and subset it to just the list of votes in the current legislative session.
billvotes <- read.csv(unzip(temp, files = "mn_bill_votes.csv"), stringsAsFactors = FALSE) %>% subset(session == "2015-2016", select = "vote_id")

# Extract the list of votes by legislator, and filter it to just those votes we highlighted in the prior step.
votesin <- read.csv(unzip(temp, files = "mn_bill_legislator_votes.csv"), stringsAsFactors = FALSE) %>% semi_join(billvotes, by = "vote_id")

romney <- read.csv("romney.csv", stringsAsFactors = F) # Load Romney margin by district

# Load the legislator directory
info <- read.csv(unzip(temp, files = "mn_legislators.csv"), stringsAsFactors = FALSE)
# Code "Democratic-Farmer-Labor" to "DFL"
info$party <- gsub("Democratic-Farmer-Labor","DFL",info$party)
# Fill in some missing information for deceased or resigned lawmakers
info[143:145,10] <- "lower"
info[143,11] <- "46A"
info[144,11] <- "3A"
info[145,11] <- "50B"
info[143:145,12] <- "DFL"
info <- subset(info, chamber == "lower") %>% arrange(last_name, first_name) %>% inner_join(romney, by= "district") # Subset to just active members, then sort by last and first name. Important!





unlink(temp) # Unlink the ZIP


dir <- unique(votesin[,2:3]) %>% arrange(name)
v <- unique(votesin$vote_id)
n <- dir[,2]
id <- dir[,1]

# Go through votes and add in missing votes as "NA"
# This will take a while
for (i in 1:length(v)) {
	for (j in 1:length(n)) {
		if(!(n[j] %in% subset(votesin, vote_id == v[i])$name)) {
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
write.csv(mnlegnom$legislators[,c(11,12,24,17)],"nomscores.csv")