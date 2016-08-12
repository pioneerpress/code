# Syrian ancestry map
by David H. Montgomery

Automatically create choropleth maps showing the prevalence of people of Syrian ancestry in the United States using R. Based off of the 2014 release of the American Community Survey's 5-year estimates, from [code by Ari Lamstein](http://www.arilamstein.com/blog/2015/11/16/search-census-data-r/). See below for ways to customize the code to produce different types of maps or map different Census data.

When run in full, code will create three maps: 
- [syrian_norm.jpg](https://raw.githubusercontent.com/pioneerpress/code/master/syrian-map/Maps/syrian_norm.jpg) maps the absolute number of people of Syrian descent living in each US county:
![Syrians in US counties](https://raw.githubusercontent.com/pioneerpress/code/master/syrian-map/Small%20Maps/syrian_norm_sm.jpg)
- [syrian_pc.jpg](https://raw.githubusercontent.com/pioneerpress/code/master/syrian-map/Maps/syrian_pc.jpg) maps the people of Syrian ancestry in each US county per 100,000 residents:
![Syrians per 100,000 people in US counties](https://raw.githubusercontent.com/pioneerpress/code/master/syrian-map/Small%20Maps/syrian_pc_sm.jpg)
- [syrian_log.jpg](https://raw.githubusercontent.com/pioneerpress/code/master/syrian-map/Maps/syrian_log.jpg) maps the absolute number of Syrians in each county, but on a logarithmic scale:
![Syrians in US counties, log scale](https://raw.githubusercontent.com/pioneerpress/code/master/syrian-map/Small%20Maps/syrian_log_sm.jpg)

This code can be freely customized. A few possible changes:
- To change the size of the outputted images, change the "width=1000,height=600" portions of each of the three county_choropleth() functions to your preferred pixel height. You'll want to preserve that approximate aspect ratio, though, for best appearance.
- To create a vector image that can be edited in Illustrator or a similar program, change the jpeg() functions to pdf() or svg() functions. (When doing so, you'll need to change the size from pixels to inches.) I did this for display purposes to change the log scale from "0, 1, 2, 3" into "0, 10, 100, 1,000", which makes a lot more sense for readers.
- To map a different ethnicity, all you need to do is pull a different column of the ACS table of ancestry. Run acs.lookup() searching for the nationality of your choice. For example: acs.lookup(endyear=2014, keyword="Irish", table.number = "B04006") will find the column for people of Irish ancestry (#49) — as well as the column for Scotch-Irish ancestry (#66). To map this new data, change the column_idx= variable in the get_acs_data function to your desired column, like so: s = get_acs_data("B04006", "county", column_idx=49). The rest of the code can run as is, though you'll probably want to change the filenames and map titles in your county_choropleth() code away from "Syrian."

This code, and all code published on the Pioneer Press Github, is made available under the [MIT License](http://opensource.org/licenses/MIT).
