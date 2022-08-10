#!/bin/sh
# Last update: Fri Jul  8 19:16:09 JST 2022
date=date; type gdate > /dev/null 2>&1 && date=gdate # alias date=gdate
sed=sed;   type gsed  > /dev/null 2>&1 && sed=gsed   # alias sed=gsed
[ "x$TSKEY" = "x" ] && TSKEY='$USER-$$'
cat -u "$@" | $sed -u -e "s/'/'\"'\"'/g" -e "s/^/'/" -e "s/$/'/" -e 's/^/echo "'$TSKEY'\t$('$date' +%s.%3N\)\t"/' | /bin/sh
exit $?
