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

class Check:

    def __init__(self, opts):
        self.testcase_dir = opts.testcase_dir # directory where testcases are placed
        self.output_dir = opts.output_dir # location of output files produced by `python zipout.py`
        self.zipfile = opts.zipfile # location of output zipfile produced by `python zipout.py`

    def getfiles(self, path):
        if os.path.isdir(path):
            return set(f for f in os.listdir(path) if not f[0] == '.')
        else:
            logging.error("invalid directory or path: %s" % path)
            return []

    def getdirs(self, path):
        if os.path.isdir(path):
            return set(f for f in os.listdir(path) if (f[0] != '.') and os.path.isdir(os.path.join(path, f)))
        else:
            logging.error("invalid directory or path: %s" % path)
            return []

    def check_all(self):
        # check if testcases has subdirectories
        testcase_subdirs = self.getdirs(os.path.abspath(self.testcase_dir))

        if len(testcase_subdirs) > 0:
            for subdir in testcase_subdirs:
                files = self.getfiles(os.path.abspath(os.path.join(self.testcase_dir, subdir)))
                #self.run_path(subdir, files)
        else:
            files = self.getfiles(os.path.abspath(self.testcase_dir))
            #self.run_path(None, files)

        print files
        return True

if __name__ == '__main__':
    #check_dir = os.path.dirname(os.path.abspath(sys.argv[0]))
    optparser = optparse.OptionParser()
    optparser.add_option("-t", "--testcases", dest="testcase_dir", default='references', help="references directory [default: references]")
    optparser.add_option("-o", "--outputdir", dest="output_dir", default='output', help="output directory created by zipout.py [default: output]")
    optparser.add_option("-z", "--zipfile", dest="zipfile", default='output.zip', help="zip file created by zipout.py [default: output.zip]")
    optparser.add_option("-l", "--logfile", dest="logfile", default=None, help="log file for debugging")
    (opts, _) = optparser.parse_args()

    if opts.logfile is not None:
        logging.basicConfig(filename=opts.logfile, filemode='w', level=logging.INFO)

    check = Check(opts)
    check.check_all()

