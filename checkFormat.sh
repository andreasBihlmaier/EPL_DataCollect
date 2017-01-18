#!/bin/bash

# Test clang-format formating

########################
# BEGIN CONFIG SECTION #
########################

CLANG_FORMAT_VERSION="RELEASE_391"
CALNG_FORMAT_DEFAULT_CMD="clang-format"
EXTENSIONS=( cpp c hpp h )

########################
#  END  CONFIG SECTION #
########################

VERBOSE=0

for I in "$@"; do
  case "$I" in
    -v|--verbose) VERBOSE=1 ;;
  esac
done

error() {
  echo -e '        \x1b[1;31m______ ______________  ___  ___ _____   _________________ ___________  \x1b[0m'
  echo -e '        \x1b[1;31m|  ___|  _  | ___ \  \/  | / _ \_   _| |  ___| ___ \ ___ \  _  | ___ \ \x1b[0m'
  echo -e '        \x1b[1;31m| |_  | | | | |_/ / .  . |/ /_\ \| |   | |__ | |_/ / |_/ / | | | |_/ / \x1b[0m'
  echo -e '        \x1b[1;31m|  _| | | | |    /| |\/| ||  _  || |   |  __||    /|    /| | | |    /  \x1b[0m'
  echo -e '        \x1b[1;31m| |   \ \_/ / |\ \| |  | || | | || |   | |___| |\ \| |\ \\\\ \_/ / |\ \  \x1b[0m'
  echo -e '        \x1b[1;31m\_|    \___/\_| \_\_|  |_/\_| |_/\_/   \____/\_| \_\_| \_|\___/\_| \_| \x1b[0m'
  echo -e '        \x1b[1;31m                                                                       \x1b[0m'
  echo -e "  \x1b[1;31m==> \x1b[0;31m$*\x1b[0m"
}

verbose() {
  (( VERBOSE == 0 )) && return
  echo -e "$*"
}


cd "$(dirname "$0")"

[ -z "$CALNG_FORMAT_CMD" ] && CALNG_FORMAT_CMD="$CALNG_FORMAT_DEFAULT_CMD"

# Check if the command exists
CALNG_FORMAT_EXEC=$(which "$CALNG_FORMAT_CMD" 2> /dev/null)
if (( $? != 0 )); then
  error "clang-format ($CALNG_FORMAT_CMD) not found. Try setting the CALNG_FORMAT_CMD environment variable"
  exit 1
fi

verbose "clang-format command: $CALNG_FORMAT_EXEC"


# Check the version
CURENT_VERSION="$(clang-format --version | sed 's/^[^(]*(tags\/\([^/]*\).*/\1/g')"
if [[ "$CLANG_FORMAT_VERSION" != "$CURENT_VERSION" ]]; then
  error "Invalid clang-format version! $CLANG_FORMAT_VERSION required but $CURENT_VERSION provided"
  exit 2
fi

verbose "clang-froamt version: $CURENT_VERSION\n"


#########################
# Checking source files #
#########################

ERROR=0
NUM_FILES=0
TO_GIT_ADD=()

checkFromat() {
  local I J
  NUM_FILES=0
  ERROR=0

  verbose " ==> Checking files"

  for I in $(git diff --cached --name-only); do
    for J in "${EXTENSIONS[@]}"; do
      echo "$I" | grep -E "\.$J$" &> /dev/null
      (( $? != 0 )) && continue

      (( NUM_FILES++ ))

      if [[ "$1" == "format" ]]; then
        verbose "   --> Fixing $I"
        $CALNG_FORMAT_EXEC -i "$I"
        TO_GIT_ADD+=( "$I" )
      fi

      verbose "   --> Checking $I"

      RES=$( $CALNG_FORMAT_EXEC -output-replacements-xml "$I" | grep "<replacement " )
      if [ -n "$RES" ]; then
        echo -e " \x1b[1;31mFormat check error: $I"
        (( ERROR++ ))
      fi

      break
    done
  done
}

checkFromat check

if (( ERROR != 0 )); then
  exec < /dev/tty

  error "$ERROR out of $NUM_FILES files are not formated"
  read -p "  ==> Try formating source files [Y/n]? " -n 1 INPUT
  [ -z "$INPUT" ] && INPUT=y || echo ""

  if [[ "$INPUT" == "Y" || "$INPUT" == "y" ]]; then
    checkFromat format
    if (( ERROR != 0 )); then
      error "$ERROR out of $NUM_FILES files are not formated -- CLANG FORMAT FAIL"
      exit $ERROR
    fi

    read -p "  ==> Show git diff [y/N]? " -n 1 INPUT
    [ -z "$INPUT" ] && INPUT=n || echo ""
    [[ "$INPUT" == "Y" || "$INPUT" == "y" ]] && git diff
  else
    exec <&-
    exit $ERROR
  fi
  exec <&-
fi

echo -e '        \x1b[1;32m _____ ________  ______  ________ _____   _____ _   __ \x1b[0m'
echo -e '        \x1b[1;32m/  __ \  _  |  \/  ||  \/  |_   _|_   _| |  _  | | / / \x1b[0m'
echo -e '        \x1b[1;32m| /  \/ | | | .  . || .  . | | |   | |   | | | | |/ /  \x1b[0m'
echo -e '        \x1b[1;32m| |   | | | | |\/| || |\/| | | |   | |   | | | |    \  \x1b[0m'
echo -e '        \x1b[1;32m| \__/\ \_/ / |  | || |  | |_| |_  | |   \ \_/ / |\  \ \x1b[0m'
echo -e '        \x1b[1;32m \____/\___/\_|  |_/\_|  |_/\___/  \_/    \___/\_| \_/ \x1b[0m'
echo -e '        \x1b[1;32m                                                       \x1b[0m'
echo -e "  \x1b[1;32m==>\x1b[0m All $NUM_FILES files are OK"

# Add changes
for I in "${TO_GIT_ADD[@]}"; do
  git add "$I"
done

exit $ERROR
