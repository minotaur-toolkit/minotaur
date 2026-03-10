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
  with open(path, 'r') as fd:
    return fd.read()

def _excerpt_tail(lines, total_lines=100):
  """Return the last total_lines lines (with line numbers)."""
  if not lines:
    return ""
  total_lines = max(1, int(total_lines))
  start = max(0, len(lines) - total_lines)
  end = len(lines)
  excerpt = lines[start:end]
  header = f"=== Output tail (lines {start+1}-{end} of {len(lines)}) ===\n"
  body = ""
  for i, line in enumerate(excerpt, start=start + 1):
    body += f"{i:6d}: {line}\n"
  return header + body


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
    output_lines = output.splitlines()

    xfail = self.regex_xfail.search(input)
    if xfail != None and output.find(xfail.group(1)) != -1:
      return lit.Test.XFAIL, ''

    if is_timeout(output):
      return lit.Test.PASS, ''

    # CHECK / CHECK-NOT handling.
    # We intentionally treat CHECK patterns as *literal substrings* (not regex),
    # because many tests include characters like '|' which would be special in FileCheck.
    checks = [s.strip() for s in self.regex_check.findall(input)]
    if checks:
      for needle in checks:
        if output.find(needle) == -1:
          msg = ""
          msg += "CHECK failed: expected substring not found.\n"
          msg += "Test: " + test + "\n"
          msg += "Command: " + " ".join(cmd) + "\n\n"
          msg += "Expected (CHECK):\n" + needle + "\n\n"
          msg += _excerpt_tail(output_lines, total_lines=100)
          return lit.Test.FAIL, msg

    check_nots = [s.strip() for s in self.regex_check_not.findall(input)]
    if check_nots:
      for needle in check_nots:
        if output.find(needle) != -1:
          msg = ""
          msg += "CHECK-NOT failed: forbidden substring was found.\n"
          msg += "Test: " + test + "\n"
          msg += "Command: " + " ".join(cmd) + "\n\n"
          msg += "Forbidden (CHECK-NOT):\n" + needle + "\n\n"
          msg += _excerpt_tail(output_lines, total_lines=100)
          return lit.Test.FAIL, msg

    expect_err = self.regex_errs.search(input)
    if expect_err is None and xfail is None and not checks and not check_nots:
      # If there's no other test, correctness of the transformation should be
      # checked.
      if exitCode == 0 and output.find(ok_string) != -1 and \
          self.regex_errs_out.search(output) is None:
        return lit.Test.PASS, ''
      # Avoid dumping huge outputs in CI logs; show the last few lines.
      msg = ""
      msg += "Test: " + test + "\n"
      msg += "Command: " + " ".join(cmd) + "\n\n"
      msg += _excerpt_tail(output_lines, total_lines=100)
      return lit.Test.FAIL, msg

    if expect_err != None and output.find(expect_err.group(1)) == -1:
      msg = ""
      msg += "Expected error not found.\n"
      msg += "Test: " + test + "\n"
      msg += "Command: " + " ".join(cmd) + "\n\n"
      msg += _excerpt_tail(output_lines, total_lines=100)
      return lit.Test.FAIL, msg

    return lit.Test.PASS, ''
