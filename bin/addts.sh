#!/bin/sh
export date=date; type gdate > /dev/null 2>&1 && date=gdate # alias date=gdate
export sed=sed;   type gsed  > /dev/null 2>&1 && sed=gsed   # alias sed=gsed
[ "x$TSKEY" = "x" ] && TSKEY='$USER-$$'
cat "$@" | $sed -u -e 's/^/echo "'$TSKEY'\t$($date +%s.%3N\)\t/' -e 's/$/"/' | /bin/sh
