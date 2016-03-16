#/usr/bin/env bash

# The next three lines are for the go shell.
export SCRIPT_NAME="test-unit"
export SCRIPT_HELP="Run unit tests"
[[ "$GOGO_GOSH_SOURCE" -eq 1 ]] && return 0

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/../
source "$DIR"/env.sh || exit 1
assert-env-or-die BR_SCRIPTS
"$BR_SCRIPTS"/test-unit.sh

