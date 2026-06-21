#!/bin/sh

DATESTR=$(/bin/date "+%Y-%m-%d %H:%M:%S %Z")
DATESTR=$(/bin/date "+%Y-%m-%d %Z")
TIMEVAL=$(/bin/date "+%H")
TIMEVAL=${1:-$TIMEVAL}
if [ $TIMEVAL -le 3 ]; then x="こんばんは"; 
elif [ $TIMEVAL -le 9 ]; then x="おはようございます"; 
elif [ $TIMEVAL -le 16 ]; then x="こんにちは"; 
else x="こんばんは"; 
fi
echo "$x ($DATESTR)" > $HOME/Desktop/今日のタイトル1.txt
