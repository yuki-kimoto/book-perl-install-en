use strict;
use warnings;

use File::Basename 'basename';

my $file = '/foo/bar.txt';

# ベース名を取得
my $base_name = basename $file;

print "$base_name\n";
