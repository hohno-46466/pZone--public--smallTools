#!/usr/bin/env perl
#
# usage: perl mkqrcode.pl [ URL [ ECC [ Version [ ModuleSize ] ] ] ]
#
# Last update: 2026-10-05(Mon) 07:34 JST / 2026-10-04(Sun) 22:34 UTC
#

use strict;
use warnings;
use GD::Barcode::QRcode;
use File::Path qw(make_path); # ディレクトリ作成用

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

my $debugFlag = 0;
my $url  = 'https://goo.gl/';
my $home = $ENV{"HOME"};
my $out  = "$home/tmp/qr.gif";
my $QRversion    = 3;
my $QRecc        = 'H';
my $QRmoduleSize = 4;

if ((@ARGV >= 1) && (($ARGV[0] eq "-h") || ($ARGV[0] eq "--help"))) {
  print "usage: perl mkqrcode.pl [ -d|--debug ] [ URL [ ECC [ Version [ ModuleSize ] ] ] ]\n";
  exit(0);
}

while ((@ARGV >= 1) && (($ARGV[0] eq "-d") || ($ARGV[0] eq "--debug"))) {
  $debugFlag++;
  shift;
}

# shift を使って順番に割り当てる（引数のズレを防止）
if (@ARGV >= 1) { $url = shift; }
if (@ARGV >= 1) { $QRecc = shift; }
if (@ARGV >= 1) { $QRversion = shift; }
if (@ARGV >= 1) { $QRmoduleSize = shift; }
 
#TEXT# my $qr  = GD::Barcode::QRcode->new($url, {Ecc => 'H', Version => 3, ModuleSize => 1});
#TEXT# my $qrstr = $qr->barcode();
#TEXT# print STDOUT "$qrstr";
#TEXT# exit(0);

my $qr;

eval {
  $qr  = GD::Barcode::QRcode->new($url, {
#    Ecc => 'M', Version => 3, ModuleSize => 2,
#    Ecc => 'H', Version => 3, ModuleSize => 2,
#    Ecc => 'H', Version => 3, ModuleSize => 4,
     Ecc => $QRecc, Version => $QRversion, ModuleSize => $QRmoduleSize,
  })->plot;
};

if ($@ || !$qr) { # $qr が空の場合も考慮
  if ($debugFlag >= 1) { 
    print("Can't create QRcode with Ecc=>'$QRecc' and Version=>'$QRversion'\n");
    if ($@) { print("Raw Error: $@\n"); } # 生のエラーメッセージを表示
  }
  exit(99);
}

# 出力先ディレクトリ (~/tmp) がなければ自動作成
my ($dir) = $out =~ m|(.*)/|;
if (!-d $dir) {
  make_path($dir);
}

# エラー時に理由がわかるように die に $! を追加
open my $fh, '>', $out or die "Can't open $out: $!";

if ($debugFlag >= 2) { 
  print("QRcode with Ecc=>'$QRecc' and Version=>'$QRversion' has been created.\n");
}
if ($debugFlag >= 1) {
  print "output: $out\n";
}
print {$fh} $qr->gif;
close $fh;

exit(0);
