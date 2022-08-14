#!/bin/sh

# bkwt - backup with time stamp

PNAME=$(basename $0)

if [ "x$1" = "x" -o ! -f "$1" ]; then
  echo "${PNAME}: usage: ${PNAME} file"
  exit 1
fi

FN="$1"
EXT=$(date +%Y%m%d-%H%M%S)

echo cp -i -p $FN ${FN}-${EXT}
cp -i -p $FN ${FN}-${EXT}

exit $?
