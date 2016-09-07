# Script to import ideology estimates from "nomscores.csv" and produce a chart plotting those estimates against Mitt Romney's share of the two-party vote in each lawmaker's district.

# Load the data
mnnom <- read.csv("nomscores.csv") %>% arrange(coord1D)
mnnom.d <- subset(mnnom, coord1D <= 0) # Subset Democrats
mnnom.r <- subset(mnnom, coord1D >= 0) # Subset Republicans

# Create the image
png("nominate-margin.png", width = 2000, height = 2000, res = 250) # Open the PNG file
par(mar=c(4,4.2,4,2)) # Set margins

# Plot Democrats
plot(
	mnnom.d$R.margin, # X-axis: Romney margin
	mnnom.d$coord1D, # Y-axis: Ideology estimates
	xlim = c(0,.7), # X limits from 0% to 70%
	ylim = c(-1, 1), # Y limits from -1 to 1
	xaxt="n", # Suppress x-axis
	yaxt="n", # Suppress y-axis
	pch=20, # Shape
	col="blue", # Color
	xlab = "", # No x-axis label
	ylab = "Ideology estimate", # Y-axis label
	main = "Ideology in 2015-16 Minnesota House of Representatives") # Title

# Add left axis
axis(
	2, # Left side
	at = seq(-1, 1, .2), # From -1 to 1 by increments of 0.2
	lwd = 0, # Suppress axis line
	lwd.ticks = 1, # Tick widths
	las = 1, # Horizontal numbers
	cex.axis=.8) # Font size

# Add bottom axis
axis(
	1, # Bottom side
	at = seq(0, .7, .1), # 0 to .7 by increments of 0.1 
	lwd = 0, # Suppress axis line
	lwd.ticks = 1, # Tick widths
	cex.axis=.8) # Font size

# Label x-axis
mtext("2012 Romney vote share", side=1, line=2.2)

# Add Republicans
points(
	mnnom.r$R.margin, # X-coordinates: Romney margin
	mnnom.r$coord1D, # Y-coordinates: Ideology estimates
	pch=20, # Shape
	col="red") # Color
	
abline(h=0, lty=3) # Add dotted line at ideology = 0
abline(v=.5, lty=3) # Add dotted line at Romney margin = 50%
mtext("More conservative", side=2, line=3,adj=1, cex= .7) ## Label the top of the y-axis.
mtext("More liberal", side=2, line=3,adj=0, cex = .7) ## And the bottom of the y-axis.
mtext("Estimated using W-NOMINATE method by Keith Poole, Jeffrey Lewis, James Lo & Royce Carroll", cex=0.7, line=0.5) ## Subtitle the map.
text(.73,-1,"Graphic by David H. Montgomery\nPioneer Press", pos=2, cex=.5) # Add credit line
dev.off()