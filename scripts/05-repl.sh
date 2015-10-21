#/usr/bin/env bash

# The next three lines are for the go shell.
export SCRIPT_NAME="repl"
export SCRIPT_HELP="Run the REPL (read,eval,print,loop)"
[[ "$GOGO_GOSH_SOURCE" -eq 1 ]] && return 0

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/../
source "$DIR"/env.sh || exit 1
assert-env-or-die SCRIPTS
"$SCRIPTS"/repl.sh

