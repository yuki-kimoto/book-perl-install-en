use strict;
use warnings;

use File::Path 'rmtree';

# ディレクトリを削除
my $dir1 = 'dir1';
rmdir $dir1
  or die "Can't create directory \"$dir1\": $!";

# 複数階層のディレクトリを削除
my $dir2 = 'dir2';
rmtree $dir2;
