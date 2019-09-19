#!/usr/bin/env python

"""A test case update script.

This script is a utility to update LLVM 'llc' based test cases with new
FileCheck patterns. It can either update all of the tests in the file or
a single test function.
"""

from __future__ import print_function

import argparse
import glob
import os         # Used to advertise this file's name ("autogenerated_note").
import string
import subprocess
import sys
import re

from UpdateTestChecks import asm, common

ADVERT = ' NOTE: Assertions have been autogenerated by '


def main():
  parser = argparse.ArgumentParser(description=__doc__)
  parser.add_argument('-v', '--verbose', action='store_true',
                      help='Show verbose output')
  parser.add_argument('--llc-binary', default='llc',
                      help='The "llc" binary to use to generate the test case')
  parser.add_argument(
      '--function', help='The function in the test file to update')
  parser.add_argument(
      '--extra_scrub', action='store_true',
      help='Always use additional regex to further reduce diffs between various subtargets')
  parser.add_argument(
      '--x86_scrub_rip', action='store_true', default=True,
      help='Use more regex for x86 matching to reduce diffs between various subtargets')
  parser.add_argument(
      '--no_x86_scrub_rip', action='store_false', dest='x86_scrub_rip')
  parser.add_argument('-u', '--update-only', action='store_true',
                      help='Only update test if it was already autogened')
  parser.add_argument('tests', nargs='+')
  args = parser.parse_args()

  script_name = os.path.basename(__file__)

  test_paths = [test for pattern in args.tests for test in glob.glob(pattern)]
  for test in test_paths:
    if args.verbose:
      print('Scanning for RUN lines in test file: %s' % (test,), file=sys.stderr)
    with open(test) as f:
      input_lines = [l.rstrip() for l in f]
    
    first_line = input_lines[0] if input_lines else ""
    if 'autogenerated' in first_line and script_name not in first_line:
      common.warn("Skipping test which wasn't autogenerated by " + script_name, test)
      continue

    if args.update_only:
      if not first_line or 'autogenerated' not in first_line:
        common.warn("Skipping test which isn't autogenerated: " + test)
        continue

    triple_in_ir = None
    for l in input_lines:
      m = common.TRIPLE_IR_RE.match(l)
      if m:
        triple_in_ir = m.groups()[0]
        break

    raw_lines = [m.group(1)
                 for m in [common.RUN_LINE_RE.match(l) for l in input_lines] if m]
    run_lines = [raw_lines[0]] if len(raw_lines) > 0 else []
    for l in raw_lines[1:]:
      if run_lines[-1].endswith("\\"):
        run_lines[-1] = run_lines[-1].rstrip("\\") + " " + l
      else:
        run_lines.append(l)

    if args.verbose:
      print('Found %d RUN lines:' % (len(run_lines),), file=sys.stderr)
      for l in run_lines:
        print('  RUN: ' + l, file=sys.stderr)

    run_list = []
    for l in run_lines:
      if '|' not in l:
        common.warn('Skipping unparseable RUN line: ' + l)
        continue

      commands = [cmd.strip() for cmd in l.split('|', 1)]
      llc_cmd = commands[0]
      llc_tool = llc_cmd.split(' ')[0]

      triple_in_cmd = None
      m = common.TRIPLE_ARG_RE.search(llc_cmd)
      if m:
        triple_in_cmd = m.groups()[0]

      march_in_cmd = None
      m = common.MARCH_ARG_RE.search(llc_cmd)
      if m:
        march_in_cmd = m.groups()[0]

      filecheck_cmd = ''
      if len(commands) > 1:
        filecheck_cmd = commands[1]
      common.verify_filecheck_prefixes(filecheck_cmd)
      if llc_tool != 'llc':
        common.warn('Skipping non-llc RUN line: ' + l)
        continue

      if not filecheck_cmd.startswith('FileCheck '):
        common.warn('Skipping non-FileChecked RUN line: ' + l)
        continue

      llc_cmd_args = llc_cmd[len(llc_tool):].strip()
      llc_cmd_args = llc_cmd_args.replace('< %s', '').replace('%s', '').strip()
      if test.endswith('.mir'):
        llc_cmd_args += ' -x mir'
        comment_sym = '#'
        check_indent = '  '
      else:
        comment_sym = ';'
        check_indent = ''

      check_prefixes = [item for m in common.CHECK_PREFIX_RE.finditer(filecheck_cmd)
                               for item in m.group(1).split(',')]
      if not check_prefixes:
        check_prefixes = ['CHECK']

      # FIXME: We should use multiple check prefixes to common check lines. For
      # now, we just ignore all but the last.
      run_list.append((check_prefixes, llc_cmd_args, triple_in_cmd, march_in_cmd))

    autogenerated_note = (comment_sym + ADVERT + 'utils/' + script_name)

    func_dict = {}
    for p in run_list:
      prefixes = p[0]
      for prefix in prefixes:
        func_dict.update({prefix: dict()})
    for prefixes, llc_args, triple_in_cmd, march_in_cmd in run_list:
      if args.verbose:
        print('Extracted LLC cmd: ' + llc_tool + ' ' + llc_args, file=sys.stderr)
        print('Extracted FileCheck prefixes: ' + str(prefixes), file=sys.stderr)

      raw_tool_output = common.invoke_tool(args.llc_binary, llc_args, test)
      triple = triple_in_cmd or triple_in_ir
      if not triple:
        triple = asm.get_triple_from_march(march_in_cmd)

      asm.build_function_body_dictionary_for_triple(args, raw_tool_output,
          triple, prefixes, func_dict)

    is_in_function = False
    is_in_function_start = False
    func_name = None
    prefix_set = set([prefix for p in run_list for prefix in p[0]])
    if args.verbose:
      print('Rewriting FileCheck prefixes: %s' % (prefix_set,), file=sys.stderr)
    output_lines = []
    output_lines.append(autogenerated_note)

    for input_line in input_lines:
      if is_in_function_start:
        if input_line == '':
          continue
        if input_line.lstrip().startswith(';'):
          m = common.CHECK_RE.match(input_line)
          if not m or m.group(1) not in prefix_set:
            output_lines.append(input_line)
            continue

        # Print out the various check lines here.
        asm.add_asm_checks(output_lines, check_indent + ';', run_list, func_dict, func_name)
        is_in_function_start = False

      if is_in_function:
        if common.should_add_line_to_output(input_line, prefix_set):
          # This input line of the function body will go as-is into the output.
          output_lines.append(input_line)
        else:
          continue
        if input_line.strip() == '}':
          is_in_function = False
        continue

      # Discard any previous script advertising.
      if input_line.startswith(comment_sym + ADVERT):
        continue

      # If it's outside a function, it just gets copied to the output.
      output_lines.append(input_line)

      m = common.IR_FUNCTION_RE.match(input_line)
      if not m:
        continue
      func_name = m.group(1)
      if args.function is not None and func_name != args.function:
        # When filtering on a specific function, skip all others.
        continue
      is_in_function = is_in_function_start = True

    if args.verbose:
      print('Writing %d lines to %s...' % (len(output_lines), test), file=sys.stderr)

    with open(test, 'wb') as f:
      f.writelines(['{}\n'.format(l).encode('utf-8') for l in output_lines])


if __name__ == '__main__':
  main()
