# Code and data for Pioneer Press speeding ticket project

For the Sunday, Aug. 13, 2017 *St. Paul Pioneer Press*, reporters David Montgomery and Sophie Carson produced an analysis of Minnesota State Patrol speeding ticket data.

This repository contains:

- `speeding-raw.csv`: A CSV version of speeding ticket data from Dec. 31, 2013 to June 18, 2017, as provided to the Pioneer Press by the Minnesota State Patrol.
- `speeding-clean.csv`: A CSV version of `speeding-raw.csv` after having been processed by an R script.
- `speeding.md`: Code used to analyze the speeding data, inline with a narrative exploring what it means. This was the beginning of the project; some but not all of the observations and charts in this initial analysis would make it to the final project. 
- `speeding_files`: A folder containing images for `speeding.md`.
- `stateth.zip`: A zip of shapefiles of Minnesota's trunk highway network
- `mn counties`: A folder containing shapefiles of Minnesota's county borders
- `printexports.R`: An R script used to create graphics for online publication. Requires code in `speeding.md` to have been run first in order to get data into the proper function.
- `animation.R`: An R script used to create animated charts for online publication. Requires code in `speeding.md` to have been run first in order to get data into the proper function.
- `images`: A folder containing images produced by `printexports.R` and `animation.R`.
