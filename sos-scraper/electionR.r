# Scrapes results for the Aug. 9, 2016 Minnesota primary election from the Minnesota Secretary of State's FTP file, filters it down to just the competitive 2nd Congressional District primary, saves that data, and maps it.
# Requires the cd2.shp shapefile and countycode-fips converter.csv to be in the working directory. These should have been provided if you downloaded this entire folder.
# Also requires a username and password to access the Secretary of State's FTP server. This is not provided. It should be placed in a file called "sospw.txt" in the working directory; that file should be a single line with the format "username:password" with no quotes.
# Will output a csv, "cd2table.csv", and a map, "cd2map.png".
# Code by David H. Montgomery for the Pioneer Press.

# I'm actually not 100% certain all of these libraries are needed.
library(RCurl)
library(tidyr)
library(maptools)
library(sp)
library(shapefiles)
library(dplyr)
library(plotrix)

# Load the password from the file. You need a working username and password for this to work.
pw <- scan("sospw.txt", what = character(), quiet = TRUE)

# Read the precinct results file in from the FTP server.
allvotes <- read.table(
	textConnection(
		getURL("ftp://ftp.sos.state.mn.us/20160809/ushousepct.txt",userpwd = pw)),
	sep=";",
	colClasses=c( #Set classes for each column. Important to make precinct IDs show up as strings, so you get "0005" instead of "5".
		rep("factor",5), 
		"numeric",
		rep("factor",5),
		rep("numeric",5)
		))


allvotes <- allvotes[,c(1:8,11:16)] # Drop some unneeded columns.
colnames(allvotes) <- c("State","CountyID","PrecinctNumber","OfficeID","OfficeName ","District","CandidateID","CandidateName","Party","PrecinctsReporting","TotalPrecincts","CandidateVotes","Percentage","TotalVotes") # Assign column names
cd2votes <- subset(allvotes, District == 2 & Party == "R") # Filter to just the 2nd District GOP primary

# Load a table that converts between the Secretary of State's county codes and formal FIPS codes.
fips <- read.csv("countycode-fips converter.csv")
fips <- fips[,-3] # Drop an unnecessary column
colnames(fips) <- c("CountyID","County","FIPS") # Label columns
cd2votes <- merge(fips,cd2votes, by = "CountyID") # Merge with the voting data by County IDs
cd2votes$VTD <- paste0(cd2votes$FIPS,cd2votes$PrecinctNumber) # Combine the FIPs code and the Precinct IDs to create a nine-digit VTD code.

cd2table <- spread(cd2votes[,-c(8,14)],CandidateName, CandidateVotes) # Convert data from tall to wide format and save as a new data frame.
cd2table$winner <- apply(cd2table[,13:16],1,function(x)
    names(cd2table[,13:16])[which(x==max(x))]) # Calculate winner for each precinct

#Calculate winner's percentage
for (i in 1:nrow(cd2table)) { # Iterate through the table row by row
	cd2table$WinnerPct[i] <- cd2table[i,13:16][which.max(cd2table[i,13:16])]/cd2table[i,11] # Identify the largest number of votes and divide it by the total number of voters
	}

write.csv(cd2table, "cd2table.csv") # Write the data in spreadsheet form.

# Map our precincts
cd2table <- cd2table[-227,] # Drop a precinct not on our map.
cd2table$VTD <- as.factor(cd2table$VTD) # Reformat a column to make this easier.
cd2map <- readShapePoly("cd2.shp") # Load the map
cd2map@data <- cd2map@data[order(cd2map@data$VTD),] ## Sort the vote file to be sure
cd2map@data <- left_join(cd2map@data,cd2table, by="VTD") # Merge our data into the map

# Define the colors we'll use on the map — a light & dark color for each candidate.
colscale <- c( 
	"goldenrod1","goldenrod3", # Lewis colors
	"darkseagreen1","darkseagreen3", # Miller colors
	"mediumorchid1","mediumorchid3", # Howe colors
	"cyan1","cyan3", #Erickson colors
	"Grey") # Tie

# Give each precinct a color based on who won it and how well they did. Topping 50% in a precinct means a darker shade.
cd2map@data <- cd2map@data %>%
		mutate(color = 
			ifelse(TotalVotes == 0, "White",
			ifelse(winner == "Jason Lewis" & WinnerPct < .5, colscale[1], 
			ifelse(winner == "Jason Lewis" & WinnerPct >= .5, colscale[2], 
			ifelse(winner == "Darlene Miller" & WinnerPct < .5, colscale[3],
			ifelse(winner == "Darlene Miller" & WinnerPct >= .5, colscale[4], 
			ifelse(winner == "John Howe" & WinnerPct < .5, colscale[5], 
			ifelse(winner == "John Howe" & WinnerPct >= .5, colscale[6], 
			ifelse(winner == "Matthew D. Erickson" & WinnerPct < .5, colscale[7],
			ifelse(winner == "Matthew D. Erickson" & WinnerPct >= .5, colscale[8], 
			colscale[9]))))))))))

sums <- colSums(cd2table[,13:16]) # Add up the total votes each candidate received.
counts <- c(sum(cd2map@data$winner == "Jason Lewis"), sum(cd2map@data$winner == "Darlene Miller"), sum(cd2map@data$winner == "John Howe"), sum(cd2map@data$winner == "Matthew D. Erickson"), sum(lengths(cd2map@data$winner,use.names=FALSE)>1)) # Count the number of precincts each candidate won (not currently used)

file.copy("cd2map.png",paste0("cd2map",Sys.time(),".png")) # Copy any old versions of the map into a new file with a timestamp.

# Begin making the map.
png("cd2map.png", width= 1700, height=1000) # Open the image file
par(mar = c(.5,.5,5,.5)) ## Set the margins

plot( # Plot the map
	cd2map, 
	col = cd2map@data$color, #Colors set above.
	border = "black", # Black borders around precincts
	lwd=.4, # Set border thickness.
	)

title("Minnesota 2nd District GOP primary (Aug. 9, 2016)", cex.main=3.5) # Title the map
mtext("Pioneer Press graphic by David H. Montgomery", line= -1.5, cex=1.5) ## Add credit
mtext(paste0("Precincts reporting: ",sum(cd2table$PrecinctsReporting),"/",sum(cd2table$TotalPrecincts)), side = 1,line= -1, cex=1.5) ## Add precincts reporting

# Add a legend in two columns
legend("topright", 
	legend = c(
		"", # The first four boxes in the left column have no labels
		"",
		"",
		"",
		"Tie",
		"No votes counted",
		paste0("Jason Lewis (",sums[[2]],")"), # The first four boxes in the right column have candidate labels
		paste0("Darlene Miller (",sums[[1]],")"),
		paste0("John Howe (",sums[[3]],")"),
		paste0("Matt Erickson (",sums[[4]],")"),
		"",
		""		
	),
	fill = c(colscale[1],colscale[3],colscale[5],colscale[7],colscale[9],"White",colscale[2],colscale[4],colscale[6],colscale[8],NA,NA), # Define the box colors, including blank boxes at the bottom of the right column
	border = c(rep("black",10),"white","white"), # Give boxes black boundaries except for the bottom two at the bottom of the right column, which should be invisible
	bty="n", # No frame around the legend
	cex = 2, # Set font size
	ncol= 2, # Set number of columns
	x.intersp = .5, # Adjust spacing
	text.width = rep(0,12), # Minimize spacing
	inset=c(.1,.1), # Move the legend away from the edge of the map
	title="Precinct winner (total votes)\nDarker shades = bigger victory" # Title the legend
	)

dev.off() # Close the map and output to the file.
