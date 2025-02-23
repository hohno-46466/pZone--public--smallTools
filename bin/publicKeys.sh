#!/bin/sh

# publicKeys.sh

# Last update: Sun Feb 23 10:18:04 JST 2025

# for key in ~/.ssh/*.pub; do
#   if ssh-keygen -lf "$key" 2>/dev/null | grep -q "$(ssh-add -l | awk '{print $2}')"; then
#     echo "Matching public key: $key"
#   fi
# done

FINGERPRINTS="$(ssh-add -l | awk '{print $2}')"
for key in ~/.ssh/*.pub; do
  fingerprint="$(ssh-keygen -lf "$key" 2>/dev/null | awk '{print $2}')"
  if echo "$FINGERPRINTS" | grep -Fxq "$fingerprint"; then
    echo "Matching public key: $key"
  fi
done
