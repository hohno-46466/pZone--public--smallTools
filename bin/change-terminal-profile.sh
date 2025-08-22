#!/bin/bash

# First version: 2025-04-24(Thu) 19:56 JST / 2025-04-24(Thu) 10:56 UTC

pname=$(basename $0)
n="$1"
x="$2"

if [[ -z "$n" || ! "$n" =~ ^[0-9]+$ ]]; then
  echo "使用法: ${pname} <番号>"
  echo "使用法: ctp <番号>"
  echo "設定可能なプロファイル一覧:"
  get-terminal-profiles.sh
  echo "使用法: sttb <番号>"
  get-terminal-tabbars.sh
  exit 1
fi

name="$(get-terminal-profiles.sh | sed -n "${n}p" | expand | /usr/bin/sed -e 's/#.*$//' -e 's/ *$//' -e 's/^ *[0-9]* *//')"

if [  -z "$name" ]; then
  echo "無効な番号です。"
  return 1
fi

echo set-terminal-profile.sh "$name"
set-terminal-profile.sh "$name"
# set-terminal-tabbar.sh "$x"
# source ~/.bashrc
if declare -f sttb > /dev/null; then
  sttb "$x"
else
  if declare -f sttb > /dev/null; then
    sttb "$x"
  fi
  echo "Try \"sttb $x\" manually"
  sttb
fi

# echo "Debug: ${BASH_PROFILE_NAME}"

