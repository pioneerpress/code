# Scrapes turnout data for the Aug. 9, 2016 Minnesota primary election from the Minnesota Secretary of State's FTP file, processes that data and saves it.
# Requires countycode-fips converter.csv to be in the working directory. These should have been provided if you downloaded this entire folder.
# Also requires a username and password to access the Secretary of State's FTP server. This is not provided. It should be placed in a file called "sospw.txt" in the working directory; that file should be a single line with the format "username:password" with no quotes.
# Note that this will calculate turnout percentage as a share of registered voters. The Secretary of State's formal turnout percentages are based on total eligible voters in the state, but there's no available figure on the congressional district level.
# Will output three csv files: "mnturnout.csv", "cdturnout.csv" and "hdturnout.csv"
# Code by David H. Montgomery for the Pioneer Press.

library(RCurl)
library(tidyr)
library(plyr)
library(dplyr)

# Load the password from the file. You need a working password for this to work.
pw <- scan("sospw.txt", what = character(), quiet = TRUE)

# Read the precinct results file in from the FTP server.
turnout <- read.table(
	textConnection(
		getURL("ftp://ftp.sos.state.mn.us/20160809/pctstats.txt",userpwd = pw)),
	sep=";", 
	quote = "\"", # Don't count apostrophes as strings, otherwise things like "Mary's Point" will break the data.
	colClasses=c("factor","numeric","factor","factor",rep("numeric",8)) #Set classes for each column. Important to make precinct IDs show up as strings, so you get "0005" instead of "5".
	)

colnames(turnout) <- c("State","CountyID","PrecinctID","PrecinctName ","HasReported","amReg","SameDayReg","Num.sigs","AbsenteeBallots","FederalAbsentees","PresAbsentees","TotalVoted") # Assign column names

turnout <- turnout[,-c(10:11)] # Drop some unneeded columns.

# Load a table that converts between the Secretary of State's county codes and formal FIPS codes.
fips <- read.csv("../countycode-fips converter.csv")
fips <- fips[,-3] # Drop an unnecessary column
colnames(fips) <- c("CountyID","County","FIPS") # Label columns
turnout <- merge(fips,turnout, by = "CountyID") # Merge with the voting data by County IDs
turnout$VTD <- paste0(turnout$FIPS,turnout$PrecinctID) # Combine the FIPs code and the Precinct IDs to create a nine-digit VTD code.

turnout$turnout.pct <- as.numeric(turnout$TotalVoted/(turnout[,7]+turnout[,8])) # Calculate percentage of voters divided by total registered, including those registered before Election Day and on it.
turnout$absentee.rate <- as.numeric(turnout$AbsenteeBallots/turnout$TotalVoted) # Calculate the percentage of voters who voted absentee.

# Load in a second table with details about each precinct, which we'll merge with our turnout results for a more readable and informative table. Same format as above.
precincts <- read.table(
	textConnection(
		getURL("ftp://ftp.sos.state.mn.us/20160809/PrctTbl.txt",userpwd = pw)),
	sep=";",
	quote = "\"",
	colClasses=c("numeric",rep("factor",2),"numeric",rep("factor",6))
	)

precincts <- precincts[,-c(6:10)] # Drop some unneeded columns
colnames(precincts) <- c("CountyID","PrecinctID","PrecinctName","CongressionalDistrict","LegislativeDistrict")
precincts <- merge(fips,precincts, by = "CountyID") # Label columns
precincts$VTD <- paste0(precincts$FIPS,precincts$PrecinctID) # Concatenate nine-digit VTD votes for the precinct data.
turnout <- merge(precincts,turnout[,c(7:15)], by = "VTD") # Merge the turnout data with the precinct data by VTDs.

write.csv(turnout,"mnturnout.csv", row.names=FALSE) # Save this turnout data to disk.

# Create a table showing turnout results by congressional district.
cdturnout <- turnout %>% group_by(CongressionalDistrict) %>% summarise(
    votes = sum(TotalVoted), # Add a column for total votes.
    RV = sum(amReg) + sum(SameDayReg), # Add a column for registered voters combining Election Day and pre-election registrations
    Reporting = sum(HasReported)) # Add a column for the number of precincts reporting.
cdturnout$pct <- cdturnout$votes / cdturnout$RV # Calculate turnout percentage as a share of registered voters

# Repeat the same calculation but for state house district.
hdturnout <- turnout %>% group_by(LegislativeDistrict) %>% summarise(
    votes = sum(TotalVoted), 
    RV = sum(amReg) + sum(SameDayReg))
hdturnout$pct <- hdturnout$votes / hdturnout$RV

# Write the congressional district and legislative district into spreadsheets
write.csv(cdturnout,"cdturnout.csv", row.names=FALSE)
write.csv(hdturnout,"hdturnout.csv", row.names=FALSE)

# Return some summary stats on the command line.
print(paste0("Precincts reporting: ",sum(turnout[,9]),"/",nrow(turnout)," (",round(sum(turnout[,9])/nrow(turnout),4),")"))
print(paste0("Total votes: ",sum(turnout$TotalVoted)))
print(paste0("Total registered: ",sum(turnout$amReg) + sum(turnout$SameDayReg)))
print(paste0("Percent of RVs voting: ",round(sum(turnout$TotalVoted)/(sum(turnout$amReg)+sum(turnout$SameDayReg)),4)))
print(paste0("Percent of eligibles voting: ",round(sum(turnout$TotalVoted)/3967061,4)))
