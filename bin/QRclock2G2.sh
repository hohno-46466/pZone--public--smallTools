#!/bin/sh

# QRclock2G2.sh

# First version: Thu Sep 15 15:06:02 JST 2022 by @hohno_at_kuimc
# Last update: Fri Sep 16 21:37:25 JST 2022 by @hohno_at_kuimc

PNAME=$(basename $0)
LANG=C
TMPFILE=/tmp/QRclock.tmp
/bin/rm -f "$TMPFILE" || exit 999

while [ "x$1" != "x" ]; do
  if [ "x$1" = "x-x" ]; then
    flag1="x"
  elif [ "x$1" = "x-v" ]; then
    flag2="v"
  fi
  shift
done

if ! type qr > /dev/null 2>&1; then
  echo "${PNAME}: Error: install qr command before you start."
  exit 1
fi

if ( type gdate > /dev/null 2>&1 ); then
  date=gdate # alias date=gdate # On Mac, gdate can be found in coreutils
  dateopt="+%Y-%m-%dT%H:%M:%S.%3N"
else
  date=date 
  dateopt="+%Y-%m-%dT%H:%M:%S"
fi

clear
while [ 1 ]; do
  printf "\033[%d;%dH" 1 1;
  echo ""
  T=$(/bin/date +%s)
  x=$(( $T + 1 ))
  y=$T
  c=0
  mkqrcodeG2-as-text.sh $($date $dateopt) | sed '$s/^/  /'
  
  if [ "x$flag1" = "x" ]; then
    if [ "x$flag2" = "x" ] ; then
      while [ "$x" -ne "$y" ]; do y=$(/bin/date +%s); c=$(( $c + 1 )); sleep 0.05; done
    else
      while [ "$x" -ne "$y" ]; do y=$(/bin/date +%s); c=$(( $c + 1 )); sleep 0.05; /bin/echo -n "."; done;
      /bin/echo -n "$c  "
    fi
  fi

  /bin/rm -f "$TMPFILE" || exit 999
done

