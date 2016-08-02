# A script to take a series of Excel files provided by the St. Anthony, Minnesota police department, with statistics on arrests, warnings and citations by race and gender and combine them into a single R data frame.
# A separate script in this folder, `st-anthony-viz.R`, will analyze differences on the subject of race and produce a graph showing racial disparities.
# The full dataset contains every arrest, citation and warning, by race and gender, for each year 2011-2016 (through July 3, 2016). There is a separate file for each arrest outcome (arrest, citation and warning) for each year.
# Written by David H. Montgomery for the Pioneer Press.
# Before beginning, you must set your working directory to the folder containing "stanthony.zip".

library(xlsx)
library(plyr)
library(utils)

if(!file.exists("data")) {
    unzip("stanthony.zip", exdir = "data") # Extract the ZIP into a Data folder.
}
setwd("data")

temp <- list.files(pattern = "*.xls") # Store a list of the file names.
titles <- list() # Create an empty list which we will shortly fill.

# The first line of each file contains a title. The second line contains the headers. The filenames themselves have no particular significance. Here's how we deal with that.
for (i in 1:length(temp)) {
	titles[i] <- read.xlsx(temp[i], sheetIndex= 1, rowIndex = c(1:1), header= FALSE)
} # Iterate through all the filenames contained in the `temp` object, and in each case read the first line into an empty list, `titles`. 
# This will produce the list `titles`, which contains the titles such as "2011 Arrest Demographics".
# Your Java install may need to be up to date for this to work.
	
titles <- as.character(unlist(titles)) # Convert the list into a character vector.
titles <- unlist(strsplit(titles, split = " Demographics"))[c(1:7,9,11:13,15:21)] # Simplify the titles to remove the word "Demographics" from each one. Also purge the parenthetical dates in the title lines for the 2016 spreadsheets.
# Output will be files with the name format "2012 Arrest", "2012 Citation", etc.

# Cycle through each of the filename and read the spreadsheet as a dataframe, starting with the second row. The outcome will be an R object for each file.
# This could will take a few minutes.
for (i in 1:length(temp)) {
	assign(titles[i],read.xlsx(temp[i], sheetIndex= 1, startRow = 2))
}


# Combine the three files for each year into a single data frame.
stats2011 <- rbind(`2011 Arrest`,`2011 Citation`,`2011 Warning`)
stats2012 <- rbind(`2012 Arrest`,`2012 Citation`,`2012 Warning`)
stats2013 <- rbind(`2013 Arrest`,`2013 Citation`,`2013 Warning`)
stats2014 <- rbind(`2014 Arrest`,`2014 Citation`,`2014 Warning`)
stats2015 <- rbind(`2015 Arrest`,`2015 Citation`,`2015 Warning`)
stats2016 <- rbind(`2016 Arrest`,`2016 Citation`,`2016 Warning`)

# Clean up the workspace by removing our old data frames.
rm(`2011 Arrest`,`2011 Citation`,`2011 Warning`,`2012 Arrest`,`2012 Citation`,`2012 Warning`,`2013 Arrest`,`2013 Citation`,`2013 Warning`,`2014 Arrest`,`2014 Citation`,`2014 Warning`,`2015 Arrest`,`2015 Citation`,`2015 Warning`,`2016 Arrest`,`2016 Citation`,`2016 Warning`)

# Combine them all into a single data frame.
allstats <- rbind(stats2011, stats2012, stats2013, stats2014, stats2015, stats2016)
# Could have just made a single rbind call to combine all the individual data frames, but this way you have the year data frames on hand if you want to look at just a particular year.
allstats$year <- as.numeric(format(allstats$Reported.Date, "%Y")) # Add a 'year' column.

# Deal with missing variables.
allstats$Race <- as.character(allstats$Race) #The data is coded as factors, so we have to convert it to character first.
allstats$Sex <- as.character(allstats$Sex)
allstats[is.na(allstats)] <- "Not available" #Replace every entry that's NA with "Not available"

# Move up one directory.
setwd("..")
# Write to a CSV file if it doesn't already exist.
if(!file.exists("st-anthony-stats.csv")) {
    write.csv(allstats,"st-anthony-stats.csv")
}

# Summarize the stats by race.
sums_race <- count(allstats, c("Race","Involvement.Type","year"))


# Create summary table showing the number of people to receive each action by year.
attach(sums_race)
sums <- aggregate(freq, list(year,Involvement.Type), FUN=sum)
colnames(sums) <- c("year","outcome","count")
detach(sums_race)

# Add a column showing for each race-outcome-year combination, what percentage that is of that outcome in that year for all races.
for (i in 1:nrow(sums_race)) {
	sums_race$share_of_action[i] <- sums_race[i,4] / subset(sums, year == sums_race[i,3] & outcome == sums_race[i,2])[,3]
}

# Create summary table showing the number of people of each race by year.
attach(sums_race)
sums_year <- aggregate(freq, list(year,Race), FUN=sum)
colnames(sums_year) <- c("year", "Race", "count")
detach(sums_race)

# Add a column showing for each race-outcome-year combination, what percentage that is of all outcomes in that year for that race. 
for (i in 1:nrow(sums_race)) {
	sums_race$disposition_by_race[i] <- sums_race[i,4] / subset(sums_year, year == sums_race[i,3] & Race == sums_race[i,1])[,3]
}

# Write to a CSV file if it doesn't already exist.
if(!file.exists("summary-stats.csv")) {
    write.csv(sums_race, "summary-stats.csv")
}

# Write to a CSV file if it doesn't already exist.
if(!file.exists("summary-stats-readable.csv")) {
    write.csv(spread(sums_race[,1:4],year,freq), "summary-stats-readable.csv")
}
