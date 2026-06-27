#!/bin/sh

# 2026-06-27(Sat) 13:58 JST / 2026-06-27(Sat) 04:58 UTC

DATESTR=$(/bin/date "+%Y-%m-%d %H:%M:%S %Z")
DATESTR=$(/bin/date "+%Y-%m-%d %Z")
DATESTR=$(/bin/date "+%Y-%m-%d %H:%M %Z")
TIMEVAL=$(/bin/date "+%H")
TIMEVAL=${1:-$TIMEVAL}
if [ $TIMEVAL -le 3 ]; then x="こんばんは"; 
elif [ $TIMEVAL -le 9 ]; then x="おはようございます"; 
elif [ $TIMEVAL -le 16 ]; then x="こんにちは"; 
else x="こんばんは"; 
fi
# echo "$x ($DATESTR)" > $HOME/Desktop/今日のタイトル1.txt
echo "$x ($DATESTR)" > /var/tmp/$USER/今日のタイトル1.txt
