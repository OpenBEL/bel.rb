#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/../
source "$DIR"/env.sh || exit 1
assert-env-or-die BR_DIR
cd "$BR_DIR" || exit 1

assert-env-or-die BR_GEM_CMD
if [ $BR_ISOLATE != "yes" ]; then
    echo "Running CI tests out of isolation mode is not supported." >&2
    exit 1
fi

assert-env-or-die BR_SCRIPTS
source "$BR_SCRIPTS"/isolate.sh || exit 1

rake
RAKE_RC=$?
if [ $RAKE_RC -eq 0 ]; then
    echo "You totes win. Epic."
    exit 0
else
    echo "FAIL"
    exit 1
fi
