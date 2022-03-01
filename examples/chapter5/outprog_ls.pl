use strict;
use warnings;

# lsコマンドを実行
my $cmd = 'ls';
system($cmd) == 0
  or die "Can't execute command $cmd: $!";
