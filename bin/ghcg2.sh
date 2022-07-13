#!/bin/sh

# Last update: Thu Jul 14 03:38:16 JST 2022

zone=${1:-bZone}

cd $HOME/GitHub
cd $zone || exit 9

flag=g
echo $zone | egrep -q '.Zone--*' && flag=

READMEnew=README.md
READMEold=README.md.old
READMEtmp1=.README.md-tmp1
READMEtmp2=.README.md-tmp2
READMEtmp3=.README.md-tmp3

[ -f ${README} ] || exit 1

cp -p ${READMEnew} ${READMEold} || exit 2

rm -f ${READMEnew} || exit 3
rm -f ${READMEtmp1} ${READMEtmp2} ${READMEtmp3} || exit 4

cat ${READMEold} | sed -n -e "1,/ \.\/$zone/p" | sed '$d' | cat -s | tee ${READMEtmp1} >> ${READMEnew}

if [ "x$flag" = "xg" ]; then
  (cd ..; for x in ${zone}*; do echo $x 1>&2; cd $x; n=$(treex -L 4 | wc -l); if [ $n -gt 80 ]; then treex -L 3; else treex -L 4; fi; cd .. ; echo; done) | cat -s | tee ${READMEtmp2} >> ${READMEnew}
else
  x="$zone"; echo $x 1>&2; n=$(treex -L 4 | wc -l); (if [ $n -gt 80 ]; then treex -L 3; else treex -L 4; fi) | cat -s | tee ${READMEtmp2} >> ${READMEnew}
fi

tac ${READMEold} | sed -n -e '1,/[0-9]* *director.*,.*[0-9] *file/p'| tac | tail +2 | cat -s | tee ${READMEtmp3} >> ${READMEnew}

exit $?

