#!/bin/sh

# mkd4gc - Make a dummy file for GitHub Contribution Graph

mesg_and_exit () {
  _ret=$1
  shift
  echo "$@"
  exit $_ret
}

TARGETDIR="$HOME/GitHub"
TARGETREPO=${1-"hohno-46466--Private"}
TARGETFILE1="._lastupdate_"
TARGETFILE2=".dummy4GHCG.tsv"

[ -d ${TARGETDIR}/${TARGETREPO} ] || mesg_and_exit 1 "Can't find ${TARGETREPO}"

echo "Target: ${TARGETDIR}/${TARGETREPO}/${TARGETFILE1}"

cd ${TARGETDIR}/${TARGETREPO} || exit 2

export LANG=C
echo "$(date)	$(date +%s)" | tee $TARGETFILE1 | tee -a $TARGETFILE2

