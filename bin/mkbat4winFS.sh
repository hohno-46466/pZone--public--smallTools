#! /bin/sh
#
# mkbat4winFS.sh - Create a windows batch file to replace the UNIX symbolic link in the current directory with a windows-style symbolic link
#
# Note: Save the output of this script as a batch file (.bat extension) and run it on Windows PowerShell with administrative privileges. 
#
# Last update: Mon Oct  4 06:55:42 JST 2021
#

if [ "x$1" = "x-h" -o "x$1" = "x--help" ]; then
  echo "usage: $0 [-d|/d]"
  exit 9
elif [ "x$1" = "x-d" -o "x$1" = "x/d" ]; then
  OPTION="/d"
fi

ls -l | egrep -e '->' | awk '{print $9, $11}' | sed 's|/|\\|g' | awk -v "opt=$OPTION" '{printf "del %s\ncmd.exe /c mklink %s %s %s\n",$1,opt,$1,$2}'
