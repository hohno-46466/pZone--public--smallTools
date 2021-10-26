#! /bin/sh

TARGET=$HOME/bin

opt="--exclude '.*.swp'"
opt="$opt --exclude '*~'"
opt="$opt --exclude '*.bak'"
opt="$opt --exclude '00doit.sh'"

rsync -avE "$@" $opt $(pwd)/ $TARGET 
