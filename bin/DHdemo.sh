#!/bin/sh

# Last update: Sat Apr 30 08:46:40 JST 2022 by @hohno_at_kuimc

g=2
p=1000003
p=163
p=1009
p=10007
p=99991
#p=100003
#p=999983
#p=1000003

echo "g = $g"
echo "p = $p"
echo ""

rnd1=$(od -An -tu4 -N4 /dev/urandom | tr -d ' ')
rnd2=$rnd1

while [ "$rnd1" = "$rnd2" ]; do
  rnd2=$(od -An -tu4 -N4 /dev/urandom | tr -d ' ')
  # echo -n "."
done
# echo 

echo "rnd1 = $rnd1"
echo "rnd2 = $rnd2"
echo ""

Sa=$(($rnd1 % $p))
Sb=$(($rnd2 % $p))

#Sa=22
#Sb=80
#Sa=999
#Sb=1007

echo 'Sa = rnd1 % p =' "$rnd1 % $p = $Sa"
echo 'Sb = rnd2 % p =' "$rnd2 % $p = $Sb"
echo ""

Pa=$(calc -- "mod((2 ** $Sa), $p)" | tr -d ' 	')
Pb=$(calc -- "mod((2 ** $Sb), $p)" | tr -d ' 	')

echo 'Pa = mod((2^Sa),p) =' "mod((2^$Sa),$p) = $Pa"
echo 'Pb = mod((2^Sb),p) =' "mod((2^$Sb),$p) = $Pb"
echo ""


Ka=$(calc -- "mod(($Pb ** $Sa), $p)" | tr -d ' 	')
Kb=$(calc -- "mod(($Pa ** $Sb), $p)" | tr -d ' 	')

echo 'Ka = mod((Pb^Sa),p)' "= mod(($Pb^$Sa),$p) = $Ka"
echo 'Kb = mod((Pa^Sb),p)' "= mod(($Pa^$Sb),$p) = $Kb"
echo ""

Kcommon=$(calc -- "mod((2 ** ($Sa * $Sb)), $p)" | tr -d ' 	')

echo 'Kcommon = mod((2^(Sa*Sb)),p)' "= mod((2^($Sa*$Sb)),$p) = $Kcommon"
echo ""
