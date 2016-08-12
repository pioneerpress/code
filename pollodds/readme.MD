# Calculate poll odds

Most discussions of polls include a reference to the margin of error. For example, an [Aug. 10, 2016 Bloomberg Politics poll](http://www.bloomberg.com/politics/articles/2016-08-10/bloomberg-politics-national-poll) found Hillary Clinton leading Donald Trump 50 percent to 44 percent with a margin of error plus-or-minus 3.6 percentage points.

Software developer Dan Vanderkam [points out](http://www.danvk.org/wp/2008-09-25/how-to-read-polls/) that most people don't quite know how to interpret margin of error. Does it mean Clinton's lead is statistically significant because it's greater than the 3.6-point margin of error? Or that Clinton's six-point lead is not statistically significant because it's less than twice the margin of error, or 7.4 percent?

In fact, the answer is that a lead is significant if it's greater than 1.6 times the margin of error, for gory mathematical reasons Vanderkam [goes into](http://www.danvk.org/wp/2008-09-25/how-to-read-polls/). But Vanderkam's larger point is that there is a better way to think about error margins in polls: given the poll's results, what are the odds that a candidate is ACTUALLY ahead?

"It’s easier to interpret the statement 'There’s an 86.5% chance that Obama is ahead' than a statement about margins of error," Vanderkam writes.

For the Bloomberg poll, for example, there is a 95.5 percent that Hillary Clinton is actually ahead given the results and margin of error. There's a 4.5 percent chance that sampling error means Donald Trump is actually ahead. (This makes sense given the prior paragraph. Statistics traditionally concludes a result is significant if there's a 95 percent chance it didn't occur by random chance; the chance Clinton is really ahead is just above 95 percent — and her six-point lead is just above 1.6 times the 3.6 percent margin of error, or 5.76 percentage points.)

That can be calculated using Bayesian statistics and an integral, using a function called the "[regularized incomplete beta function](http://en.wikipedia.org/wiki/Regularized_incomplete_beta_function)". It's a little tricky and every time I try to calculate it, it takes me about 10 minutes to re-figure out how to do it.

So I've whipped up this simple R function that does the math for me — or for you. Load `winnerodds.R`, run it with some basic data about the poll, and it will tell you the odds that each candidate is winning given the poll. 

The variables you'll need:

- `samplesize`: The number of respondents in the poll.
- `cand1`: The name of the first candidate. Defaults to "Candidate 1".
- `cand2`: The name of the second candidate. Defaults to "Candidate 2".
- `cand1.pct`: The percent of the vote the first candidate got in the poll, in decimal form (e.g, .49).
- `cand2.pct`: The percent of the vote the second candidate got in the poll.

Here's how the script works for the Bloomberg poll discussed here: 
```
> winnerodds(749,"Hillary Clinton","Donald Trump",.5,.44)
The poll showed Hillary Clinton with 50% of the vote and Donald Trump with 44% of the vote.
There is a 95.5% chance Hillary Clinton is winning based on this poll.
There is a 4.5% chance Donald Trump is winning based on this poll.
```

This code, and all code published on the Pioneer Press Github, is made available under the [MIT License](http://opensource.org/licenses/MIT).
