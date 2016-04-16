## Creates graphs showing the estimated liberal-conservative ideology of members of the 2008 Minnesota Legislature, the most recent such legislature for which data is available. Data comes from Boris Shor and Nolan McCarty's "Individual State Legislator Shor-McCarty Ideology Data, June 2015 update," http://dx.doi.org/10.7910/DVN/THDBRA. Code by David H. Montgomery of the Pioneer Press.

## Before beginning make sure your working directory is set to the folder containing 08mnleg.csv or this code will not function.

mnshor <- read.csv("08mnleg.csv") ## Load the data.

## Plot the base graph.
png("08mnleg.png",width=1500,height=1500,res=200) ## Create a PNG file to draw the graph on. Change the file name to your preference. Adjust parameters as desired, but keep the width and height equal. If changing file dimensions, adjust the res parameter to taste — may take trial and error.
par(mar=c(1.1,4.1,3.1,2.1)) ## Set margins
plot(mnshor$Score, pch=19, xlab="",xaxt="n", ylab="", cex=0.4, ylim=c(-2,2)) ## Plot the basic data on a scale from -2 to +2.
mnsen <- subset(mnshor, Chamber == "senate") ## Create a subset of the data with just senators.
points(rownames(mnsen),mnsen$Score, col="grey", pch=19, cex=0.4) ## Plot senators in grey. Change the color if you want, but be sure to change the legend below on line 39 if you do.

## Add and label lines
abline(h=0, lty=5) ## Draw a dashed line across the middle of the chart.
dems <- subset(mnshor, Party == "D") ## Create a subset of the data with just DFL lawmakers.
gop <- subset(mnshor, Party == "R") ## Create a subset of the data with just GOP lawmakers.
abline(h=median(dems$Score), lty=3) ## Draw a dotted horizontal line at the median score for DFL lawmakers.
abline(h=median(gop$Score), lty=3) ## Draw a dotted horizontal line at the median score for GOP lawmakers.
text(150,median(dems$Score),"Median DFL lawmaker",pos=3, cex=.5, offset=.2, font=3) ## Label the median DFL line.
text(75,median(gop$Score),"Median GOP lawmaker",pos=3, cex=.5, offset=.2, font=3) ## Label the median GOP line.

## Add and label significant lawmakers
signif <- data.frame(
	"name"=c("Bonoff","Paulsen","Emmer"), 
	x=c(102,174,201), 
	y=c(mnshor[102,5],mnshor[174,5],mnshor[201,5])
) ## Create an object containing significant lawmakers we want to highlight. If editing, add the last name or other desired label to the "name" list, the row number of that lawmaker's data to the x list, and 'mnshor[rownum,5]' to the y list with the row number in place of 'rownum.' Make sure each lawmaker's name and coordinates are in the same position in each of the three lists — Bonoff is the first name, first x coordinate and first y coordinate, for example.
points(signif$x,signif$y,col="red",pch=19, cex=0.8) ## Draw larger red circles over the significant lawmakers identified above. Change the color if you like.
text(signif$x-10,signif$y,labels=signif$name, cex=0.8, pos=3, adj=0) ## Label the significant lawmakers.

## Add title and legend.
title("2008 Minnesota Legislature ideology estimates") ## Title the map.
mtext("Based on estimates by Boris Shor & Nolan McCarty, americanlegislatures.com", cex=0.8, line=0.2) ## Subtitle the map.
mtext("Pioneer Press graphic by David H. Montgomery", side=1, line=0, cex=.6,adj=1, font=3) ## Credit line. If you wish, add your own credit and change this text to "By [your name], based on Pioneer Press graphic by David H. Montgomery."
mtext("More conservative", side=2, line=3,adj=1) ## Label the top of the y-axis.
mtext("More liberal", side=2, line=3,adj=0) ## And the bottom of the y-axis.
points(0,2,pch=19) ## Add a black dot for the legend.
points(0,1.9,pch=19, col="grey") ## Add a grey dot for the legend. Change the color if you altered this above in line 12.
text(0,2, "Representatives", pos=4, cex=.8) ## Label the black dot.
text(0,1.9, "Senators", pos=4, cex=.8) ## Label the grey dot.
dev.off() ## Finish up and create the file.