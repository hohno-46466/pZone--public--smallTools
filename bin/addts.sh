#!/bin/sh
gdate=gdate; type gdate > /dev/null 2>&1 || gdate=date # alias gdate=date
gsed=gsed;   type gsed  > /dev/null 2>&1 || gsed=sed   # alias gsed=sed
[ "x$TSKEY" = "x" ] && TSKEY='$USER-$$'
cat -u "$@" | $gsed -u -e "s/'/'\"'\"'/g" -e "s/^/'/" -e "s/$/'/" -e 's/^/echo "'$TSKEY'\t$('$gdate' +%s.%3N\)\t"/' | /bin/sh
exit
