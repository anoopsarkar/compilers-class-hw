"""
Run:

    python zipcontest.py

This will create a file `contest.zip` which you can upload to Coursys (courses.cs.sfu.ca) as part of your submission.

To customize the files used by default, run:

    python zipcontest.py -h
"""
import sys, os, optparse, zipfile

if __name__ == '__main__':
    #zipout_dir = os.path.dirname(os.path.abspath(sys.argv[0]))
    optparser = optparse.OptionParser()
    optparser.add_option("-t", "--testcases", dest="testcase_dir", default='testcases', help="testcases directory [default: testcases]")
    optparser.add_option("-r", "--references", dest="reference_dir", default='references', help="references directory [default: references]")
    optparser.add_option("-z", "--zipfile", dest="zipfile", default='contest.zip', help="zip file with your final contest testcases and references")
    optparser.add_option("-i", "--ignore", dest="ignore_dirs", action="append", default=['dev','test'], help="ignore these directories when creating zip file")
    (opts, _) = optparser.parse_args()

    with zipfile.ZipFile(opts.zipfile, "w") as zo:
        for dir in {opts.testcase_dir, opts.reference_dir}:
            ignore = [ os.path.join(dir, ignore_dir) for ignore_dir in opts.ignore_dirs ]
            for (dirname, subdirs, files) in os.walk(dir):
                if len(files) == 0:
                    continue
                if dirname not in ignore:
                    zo.write(dirname)
                    for file_name in files:
                        zo.write(os.path.join(dirname, file_name))
                        print(dir, dirname, subdirs, file_name)
    print("{} created".format(opts.zipfile), file=sys.stderr)
