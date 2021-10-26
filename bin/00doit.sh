#! /bin/sh

# Last update: Wed Oct 27 06:38:35 JST 2021 by @hohno_at_kuimc

TARGET=$HOME/bin

opts="--exclude '*.swp'"
opts="$opts --exclude '*~'"
opts="$opts --exclude '*.bak'"
opts="$opts --exclude '00doit.sh'"

echo $(echo rsync -avE $@ $opts $(pwd)/ $TARGET)
eval $(echo rsync -avE $@ $opts $(pwd)/ $TARGET)
