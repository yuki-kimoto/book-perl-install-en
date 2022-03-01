use strict;
use warnings;

# 「ls -1」コマンドを実行
my $cmd = 'ls -1';
system($cmd) == 0
  or die "Can't execute command $cmd: $!";
