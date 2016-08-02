# An R script that will import data on police activity by the St. Anthony, Minnesota, police department, previously produced by the `st-anthony-data.R` script. It will then analyze that data on the basis of race and produce a graph of the racial disparities.
# Written by David H. Montgomery for the Pioneer Press.
# This script assumes your working directory is the folder containing the "st-anthony-stats.csv" file. If you just ran `st-anthony-data.R` your working directory should already be that folder.

library(plyr)
library(utils)

# Load the data
allstats <- read.csv("st-anthony-stats.csv")
sums_race <- read.csv("summary-stats.csv")


# Create subsets with just the summary data for each type of offense.
arrests <- subset(sums_race, Involvement.Type == "Arrested")
cited <- subset(sums_race, Involvement.Type == "Cited")
warning <- subset(sums_race, Involvement.Type == "Warned")

# Create a subset with just white and black races.
sums_race_wb <- subset(sums_race, Race %in% c("White","Black"))


# Graph showing interactions by result

# Prepare the data. 
attach(sums_race)
crime_race <- aggregate(freq, list(Race, Involvement.Type), FUN=sum) #Create a data frame summarizing all interactions over the six-year period by race and outcome.
crime_race_sum <- aggregate(freq, list(Involvement.Type), FUN=sum) # Create a data frame with the total number of each outcome.
colnames(crime_race) <- c("Race","Result","freq") #Name the columns.
colnames(crime_race_sum) <- c("Result","freq") #Name the columns.
detach(sums_race)
crime_race_wb <- subset(crime_race, Race %in% c("White","Black")) # Discard races other than white and black.
crime_race_wb$rate <- c(4356/11474,6088/11474,1695/13863,7841/13863,205/1039,686/1039) # Divide the sums for each race-outcome combo by the total number of each outcome, here rendered manually.
# Convert this data into a matrix for barplotting purposes.
# Extract white and black data.
crime_race_w <- crime_race_wb[crime_race_wb$Race == "White",] 
crime_race_b <- crime_race_wb[crime_race_wb$Race == "Black",]
# Create a new matrix recombining the two races.
crime_race_new <- cbind(crime_race_w[,4],crime_race_b[,4])
crime_race_new <- crime_race_new[-2,] # Drop citations, which have a high missing data rate.
colnames(crime_race_new) <- c("White","Black")
rownames(crime_race_new) <- c("Arrested","Warned")

# Plot the percentage of all arrests and warnings given to whites and blacks.
# Will write to a PNG file in the working directory.
png("stanthony-stops.png",width=1500,height=1500, res=200)
par(mar = c(7,4,4,2))
stops1 <- barplot(
    t(crime_race_new), 
    beside=T, 
    ylim=c(0,.89), 
    col=c("orange","blue"), 
    ylab="White and black share of outcome",
    xlab="Types of outcomes", 
    border=NA, 
    legend.text=TRUE, 
    args.legend= c(x="right",title="Race", bty="n"), 
    cex.main= 1.5, 
    axes=FALSE, 
    main = "St. Anthony Police Department arrests & warnings")
axis(
    2, 
    at=(c(0,.2,.4,.6,.8)), 
    labels=c("0%","20%","40%","60%","80%"), 
    las=1)
text(stops1, t(crime_race_new)+.03,paste0(round(t(crime_race_new)*100,1),"%"))
# Add lines for the population share of whites and blacks in the three-city region served by the St. Anthony Police Department, derived from the U.S. Census.
abline(h=.07, lty=3)
abline(h=.76, lty=3)
text(3.5,.07,"Black population share", pos=3, cex=0.6)
text(3.5,.76,"White population share", pos=3, cex=0.6)
mtext("Pioneer Press graphic by David H. Montgomery",side=3, cex=.85, line=-1, font=3) # Credit line.
mtext("percent of given to whites and blacks, 2011-2016",side=3, cex=1, line=.3) # Subtitle
mtext("Note: Warning data only for traffic violations. Arrests include all departmental arrests.\nCitations not included due to high rate of missing race data.\nPopulation share from U.S. Census for three-city region covered by department.", side=1,line=5.8, font =3, cex=.8) #Notes
dev.off()
