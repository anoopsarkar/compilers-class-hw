"""
First run `python zipout.py` to create your output zipfile `output.zip` and output directory `./output`

Then run:

    python check.py

It will print out a score of all your outputs that matched the
testcases with a reference output file (typically `./references/dev/*.out`).
In some cases the output is supposed to fail in which case it
compares the `*.ret` files instead.

To customize the files used by default, run:

    python check.py -h
"""

import sys, os, optparse, logging, tempfile, subprocess, shutil, difflib
from collections import defaultdict
import iocollect

class Check:

    def __init__(self, opts):
        self.ref_dir = opts.ref_dir                        # directory where references are placed
        self.zipfile = iocollect.extract_zip(opts.zipfile) # contents of output zipfile produced by `python zipout.py` as a dict
        self.linesep = "%c" % (os.linesep)                 # os independent line separator
        self.path_score = {'dev': 1, 'test': 2}            # set up this dict to score different testcases differently
        self.default_score = 1                             # default score if it does not exist in path_values

        # perf is a dict used to keep track of total score based on testcase type with three keys:
        # each element of perf is a dict with three (key, value) pairs
        # num_correct: used to keep track of how many were correctly matched to reference output
        # total: used to keep track of total number of testcases with reference outputs
        # score: total score earned which depends on self.path_score or default_score
        self.perf = {}

    def check_path(self, path, files):
        logging.info("path=%s" % (path))
        tally = defaultdict(int)
        for filename in files:
            if path is None or path == '':
                testfile_path = os.path.abspath(os.path.join(self.ref_dir, filename))
                testfile_key = filename
            else:
                testfile_path = os.path.abspath(os.path.join(self.ref_dir, path, filename))
                testfile_key = os.path.join(path, filename)

            # set up score value for matching output correctly
            score = self.default_score
            if path in self.path_score:
                score = self.path_score[path]

            logging.info("Checking %s" % (testfile_key))
            if testfile_key in self.zipfile:
                with open(testfile_path, 'r') as ref:
                    ref_data = map(lambda x: x.strip(), ref.read().splitlines())
                    output_data = map(lambda x: x.strip(), self.zipfile[testfile_key].splitlines())
                    diff_lines = list(difflib.unified_diff(ref_data, output_data, "reference", "your-output", lineterm=''))
                    if len(diff_lines) > 0:
                        logging.info("Diff between reference and your output for %s" % (testfile_key))
                        logging.info("%s%s" % (self.linesep, self.linesep.join(list(diff_lines))))
                    else:
                        tally['score'] += score
                        tally['num_correct'] += 1
                        logging.info("%s Correct!" % (testfile_key))
                    tally['total'] += 1
        self.perf[path] = dict(tally)

    def check_all(self):
        # check if references has subdirectories
        ref_subdirs = iocollect.getdirs(os.path.abspath(self.ref_dir))
        if len(ref_subdirs) > 0:
            for subdir in ref_subdirs:
                files = iocollect.getfiles(os.path.abspath(os.path.join(self.ref_dir, subdir)))
                self.check_path(subdir, files)
        else:
            files = iocollect.getfiles(os.path.abspath(self.ref_dir))
            self.check_path(None, files)
        return self.perf

if __name__ == '__main__':
    #check_dir = os.path.dirname(os.path.abspath(sys.argv[0]))
    optparser = optparse.OptionParser()
    optparser.add_option("-t", "--refcases", dest="ref_dir", default='references', help="references directory [default: references]")
    optparser.add_option("-z", "--zipfile", dest="zipfile", default='output.zip', help="zip file created by zipout.py [default: output.zip]")
    optparser.add_option("-l", "--logfile", dest="logfile", default=None, help="log file for debugging")
    (opts, _) = optparser.parse_args()

    if opts.logfile is not None:
        logging.basicConfig(filename=opts.logfile, filemode='w', level=logging.INFO)

    check = Check(opts)
    perf = check.check_all()
    if perf is not None:
        total = 0
        for (d, tally) in perf.iteritems():
            print "Correct(%s): %d / %d" % (d, tally['num_correct'], tally['total'])
            print "Score(%s): %.02f" % (d, tally['score'])
            total += tally['score']
        print "Total Score: %.02f" % (total)
    else:
        print "Nothing to report!"

