#/usr/bin/env bash

# The next three lines are for the go shell.
export SCRIPT_NAME="build"
export SCRIPT_HELP="Run gem build."
[[ "$GOGO_GOSH_SOURCE" -eq 1 ]] && return 0

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/../
source "$DIR"/env.sh || exit 1
assert-env-or-die BR_SCRIPTS
"$BR_SCRIPTS"/build.sh

