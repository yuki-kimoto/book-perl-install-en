use strict;
use warnings;
use Data::Dumper;
use FindBin;
use File::Basename 'basename';

# glob関数でファイル名を取得
my @files = map { basename $_ } glob "$FindBin::Bin/*";

# ファイル一覧を表示
warn Dumper \@files;
