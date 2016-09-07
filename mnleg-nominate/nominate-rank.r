## Function to graph the ideologies of the 2015-16 Minnesota Legislature, and to highlight any interesting lawmakers. The variables of the function should be a list of legislator names: function(c("Daudt","Peppen","Thissen")). Calling the function with no variables will graph with no highlights. 
mnlegnom <- function(highlights = NA) {
	## Load the data
	library(dplyr)
	mnnom <- read.csv("nomscores.csv") %>% arrange(coord1D)
	colnames(mnnom)[1] <- "name"
	
	## Process the data
	mnnom.d <- subset(mnnom, coord1D <= 0)
	mnnom.r <- subset(mnnom, coord1D >= 0)

	# If you have entered highlights, checks to make sure they're in the database
	# Throws a warning if they're not.		
	if (!is.na(highlights[1])) {
        for (k in 1:length(highlights)) {
            if(sum(grepl(highlights[k], mnnom$name)) == 0) {
                stop(paste("No lawmaker named \"",highlights[k],"\" in the database.", sep=""))
            }
        }
    }
	
	# Create the image file
    if(is.na(highlights[1])) { # Check to see if there are highlights
        png("mnleg-nominate.png", width=2000, height=2000, res=250) # If not, title the file simply
        } else {
        png( # Otherwise title it based on the first lawmaker mentioned, plus the number of additional lawmakers
            paste0(
                "mnleg-nominate_",
                highlights[1],"+",
                length(highlights)-1,
                ".png"), 
            width=2000, height=2000, res= 250)
        }

	# Start graphing
	par(mar=c(2,4.2,4,2)) # Set margins
	plot( # Plot data
		mnnom$coord1D, # Ideology as y-axis. 
		# X-axis isn't mentioned so defaults to rank-order 
		pch=20, # Shape
		xaxt = "n", # Suppress x-axis
		yaxt="n", # Suppress y-axis
		ylab = "Ideology estimate", # Y-axis label 
		main = "Ideology in 2015-16 Minnesota House of Representatives", # Title
		cex=.6) # Size

	# Draw horizontal lines at the median ideologies for each party
	abline(h=median(mnnom.r$coord1D), lty=3)
	abline(h=median(mnnom.d$coord1D), lty=3)

	# Plot Democrats in blue
	points(
		mnnom.d$coord1D, # Y-coordinates from the Democrats data frame
		pch=20, # Shape
		col="blue", # Color
		cex=.6) # Size
	
	# Plot Republicans in red
	points(
		c(65:137), # Manually specify x-coordinates
		mnnom.r$coord1D, # Y-coordinates from the Republicans data frame
		pch=20, # Shape
		col="red", # Color
		cex=.6) # Size
	

	abline(h=0, lty=1) # Horizontal line at ideology = 0
	
	# Label the median DFL and GOP lines created above
	text(
		100, # X-coordinate set manually
		median(mnnom.d$coord1D), # Y-coordinate at median for party
		"Median DFL lawmaker", # Label
		pos=3, # Text located above specified coordinates
		cex=.5, # Font size
		offset=.2, # Offset slightly from the line
		font=3) # Italics
	text(
		35,
		median(mnnom.r$coord1D),
		"Median GOP lawmaker",
		pos=3, 
		cex=.5, 
		offset=.2, 
		font=3)
		
	# Add labels to the y-axis
	mtext( # Label the top
		"More conservative", # Label
		side=2, # Left side
		line=3, # Distance from edge of plot
		adj=1, # Justified to the top of the axis
		cex= .7) # Size
	mtext( # And the bottom
		"More liberal", 
		side=2, # Left side
		line=3, # Distance from the edge of plot
		adj=0, # Justified to the bottom of the axis
		cex = .7) # Size
	
	# Label the x-axis
	mtext("Order", side=1, line=.2)
	
	# Subtitle
	mtext(
		"Estimated using W-NOMINATE method by Keith Poole, Jeffrey Lewis, James Lo & Royce Carroll", # Label
		cex=0.7, # Size
		line=0.5) # Distance from the edge of plot
	
	# Credit line
	text(
		140, # X-coordinate, near right edge of plot
		-1, # Y-coordinate, at bottom of plot
		"Graphic by David H. Montgomery\nPioneer Press", # Label 
		pos=2, # Located to the left of the specified coordinate
		cex=.5) # Size
	
	# Add left axis
	axis(
		2, # Left side
		at = seq(-1, 1, .2), # From -1 to 1 by increments of 0.2
		lwd = 0, # No axis line
		lwd.ticks = 1, # Axis tick width
		las = 1, # Horizontal label orientation
		cex.axis=.8) # Font size
	
	# If you've selected any lawmakers to highlight, draw them	
	if (!is.na(highlights[1])) { # Check to see if there are any highlights; if not, skip this whole step.
        # Create an empty list as long as the number of lawmakers you want to highlight
        l <- vector(
        	"list", 
        	length(highlights)) 
        yl <- l # Create a copy of the list to store y-coordinates in
        # Fill out our x-coordinates
        for (i in 1:length(highlights)) { # Cycle through each highlight
            l[i] <- which(mnnom$name == highlights[i]) # Fill each position in L with the row number of each specified lawmaker name
            # This will be the x-coordinate for each point
            }
        xl <- as.numeric(l) # Store this and coerce to numeric
        # Fill out our y-coordinates
        # No need to cycle through with names this time, since we've already extracted the row names above.
        for (j in 1:length(l)) { yl[j] <- mnnom[xl[j],4] } # Write the ideology estimate for each lawmaker into the list yl.
        yl <- as.numeric(yl) # Coerce to numeric
        # Create a data frame from our x and y coordinates, plus the names
        signif <- data.frame(
            "name" = highlights, # Name column from specified highlights
            x = xl, # X-coordinates
            y = yl # Y-coordinates
        )
        # Draw the points
        points(
        	signif$x, # X-coordinates set above
        	signif$y, # Y-coordinates set above
        	col="black", # Black color
        	pch=19, # Shape
        	cex=1) # Size — bigger than the normal plots, for emphasis
        # Label each point
        # This includes some conditionals to make sure labels near the left or right side of the chart don't go outside the boundary
        text(
            ifelse(signif$x<40, signif$x+5, signif$x-5), # For Democrats near the extreme left, center the label to the right of the point. Otherwise, put it to the left.
            signif$y, # Y-coordinate
            labels= signif$name, # Label
            cex=0.7, # Font size
            pos= ifelse(signif$x<40,4,2), # For Democrats near the extreme left, put the label to the right side of its coordinates. Otherwise, put it to the left.
            adj = ifelse(signif$x<40, 1,0) # For Democrats near the extreme left, justify the label right; otherwise, justify left.
        )
    }
    # Close the image and finish.
	dev.off()
}
