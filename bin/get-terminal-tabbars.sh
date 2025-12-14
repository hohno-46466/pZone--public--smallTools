#!/bin/sh

TERMINAL_PROFILE_NAME_FILE="$HOME/.terminal_profile_names"

echo "タブバーに設定可能なプロファイル一覧:"
grep -v '^#' "$TERMINAL_PROFILE_NAME_FILE" | expand | sed '/^ *$/d' | cat -n

