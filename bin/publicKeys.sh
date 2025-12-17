#!/bin/sh

# publicKeys.sh

# Prev update: Sun Feb 23 10:18:04 JST 2025
# Prev update: 2025-12-15(Mon) 05:45 JST / 2025-12-14(Sun) 20:45 UTC
# Last update: 2025-12-15(Mon) 17:13 JST / 2025-12-15(Mon) 08:13 UTC

# for key in ~/.ssh/*.pub; do
#   if ssh-keygen -lf "$key" 2>/dev/null | grep -q "$(ssh-add -l | awk '{print $2}')"; then
#     echo "Matching public key: $key"
#   fi
# done

# FINGERPRINTS="$(ssh-add -l | awk '{print $2}')"
# for pubkeyfile in ~/.ssh/*.pub; do
#   pubkeyinfo="$(ssh-keygen -lf "$pubkeyfile" 2>/dev/null)"
#   fingerprint="$(echo $pubkeyinfo | awk '{print $2}')"
#   if echo "$FINGERPRINTS" | grep -Fxq "$fingerprint"; then
#     # echo "Matching public key: $pubkeyfile"
#     # echo "$pubkeyfile"
#     echo "$(echo $pubkeyinfo | awk '{print $1, $2}') $pubkeyfile"
#   fi
# done

# agentのfingerprint一覧を作る（fingerprintっぽい行（第2フィールドが "SHA256:" か "MD5:"）だけ抽出）
FINGERPRINTS="$(ssh-add -l 2>/dev/null | awk '$2 ~ /^(SHA256:|MD5:)/ {print $2}')"

# agentに鍵が無ければ終了（無駄なループを避ける）
[ -n "$FINGERPRINTS" ] || exit 1

# pubkeyfile を位置パラメタとしてセット
set -- "$HOME"/.ssh/*.pub
# pubkeyfile がひとつも無ければ終了
[ -e "$1" ] || exit 2

# pubeyfile を位置パラメタからひとつずつ取り出してテスト
for pubkeyfile in "$@"; do
  # pubkey についての情報を得る
  # 例： 4096 SHA256:Y9JI3BorfR...XYw7k4TGh5L6 コメント
  pubkeyinfo="$(ssh-keygen -lf "$pubkeyfile" 2>/dev/null)" || continue

  # pubkeyinfo から fingerprint を抜き出す
  fingerprint="$(printf '%s\n' "$pubkeyinfo" | awk '{print $2}')"

  if printf '%s\n' "$FINGERPRINTS" | grep -Fxq "$fingerprint"; then
    # $FINGERPRINTS に$fingerprint が含まれていたら「鍵長 fingerprint ファイル名」を出力
    printf '%s %s %s\n' \
      "$(printf '%s\n' "$pubkeyinfo" | awk '{print $1}')" \
      "$fingerprint" \
      "$pubkeyfile"
  fi
done

exit 0
