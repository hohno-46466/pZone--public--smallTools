#!/bin/sh

# QRclock3.sh

# Last udpate: 2026-07-06(Mon) 20:22 JST / 2026-07-06(Mon) 11:22 UTC

dateopt="+%Y-%m-%dT%H:%M:%S"
cmd=qrencode
cmdopts="-t ANSI256 -l H"
cnt=0

xx=""
while [ 1 ]; do
  x=$(/bin/date +$dateopt)
  if [ "x$x" != "x$xx" ]; then
    clear
    $cmd $cmdopts "$x"
    echo "[ $x ] $cnt"
    cnt=0
    xx=$x
  fi
  cnt=$((cnt + 1))
  sleep 0.05
done
  


