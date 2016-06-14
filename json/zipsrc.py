"""
Run:

    python zipsrc.py

This will create a file `source.zip` which you can upload to Coursys (courses.cs.sfu.ca) as your submission.

To customize the files used by default, run:

    python zipsrc.py -h
"""
import sys, os, optparse, shutil

if __name__ == '__main__':
    optparser = optparse.OptionParser()
    optparser.add_option("-a", "--answerdir", dest="answer_dir", default='answer', help="answer directory containing your source files")
    optparser.add_option("-z", "--zipfile", dest="zipfile", default='source', help="zip file you should upload to Coursys (courses.cs.sfu.ca)")
    (opts, _) = optparser.parse_args()

    outputs_zipfile = shutil.make_archive(opts.zipfile, 'zip', opts.answer_dir)
    print >>sys.stderr, "{0} created".format(outputs_zipfile)

