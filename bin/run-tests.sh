#!/bin/bash

set -e
set -o pipefail

INTERPRETER="turing.macro"
SETUP_MACRO_LINE_NUM="6"

function available_tests {
  test_matches="$1"
  find tests -mindepth 1 -type d \
    | grep "${test_matches}"
}

function end_state_from_initial {
  initial_state="$1"
  echo $initial_state | sed 's/\/initial/\/end/'
}

function expected_state_from_initial {
  initial_state="$1"
  echo $initial_state | sed 's/\/initial/\/expected/'
}

function run_machine_with_state {
  turing_machine="$1"
  initial_state="$2"
  end_state="$(end_state_from_initial $initial_state)"

  vi \
    -O2 +${SETUP_MACRO_LINE_NUM} \
    "+normal \"iyy" \
    "+q" \
    "+normal @i" \
    "+vsplit ${initial_state}" \
    "+normal @t" \
    "+w! ${end_state}" \
    "+q!" \
    "+q!" \
    ${INTERPRETER} \
    ${turing_machine}
}

test_matches="$1"

for dir in $(available_tests "${test_matches}"); do
  turing_machine="$(find ${dir} -name "*.turing")"
  states="$(find ${dir} -name "initial-*.state")"
  for initial_state in $states; do
    run_machine_with_state ${turing_machine} ${initial_state}
    expected_state=$(expected_state_from_initial $initial_state)
    end_state=$(end_state_from_initial $initial_state)
    diff $expected_state $end_state
  done
done
