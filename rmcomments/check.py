"""
First run `python zipout.py` to create your output zipfile `output.zip` and output directory `./output`

Then run:

    python check.py

It will print out a score of all your outputs that matched the
testcases with a reference output file (typically `./testcases/dev/*.out`).
In some cases the output is supposed to fail in which case it
compares the `*.ret` files instead.

To customize the files used by default, run:

    python check.py -h
"""

import sys, os, optparse, logging, tempfile, subprocess, shutil
import getfile

class Check:

    def __init__(self, opts):
        self.testcase_dir = opts.testcase_dir # directory where testcases are placed
        self.zipfile = getfile.extract_zip(opts.zipfile) # contents of output zipfile produced by `python zipout.py` as a dict

    def check_path(self, path, files):
        for filename in files:
            if path is None or path == '':
                testfile_path = os.path.abspath(os.path.join(self.testcase_dir, filename))
                testfile_key = filename
            else:
                testfile_path = os.path.abspath(os.path.join(self.testcase_dir, path, filename))
                testfile_key = os.path.join(path, filename)

            if testfile_key in self.zipfile:
                with open(testfile_path, 'r') as ref:
                    print ref.read()
                    print self.zipfile[testfile_key]

    def check_all(self):
        # check if testcases has subdirectories
        testcase_subdirs = getfile.getdirs(os.path.abspath(self.testcase_dir))

        if len(testcase_subdirs) > 0:
            for subdir in testcase_subdirs:
                files = getfile.getfiles(os.path.abspath(os.path.join(self.testcase_dir, subdir)))
                self.check_path(subdir, files)
        else:
            files = getfile.getfiles(os.path.abspath(self.testcase_dir))
            self.check_path(None, files)

        return True

if __name__ == '__main__':
    #check_dir = os.path.dirname(os.path.abspath(sys.argv[0]))
    optparser = optparse.OptionParser()
    optparser.add_option("-t", "--testcases", dest="testcase_dir", default='references', help="references directory [default: references]")
    optparser.add_option("-z", "--zipfile", dest="zipfile", default='output.zip', help="zip file created by zipout.py [default: output.zip]")
    optparser.add_option("-l", "--logfile", dest="logfile", default=None, help="log file for debugging")
    (opts, _) = optparser.parse_args()

    if opts.logfile is not None:
        logging.basicConfig(filename=opts.logfile, filemode='w', level=logging.INFO)

    check = Check(opts)
    check.check_all()

