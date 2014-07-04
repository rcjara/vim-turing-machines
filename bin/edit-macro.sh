#!/bin/bash

set -e
set -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
source "${DIR}/bin/shared.sh"

filename=$1

vi \
  -O2 "+/${COMPILE_MACRO_HEADING}" \
  "+normal j\"kyy" \
  "+q" \
  ${TOOLS} \
  ${filename}
