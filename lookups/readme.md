# Minnesota lookup tables

Tables with common reference data about Minnesota for quick and programmatic reference. 

Data is presented in two different formats:

- CSV spreadsheets presenting a periodically updated snapshot in time
- R scripts that pull the data from government websites on the fly, creating a data frame with up-to-date information whenever they are run.

The CSVs can be viewed and downloaded manually.

Both can be accessed directly from the command line. To access them in R, you need to point to the raw versions of each document.

For example, to directly load the County Populations CSV into R, run the following code:

`mncountypop <- read.csv("https://raw.githubusercontent.com/pioneerpress/code/master/lookups/mncountypop.csv")`

To run an R script and generate a fresh data frame, simply call the `source()` pointed at the raw R script. You don't need to assign this to an object.

`source("https://raw.githubusercontent.com/pioneerpress/code/master/lookups/mncitypop.r")`

This will create the data frame as an object in R.

Lookup tables currently in this folder (links go to raw file): 

Table | R? | CSV? | Updated
-------------|---|---|---- 
MN cities | [Yes](https://raw.githubusercontent.com/pioneerpress/code/master/lookups/mncitypop.r) | [Yes](https://raw.githubusercontent.com/pioneerpress/code/master/lookups/mncitypop.csv) | 2017-02-10
MN counties | [Yes](https://raw.githubusercontent.com/pioneerpress/code/master/lookups/mncountypop.r) | [Yes](https://raw.githubusercontent.com/pioneerpress/code/master/lookups/mncountypop.csv) | 2017-02-10
MN voter registration by county | [Yes](https://raw.githubusercontent.com/pioneerpress/code/master/lookups/mnvoterreg.r) | No  | 2017-02-10
2017-18 MN Legislature | No | [Yes](https://raw.githubusercontent.com/pioneerpress/code/master/lookups/mnleg17.csv) | 2017-02-10
