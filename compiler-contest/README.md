
Submission Rules for the Compiler Contest
-----------------------------------------

1. Create at least 10 new testcases and at most 50 testcases that are distinct from the provided testcases for decafcomp (hw4). They must pass validation (see below).
1. Your testcases must pass and are expected to produce valid LLVM output that when compiled to binary produce some output after execution of the binary. Note that testcases expected to fail cannot be submitted to the contest.
1. In your answer directory create two new directories: `testcases/your-groupname` and `references/your-groupname` where `your-groupname` is the group name you have been using for the leaderboard.
1. The directory `testcases/your-groupname` should contain the Decaf source files named with a `.decaf` file name suffix.
1. The directory `references/your-groupname` should contain the Decaf source files named with a `.decaf` file name suffix.
1. You can create the contents of directory `references/your-groupname` by running `python zipout.py -t answer/testcases` and copying over the `.out` files to your references (sub)directory.
1. Enter the contest by emailing me your gitlab repo or github private repo. Include the full path to the answer directory in your URL. I will pull and compile your compiler from this repository.

The Contest
-----------

1. The email to me with the git repo link must reach me before Aug 10, 2016 9:30am to be considered for the contest.
1. The first phase of the contest will be a validation phase where I examine your output and make a decision about your program and the output being consistent with the Decaf spec.
1. I can remove testcases if I consider them to be invalid or producing the wrong output.
1. After I remove bad testcases, each group that has at least 10 testcases remaining will be tested in the contest.
1. If there are more than 50 remaining testcases, I will take the first 50 based on lexicographic sort.
1. The compiler from each participating group will be run on all the collected testcases. 
1. Whoever passes the most testcases will be the winner of the contest.
1. If there is a tie, the fastest compiler wins.
1. My compiler cannot be the winner.

The Prize
---------

* The prize for the winner of the contest is a $25 gift certificate from amazon.ca
* The prize will be handed out to the winner of the contest at the final exam.


