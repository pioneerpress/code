# FEC report grabber

A pair of R functions that will download a candidate's quarterly FEC report, process it, and produce summary tables for the report's top donors by state, city, occupation and employer, and top expenses by kind and recipient.

The first function, fecgrabber(), is normally all you'll need to run, after giving it a title and an ID for the report. The ID number can be obtained from the Filings page on a candidate's FEC page, under the View/Download column. It is the numeric part of a string such as "FEC-1061533" — so, in this case, the ID would be 1061533.

![FEC sample](https://raw.githubusercontent.com/pioneerpress/code/master/misc-images/fec-screengrab.jpg)

The second function, fecanalyzer(), is normally called as a helper function to fecgrabber(). However, it can be called on its own — helpful if the output of fecgrabber() needs manual cleaning.

This code, and all code published on the Pioneer Press Github, is made available under the [MIT License](http://opensource.org/licenses/MIT).
