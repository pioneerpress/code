# Given a campaign finance report ID number from the FEC's website, will download that data, analyze it, and save it as CSVs.
# Consists of two functions: fecgrabber() and fecanalyzer().
# fecgrabber() takes as input a title and an ID.
# It will download the specified report, and clean it up.
# The title should be descriptive and precise, such as "LewisQ1". It should not include any characters such as spaces, dashes or periods that could confuse either R or your file system.
# The ID number can be obtained from the Filings page on a candidate's FEC page, under the View/Download column. It is the numeric part of a string such as "FEC-1061533" — so, in this case, the ID would be 1061533.
# Sample function call: fecgrabber("LewisQ1",1061533)
# It will create a folder in your working directory with a name equal to the title you called the function with, and in it create two CSVs: full data for receipts (1) and expenses (2).
# It then calls fecanalyzer() using the output.
# fecanalyzer() takes as input a title, a table with receipts data and a table with expenditures data. 
# Will be run automatically as part of fecgrabber(). Can also be called manually, in which case the receipts and expenditures data should be specified by reference to data frames in R. It does not include any read.csv() calls to load from the disk; this will have to be done manually.
# fecanalyzer() will output in the console quick overall fundraising summary numbers, but these are incidental to this script. The script is designed to do more in-depth analysis; for basic summary data see the FEC's summaries.
# It will also create a folder in your working directory with a name equal to the title you called the function with, if this doesn't already exist, and in it create six CSVs: Fundraising summarized by (1) states, (2) cities, (3) occupation and (4) employer, and expenses summarized by (5) purpose and (6) recipient.
# FEC reports often contain lots of unclean artifacts — typos, unusual methods of recording data, etc. This won't catch that stuff, so always check your outputs. If you catch issues, you can fix them manually and then call fecanalyzer() to re-run the analysis on the clean data.
# This code drops all contributions from "Actblue", a conduit PAC that often shows up as double entries in FEC reports. If your data should not exclude Actblue, comment out line 47.
# Code by David H. Montgomery for the Pioneer Press.

library(RCurl)
library(dplyr)

fecgrabber <- function(title,id) {
    tmp <- read.table( # Load the FEC file from the web
        textConnection(
            getURL(
                paste0("http://docquery.fec.gov/dcdev/posted/",id,".fec")
            )
        ),
        sep = "\034",
        quote = "\"",
        skip = 2, # Skip the useless header lines
        fill = TRUE, # Fill in blank cells to avoid tons of errors
        stringsAsFactors= FALSE,
        colClasses = c(rep("character",20),"numeric","numeric",rep("character",3))
    )
    tmp$V20 <- as.Date(tmp$V20,"%Y%m%d") # Convert dates from character to date format
    receipts <- subset(tmp, grepl("SA", V1)) # Extract receipt data to a new data frame
    expenses <- subset(tmp, grepl("SB", V1)) # Extract expenses data to a new data frame
    
    # Process Receipts table
    
    receipts <- receipts[,c(1,6:9,13:18,20:25)] # Drop unneeded receipts columns
    colnames(receipts) <- c("Code","Type","Name","Lastname","Firstname","Address","PO Box","City","State","ZIP","Elex","Date","Contrib","To Date","Memo","Employer","Job") # Label receipts columns
    receipts <- receipts[receipts$Code != "SA13A",] # Drop self-funding
    for (i in 1:nrow(receipts)) { if(receipts[i,3] == "") {receipts[i,3] <- paste0(receipts[i,4],", ",receipts[i,5]) }} # Fill in full names
    for (i in 1:nrow(receipts)) { if(receipts[i,7] != "") {receipts[i,6] <- paste(receipts[i,6],receipts[i,7]) }} # Fill in full addresses
    receipts <- receipts[,-c(4,5,7)] # Drop newly superfluous columns
    receipts <- receipts[receipts$Name != "Actblue",] # Remove ActBlue contributions
    
    # Process Expenses table
    
    expenses <- expenses[,c(1,6:9,13:18,20:21,23)] # Drop unneeded expenses columns
    colnames(expenses) <- c("Code","Type","Name","Lastname","Firstname","Address","PO Box","City","State","ZIP","Elex","Date","Amount","Expense") # Label expenses columns
    for (i in 1:nrow(expenses)) { if(expenses[i,3] == "") {expenses[i,3] <- paste0(expenses[i,4],", ",expenses[i,5]) }} # Fill in full names
    for (i in 1:nrow(expenses)) { if(expenses[i,7] != "") {expenses[i,6] <- paste(expenses[i,6],expenses[i,7]) }} # Fill in full addresses
    expenses <- expenses[,-c(4,5,7)] # Drop newly superfluous columns

	# Save contents to disk.
	if (!dir.exists(title)) {dir.create(title)} # If it doesn't exist, create a directory named after the specified title.
	setwd(title) # Move to the new directory
	# Save the receipts and expenses tables as CSVs
	write.csv(receipts,paste0(title,"receipts.csv"), row.names =F)
	write.csv(expenses,paste0(title,"expenses.csv"), row.names = F)
	setwd("..") # Return to the original working directory.
	fecanalyzer(title,receipts,expenses) # Call the supporting function fecanalyzer() with the outputs from fecgrabber().
}
		
	
# Supporting function that takes data frames as formatted by fecgrabber() and extracts some interesting information from them.

