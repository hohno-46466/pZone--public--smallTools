#!/usr/bin/env perl
use strict;
use warnings;
use GD::Barcode::QRcode;

my $url = 'https://goo.gl/';
my $home = $ENV{"HOME"};
my $out="$home/tmp/qr.gif";

if (@ARGV >= 1) {
  $url = $ARGV[0];
}
 
my $qr  = GD::Barcode::QRcode->new($url, {Ecc => 'H', Version => 3, ModuleSize => 1});
my $qrstr = $qr->barcode();
print STDOUT "$qrstr";

#QR# my $qr  = GD::Barcode::QRcode->new($url, {
#QR# #    Ecc => 'M', Version => 3, ModuleSize => 2,
#QR# #    Ecc => 'H', Version => 3, ModuleSize => 2,
#QR#      Ecc => 'H', Version => 3, ModuleSize => 4,
#QR# })->plot;
#QR# 
#QR# open my $fh, '>', $out or die;
#QR# # print "output: $out\n";
#QR# print {$fh} $qr->gif;
#QR# close $fh;

exit(0);
