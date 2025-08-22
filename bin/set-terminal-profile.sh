#!/bin/sh

# First version: 2025-04-24(Thu) 19:56 JST / 2025-04-24(Thu) 10:56 UTC
# Last update:   2025-06-29(Sun) 10:06 JST / 2025-06-29(Sun) 01:06 UTC

PNAME=$(basename $0)

if [ -z "$1" ]; then
  echo "usage: ${PNAME} [number | name]"
  echo "Note: use number or name in the list below."
  get-terminal-profiles.sh
  exit 1
fi

profile="$1"

if [ "$1" -gt 0 ] ; then
  nn=$1
  profile="$(get-terminal-profiles.sh -nn | grep -v '^#' | expand | sed -e '/^ *$/d'  | sed -n ${nn}p)"
fi

#echo "[$profile]"
#exit

osascript <<EOF
tell application "Terminal"
  set current settings of front window to settings set "$profile"
end tell
EOF
