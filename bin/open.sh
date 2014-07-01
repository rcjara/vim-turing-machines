#!/bin/bash

set -e
set -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
source "${DIR}/bin/shared.sh"

function open_machine_with_state {
  turing_machine="$1"
  initial_state="$2"

  vi \
    -O2 +${SETUP_MACRO_LINE_NUM} \
    "+normal \"iyy" \
    "+q" \
    "+normal @i" \
    "+vsplit ${initial_state}" \
    ${INTERPRETER} \
    ${turing_machine}
}

test_rex="$1"
state_rex="$2"

num_tests=$(available_tests $test_rex | num_matches )

if [ "$num_tests" = "1" ]; then
  test=$(available_tests $test_rex)
  num_states=$(matching_states $test $state_rex | num_matches )
  if [ "$num_states" = "1" ]; then
    state=$(matching_states $test $state_rex)
    turing_machine=$(turing_machine_in_dir $test)
    echo "turing_machine: $turing_machine "
    echo "INTERPRETER: $INTERPRETER"
    open_machine_with_state $turing_machine $state
  else
    echo "please choose a rex that matches only one initial-state; yours matched:"
    matching_states $(available_tests $test_rex) $state_rex
  fi
else
  echo "please choose a rex that matches only one test case; yours matched:"
  available_tests $test_matches
fi

