library(RCurl)
library(dplyr)
library(readxl)

url <- "https://mn.gov/admin/assets/mn_county_estimates_sdc_2015_tcm36-250306.xlsx" # Set the URL
tmp = tempfile(fileext = ".xlsx")
download.file(url, destfile = tmp, mode = "wb")
mncountypop <- read_excel(tmp)[-88,-c(6:7)]

colnames(mncountypop) <- c("FIPS", "FIPS.county", "county", "pop", "households", "pop.per.household")
mncountypop$num <- row.names(mncountypop)

mncountypop$county <- gsub("St. ","Saint ",mncountypop$county)
mncountypop$county <- gsub("qui ","Qui ",mncountypop$county)

mncountypop <- select(mncountypop, num, code, FIPS, county, pop, households, pop.per.household)
mncountypop <- select(mncountypop,7,2,1,3,4,5,6)
