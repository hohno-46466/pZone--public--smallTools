#! /bin/sh

# mkqrcode-as-32x128-ppm.sh

scr=$HOME/bin/mkqrcode-as-text.pl
prefix="$HOME/tmp"

if [ "x$1" = "x-h" -o "x$1" = "x-help" -o "x$1" = "x--help" ]; then
  echo "usage: $0 keyword"
  exit 1;
fi

str=${1-"none"}

if [ "x`echo $str | egrep ' *http://goo.gl/'`" != "x" ]; then
  str=`echo $str | sed 's|^ *http://goo.gl/||'`

elif [ "x`echo $str | egrep ' *https://goo.gl/'`" != "x" ]; then
  str=`echo $str | sed 's|^ *https://goo.gl/||'`

fi

if [ "x`echo $str | grep / `" != "x" ]; then
  echo "Bad argument."
  exit 2;
fi

# echo "str: $str"

p3top6=p3top6.rb
convert=convert

tmp="${prefix}/qr-tmp.ppm"
tmp1="${prefix}/qr-tmp1.ppm"
tmp2="${prefix}/qr-tmp2.ppm"
out1="${prefix}/qr-${str}-64x32.ppm"
out2="${prefix}/qr-${str}-64x32.gif"

url="https://goo.gl/$str"

for x in "$tmp" "$tmp1" "$tmp2" "$out1" "$out2"; do
  rm -f "$x"
  [ -f "$x" ] && exit 9
  touch "$x"
  [ ! -f "$x" ] && exit 9
done

RGB1="0xff 0x02 0x02"
RGB2="#FF0202"
XXX1="0x00 0x00 0x00"
XXX2="#000000"
ZZZZ="#000000"

( cat << --EOF--
P3
# stdin
37 37
255
--EOF--
perl $scr "$url" \
| sed -e 's/0/P/g' -e 's/1/Q/g' \
| sed -e "s/P/${RGB1} /g" -e "s/Q/${XXX1} /g"
) \
| $p3top6 \
| convert - -crop 29x29+4+4 - \
| convert - -background "${RGB2}" -gravity center -extent 31x31 - \
| convert - -background "${XXX2}" -gravity northwest -extent 32x32 - \
| convert - -background "#000000" -gravity east -extent 64x32 - \
> $tmp

ls -l $tmp 2>&1 \
&& convert "$tmp" "$out2" \
&& mv "$tmp" "$out1" \
&& /bin/rm -f "$tmp" "$tmp1" "$tmp2" 2>&1

# echo "rename: $tmp -> $out1, $out2"
echo "result: $out1" 2>&1
echo "result: $out2" 2>&1

exit 0;
