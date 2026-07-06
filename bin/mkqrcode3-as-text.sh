#!/bin/sh

# mkqrcode3-as-text.sh

# Last update: 2026-07-06(Mon) 20:47 JST / 2026-07-06(Mon) 11:47 UTC

# export LANG=C

URL="https://goo.gl/"
OUT="$HOME/tmp/QRout.gif"

if [ "x$1" != "x" ]; then
  URL="$1"
fi

# echo "[$OUT]"

qrencode -t ANSI256 -l H "$URL"
echo "$URL"
# echo ""

exit "$?"

