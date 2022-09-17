#!/bin/sh

# mkqrcodeG2-as-text.sh

# Last update:  Sun Sep 18 04:05:05 JST 2022

# export LANG=C

URL="https://goo.gl/"
OUT="$HOME/tmp/QRout.gif"

if [ "x$1" != "x" ]; then
  URL="$1"
fi

# echo "[$OUT]"

# echo  qr --error-correction=H --ascii "$URL"
qr --error-correction=H --ascii "$URL" | sed -n '3,$p' | sed -e '$d' 
echo "    $URL"
# echo ""

exit "$?"

# #!/usr/bin/env perl
# use strict;
# use warnings;
# use GD::Barcode::QRcode;
# 
# my $url = 'https://goo.gl/';
# my $home = $ENV{"HOME"};
# my $out="$home/tmp/qr.gif";
# 
# if (@ARGV >= 1) {
#   $url = $ARGV[0];
# }
#  
# my $qr  = GD::Barcode::QRcode->new($url, {Ecc => 'H', Version => 3, ModuleSize => 1});
# my $qrstr = $qr->barcode();
# print STDOUT "$qrstr";
# 
# #QR# my $qr  = GD::Barcode::QRcode->new($url, {
# #QR# #    Ecc => 'M', Version => 3, ModuleSize => 2,
# #QR# #    Ecc => 'H', Version => 3, ModuleSize => 2,
# #QR#      Ecc => 'H', Version => 3, ModuleSize => 4,
# #QR# })->plot;
# #QR# 
# #QR# open my $fh, '>', $out or die;
# #QR# # print "output: $out\n";
# #QR# print {$fh} $qr->gif;
# #QR# close $fh;
# 
# exit(0);
