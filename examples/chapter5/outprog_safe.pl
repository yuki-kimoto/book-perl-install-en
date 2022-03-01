use strict;
use warnings;

# 「ls -1」コマンドを安全に実行
my @cmd = qw(ls -1);
system(@cmd) == 0
  or die "Can't execute command @cmd: $!";
