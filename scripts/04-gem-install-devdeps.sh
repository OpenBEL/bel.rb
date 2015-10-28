#/usr/bin/env bash

# The next three lines are for the go shell.
export SCRIPT_NAME="gem-install-devdeps"
export SCRIPT_HELP="Gem install dependencies (including dev deps)."
[[ "$GOGO_GOSH_SOURCE" -eq 1 ]] && return 0

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/../
source "$DIR"/env.sh || exit 1
assert-env-or-die BR_SCRIPTS
"$BR_SCRIPTS"/gem-install-devdeps.sh

