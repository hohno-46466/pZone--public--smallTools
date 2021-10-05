#!/usr/bin/perl
use strict;
use warnings;
use GD::Barcode::QRcode;

# my $url = 'http://www.google.com';
# my $url = 'https://goo.gl/UlxaEl';
# my $url = 'https://goo.gl/w2H2pL';
# my $url = 'https://goo.gl/cax79E';

# my $url = 'https://goo.gl/lknBwj';
# my $url = 'https://goo.gl/eb8YNe';
# my $url = 'https://goo.gl/kD1dts';
# my $url = 'https://goo.gl/0Tss0z';
# my $url = 'https://goo.gl/UW8UAo';
# my $url = 'https://goo.gl/Cq0G9v';
# my $url = 'https://goo.gl/3dokdk';
# my $url = 'https://goo.gl/38HsGo';

my $url = 'https://goo.gl/';
my $home = $ENV{"HOME"};
my $out="$home/tmp/qr.gif";

if (@ARGV >= 1) {
  $url = $ARGV[0];
}
 
#TEXT# my $qr  = GD::Barcode::QRcode->new($url, {Ecc => 'H', Version => 3, ModuleSize => 1});
#TEXT# my $qrstr = $qr->barcode();
#TEXT# print STDOUT "$qrstr";
#TEXT# exit(0);

my $qr  = GD::Barcode::QRcode->new($url, {
#    Ecc => 'M', Version => 3, ModuleSize => 2,
#    Ecc => 'H', Version => 3, ModuleSize => 2,
     Ecc => 'H', Version => 3, ModuleSize => 4,
})->plot;

open my $fh, '>', $out or die;
# print "output: $out\n";
print {$fh} $qr->gif;
close $fh;

exit(0);
