#! /bin/sh

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
tmp3="${prefix}/qr-tmp3.ppm"
out="${prefix}/qr-${str}.ppm"

url="https://goo.gl/$str"

for x in "$tmp" "$tmp1" "$tmp2" "$tmp3" "$out"; do
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
> $tmp

convert - -crop 32x16+0+0 - < $tmp > $tmp1
convert - -crop 32x16+0+16 -rotate 180 - < $tmp > $tmp2

convert +append $tmp1 $tmp2 - \
| convert - -background "${ZZZZ}" -gravity east -extent 64x16 - \
> $tmp3
# | convert - gif:- \

ls -l $tmp $tmp1 $tmp2 $tmp3 2>&1

# && mv "$tmp" "$out" \

#/bin/rm -f "$tmp" "$tmp1" "$tmp2" 2>&1

# echo "rename: $tmp -> $out"
# echo "result: $out"2>&1

exit 0;

