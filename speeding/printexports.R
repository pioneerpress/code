# Miles over
ggplot(speeding %>% filter(milesover >= 0), aes(milesover)) +
	geom_bar(aes(y = (..count..)/sum(..count..))) +
	scale_y_continuous("Percent of speeding tickets", labels = percent, limits = c(0,0.3)) +
	scale_x_continuous(limits = c(0,40), breaks = seq(0, 40, by = 5)) +
	theme_minimal() +
	theme(text = element_text(size = 20)) +
	labs(title = "How fast are Minnesota highway speeders going?",
		 subtitle = paste0(
		 	strftime(min(speeding$datetime), format = "%b. %e, %Y"),
		 	" - ",
		 	strftime(max(speeding$datetime), format = "%b. %e, %Y"),
		 	". Source: Minnesota State Patrol"
		 ),
		 caption = "Pioneer Press graphic by David H. Montgomery",
		 x = "Miles over the posted speed limit")
ggsave("milesover.png", width = 12)

# Age/sex
ggplot(speeding %>% filter(violator_sex != "", AGE >= 10) %>% group_by(violator_sex, AGE) %>% summarize(tickets = n()) %>% mutate(pct = tickets/sum(tickets)), aes(AGE, tickets, group = violator_sex, fill = violator_sex, color = violator_sex)) +
	geom_col() +
	scale_y_continuous(labels = comma) +
	scale_x_continuous(position = "top", limits = c(10,103), breaks = seq(10,100, by = 10)) +
	facet_wrap(~ violator_sex, strip.position = "bottom") +
	theme_bw() +
	theme(legend.position = "none") +
	labs(title = "Minnesota State Patrol speeding tickets by age and gender",
		 subtitle = paste0(
		 	strftime(min(speeding$datetime), format = "%b. %e, %Y"),
		 	" - ",
		 	strftime(max(speeding$datetime), format = "%b. %e, %Y"),
		 	". Source: Minnesota State Patrol"
		 ),
		 caption = "Pioneer Press graphic by David H. Montgomery",
		 x = "Age",
		 y = "Speeding tickets")
ggsave("agegender.png", width = 12)

# 35E
i35e <- speeding %>% # Create a new data frame from the speeding dataset where:
	filter( 
		violation_county == "RAMSEY", # The county is Ramsey
		posted_speed == 45, # The speed limit is 45 mph
		str_detect(location_description, "35E")) # And the location description includes "35E"

ggplot(i35e, aes(actual_speed)) + # Graph this data based on the actual speed of the driver
	geom_histogram(binwidth = 1, center = .5) + # Create a histogram with bars 1 mph wide, centered in the middle
	scale_x_continuous(breaks = c(45, 55, 65, 75, 85, 95, 105)) + # Set the x-axis scale
	geom_vline(xintercept = 55, color = "blue") + # Draw a line to mark 55 mph
	theme_minimal() + # Set a minimalist theme
	theme(text = element_text(size = 20)) +
	# theme(axis.line = element_line(),
	# 	  axis.ticks = element_line(),
	# 	  axis.ticks.length = unit(0.25, "cm"),
	# 	  panel.grid = element_blank()) +
	# Label the graph
	labs(title = "Cited speeds for speeding tickets on 45 mph section of Interstate 35E", # Title
		 # A programmatically generated subtitle calculating the earliest and latest date
		 subtitle = paste0( # Concatenate multiple elements together
		 	strftime(min(speeding$datetime), format = "%b. %e, %Y"),
		 	" - ",
		 	strftime(max(speeding$datetime), format = "%b. %e, %Y"),
		 	". Source: Minnesota State Patrol" # Append a source sentence to the end.
		 ),
		 caption = "Pioneer Press graphic by David H. Montgomery", # Add a caption
		 x = "Cited speed (mph)", # X-axis title
		 y = "Number of tickets") # Y-axis title
ggsave("speeding-35e.png", width = 12)

# 94
i94 <- speeding %>% filter(violation_county == "RAMSEY", posted_speed == 55, str_detect(location_description, " 94"), actual_speed >= 45)
ggplot(i94, aes(actual_speed)) +
	geom_histogram(binwidth = 1, center = .5) +
	scale_x_continuous(limits = c(45, 105), breaks = c(45, 55, 65, 75, 85, 95, 105)) +
	scale_y_continuous(labels = comma) +
	theme_minimal() +
	theme(text = element_text(size = 20)) +
	labs(title = "Cited speeds for speeding tickets on Interstate 94 in Ramsey County",
		 subtitle = paste0(
		 	strftime(min(speeding$datetime), format = "%b. %e, %Y"),
		 	" - ",
		 	strftime(max(speeding$datetime), format = "%b. %e, %Y"),
		 	". Source: Minnesota State Patrol"
		 ),
		 caption = "Pioneer Press graphic by David H. Montgomery",
		 x = "Cited speed (mph)",
		 y = "Number of tickets")
ggsave("speeding-94.png", width = 12)


