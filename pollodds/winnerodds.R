# A simple function to calculate the odds that one candidate is actually ahead of a second candidate given a poll showing the percentage of respondents backing each candidate.
# Parameters include:
#   - samplesize: The number of respondents in the poll.
#   - cand1: The name of the first candidate.
#   - cand2: The name of the second candidate.
#   - cand1.pct: The percent of the vote the first candidate got in the poll, in decimal form (e.g, .49)
#   - cand2.pct: The percentage of the vote the second candidate got in the poll
# Sample output for a poll with 732 respondents showing Barack Obama with 50% and John McCain with 46%:
##> winnerodds(732,"Barack Obama","John McCain",.5,.46)
##The poll showed Barack Obama with 50% of the vote and John McCain with 46% of the vote.
##There is a 86.55% chance Barack Obama is winning based on this poll.
##There is a 13.45% chance John McCain is winning based on this poll.
# Script written by David Montgomery for the Pioneer Press.
# Based on "How to read polls" by Dan Vanderkam: http://www.danvk.org/wp/2008-09-25/how-to-read-polls/

winnerodds <- function(samplesize,cand1 = "Candidate 1",cand2 = "Candidate 2",cand1.pct, cand2.pct) {
    odds <- pbeta(.5,samplesize*cand1.pct,samplesize*cand2.pct)
    inv.odds <- 1-odds
            cat(
                paste0("The poll showed ",cand1," with ",round(cand1.pct*100,2),"% of the vote and ",cand2," with ",round(cand2.pct*100,2),"% of the vote."),
                paste0("There is a ",round(inv.odds*100,2),"% chance ",cand1," is winning based on this poll."),
                paste0("There is a ",round(odds*100,2),"% chance ",cand2," is winning based on this poll."),
            sep = "\n"
        )
}
