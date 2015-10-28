#/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/../
source "$DIR"/env.sh || exit 1
assert-env-or-die BR_DIR
cd "$BR_DIR" || exit 1

assert-env-or-die BR_SCRIPTS
if [ $BR_ISOLATE == "yes" ]; then
    source "$BR_SCRIPTS"/isolate.sh || exit 1
fi

echo "Compiling libbel C extension."
COMPILE_OUT=$(mktemp)
rake compile > /dev/null 2> $COMPILE_OUT
if [ $? -ne 0 ]; then
  echo "Compilation error, output of \"rake compile\":"
  cat $COMPILE_OUT
  exit 1
fi

pry -I "./lib" -r "bel"
