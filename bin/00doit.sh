#! /bin/sh
TARGET=$HOME/bin
rsync -avE "$@" --exclude=00doit.sh $(pwd)/ $TARGET 
