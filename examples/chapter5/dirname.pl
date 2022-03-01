use strict;
use warnings;

use File::Basename 'dirname';

my $file = '/foo/bar.txt';

# ディレクトリ名を取得
my $base_name = dirname $file;

print "$base_name\n";
