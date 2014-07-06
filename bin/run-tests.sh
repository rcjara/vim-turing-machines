#!/bin/bash

set -e
set -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
source "${DIR}/bin/shared.sh"

function run_machine_with_state {
  turing_machine="$1"
  initial_state="$2"
  end_state="$(end_state_from_initial $initial_state)"

  vi \
    -O2 "+/${INITIALIZE_MACRO_HEADING}" \
    "+normal j\"iyy" \
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
  turing_machine=$(turing_machine_in_dir $dir)
  states="$(find ${dir} -name "initial-*.state")"
  for initial_state in $states; do
    run_machine_with_state ${turing_machine} ${initial_state}
    expected_state=$(expected_state_from_initial $initial_state)
    end_state=$(end_state_from_initial $initial_state)

    set +e
    colordiff --context=3 $expected_state $end_state
    set -e
  done
done
