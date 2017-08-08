library(RCurl)
library(dplyr)
library(readxl)

url <- "https://www.dropbox.com/s/a27hcp4csc55ckg/Screenshot%202017-08-08%2015.07.31.png?dl=0" # Set the URL
tmp = tempfile(fileext = ".xlsx") # Create a temporary file to store the spreadsheet
download.file(url, destfile = tmp, mode = "wb") # Download the URL into the temporary file
mncountypop <- read_excel(tmp)[-88,-c(6:7)] # Clean the data

colnames(mncountypop) <- c("FIPS", "FIPS.county", "county", "pop", "households", "pop.per.household") # Rename the columns
mncountypop$num <- row.names(mncountypop) # Add a column with each county's number

mncountypop$county <- gsub("St. ","Saint ",mncountypop$county) # Format Saint Louis County
mncountypop$county <- gsub("qui ","Qui ",mncountypop$county) # Format Lac Qui Parle County

mncountypop <- select(mncountypop, num, code = FIPS.county, FIPS, county, pop, households, pop.per.household) # Select and reorder columns
