# Minnesota Legislature vote mapper

A set of R scripts that will take a roll call vote from the Minnesota House of Representatives or the Minnesota Senate and produce a map showing how each member voted:

![](https://raw.githubusercontent.com/pioneerpress/code/master/votemapper/2017-03-02-accepting%20Senate%20Sunday%20Sales%20bill.png)

To set up this system, you must do the following after installing R and RStudio:

- Install the relevant packages: `install.packages("maptools", "RColorBrewer", "rgdal", "dplyr", "plotrix", "googlesheets")`
- Create a copy of [this Google Sheet](https://docs.google.com/spreadsheets/d/1LGjksM_yTPKuCDsIrUSH5AcmdfZXBrGWBaHVqxxno6E/edit#gid=1196600902) in your own Google Drive. Make sure the name is the same, "#mnleg Vote Tracker"
- Input votes on the `Vote Input` tab of your new sheet. This will likely have to be done manually. Votes must be one of the following three formats: "Y", "N" or "Absent"; both are case- and space-sensitive.
- Set your working directory to the folder containing `housevotetracker.R`, `senvotetracker.R`, `housemap` and `senatemap`
- Run either `senvotetracker.R` or `housevotetracker.R`, depending on which chamber you want to map
- Execute the function for the appropriate chamber. In the case of the Senate, you would type: `senvotetracker("Title", "Vote description", "Vote date")`
  - "Title" should be one or two words; if not beginning with a proper noun it should begin with a lowercase letter
  - "Vote description" should be a short- to medium-length sentence describing the vote
  - "Vote date" must be in a specific format: `"YYYY-MM-DD"`. For example, `"2017-09-01"` for Sept. 1, 2017.
  - For example, for the example map above, the code to generate that map once the proper votes are entered in the spreadsheet would be: `housevotetracker("accepting Senate Sunday Sales bill", "By concurring, House sends Sunday liquor sales to the governor", "2017-03-02")`
- The first time you run the script, you might need to authorize Google Sheets to talk to R via a browser window

The output image will save in your working directory as a .png.

Best practices:

- If you encounter any errors, make sure you haven't made any typos in the spreadsheet, such as typing a space after "Y" or "N"
- The script pulls votes based on what's in the `Vote Input` tab of the Google Sheet. Once you've mapped a vote, archive your roll call in the `2017 Senate Archive` or `2017 House Archive` sheets
- Do not edit the `Senate` or `House` tabs
- Be as descriptive as possible given space constraints in your title and description
- If your title or description runs off the page or overlaps other elements, shorten them

This code is released [under an MIT License](https://github.com/pioneerpress/code/blob/master/LICENSE). Please review the terms before using, copying, modifying or distributing the code.
