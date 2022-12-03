#!/bin/sh

# Prev update: Thu Oct 20 10:24:45 JST 2022
# Last update: Thu Oct 20 13:40:44 JST 2022

# pdf-to-2x5nameCards.sh

INFILE="input0.pdf"
if [ -f "$1" ]; then
  INFILE="$1"
fi

# 対応用紙：A-one 名刺用紙10面 No.51861
# 名刺サイズ：91mm × 55mm（裏面には上下に印刷不可領域が 5mmずつある．この領域は下側左右端では印刷不可領域が 15mmまでせり上がっている）
# 用紙マージン：上側 11mm，左側 14mm（よって，下側 297 - 55*5 - 11 = 11mm，右側 210 - 91*2 - 14 = 14mm）


# 印刷に際しては印刷サービス側の設定の影響を受ける
# 現状，macOS では（「用紙サイズに合わせる」等ではなく）「サイズ調整」で「100%」にしている

pdfjam "$INFILE" --scale 0.87 --nup 2x5 --delta "8mm 9.6mm" --offset "0mm 0mm" -o output-by-doit.pdf
echo "(Thu Oct 20 12:21:14 JST 2022)"

# ----------------------------------------------------------

# old challenges:

# pdfjam "$INFILE" --scale 0.87 --nup 2x5 --delta "8mm 9.6mm" --offset "-2mm 0mm" -o output-by-doit.pdf
# echo "(Thu Oct 20 12:15:48 JST 2022)"

# pdfjam "$INFILE" --scale 0.87 --nup 2x5 --delta "4mm 9.6mm" --offset "-2mm 0mm" -o output-by-doit.pdf
# echo "(Thu Oct 20 12:05:53 JST 2022)"

# pdfjam "$INFILE" --scale 0.87 --nup 2x5 --delta "2mm 9.6mm" --offset "-2mm 0mm" -o output-by-doit.pdf
# echo "(Thu Oct 20 12:00:41 JST 2022)"

# pdfjam "$INFILE" --scale 0.94 --nup 2x5 --delta "1mm 0mm" --offset "1mm 1mm" -o output-by-doit.pdf
# echo "(Thu Oct 20 11:40:50 JST 2022)"

# pdfjam "$INFILE" --scale 0.94 --nup 2x5 --delta "0mm 0mm" --offset "0mm 0mm" -o output-by-doit.pdf

# pdfjam "$INFILE" --scale 1.00 --nup 2x5 --delta "0mm 0mm" --offset "0mm 0mm" -o output-by-doit.pdf

# pdfjam "$INFILE" --scale 0.94 --nup 2x5 --delta "2mm 2mm" --offset "0mm 0mm" -o output-by-doit.pdf

## pdfjam "$INFILE" --scale 0.95 --nup 2x5 --delta "1mm 5mm" --offset "0mm 0mm" -o output-by-doit.pdf

# pdfjam input2.pdf --scale 0.94 --nup 2x5 --delta "2mm 5mm" --offset "0mm 0mm" -o output-by-doit.pdf

# pdfjam input2.pdf --scale 0.90 --nup 2x5 --delta "2mm 2mm" --offset "1mm -1mm" -o output-2x5-0p90-d2x2-o1x-1.pdf
