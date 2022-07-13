#!/bin/sh

# Last update: Sun Jul 10 12:18:04 JST 2022

zone=${1:-bZone}

cd $HOME/GitHub
cd $zone

READMEnew=README.md
READMEold=README.md.old
READMEnew2=README2.md

[ ! -f ${README} ] && exit 1

cp -p ${READMEnew} ${READMEold} || exit 2

rm -f ${READMEnew} || exit 2

cat ${READMEold} | sed -n -e "1,/.\/$zone/p" | sed '$d' >> ${READMEnew}

(cd ..; for x in ${zone}*; do echo $x 1>&2; cd $x; n=$(treex -L 4 | wc -l); if [ $n -gt 50 ]; then treex -L 3; else echo $(treex -L 4|wc -l); fi; cd .. ; echo; done

# (echo; (cat ${READMEold} | sed -n '/directories/,$p')) | sed '1,/directories/d' >> ${READMEnew}
# cat ${READMEold} | sed -n '/^Note:/,$p' >>  ${READMEnew}
tac ${READMEold} | sed -n -e '1,/director.*JST 20[0-9][0-9]/p'| tac | tail +2 >> ${READMEnew}

exit $?

