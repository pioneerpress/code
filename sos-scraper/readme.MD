# 2016 Minnesota primary election scraper

Two R scripts that download election data from the Minnesota Secretary of State's FTP server, process that data, and output CSVs and a map.

The scripts are specific for the Aug. 9, 2016 primary election; one of them is specific to the 2nd Congressional District GOP primary. However, techniques in the scripts can be easily generalized for other races.

A username and password to access the FTP server is required but not provided.

The scripts can be run repeatedly from the command line as results are updated.

The map produced by the script: 

![CD2 map](https://raw.githubusercontent.com/pioneerpress/code/master/sos-scraper/cd2map.png)

This code, and all code published on the Pioneer Press Github, is made available under the [MIT License](http://opensource.org/licenses/MIT).
