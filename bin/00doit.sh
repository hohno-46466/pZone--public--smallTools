#! /bin/sh
TARGET=$HOME/bin
rsync -avE "$@" $(pwd)/ $TARGET 
