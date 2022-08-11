#!/bin/sh
# Prev Modified: Fri Jul  8 19:16:09 JST 2022
# Last Modified: Wed Aug 10 20:53:13 JST 2022

date=date; type gdate > /dev/null 2>&1 && date=gdate # alias date=gdate # On Mac, gdate can be found in coreutils
sed=sed;   type gsed  > /dev/null 2>&1 && sed=gsed   # alias sed=gsed

[ "x$TSKEY" = "x" ] && TSKEY='$USER-$$'
cat -u "$@" | $sed -u -e "s/'/'\"'\"'/g" -e "s/^/'/" -e "s/$/'/" -e 's/^/echo "'$TSKEY'\t$('$date' +%s.%3N\)\t"/' | /bin/sh

exit $?

# 上記の sed の補足説明
# -e "s/'/'\"'\"'/g"  - 「'」を「'"'"'」に置き換える
# -e "s/^/'/"         - 行頭に「'」を付加する．直上の変更と組み合わせると入力行の「'」が「"'"」になる
# -e "s/$/'/"         - 行末に「'」を付加する
# -e 's/^/echo "'$TSKEY'\t$('$date' +%s.%3N\)\t"/' - 上記の行の前に「"キーワード(TAB)時刻(TAG)"」を付加する

