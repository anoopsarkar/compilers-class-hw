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
import iocollect

class Check:

    def __init__(self, opts):
        self.ref_dir = opts.ref_dir                        # directory where references are placed
        self.zipfile = iocollect.extract_zip(opts.zipfile) # contents of output zipfile produced by `python zipout.py` as a dict
        self.linesep = "%c" % (os.linesep)                 # os independent line separator
        self.counter = 0                                   # used to keep track of total reward based on testcase type
        self.correct = 0                                   # used to keep track of how many were correctly matched to reference output
        self.total = 0                                     # used to keep track of total number of testcases with references
        self.path_values = {'dev': 5, 'test': 10}          # set up this dict to reward different testcases differently
        self.default_reward = 5                            # default reward if it does not exist in path_values

    def check_path(self, path, files):
        for filename in files:
            if path is None or path == '':
                testfile_path = os.path.abspath(os.path.join(self.ref_dir, filename))
                testfile_key = filename
            else:
                testfile_path = os.path.abspath(os.path.join(self.ref_dir, path, filename))
                testfile_key = os.path.join(path, filename)

            # set up reward value for matching output correctly
            correct_reward = self.default_reward
            if path in self.path_values:
                correct_reward = self.path_values[path]

            logging.info("Checking %s" % (testfile_path))
            if testfile_key in self.zipfile:
                with open(testfile_path, 'r') as ref:
                    ref_data = ref.read()
                    output_data = self.zipfile[testfile_key]
                    diff_lines = list(difflib.unified_diff(ref_data.splitlines(), output_data.splitlines(), "reference", "your-output", lineterm=''))
                    if len(diff_lines) > 0:
                        print 80*'-'
                        print "Diff for %s" % (testfile_key)
                        print self.linesep.join(list(diff_lines))
                    else:
                        self.counter += correct_reward
                        self.correct += 1
                        logging.info("Correct! %s" % (testfile_path))
                    self.total += 1

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

        print 80*'-'
        print "Correct: %d / %d" % (self.correct, self.total)
        print "Score: %.02f" % (self.counter)
        return True

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
    check.check_all()

