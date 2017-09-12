# A function to generate a map votes in the 2016 Minnesota Senate. Created by David H. Montgomery for the Pioneer Press.
# "votetitle" should be a bill number or one or two words to describe the vote; it will also double as the name of the file generated.
# "votedescription" should be a one-sentence summary of the issue at stake.
# "votedate" must be in the format "2017-02-01" for Feb. 1, 2017.
senvotetracker <- function(votetitle, votedescription,votedate) {
	# Load all the necessary libraries
	library(maptools)
	library(RColorBrewer)
	library(rgdal)
	library(dplyr)
	library(plotrix)
	library(googlesheets)
	
	# Register Google Sheets
	gsvotes <- gs_title("#mnleg Vote Tracker") # Connect to the Google sheet
	votes <- as.data.frame(gs_read(gsvotes, "Senate", verbose = FALSE))
	
	# Load the data
	area <- readOGR(dsn = "senatemap", layer = "sorted")
		votes <- arrange(votes, district) # Sort the vote file to be sure
	
	area@data <- data.frame(area@data,votes, by="DISTRICT") # Merge the vote file with the map
	colscale <- c("#BDF9FF","#57B0FF","white","#FFAC75","#F72836","grey") # DFL-Y (light blue), DFL-N (dark blue), R-Y (light red), R-N (dark red), Absent (grey) 
	area@data <- area@data %>%
		mutate(color = ifelse(partyvote == "R-N", colscale[5], ifelse(partyvote == "R-Y", colscale[4], ifelse(partyvote == "DFL-N", colscale[2], ifelse(partyvote == "DFL-Y",colscale[1], colscale[6]))))) # Add a new column to the data specifying which color the map should be based on the party and vote.
	
	# Count up how many party-vote combinations there are.
	counts <- c(sum(area@data$partyvote == 'DFL-Y'), sum(area@data$partyvote == 'DFL-N'), sum(area@data$partyvote == 'R-Y'), sum(area@data$partyvote == 'R-N'), sum(sum(area@data$partyvote == 'R-Absent'),sum(area@data$partyvote == 'DFL-Absent')))
	
	# Define the rows of our data that are in the metro and outstate.
	zoom.area <- area[c(34:46,48:54,56,57,59:67),]
	metro <- c(34:46,48:54,56,57,59:67)
	outstate <- c(1:33,47,55,58)
	
	# Start mapping
	png(paste0(votedate, "-", votetitle,".png"), width=1500, height=1001) ## Create the canvas
	par(pin = c(20.9,14)) # Define the size
	par(mar = c(.5,0,4,1)) # Set the margins
	# Plot the base map
	plot(
		area, 
		col = area@data$color, 
		border = "white", 
		lwd=.8 
	)
	title(paste("Vote on",votetitle), cex.main=3, line=1) # Add title
	mtext(votedescription, cex=2, line=-1.5) # Add subtitle
	mtext("Labels = Senate Districts", cex=1.5, line = -8) # Add label
	mtext(paste0("Vote on ",format(as.Date(votedate), "%B %d, %Y")), cex = 1.5, font = 2, line = -6) # Add date
	mtext("Pioneer Press graphic", cex=2, line= 0, adj=1) # Add credit
	mtext("Designed by David H. Montgomery", cex=1.2, line= -2,adj=1) # Add URL
	
	# Add the table
	colnames(votes) <- c("District","lastname","firstname","Name","Party","Vote","partyvote")
	addtable2plot(par("usr")[1],par("usr")[3], votes[,c(1,4,5,6)], xjust=-.1, yjust=1.01, ypad=0.5, hlines=TRUE, bty="o")
	
	# Add the legend
	legend("topright", 
		   legend = c(
		   	paste0("DFL Yes (",counts[1],")"),
		   	paste0("DFL No (",counts[2],")"),
		   	" ",
		   	paste0("GOP Yes (",counts[3],")"),
		   	paste0("GOP No (",counts[4],")"),
		   	paste0("Absent (",counts[5],")")
		   ),
		   fill = colscale,
		   border = colscale,
		   bty = "n",
		   cex = 2.2,
		   ncol=2,
		   inset=c(0,.1)
	)
	
	# Label the map
	label_points = coordinates(area) # Calculate the center of each district
	rownames(label_points) <- c(1:67) # Change the labels to the district names
	outstate_labels <- label_points[outstate,] # Filter labels to just the outstate districts
	text(outstate_labels, labels=as.character(rownames(outstate_labels)), cex=1.4, font=2) # Put labels on the map
	
	# Create the inset area
	par(
		# Define the extent of the inset as a percentage of the canvas
		plt = c(0.66, 0.97, 0.03, 0.53),
		new = TRUE # Specify we want to overlay the inset on the map instead of starting a new canvas
	)
	# Map the inset
	plot(
		zoom.area, 
		col = zoom.area@data$color, 
		border = "white", 
		lwd=.8
	)
	box() # Box the inset
	title("Zoom on metro", cex.main=2, line=0.5) # Title the inset
	metro_labels <- label_points[metro,] # Filter labels to just metro districts
	text(metro_labels, labels=as.character(rownames(metro_labels)), cex=1, font=2) # Put labels on the map
	dev.off()
}
