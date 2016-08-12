# St. Anthony police department arrest data

Contains:
- `stanthony.zip`: raw data on arrests, citations and warnings given by the police department in St. Anthony, Minnesota.
- `st-anthony-data.R`: an R script to process the raw data and produce a single spreadsheet.
- `st-anthony-stats.csv`: one of the outputs of `st-anthony-data.R`, containing all the original St. Anthony spreadsheets combined into one.
- `summary-stats.csv`: another output of `st-anthony-data.R`, summarizing the police data by subject race.
- `summary-stats-readable.csv`: the final output of `st-anthony-data.R`. Basically `summary-stats.csv` but in a more human-readable format.
- `st-anthony-viz.R`: an R script that will take the outputs from `st-anthony-data.R` and produce a barplot of St. Anthony racial differences.
- `stanthony-stops.png`: The output of `st-anthony-viz.R`.

![St. Anthony disparities](https://raw.githubusercontent.com/pioneerpress/code/master/st-anthony-police/stanthony-stops.png)

This code, and all code published on the Pioneer Press Github, is made available under the [MIT License](http://opensource.org/licenses/MIT).
