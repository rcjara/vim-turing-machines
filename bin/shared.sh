#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
INTERPRETER="${DIR}/turing.macro"
SETUP_MACRO_LINE_NUM="6"

function available_tests {
  test_matches="$1"
  find ${DIR}/tests -mindepth 1 -type d \
    | grep "${test_matches}"
}

function matching_states {
  test_dir="$1"
  rex="$2"

  find ${test_dir} -name "initial-*.state" \
    | grep "${rex}"
}

function num_matches {
  wc -l | tr -d ' '
}

function turing_machine_in_dir {
  dir="$1"
  find ${dir} -name "*.turing"
}

function end_state_from_initial {
  initial_state="$1"
  echo $initial_state | sed 's/\/initial/\/end/'
}

function expected_state_from_initial {
  initial_state="$1"
  echo $initial_state | sed 's/\/initial/\/expected/'
}
