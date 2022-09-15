#!/bin/sh

# QRclock2G2.sh

# First version: Thu Sep 15 15:06:02 JST 2022 by @hohno_at_kuimc

LANG=C
clear
TMPFILE=/tmp/QRclock.tmp
/bin/rm -f "$TMPFILE"  || exit 999

# x=$(/bin/date +%s)
# if [ $(( $x % 2)) -eq 1 ] ; then
#   y=$(/bin/date +%s)
#   while [ "$x" -eq "$y" ]; do y=$(/bin/date +%s);  sleep 0.05; done
# fi

while [ 1 ]
do
  printf "\033[%d;%dH" 1 1;
  echo ""
  T=$(/bin/date +%s)
  x=$(( $T + 1 ))
  y=$T
  c=0
  while [ "$x" -ne "$y" ]; do y=$(/bin/date +%s);  c=$(( $c + 1 )); sleep 0.05; done #/bin/echo -n "."; done
  # /bin/echo -n "$c  "

  mkqrcodeG2-as-text.sh $(/bin/date "+%Y-%m-%dT%H:%M:%S%z")  | sed '$s/^/  /'
  
  /bin/rm -f "$TMPFILE"  || exit 999
done

