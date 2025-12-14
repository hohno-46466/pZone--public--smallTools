#! /bin/bash

TERMINAL_PROFILE_NAME_FILE="$HOME/.terminal_profile_names"

pname="$(basename $0)"
n="$1"

if [[ -z "$n" || ! "$n" =~ ^[0-9]+$ ]]; then
  echo "使用法: $0 <番号>（get-terminal-tabbars.sh でも番号を確認）" 1>&2
  get-terminal-tabbars.sh 1>&2
  exit 1
fi 


echo "Use \"sttb $n\" instead."

exit 9

# name=$(grep -v '^#' "$TERMINAL_PROFILE_NAME_FILE" | expand | sed -e '/^ *$/d' | sed -n "${n}p")
# 
# if [[ -z "$name" ]]; then 
#   echo "無効な番号です。" 1>&2
#   exit 1
# fi
# 
# if declare -f set_terminal_tabbar >/dev/null; then
#   set_terminal_tabbar $name 
# fi
# 
# if declare -f my_prompt_command >/dev/null; then
#   my_prompt_command 
# fi