fecanalyzer <- function(title, raised, spent) {	
    # The top states of origin for donations in the report.      
	a <- raised %>% group_by(State) %>% summarise(Total = sum(Contrib)) %>% arrange(desc(Total)) %>% mutate(Percent = Total / sum(Total, na.rm=T))

	# The top cities of origin for donations in the report.	
	b <- raised %>% group_by(City, State) %>% na.omit() %>% summarise(Total = sum(Contrib)) %>% arrange(desc(Total)) %>% ungroup() %>% mutate (Percent = Total / sum(Total, na.rm=T))
	
	# The top occupations listed by donors in the report.
	c <- raised %>% group_by(Job) %>% summarise(Total = sum(Contrib)) %>% arrange(desc(Total)) %>% mutate(Percent = Total / sum(Total, na.rm=T))
	
	# The top employers listed by donors in the report.
	d <- raised %>% group_by(Employer) %>% summarise(Total = sum(Contrib)) %>% arrange(desc(Total)) %>% mutate(Percent = Total / sum(Total, na.rm=T))
	
	# The top types of expense in the report.
	e <- spent %>% group_by(Expense) %>% summarise(Total = sum(Amount)) %>% arrange(desc(Total)) %>% mutate(Percent = Total / sum(Total, na.rm=T))

	# The top recipients of expenses in the report.
	f <- spent %>% group_by(Name) %>% summarise(Total = sum(Amount)) %>% arrange(desc(Total)) %>% mutate(Percent = Total / sum(Total, na.rm=T))
	
	if (!dir.exists(title)) {dir.create(title)} # If it doesn't exist, create a directory named after the specified title.
	setwd(title) # Move to the directory in question
	# Save the six data frames just calcualted as CSVs, with filenames based on your title.
	write.csv(a,paste0(title,"-in-states.csv"), row.names =F)
	write.csv(b,paste0(title,"-in-cities.csv"), row.names =F)
	write.csv(c,paste0(title,"-in-jobs.csv"), row.names =F)
	write.csv(d,paste0(title,"-in-employers.csv"), row.names =F)
	write.csv(e,paste0(title,"-out-expenses.csv"), row.names =F)
	write.csv(f,paste0(title,"-out-recipients.csv"), row.names =F)
	setwd("..") # Return to the original working directory.
	
	# Create a new global variable, called [title].fec: a list containing the six data frames, so you can call them in R for quick analysis.
	assign(paste0(title,".fec"),list("Top States" = a,"Top Cities" = b,"Top Jobs" = c,"Top Employers" = d, "Top Expenses" = e, "Top Recipients" = f), envir = .GlobalEnv) 
	rm(a,b,c,d,e,f) # Clean up the old data frames.
	
	# Print basic summary data into the console.
	print(paste0("Total raised: $",sum(raised$Contrib, na.rm=T)))
	print(paste0("Total spent: $",sum(spent$Amount, na.rm=T)))
}
