library(RCurl)
library(dplyr)
library(readxl)

url <- "https://mn.gov/admin/assets/mn_cities_townships_estimates_sdc_2015_tcm36-250307.xlsx" # Set the URL
tmp = tempfile(fileext = ".xlsx")
download.file(url, destfile = tmp, mode = "wb")
mncitypop <- read_excel(tmp)[,-c(6:7)]

colnames(mncitypop) <- c("FIPS","CTU","county","city","pop","households","people.per.household")
mncitypop <- mncitypop[mncitypop$county != "MINNESOTA",]
mncitypop$civildivision <- mncitypop$city

mncitypop$city <- gsub("\\(part\\)","",mncitypop$city)
mncitypop$city <- gsub("\\(balance\\)","",mncitypop$city)
mncitypop$city <- gsub("Unorg\\.","Unorganized",mncitypop$city)
mncitypop$city <- trimws(mncitypop$city,"r")


mncitypop$type <- NA
for (i in 1:nrow(mncitypop)) {
    mncitypop$type[i] <- tail(strsplit(mncitypop$city[i],split=" ")[[1]],1)
}
        
# Remove the "city", "township" and "unorganized" from the end of the city names
# Do this by deleting the last word of each city name
for (i in 1:nrow(mncitypop)) { # Cycle through each row
    mncitypop$city[i] <- paste(
        head(
            strsplit(
                mncitypop$city[i],
                split=" "
            )[[1]],
                length(
                    strsplit(
                        mncitypop$city[i],
                        split=" "
                    )[[1]]
                )-1
        ),
        collapse = ' '
    )
}

mncitypop <- mncitypop[,c(1,3,4,5,9,6,7,8,2)]
