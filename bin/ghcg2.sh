#!/bin/sh

# Last update: Sun Jul 10 12:18:04 JST 2022

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

rm -f ${READMEnew} || exit 2
rm -f ${READMEtmp1} || exit 3
rm -f ${READMEtmp2} || exit 4
rm -f ${READMEtmp3} || exit 5

cat ${READMEold} | sed -n -e "1,/ \.\/$zone/p" | sed '$d' | cat -s | tee ${READMEtmp1} >> ${READMEnew}

# (cd ..; for x in ${zone}*; do echo $x 1>&2; cd $x; n=$(treex -L 4 | wc -l); if [ $n -gt 80 ]; then treex -L 3; else echo $(treex -L 4|wc -l); fi; cd .. ; echo; done) | cat -s | tee ${READMEtmp2} >> ${READMEnew}

if [ "x$flag" = "xg" ]; then
  (cd ..; for x in ${zone}*; do echo $x 1>&2; cd $x; n=$(treex -L 4 | wc -l); if [ $n -gt 80 ]; then treex -L 3; else treex -L 4; fi; cd .. ; echo; done) | cat -s | tee ${READMEtmp2} >> ${READMEnew}
else
  x="$zone"; echo $x 1>&2; n=$(treex -L 4 | wc -l); (if [ $n -gt 80 ]; then treex -L 3; else treex -L 4; fi) | cat -s | tee ${READMEtmp2} >> ${READMEnew}
fi

# (echo; (cat ${READMEold} | sed -n '/directories/,$p')) | sed '1,/directories/d' >> ${READMEnew}
# cat ${READMEold} | sed -n '/^Note:/,$p' >>  ${READMEnew}
# tac ${READMEold} | sed -n -e '1,/director.*JST 20[0-9][0-9]/p'| tac | tail +2 | cat -s | tee ${READMEtmp3} >> ${READMEnew}
# tac ${READMEold} | sed -n -e '1,/[0-9] *director.*,.*[0-9] *file/p'| tac | tail +2 | cat -s | tee ${READMEtmp3} >> ${READMEnew}
tac ${READMEold} | sed -n -e '1,/[0-9]* *director.*,.*[0-9] *file/p'| tac | tail +2 | cat -s | tee ${READMEtmp3} >> ${READMEnew}

exit $?

