#/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/../
source "$DIR"/env.sh || exit 1
assert-env-or-die BR_DIR
cd "$BR_DIR" || exit 1

assert-env-or-die BR_GEM_CMD
if [ $BR_ISOLATE == "yes" ]; then
    assert-env-or-die BR_SCRIPTS
    source "$BR_SCRIPTS"/isolate.sh || exit 1
fi

echo "Building... "
$BR_GEM_CMD build bel.gemspec $BR_GEM_BUILD_OPTS $@