# Time of day
ggplot(speeding %>% group_by(hour = floor(decimaltime), weekend) %>% summarize(tickets = n()) %>% ungroup() %>% group_by(weekend) %>% mutate(ticketsper = tickets/sum(tickets)), aes(hour, ticketsper)) +
	geom_col() +
	scale_y_continuous(labels = percent) +
	scale_x_continuous(breaks = c(0, 4, 8, 12, 16, 20, 24), labels = c("Midnight", "4 a.m.", "8 a.m.", "Noon", "4 p.m.","8 p.m.",""), minor_breaks = seq(0,24, by = 1)) +
	facet_wrap(~ weekend) +
	theme_bw() +
	theme(text = element_text(size = 20)) +
	labs(title = "What time of day are people ticketed on Minnesota highways?",
		 subtitle = paste0(
		 	strftime(min(speeding$datetime), format = "%b. %e, %Y"),
		 	" - ",
		 	strftime(max(speeding$datetime), format = "%b. %e, %Y"),
		 	". Source: Minnesota State Patrol"
		 ),
		 caption = "Pioneer Press graphic by David H. Montgomery",
		 x = "Hour of the day", 
		 y = "Percent of tickets written")
ggsave("speeding-time.png", width = 12)


# Total
ggplot(speeding.months, aes(yearmon, tickets)) +
	geom_col() +
	#scale_fill_manual(values = colors) +
	#geom_col(data = speeding.months %>% filter(month %in% c("06", "07", "08")), fill = "red") +
	#geom_col(data = speeding.months %>% filter(month %in% c("01", "02", "12")), fill = "blue") +
	scale_y_continuous(labels = comma) +
	scale_x_date(date_breaks = "3 months", date_labels = "%b. %y", date_minor_breaks = "1 month") +
	theme_minimal() +
	theme(legend.position = "none",
		  text = element_text(size = 20),
		  axis.text.x = element_text(size = 12),
		  plot.margin = unit(c(1, 1.25, 0.5, 0.5), "lines")) +
	labs(title = "Speeding tickets issued by month on Minnesota highways",
		 subtitle = paste0(
		 	strftime(min(speeding$datetime, na.rm = TRUE), format = "%b. %e, %Y"),
		 	" - ",
		 	strftime(max(speeding$datetime, na.rm = TRUE), format = "%b. %e, %Y"),
		 	". Source: Minnesota State Patrol."
		 ),
		 caption = "Pioneer Press graphic by David H. Montgomery",
		 x = "Month",
		 y = "Speeding tickets issued")
ggsave("speeding-overall.png", width = 12)

ggplot(speeding %>% group_by(date = date(speeding$datetime)) %>% summarize(tickets = n()), aes(date, tickets)) +
	geom_col(color = "grey35") +
	geom_smooth() +
	theme_minimal() +
	theme(text = element_text(size = 20)) +
	# Label the graph
	labs(title = "Minnesota highway speeding tickets by day", # Title
		 # Subtitle with the date range of the dataset
		 subtitle = paste0( # Combine several different elements together
		 	strftime(min(speeding$datetime, na.rm = TRUE), format = "%b. %e, %Y"), # The earliest date in the data
		 	" - ", # A hyphen
		 	strftime(max(speeding$datetime, na.rm = TRUE), format = "%b. %e, %Y"), # The latest date in the data
		 	". Source: Minnesota State Patrol" # A credit line
		 ), # End the subtitle line
		 caption = "Pioneer Press graphic by David H. Montgomery", # Caption
		 x = "Date", # X-axis label
		 y = "Speeding tickets per day") # Y-axis label
ggsave("speeding-days.png", width = 12)


ggplot(mncounties.f, aes(x=long, y=lat, group=group)) +
	geom_polygon(aes(fill = tickets.percap), color="white", lwd=0.2) +
	geom_polygon(data = trunkhwy.f, lwd = 0.2, color = "black", alpha = 0.5) +
	theme_nothing(legend=TRUE) +
	scale_fill_distiller(name= "Tickets per capita", palette="PuBu", direction = 1) +
	labs(title = "Where does the Minnesota State Patrol issue speeding tickets?",
		 subtitle = paste0(
		 	strftime(min(speeding$datetime), format = "%b. %e, %Y"),
		 	" - ",
		 	strftime(max(speeding$datetime), format = "%b. %e, %Y"),
		 	". Source: Minnesota State Patrol"
		 ),
		 caption = "Pioneer Press map by David H. Montgomery")
ggsave("speeding-map.png", height = 9.5)


ggplot(speeding %>% filter(milesover >= 0), aes(milesover)) +
	#geom_histogram(breaks = seq(from = 0, to = 40, by = 1)) + 
	geom_bar(aes(y = (..count..)/sum(..count..))) +
	scale_y_continuous("Percent of speeding tickets", labels = percent, limits = c(0,0.3)) +
	scale_x_continuous(limits = c(0,40), breaks = seq(0, 40, by = 5)) +
	theme_minimal() +
	theme(text= element_text(size = 20)) +
	labs(title = "How fast are Minnesota highway speeders going?",
		 subtitle = paste0(
		 	strftime(min(speeding$datetime), format = "%b. %e, %Y"),
		 	" - ",
		 	strftime(max(speeding$datetime), format = "%b. %e, %Y"),
		 	". Source: Minnesota State Patrol"
		 ),
		 caption = "Pioneer Press graphic by David H. Montgomery",
		 x = "Miles over the posted speed limit")
ggsave("speeding-milesover.png", width = 12)
