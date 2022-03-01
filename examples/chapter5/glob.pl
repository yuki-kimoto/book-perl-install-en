use strict;
use warnings;
use Data::Dumper;
use FindBin;

# glob関数でファイル名を取得
my @files = glob "$FindBin::Bin/*";

# ファイル一覧を表示
warn Dumper \@files;
