#!/bin/sh

# First version: Sat Apr 30 08:46:40 JST 2022 by @hohno_at_kuimc
# Last update: Sat Apr 30 17:45:01 JST 2022 by @Hohno_at_kuimc

g=2

#p=${1-163}
#p=${1-1009}
#p=${1-10007}
p=${1-99991}
#p=${1-100003}
#p=${1-999983}
#p=${1-1000003}

echo "g = $g"
echo "p = $p"
echo ""

Rnd1=$(od -An -tu4 -N4 /dev/urandom | tr -d ' ')
Rnd2=$Rnd1

while [ "$Rnd1" = "$Rnd2" ]; do
  Rnd2=$(od -An -tu4 -N4 /dev/urandom | tr -d ' ')
  # echo -n "."
done
# echo 

echo "# 乱数発生"
echo "Rnd1 = $Rnd1"
echo "Rnd2 = $Rnd2"
echo ""

Sa=$(($Rnd1 % $p))
Sb=$(($Rnd2 % $p))

#Sa=22
#Sb=80
#Sa=999
#Sb=1007

echo "# 秘匿鍵を生成"
echo 'Sa = Rnd1 % p =' "$Rnd1 % $p = $Sa"
echo 'Sb = Rnd2 % p =' "$Rnd2 % $p = $Sb"
echo ""

Pa=$(calc -- "mod((2 ** $Sa), $p)" | tr -d ' 	')
Pb=$(calc -- "mod((2 ** $Sb), $p)" | tr -d ' 	')

echo "# 公開鍵を生成"
echo 'Pa = mod((g^Sa),p) =' "mod((2^$Sa),$p) = $Pa"
echo 'Pb = mod((g^Sb),p) =' "mod((2^$Sb),$p) = $Pb"
echo ""

Ka=$(calc -- "mod(($Pb ** $Sa), $p)" | tr -d ' 	')
Kb=$(calc -- "mod(($Pa ** $Sb), $p)" | tr -d ' 	')

echo "# 相手の公開鍵と自分の秘匿鍵から共有鍵を生成"
echo 'Ka = mod((Pb^Sa),p)' "= mod(($Pb^$Sa),$p) = $Ka"
echo 'Kb = mod((Pa^Sb),p)' "= mod(($Pa^$Sb),$p) = $Kb"
echo ""

Kcommon=$(calc -- "mod((2 ** ($Sa * $Sb)), $p)" 2>&1 | expand | sed 's/^ *//')

echo "# 共有鍵を確認（Sa*Sb の大きさによってはエラーになることもある）"
echo 'Kcommon = mod((2^(Sa*Sb)),p)' "= mod((2^($Sa*$Sb)),$p) = $Kcommon"
echo ""
