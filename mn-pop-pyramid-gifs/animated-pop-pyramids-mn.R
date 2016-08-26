## Set the working directory to the population pyramid GIFs folder acquired by downloading this code. Will only function if this folder is in your current working directory.
library(plotrix) ## Activate the Plotrix package, the only outside package — aside from ImageMagick — required for this to function.
age <- read.csv("mn-age-projections.csv") ## Load the CSV containing all the data.
ctynames <- unique(age$County) # Create a vector with all the county names
ctynames1 <- tolower(gsub("\\s+","",ctynames)) # Create another vector with capital letters and spaces extracted, for filename purposes
# All our pyramids will use the same color scheme and y-axis, so we'll create those objects beforehand.
agelabels<-c("0-4","5-9","10-14","15-19","20-24","25-29","30-34",  "35-39","40-44","45-49","50-54","55-59","60-64","65-69","70-74", "75-79","80-84","85+")
mcol<-"blue"
fcol<-"red"
# These vectors will help us loop through all the counties and age brackets.
years <- c(15,20,25,30,35,40,45)
mcolumns <- c(3,5,7,9,11,13,15) # These are column numbers containing male & female data
fcolumns <- c(4,6,8,10,12,14,16)
if (!dir.exists("GIFs")) { dir.create("GIFs")} # Create a folder to put the hundreds of files this script will temporarily and permanently create in.
setwd("GIFs") # Move the working directory to that new folder.

for (i in 1:87) { # Loop through each county
	for (j in 1:7) { # And within each county, each of the seven years
		png(paste0(ctynames1[i],20,years[j],".png")) # Create a PNG file for each county and year
		par( # Set graphical elements
			mar=pyramid.plot(
				subset(age, County == ctynames[i], select = mcolumns[j], drop = TRUE), # Select the male age projections for our given county and year
				subset(age, County == ctynames[i], select = fcolumns[j], drop = TRUE), # Select the female age projections for our given county and year
				labels = agelabels, # Assign labels
				main = paste0(ctynames[i]," 20",years[j]," population pyramid"), # Title the graph
				gap = 1, # Format
				show.values = TRUE,
				lxcol = mcol, # Assign colors based on gender
				rxcol = fcol,
				xlim = c(8.1,8.1),
				laxlab = seq(from = 0, to = 8, by =1), # Label the x-axis
				raxlab = seq(from = 0, to = 8, by = 1)
			)
		)
		dev.off() # Output the png
	}
	system(paste0("convert -delay 80 *.png ",ctynames1[i],".gif")) ## Creates [county].gif
	file.remove(list.files(pattern=".png")) ##This deletes all the PNG files in the working directory, clearing the way for the next county.
}
setwd("..") # Return to our original working directory.