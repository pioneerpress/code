# Minnesota House W-NOMINATE code

Three R scripts to produce and visualize ideology estimates for the 2015-17 Minnesota House of Representatives. Also data produced by running this code, used in the story ["How liberal or conservative is your state representative?"](http://www.twincities.com/2016/09/06/how-liberal-or-conservative-is-your-state-representative/).

The code here was written by David H. Montgomery for the Pioneer Press, and is made available under the [MIT License](http://opensource.org/licenses/MIT). The data, `nominate-scores.csv`, is made available under the [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/).

Uses the WNOMINATE package by Poole, Keith, Jeffrey Lewis, James Lo, and Royce Carroll. 2011. ["Scaling Roll Call Votes with wnominate in R"](http://www.jstatsoft.org/v42/i14/paper).

- `mnleg-nominate.r` does the heavy lifting: it downloads the roll call vote data from the Sunlight Foundation's [OpenStates project](http://openstates.org/downloads/), processes it, then uses the WNOMINATE package to produce ideology estimates for each lawmaker and saves it as a CSV. This could take about 10 to 20 minutes, depending on the speed of your machine.
- `nominate-rank.r` produces this chart, plotting the ideology estimates in rank-order:
![Rank graph](https://github.com/pioneerpress/code/blob/master/mnleg-nominate/mnleg-nominate.png?raw=true)
- `nominate-elex.r` produces this chart, plotting the ideology estimates against Mitt Romney's share of the two-party vote in each lawmaker's district in the 2012 presidential election:
![Election graph](https://github.com/pioneerpress/code/blob/master/mnleg-nominate/nominate-margin.png?raw=true)

Note that `nominate-rank.r` and `nominate-elex.r` are designed to read a CSV file called 'nomscores.csv', not the `nominate-scores.csv` included in the file. The graphics may not work if you simply point them to that CSV, because it was produced using an earlier version of the code and has different column order. To generate `nomscores.csv`, run `mnleg-nominate.r`. 

Both images uploaded to this repository have been reduced in size from the 2000 px square images produced by the scripts.

You will likely end up with slightly different ideology estimates than the ones used in `nominate-scores.csv` and the story. That's because these are estimated ideology, and will naturally vary slightly from trial to trial. If you have drastic variations — extremists showing as moderates, or even as voting with the other party — something has gone wrong.
