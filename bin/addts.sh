#!/bin/sh
cat "$@" | sed -u -e 's/^/echo "$USER-$$\t$(date +%s.%3N\)\t/' -e 's/$/"/' | /bin/sh
