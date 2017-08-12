# Animated Minnesota population pyramids

by David H. Montgomery

Data and R code used to create animated population pyramds for each Minnesota county based on projections through 2045, to accompany <a href="http://blogs.twincities.com/politics/2015/08/09/visualized-minnesotas-greying-future/">this story</a>.

Projections created by the Minnesota State Demographic Center. Original data available <a href="http://mn.gov/admin/demography/data-by-topic/population-data/our-projections/index.jsp">here</a>.

The code animated-pop-pyramids-mn.R requires <a href="http://www.imagemagick.org/script/index.php">ImageMagick</a> installed to create animated GIFs. On my Macintosh, the R app was unable to call the ImageMagick code, so I had to run the code in the Terminal to successfully create the GIFs.

Output of this code will be 87 GIF files, one for each Minnesota county.

I further created an <a href="https://www.google.com/fusiontables/embedviz?q=select+col4%3E%3E1+from+15swKBAFNN1Qw6LISvXVmnqrTgdFvF-xLcox9X1eb&viz=MAP&h=false&lat=46.26309568045278&lng=-92.5205640625&t=1&z=6&l=col4%3E%3E1&y=2&tmplt=2&hml=KML">interactive map</a> using this data through Google Fusion Tables, by uploading each GIF to a server (in this case, Dropbox) and calling that image's URL inside the info window. (Update 8/12/2017: Changes at Dropbox have broken the interactive map. I'm working on a new solution.)

Output looks like this for each county:

![Scott County](https://raw.githubusercontent.com/pioneerpress/code/master/mn-pop-pyramid-gifs/scott.gif)

This code, and all code published on the Pioneer Press Github, is made available under the [MIT License](http://opensource.org/licenses/MIT).
