#!/bin/sh

# publicKeys.sh

# Prev update: Sun Feb 23 10:18:04 JST 2025
# Last update: 2025-12-15(Mon) 05:45 JST / 2025-12-14(Sun) 20:45 UTC

# for key in ~/.ssh/*.pub; do
#   if ssh-keygen -lf "$key" 2>/dev/null | grep -q "$(ssh-add -l | awk '{print $2}')"; then
#     echo "Matching public key: $key"
#   fi
# done

FINGERPRINTS="$(ssh-add -l | awk '{print $2}')"
for pubkeyfile in ~/.ssh/*.pub; do
  pubkeyinfo="$(ssh-keygen -lf "$pubkeyfile" 2>/dev/null)"
  fingerprint="$(echo $pubkeyinfo | awk '{print $2}')"
  if echo "$FINGERPRINTS" | grep -Fxq "$fingerprint"; then
    # echo "Matching public key: $pubkeyfile"
    # echo "$pubkeyfile"
    echo "$(echo $pubkeyinfo | awk '{print $1, $2}') $pubkeyfile"
  fi
done
