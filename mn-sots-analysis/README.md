# Minnesota State of the State address analysis
by David H. Montgomery
<p>Minnesota governors have given State of the State addresses since 1969. I analyzed the most unique words for each governor for <a href="http://blogs.twincities.com/politics/2015/04/10/governors-by-their-words/">this Pioneer Press article</a>.</p>
<p>This repository contains:</p>
<ul><li>The text of each of those speeches, as extracted from PDF documents published <a href="http://www.leg.state.mn.us/lrl/mngov/stateofstate">here</a> (the "Yearly Texts" folder).</li>
<li>Text files for each of Minnesota's governors since 1969 containing the text of those governors' State of the State speeches (the "Governor Texts" folder).</li>
<li>Compilations containing the full text of every Minnesota State of the State in one text file, and the full texts of all Democratic-Farmer-Labor Party addresses and all Republican Party addresses in one text file each (the "Compiled Texts" folder).</li></ul>
Additionally, this repository contains code used to compile and analyze this data:
<ul><li>"compilation-terminal-code.txt" is Terminal code for a Unix-based system to take the individual files for each year and produce combined files for each governor, for each political party and for all governors combined. Tested on a Mac OS X platform.</li>
<li>"gov_count_words.R" is R-code that will, when run, produce a CSV file for each governor with how often they used each word in their State of the State addresses.</li>
<li>"gov_wordcloud.R" is R-code that will produce a wordcloud graphic showing the most commonly used words in each governor's State of the State addresses.</li></ul>
Finally, included in this repository are the CSV tables produced by running the "gov_count_words.R" code, as well as word frequency tables for all governors, all DFL governors and all Republican governors. These files are contained in the "Comparison Tables" folder. A "Summary Table.xlsx" file lists the most unique words for each governor and party.
This code, and all code published on the Pioneer Press Github, is made available under the [MIT License](http://opensource.org/licenses/MIT).
