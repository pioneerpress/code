library(gganimate)
library(tweenr)

p <- ggplot(speeding.months, aes(yearmon, tickets, frame = yearmon)) +
	geom_col(aes(cumulative = TRUE)) +
	#scale_fill_manual(values = colors) +
	#geom_col(data = speeding.months %>% filter(month %in% c("06", "07", "08")), fill = "red") +
	#geom_col(data = speeding.months %>% filter(month %in% c("01", "02", "12")), fill = "blue") +
	scale_y_continuous(labels = comma) +
	scale_x_date(date_breaks = "4 months", date_labels = "%b. %y") +
	theme_minimal() +
	theme(legend.position = "none",
		  plot.title = element_text(size = 20),
		  text = element_text(size = 15)) +
	labs(title = "Speeding tickets issued by month on Minnesota highways",
		 subtitle = paste0(
		 	strftime(min(speeding$datetime, na.rm = TRUE), format = "%b. %e, %Y"),
		 	" - ",
		 	strftime(max(speeding$datetime, na.rm = TRUE), format = "%b. %e, %Y"),
		 	". Source: Minnesota State Patrol"
		 ),
		 caption = "Pioneer Press graphic by David H. Montgomery",
		 x = "Month",
		 y = "Speeding tickets issued")
gganimate(p, interval = 0.1, "speeding-months.gif", title_frame = F, ani.width = 626, ani.height = 360)

q <- ggplot(speeding %>% group_by(year = year(datetime)) %>% filter(year != 2017) %>% summarize(tickets = n()), aes(year, tickets, frame = year)) +
	geom_col(aes(cumulative = TRUE)) +
	scale_y_continuous(labels = comma) +
	theme_minimal() + 
	theme(plot.title = element_text(size = 20),
		  text = element_text(size = 15)) +
	labs(title = "Speeding tickets per year by Minnesota State Patrol",
		 subtitle = paste0(
		 	strftime(min(speeding$datetime, na.rm = TRUE), format = "%b. %e, %Y"),
		 	" - ",
		 	strftime(max(speeding$datetime, na.rm = TRUE), format = "%b. %e, %Y"),
		 	". Source: Minnesota State Patrol"
		 ),
		 caption = "Pioneer Press graphic by David H. Montgomery",
		 x = "",
		 y = "Speeding tickets")
gganimate(q, "speeding-years.gif", title_frame = F, ani.width = 626, ani.height = 360)


speedtime <- speeding %>% group_by(hour = floor(decimaltime), weekend) %>% summarize(tickets = n()) %>% ungroup() %>% group_by(weekend) %>% mutate(ticketsper = tickets/sum(tickets))

speedtime$weekend <- toupper(speedtime$weekend)
speedtime$weekend <- gsub("Y","YS?**", speedtime$weekend)
speedtime$weekend <- gsub("END","ENDS?**", speedtime$weekend)
speedtime$weekend <- gsub("W","**W", speedtime$weekend)

#ts <- tween_states(speedtime1, tweenlength = 2, statelength = 1, ease = "back-in-out", nframes = 20)

r <- ggplot(speedtime, aes(hour, ticketsper, frame = weekend)) +
	geom_col(position = "identity") +
	scale_y_continuous(labels = percent) +
	scale_x_continuous(breaks = c(0, 4, 8, 12, 16, 20, 24), labels = c("Midnight", "4 a.m.", "8 a.m.", "Noon", "4 p.m.","8 p.m.","")) +
	#facet_wrap(~ weekend) +
	theme_bw() +
	labs(title = "What time of day are people ticketed on Minnesota highways on",
		 subtitle = paste0(
		 	strftime(min(speeding$datetime), format = "%b. %e, %Y"),
		 	" - ",
		 	strftime(max(speeding$datetime), format = "%b. %e, %Y"),
		 	". Source: Minnesota State Patrol"
		 ),
		 caption = "Pioneer Press graphic by David H. Montgomery",
		 x = "Hour of the day", 
		 y = "Percent of tickets written")

gganimate(r, "speeding-hours.gif", title_frame = T, ani.width = 626, ani.height = 360)

source("https://gist.githubusercontent.com/jslefche/eff85ef06b4705e6efbc/raw/736d3dc9fe71863ea62964d9132fded5e3144ad7/theme_black.R")
s <- ggplot(speeding %>% group_by(hour = floor(decimaltime), weekend) %>% summarize(tickets = n()) %>% ungroup() %>% group_by(weekend) %>% mutate(ticketsper = tickets/sum(tickets)) %>% filter(weekend == "Weekday"), aes(hour, ticketsper, frame = hour)) +
	geom_col(aes(cumulative = TRUE), fill = "royalblue") +
	scale_y_continuous(labels = percent) +
	scale_x_continuous(breaks = c(0, 4, 8, 12, 16, 20, 24), labels = c("Midnight", "4 a.m.", "8 a.m.", "Noon", "4 p.m.","8 p.m.",""), minor_breaks = seq(1, 24, by = 1)) +
	coord_polar(start = -.11) +
	#facet_wrap(~ weekend) +
	#theme_bw() +
	theme_black() +
	theme(axis.text.y = element_blank(),
		  axis.ticks.y = element_blank(),
		  axis.text.x = element_text(size = 25),
		  panel.grid = element_line(size = 1.5),
		  plot.title = element_text(size = 40),
		  plot.margin = unit(c(1, 2.5, 0.5, 2.5), "lines"), 
		  text = element_text(size = 20)) +
	labs(title = "When on weekdays do people get\nspeeding tickets on MN highways?",
		 subtitle = paste0(
		 	"Data from ",
		 	strftime(min(speeding$datetime), format = "%b. %e, %Y"),
		 	" - ",
		 	strftime(max(speeding$datetime), format = "%b. %e, %Y"),
		 	". Source: Minnesota State Patrol"
		 ),
		 caption = "Pioneer Press graphic by David H. Montgomery",
		 x = "", 
		 y = "")
gganimate(s, "speeding-hours-polar.gif", title_frame = F, ani.width = 850, ani.height = 800, interval = 0.2)