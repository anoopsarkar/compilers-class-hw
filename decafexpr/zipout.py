"""
First build the executable for your answer in ./answer/

Then run:

    python zipout.py

This will create a file `output.zip` which you can upload to the leaderboard on sfu-yacc.appspot.com

To customize the files used by default, run:

    python zipout.py -h
"""

import sys, os, optparse, logging, tempfile, subprocess, shutil
import iocollect

class ZipOutput:

    def __init__(self, opts):
        self.run_program = opts.run_program # solution to hw that is being tested
        self.use_llvm_run = opts.use_llvm_run # use the llvm_run program to compile the output using LLVM
        self.llvm_run = opts.llvm_run # use this program to compile the output using LLVM and execute that binary to get stdout, stderr
        self.stdlib = opts.stdlib # standard library source code to link with output when creating the binary
        self.answer_dir = opts.answer_dir # name of directory where run_program exists
        self.testcase_dir = opts.testcase_dir # directory where testcases are placed
        self.output_dir = opts.output_dir # directory for output files of your program
        self.file_suffix = opts.file_suffix # file suffix for testcases

    def mkdirp(self, path):
        try:
            os.makedirs(path)
        except os.error:
            print("Warning: {} already exists. Existing files will be over-written.".format(os.path.join(self.output_dir, (os.path.basename(path)))), file=sys.stderr)
            pass

    def run(self, filename, path, output_path, base):
        """
        Runs a command specified by an argument vector (including the program name)
        and returns lists of lines from stdout and stderr.
        """

        # create the output files 
        if output_path is not None:
            stdout_path = os.path.join(output_path, "{}.out".format(base))
            stderr_path = os.path.join(output_path, "{}.err".format(base))

            # existing files are erased!
            stdout_file = open(stdout_path, 'w')
            stderr_file = open(stderr_path, 'w')
            status_path = os.path.join(output_path, "{}.ret".format(base))
        else:
            stdout_file, stdout_path = tempfile.mkstemp("stdout")
            stderr_file, stderr_path = tempfile.mkstemp("stderr")
            status_path = None

        run_program_path = os.path.abspath(os.path.join(self.answer_dir, self.run_program))
        if (self.use_llvm_run):
            llvm_run_path = os.path.abspath(os.path.join(self.answer_dir, self.llvm_run))
            if os.path.exists(llvm_run_path) and os.access(llvm_run_path, os.X_OK):
                stdlib_path = os.path.abspath(os.path.join(self.answer_dir, self.stdlib))
                argv = [ llvm_run_path, '-c', run_program_path, '-l', stdlib_path, filename, "llvm", path, base ]
                stdin_file = sys.stdin
            else:
                print("error: something went wrong when trying to run the following command:", file=sys.stderr)
                raise
        else:
            argv = run_program_path
            stdin_file = open(filename, 'r')
        try:
            try:
                prog = subprocess.Popen(argv, stdin=stdin_file or subprocess.PIPE, stdout=stdout_file, stderr=stderr_file)
                if stdin_file is None:
                    prog.stdin.close()
                prog.wait()
            finally:
                if output_path is not None:
                    stdout_file.close()
                    stderr_file.close()
                else:
                    os.close(stdout_file)
                    os.close(stderr_file)
            if status_path is not None:
                with open(status_path, 'w') as status_file:
                  print(prog.returncode, file=status_file)
            with open(stdout_path) as stdout_input:
                stdout_lines = list(stdout_input)
            with open(stderr_path) as stderr_input:
                stderr_lines = list(stderr_input)
            if prog.stdin != None:
                prog.stdin.close()
            return stdout_lines, stderr_lines, prog.returncode
        except:
            print("error: something went wrong when trying to run the following command:", file=sys.stderr)
            print(argv, file=sys.stderr)
            raise
            #sys.exit(1)
        finally:
            if output_path is None:
                os.remove(stdout_path)
                os.remove(stderr_path)

    def run_path(self, path, files):
        print("running on {} files".format(path), file=sys.stderr)
        # set up output directory
        if path is None or path == '':
            output_path = os.path.abspath(self.output_dir)
        else:
            output_path = os.path.abspath(os.path.join(self.output_dir, path))
        self.mkdirp(output_path)
        for filename in files:
            if path is None or path == '':
                testfile_path = os.path.abspath(os.path.join(self.testcase_dir, filename))
            else:
                testfile_path = os.path.abspath(os.path.join(self.testcase_dir, path, filename))
            if filename[-len(self.file_suffix):] == self.file_suffix:
                base = filename[:-len(self.file_suffix)]
                if os.path.exists(testfile_path):
                    self.run(testfile_path, path, output_path, base)

    def run_all(self):
        # check that a compiled binary exists to run on the testcases
        argv = os.path.abspath(os.path.join(self.answer_dir, self.run_program))
        if not (os.path.isfile(argv) and os.access(argv, os.X_OK)):
            logging.error("executable missing: {}".format(argv))
            print("Compile your source file to create an executable {}".format(argv), file=sys.stderr)
            sys.exit(1)

        # check if testcases has subdirectories
        testcase_subdirs = iocollect.getdirs(os.path.abspath(self.testcase_dir))

        if len(testcase_subdirs) > 0:
            for subdir in testcase_subdirs:
                files = iocollect.getfiles(os.path.abspath(os.path.join(self.testcase_dir, subdir)))
                self.run_path(subdir, files)
        else:
            files = iocollect.getfiles(os.path.abspath(self.testcase_dir))
            self.run_path(None, files)

        return True

if __name__ == '__main__':
    #zipout_dir = os.path.dirname(os.path.abspath(sys.argv[0]))
    optparser = optparse.OptionParser()
    optparser.add_option("-r", "--run", dest="run_program", default='decafexpr', help="run this program against testcases [default: decafexpr]")
    optparser.add_option("--use-llvm-run", dest="use_llvm_run", action="store_true", default=True, help="run this program to compile using LLVM tools [default: True]")
    optparser.add_option("-x", "--llvmrun", dest="llvm_run", default='llvm-run', help="run this program to compile using this binary to call LLVM tools [default: llvm-run]")
    optparser.add_option("-s", "--stdlib", dest="stdlib", default='decaf-stdlib.c', help="optional standard library to link during llvm run [default: decaf-stdlib.c]")
    optparser.add_option("-a", "--answerdir", dest="answer_dir", default='answer', help="answer directory [default: answer]")
    optparser.add_option("-t", "--testcases", dest="testcase_dir", default='testcases', help="testcases directory [default: testcases]")
    optparser.add_option("-e", "--ending", dest="file_suffix", default='.decaf', help="suffix to use for testcases [default: .decaf]")
    optparser.add_option("-o", "--output", dest="output_dir", default='output', help="Save the output from the testcases to this directory.")
    optparser.add_option("-z", "--zipfile", dest="zipfile", default='output', help="zip file you should upload to the leaderboard submission page on sfu-yacc.appspot.com")
    optparser.add_option("-l", "--logfile", dest="logfile", default=None, help="log file for debugging")
    (opts, _) = optparser.parse_args()

    if opts.logfile is not None:
        logging.basicConfig(filename=opts.logfile, filemode='w', level=logging.INFO)

    zo = ZipOutput(opts)
    if zo.run_all():
        outputs_zipfile = shutil.make_archive(opts.zipfile, 'zip', opts.output_dir)
        print("{} created".format(outputs_zipfile), file=sys.stderr)
    else:
        logging.error("problem in creating output zip file")
        sys.exit(1)

