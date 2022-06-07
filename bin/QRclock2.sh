#!/bin/sh

LANG=C
clear
TMPFILE=/tmp/QRclock.tmp
/bin/rm -f "$TMPFILE"  || exit 999

x=$(/bin/date +%s)
if [ $(( $x % 2)) -eq 1 ] ; then
  y=$(/bin/date +%s)
  while [ "$x" -eq "$y" ]; do y=$(/bin/date +%s);  sleep 0.05; done
fi

# x=0
c=0

x=$(( $(/bin/date +%s) + 0 ))

while [ 1 ]
do
  perl ~/bin/mkqrcode-as-text.pl $(/bin/date "+%Y-%m-%dT%H:%M:%S%z" | sed 's/\(..\)$/:\1/') | sed -e 's/0/＠/g' -e 's/1/　/g' > $TMPFILE
  y=$(/bin/date +%s)
  while [ "$x" -gt "$y" ]; do y=$(/bin/date +%s);  c=$(( $c + 1 )); sleep 0.05; done
  printf "\033[%d;%dH" 1 1;
  sed -n 3,35p $TMPFILE | cut -b 7-105
  echo ;echo -n "$x, $y, $c $(/bin/date)  "
  # x=$(( $(/bin/date +%s) + 1 ))
  x=$(( $x + 1 ))
  c=0
  # while [ "$x" -eq "$y" ]; do y=$(/bin/date +%s);  sleep 0.05; done
  /bin/rm -f "$TMPFILE"  || exit 999
done

