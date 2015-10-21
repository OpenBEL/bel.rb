#/usr/bin/env bash
# Normal script execution starts here.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/../
source "$DIR"/env.sh || exit 1
cd "$DIR" || exit 1

echo "Compiling libbel C extension."
COMPILE_OUT=$(mktemp)
rake compile > /dev/null 2> $COMPILE_OUT
if [ $? -ne 0 ]; then
  echo "Compilation error, output of \"rake compile\":"
  cat $COMPILE_OUT
  exit 1
fi

pry -I "./lib" -r "bel"

