

A function to look up the share of the 2016 two-party presidential vote Hillary Clinton and Donald Trump received in a specified Minnesota legislative district.

Takes two inputs: `district` (either a number or a string, depending on the chamber) and `house` (a boolean that defaults to T)

If `house = T`, then district must be a string in the form "10A" or "10B" — a number between 1 and 67 with "A" or "B" appended at the end. Single-digit districts should be entered WITHOUT a leading zero.

If `house = F`, then district must be a bare, unquoted number between 1 and 67.

Output will be a string giving the share of the vote received in that district by Clinton and Trump in a sentence.

Sample: 
```
> source("https://raw.githubusercontent.com/pioneerpress/code/master/mnleg-prez/mnleg_prez.R")
> mnleg_prez(26, F)
[1] "Hillary Clinton got 49.6% of the two-party vote in Minnesota Senate District 26 
and Donald Trump got 50.4%."
> mnleg_prez("26A")
[1] "Hillary Clinton got 59.57% of the two-party vote in Minnesota House District 26A 
and Donald Trump got 40.43%."
```

Created by David H. Montgomery of the St. Paul Pioneer Press.
