#!/bin/sh

# Last update: 2026-05-23(Sat) 15:19 JST / 2026-05-23(Sat) 06:19 UTC

# calc-cd4cn.sh

# calculate check digit for corporation number

# 法人番号のチェックサムを計算するスクリプト

# 引数が1つであること、および12桁の数字であることを確認
if [[ $# -ne 1 ]] || [[ ! "$1" =~ ^[0-9]{12}$ ]]; then
    echo "エラー: 12桁の会社法人等番号を1つだけ入力してください。" >&2
    echo "使い方: $0 [12桁の番号]" >&2
    exit 1
fi

base_num="$1"
total=0

# 一の位（右端）から順に処理するため、ループを11から0まで逆順に回す
# $n は算式の「n桁目（1〜12）」に対応
for i in {11..0}; do
    # 右から数えて何桁目かを計算 (1〜12)
    n=$(( 12 - i ))
    
    # 奇数桁なら1、偶数桁なら2
    if (( n % 2 != 0 )); then
        q_n=1
    else
        q_n=2
    fi
    
    # 指定位置の文字を1桁切り出す (${文字列:位置:長さ})
    p_n="${base_num:i:1}"
    
    # 積を足していく
    total=$(( total + p_n * q_n ))
done

# 国税庁の算式: 9 - (合計を9で割った余り)
check_digit=$(( 9 - (total % 9) ))

echo "$check_digit"

