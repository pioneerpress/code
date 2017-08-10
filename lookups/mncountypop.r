library(RCurl)
library(dplyr)
library(readxl)

url <- "https://mn.gov/admin/assets/mn_county_estimates_sdc_2016_tcm36-304002.xlsx" # Set the URL
tmp = tempfile(fileext = ".xlsx") # Create a temporary file to store the spreadsheet
download.file(url, destfile = tmp, mode = "wb") # Download the URL into the temporary file
mncountypop <- read_excel(tmp)[-88,c(1:3)] # Clean the data

colnames(mncountypop) <- c("countycode", "county", "pop") # Rename the columns
mncountypop$num <- row.names(mncountypop) # Add a column with each county's number

mncountypop$county <- gsub("St. ","Saint ",mncountypop$county) # Format Saint Louis County
mncountypop$county <- gsub("qui ","Qui ",mncountypop$county) # Format Lac Qui Parle County

mncountypop <- select(mncountypop, num, code = countycode, county, pop) # Select and reorder columns
