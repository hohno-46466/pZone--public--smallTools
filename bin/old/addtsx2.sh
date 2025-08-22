#!/bin/sh
while IFS= read -r line; do printf "$(date +%Y%m%d-%H%M%S.%3N)\t$line\n"; done 
