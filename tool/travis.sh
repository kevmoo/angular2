#!/bin/bash

# Fast fail the script on failures.
set -e

if [ -z "$TEST_PLATFORM" ]; then
  echo "TEST_PLATFORM must be set"
  exit 1
fi

echo "** Run a trivial travis-only test to see if the current platform works"
pub run test -p $TEST_PLATFORM tool/travis_sniff_test.dart

if [ $TEST_PLATFORM == 'vm' ]; then
  echo "** Generating template files."
  THE_COMMAND="dart test/source_gen/template_compiler/generate.dart"
  echo $THE_COMMAND
  $THE_COMMAND
fi

echo "** Running main tests – no codegen"
# Run tests that don't require codegen.
if [ $TEST_PLATFORM == 'firefox' ]; then
  THE_COMMAND="pub run test -x codegen -P safe_firefox -j 1"
else
  THE_COMMAND="pub run test -x codegen -p $TEST_PLATFORM"
fi

echo $THE_COMMAND
$THE_COMMAND

if [ $TEST_PLATFORM == 'content-shell' ]; then
  echo "** SKIPPING pub tests – with codegen - broken!"
  echo "** See https://github.com/dart-lang/angular2/issues/272"
  # "$(dirname "$0")/run_codegen_tests.sh"
fi

echo "** Done!!"
