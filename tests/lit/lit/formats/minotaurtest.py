# Copyright (c) 2018-present The Alive2 Authors.
# MIT license that can be found in the LICENSE file.

import lit.TestRunner
import lit.util
from .base import TestFormat
import os, re, signal, string, subprocess

ok_string = 'Transformation seems to be correct!'

def executeCommand(command):
  p = subprocess.Popen(command,
                       stdout=subprocess.PIPE,
                       stderr=subprocess.PIPE)
  out,err = p.communicate()
  exitCode = p.wait()

  # Detect Ctrl-C in subprocess.
  if exitCode == -signal.SIGINT:
    raise KeyboardInterrupt

  # Ensure the resulting output is always of string type.
  try:
    out = str(out.decode('ascii'))
  except:
    out = str(out)
  try:
    err = str(err.decode('ascii'))
  except:
    err = str(err)
  return out, err, exitCode

def is_timeout(str):
  return str.find('ERROR: Timeout') > 0

def id_check(fn, cmd, args):
  out, err, exitCode = executeCommand(cmd + args + ["-always-verify"])
  str = out + err
  if not is_timeout(str) and (exitCode != 0 or str.find(ok_string) < 0):
    raise Exception(fn + ' identity check fail: ' + str)


def readFile(path):
  fd = open(path, 'r')
  return fd.read()


class MinotaurTest(TestFormat):
  def __init__(self):
    self.regex_errs = re.compile(r";\s*(ERROR:.*)")
    self.regex_xfail = re.compile(r";\s*XFAIL:\s*(.*)")
    self.regex_args = re.compile(r"(?:;|//)\s*TEST-ARGS:(.*)")
    self.regex_check = re.compile(r"(?:;|//)\s*CHECK:(.*)")
    self.regex_check_not = re.compile(r"(?:;|//)\s*CHECK-NOT:(.*)")
    self.regex_errs_out = re.compile("ERROR:.*")

  def getTestsInDirectory(self, testSuite, path_in_suite,
                          litConfig, localConfig):
    source_path = testSuite.getSourcePath(path_in_suite)
    for filename in os.listdir(source_path):
      filepath = os.path.join(source_path, filename)
      if not filename.startswith('.') and \
          not os.path.isdir(filepath) and \
          filename.endswith('.syn.ll'):
        yield lit.Test.Test(testSuite, path_in_suite + (filename,), localConfig)


  def execute(self, test, litConfig):
    test = test.getSourcePath()

    opt_tv = test.endswith('.syn.ll')
    if opt_tv:
      cmd = ['./opt-minotaur.sh', '-S']
      if not os.path.isfile('opt-minotaur.sh'):
        return lit.Test.UNSUPPORTED, ''

    input = readFile(test)

    # add test-specific args
    m = self.regex_args.search(input)
    if m != None:
      cmd += m.group(1).split()

    cmd.append(test)

    out, err, exitCode = executeCommand(cmd)
    output = out + err

    xfail = self.regex_xfail.search(input)
    if xfail != None and output.find(xfail.group(1)) != -1:
      return lit.Test.XFAIL, ''

    if is_timeout(output):
      return lit.Test.PASS, ''

    chk = self.regex_check.search(input)
    if chk != None and output.find(chk.group(1).strip()) == -1:
      return lit.Test.FAIL, output

    chk_not = self.regex_check_not.search(input)
    if chk_not != None and output.find(chk_not.group(1).strip()) != -1:
      return lit.Test.FAIL, output

    expect_err = self.regex_errs.search(input)
    if expect_err is None and xfail is None and chk is None and chk_not is None:
      # If there's no other test, correctness of the transformation should be
      # checked.
      if exitCode == 0 and output.find(ok_string) != -1 and \
          self.regex_errs_out.search(output) is None:
        return lit.Test.PASS, ''
      return lit.Test.FAIL, output

    if expect_err != None and output.find(expect_err.group(1)) == -1:
      return lit.Test.FAIL, output

    return lit.Test.PASS, ''
