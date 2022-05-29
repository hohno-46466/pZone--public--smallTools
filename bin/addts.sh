#!/bin/sh
[ "x$TSKEY" = "x" ] && TSKEY='$USER-$$'
cat "$@" | sed -u -e 's/^/echo "'$TSKEY'\t$(date +%s.%3N\)\t/' -e 's/$/"/' | /bin/sh
