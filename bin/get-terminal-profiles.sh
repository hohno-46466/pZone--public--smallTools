#!/bin/sh

# First version: 2025-04-24(Thu) JST / 2025-04-24(Thu) UTC
# Last update:   2025-06-29(Sun) 10:07 JST / 2025-06-29(Sun) 01:07 UTC

CATOPT="-n"

if [ "x$1" = "x-nn" ]; then
  # nn: no line numbers
  CATOPT="-u"	# dummy
fi

osascript -e 'tell application "Terminal" to get the name of every settings set' \
| tr , \\n \
| sed 's/^ *//' \
| sort \
| cat "$CATOPT"
