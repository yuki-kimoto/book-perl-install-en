use strict;
use warnings;

use File::Basename 'basename';

my $file = '/foo/bar.txt';

my $file_without_ext;
my $file_ext;

# 拡張子前までのファイル名と拡張子を取得
if ($file =~ /(.*)[\.]([^\.]+)$/) {
  $file_without_ext = $1;
  $file_ext = $2;
}

print "$file_without_ext $file_ext\n";

