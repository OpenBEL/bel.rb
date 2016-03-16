#/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/../
source "$DIR"/env.sh || exit 1
assert-env-or-die BR_DIR
cd "$BR_DIR" || exit 1

assert-env-or-die BR_GEM_CMD
assert-env-or-die BR_SCRIPTS

if [ $BR_ISOLATE == "yes" ]; then
    source "$BR_SCRIPTS"/isolate.sh || exit 1
fi

rake unit
