#! /bin/sh

# Last update: Fri Dec  2 11:04:19 JST 2016
# Last update: Wed Oct  6 06:15:44 JST 2021 (updated for bit.ly short URL)

scr=$HOME/bin/mkqrcode.pl
prefix="$HOME/tmp"

if [ "x$1" = "x-h" -o "x$1" = "x-help" -o "x$1" = "x--help" ]; then
  echo "usage: $0 [-g] keyword"
  exit 1;
fi

Qmode=""
if [ "x$1" = "x-g" ]; then
  Qmode="G"
  shift;
elif [ "x$1" = "x-b" ]; then
  Qmode="B"
  shift;
fi

# str=${1-"https://goo.gl"}
echo "debug: [ $1 ]"
str="$1"
echo "debug: [ $str ]"
[ "x$str" = "x" ] && str="https://goo.gl"
str=$(echo "$str" | expand | sed -e 's/^ *//' -e 's/ *$//')
echo "debug: [ $str ]"

if [ "x$Qmode" = "G" ]; then
  # if $str contains "/" or "str" is longer then 6 characters (excluding 6)
  if [ "x$(echo $str | grep /)" != "x" -o "x$(echo $str | egrep '^.......')" != "x" ]; then
    echo "Bad argument. With -g option, you can just specify 6 characters."
    exit 2;
  fi
elif [ "x$Qmode" = "B" ]; then
  # if $str contains "/" or "str" is longer then 7 characters (excluding 7)
  if [ "x$(echo $str | grep /)" != "x" -o "x$(echo $str | egrep '^........')" != "x" ]; then
    echo "Bad argument. With -g option, you can just specify 7 characters."
    exit 2;
  fi
fi

tmp="${prefix}/qr.gif"

if [ "x$Qmode" = "xG" ]; then
  echo "Qmode(G)"
  out="${prefix}/qr-${str}.gif"
  str="https://goo.gl/$str"

elif [ "x$Qmode" = "xB" ]; then
  echo "Qmode(B)"
  out="${prefix}/qr-${str}.gif"
  str="https://bit.ly/$str"

# elif [ "x$(echo $str | egrep 'http://goo.gl/')" != "x" ]; then
#   # none Qmode including "http://goo.gl/"
#   str=$(echo $str | expand | sed -e 's|^.*http://goo.gl/||' -e 's/ *$//')
#   out="${prefix}/qr-${str}.gif"
#   str="https://goo.gl/$str"

elif [ "x$(echo $str | egrep 'https://goo.gl/')" != "x" ]; then
  # none Qmode including "https://goo.gl/"
  str=$(echo $str | expand | sed -e 's|^.*https://goo.gl/||' -e 's/ *$//')
  out="${prefix}/qr-${str}.gif"
  str="https://goo.gl/$str"

# elif [ "x$(echo $str | egrep 'http://bit.ly/')" != "x" ]; then
#   # none Qmode including "http://bit.ly/"
#   str=$(echo $str | expand | sed -e 's|^.*http://bit.ly/||' -e 's/ *$//')
#   out="${prefix}/qr-${str}.gif"
#   str="https://bit.ly/$str"

elif [ "x$(echo $str | egrep 'https://bit.ly/')" != "x" ]; then
  # none Qmode including "https://bit.ly/"
  str=$(echo $str | expand | sed -e 's|^.*https://bit.ly/||' -e 's/ *$//')
  out="${prefix}/qr-${str}.gif"
  str="https://bit.ly/$str"

else
  # none Qmode with free text"
  echo "debug: [ $str ]"
  out="${prefix}/qr-output.gif"
fi

echo "str: [$str]"
echo "tmp: [$tmp]"
echo "out: [$out]"

for x in "$tmp" "$out"; do
  /bin/rm -f "$x"
  [ -f "$x" ] && exit 9
  /usr/bin/touch "$x"
  [ ! -f "$x" ] && exit 9
done

perl $scr "$str" || exit 1;

mv "$tmp" "$out" && echo "result: $out"

ls -l "$out"
identify "$out"

exit $?
