use strict;
use warnings;

use File::Path 'mkpath';

# ディレクトリを作成
my $dir1 = 'dir1';
mkdir $dir1
  or die "Can't create directory \"$dir1\": $!";

# 複数階層のディレクトリを作成
my $dir2 = 'dir2/foo';
mkpath $dir2;
