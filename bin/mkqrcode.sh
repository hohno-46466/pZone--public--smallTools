#! /bin/sh

# Last update: Fri Dec  2 11:04:19 JST 2016

scr=$HOME/bin/mkqrcode.pl
prefix="$HOME/tmp"

if [ "x$1" = "x-h" -o "x$1" = "x-help" -o "x$1" = "x--help" ]; then
  echo "usage: $0 keyword"
  exit 1;
fi

gmode=""
if [ "x$1" = "x-g" ]; then
  gmode="x"
  shift;
fi

# str=${1-"https://goo.gl"}
echo "debug: [ $1 ]"
str="$1"
echo "debug: [ $str ]"
[ "x$str" = "x" ] && str="https://goo.gl"
str=`echo "$str" | expand | sed -e 's/^ *//' -e 's/ *$//'`
echo "debug: [ $str ]"

if [ "x$gmode" != "x" ]; then
  if [ "x`echo $str | grep / `" != "x" -o "x`echo $str | egrep '^......$'`" = "x" ]; then
    echo "Bad argument. With -g option, you can just specify 6 characters."
    exit 2;
  fi
fi

tmp="${prefix}/qr.gif"

if [ "x$gmode" != "x" ]; then
  # gmode
  out="${prefix}/qr-${str}.gif"
  str="https://goo.gl/$str"

elif [ "x`echo $str | egrep 'http://goo.gl/'`" != "x" ]; then
  # none gmode including "http://googl/"
  str=`echo $str | expand | sed -e 's|^.*http://goo.gl/||' -e 's/ *$//'`
  out="${prefix}/qr-${str}.gif"
  str="https://goo.gl/$str"

elif [ "x`echo $str | egrep 'https://goo.gl/'`" != "x" ]; then
  # none gmode including "https://googl/"
  str=`echo $str | expand | sed -e 's|^.*https://goo.gl/||' -e 's/ *$//'`
  out="${prefix}/qr-${str}.gif"
  str="https://goo.gl/$str"

else
  # none gmode with free text"
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

/bin/ls -l "$out"
/usr/local/bin/identify "$out"

exit $?

