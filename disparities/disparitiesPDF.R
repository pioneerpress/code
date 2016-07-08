# R code to generate charts of six different data sources on racial disparities in police traffic stops in Minnesota in PDF format.
# Data comes from a report by the Council on Crime and Justice: http://www.crimeandjustice.org/researchReports/Racial%20Profiling%20Report-%20All%20participating%20Jurisdictions.pdf
# To run, arrest-disparities.csv and this code file must both be in your working directory.
# The output will be six PDF files, 15" wide by 10" tall.
# Created by David H. Montgomery of the St. Paul Pioneer Press.

race <- read.csv("arrest-disparities.csv")

# Stopping
pdf("stops.pdf",width=15,height=10,pointsize=24)
stops <- barplot(race$pullover[2:6], names.arg= race$races[2:6], col = "grey", border = NA, main = "Likelihood of a traffic stop compared to\nrace's share of driving population", axes= FALSE, ylim=c(-.5,2.2))
axis(2, at = c(-.5,0,.5,1,1.5,2), labels = c("-50%","0%","+50%","+100%","+150%","+200%"), las = 1)
text(stops,race$pullover[2:6]-.15,paste0(round(race$pullover[2:6]*100,1),"%"),cex=1)
mtext("Pioneer Press graphic by David H. Montgomery",side=3, cex=.7)
mtext("Source: 2003 Council on Crime & Justice study of Minnesota", side=1,line=2.5, font =3)
dev.off()


# Equipment
pdf("equipment.pdf",width=15,height=10,pointsize=24)
equipment <- barplot(race$equipment[2:6], names.arg= race$races[2:6], col = "grey", border = NA, main = "Percent of stops for equipment violation, by race", axes= FALSE)
axis(2, at = c(0,.05,.1,.15), labels = c("0%", "5%","10%","15%"), las = 1)
abline(h=race$equipment[1], lty=3)
text(2, race$equipment[1], "Statewide average", pos = 3, cex = .7)
text(equipment,race$equipment[2:6],paste0(round(race$equipment[2:6]*100,1),"%"),cex=1,pos=1)
mtext("Pioneer Press graphic by David H. Montgomery",side=3, cex=.7)
mtext("Source: 2003 Council on Crime & Justice study of Minnesota", side=1,line=2.5, font =3)
dev.off()

# Searches
pdf("searches.pdf",width=15,height=10,pointsize=24)
searched <- barplot(race$searched[2:6], names.arg= race$races[2:6], col = "grey", border = NA, main = "Percent of stops resulting in discretionary searches, by race", axes= FALSE, ylim=c(0,.13))
axis(2, at = c(0,.03,.06,.09,.12), labels = c("0%", "3%","6%","9%","12%"), las = 1)
abline(h=race$searched[1], lty=3)
text(2, race$searched[1], "Statewide average", pos = 3, cex = .7)
text(searched,race$searched[2:6],paste0(round(race$searched[2:6]*100,1),"%"),cex=1,pos=1)
mtext("Pioneer Press graphic by David H. Montgomery",side=3, cex=.7)
mtext("Source: 2003 Council on Crime & Justice study of Minnesota", side=1,line=2.5, font =3)
dev.off()

# Safety
pdf("safety.pdf",width=15,height=10,pointsize=24)
safety <- barplot(race$safety[2:6], names.arg= race$races[2:6], col = "grey", border = NA, main = "Percent of searches conducted for 'officer safety,' by race", axes= FALSE, ylim=c(0,.3))
axis(2, at = c(0,.05,.1,.15,.2,.25,.3), labels = c("0%", "","10%","","20%","","30%"), las = 1)
abline(h=race$safety[1], lty=3)
text(2, race$safety[1], "Statewide average", pos = 3, cex = .7)
text(safety,race$safety[2:6],paste0(round(race$safety[2:6]*100,1),"%"),cex=1,pos=1)
mtext("Pioneer Press graphic by David H. Montgomery",side=3, cex=.7)
mtext("Source: 2003 Council on Crime & Justice study of Minnesota", side=1,line=2.5, font =3)
dev.off()

# Contraband
pdf("contraband.pdf",width=15,height=10,pointsize=24)
contra <- barplot(race$contraband[2:6], names.arg= race$races[2:6], col = "grey", border = NA, main = "Percent of searches in which contraband is found, by race", axes= FALSE, ylim=c(0,.25))
axis(2, at = c(0,.05,.1,.15,.2,.25), labels = c("0%", "5%","10%","15%","20%","25%"), las = 1)
abline(h=race$contraband[1], lty=3)
text(2, race$contraband[1], "Statewide average", pos = 3, cex = .7)
text(contra,race$contraband[2:6],paste0(round(race$contra[2:6]*100,1),"%"),cex=1,pos=1)
mtext("Pioneer Press graphic by David H. Montgomery",side=3, cex=.7)
mtext("Source: 2003 Council on Crime & Justice study of Minnesota", side=1,line=2.5, font =3)
dev.off()

# Arrests
pdf("arrests.pdf",width=15,height=10,pointsize=24)
arrests <- barplot(race$arrests[2:6], names.arg= race$races[2:6], col = "grey", border = NA, main = "Percent of stops in which driver is arrested, by race", axes= FALSE, ylim=c(0,.15))
axis(2, at = c(0,.05,.1,.15), labels = c("0%", "5%","10%","15%"), las = 1)
abline(h=race$arrests[1], lty=3)
text(2, race$arrests[1], "Statewide average", pos = 3, cex = .7)
text(arrests,race$arrests[2:6],paste0(round(race$arrests[2:6]*100,1),"%"),cex=1,pos=1)
mtext("Pioneer Press graphic by David H. Montgomery",side=3, cex=.7)
mtext("Source: 2003 Council on Crime & Justice study of Minnesota", side=1,line=2.5, font =3)
dev.off()
