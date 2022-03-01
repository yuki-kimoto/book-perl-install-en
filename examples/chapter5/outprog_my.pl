use strict;
use warnings;

# 自分で作ったPerlプログラムを実行
my @cmd = qw(perl basename.pl);
system(@cmd) == 0
  or die "Can't execute command @cmd: $!";
