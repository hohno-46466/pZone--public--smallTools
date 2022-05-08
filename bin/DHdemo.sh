#!/bin/sh

# First version: Sat Apr 30 08:46:40 JST 2022 by @hohno_at_kuimc
# Prev update: Sat Apr 30 17:45:01 JST 2022 by @hohno_at_kuimc
# Last update: Sun May  1 06:47:15 JST 2022 by @hohno_at_kuimc

calc=apcalc

g=2

#p=${1-163}
#p=${1-1009}
#p=${1-10007}
p=${1-99991}
#p=${1-100003}
#p=${1-999983}
#p=${1-1000003}

Sa="$2"
Sb="$3"

#Sa=22
#Sb=80
#Sa=999
#Sb=1007

echo "g = $g"
echo "p = $p"
echo ""

if [ "x$2" != "x" -a "x$3" != "x" ]; then

  Sa=$(($Sa % $p))
  Sb=$(($Sb % $p))

  echo "# 秘匿鍵を決定"
  echo "Sa = $Sa"
  echo "Sb = $Sb"
  echo ""

else

  Rnd1=$(od -An -tu4 -N4 /dev/urandom | tr -d ' ')
  Rnd2=$Rnd1
  
  while [ "$Rnd1" = "$Rnd2" ]; do
    Rnd2=$(od -An -tu4 -N4 /dev/urandom | tr -d ' ')
    # echo -n "."
  done
  # echo 
  
  echo "# 乱数発生（秘匿鍵生成用）"
  echo "Rnd1 = $Rnd1"
  echo "Rnd2 = $Rnd2"
  echo ""
  
  Sa=$((($Rnd1 % ($p-1)) + 1))
  Sb=$((($Rnd2 % ($p-1)) + 1))

  echo "# 乱数から秘匿鍵を生成（１以上，p(=$p) 未満の整数）"
  echo "Sa = (Rnd1 mod (p-1))+1 = ($Rnd1 mod ($p-1))+1 = $Sa  # where 0 < Sa < $p)"
  echo "Sb = (Rnd2 mod (p-1))+1 = ($Rnd2 mod ($p-1))+1 = $Sb  # where 0 < Sb < $p)"
  echo ""

fi

Pa=$(calc -- "(2 ** $Sa) % $p" | expand | tr -d ' ')
Pb=$(calc -- "(2 ** $Sb) % $p" | expand | tr -d ' ')

echo "# 秘匿鍵から公開鍵を生成"
echo "Pa = g^Sa mod p = 2^$Sa mod $p = $Pa"
echo "Pb = g^Sb mos p = 2^$Sb mod $p = $Pb"
echo ""

Ka=$(calc -- "($Pb ** $Sa) % $p" | expand | tr -d ' ')
Kb=$(calc -- "($Pa ** $Sb) % $p" | expand | tr -d ' ')

echo "# 相手の公開鍵と自分の秘匿鍵から共有鍵を生成"
echo "Ka = Pb^Sa mod p = $Pb^$Sa mod $p = $Ka"
echo "Kb = Pa^Sb mod p = $Pa^$Sb mod $p = $Kb"
echo ""

Kcommon=$($calc -- "(2 ** ($Sa * $Sb)) % $p" 2>&1 | expand | sed 's/^ *//')

echo "# 共有鍵を確認（Sa*Sb の大きさによっては計算できないこともある）"
echo "Kcommon = 2^(Sa*Sb) mod p = 2^($Sa*$Sb) mod $p = 2^$((Sa*$Sb)) mod $p = $Kcommon"
echo ""
