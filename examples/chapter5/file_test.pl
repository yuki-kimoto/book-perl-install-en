use strict;
use warnings;

use FindBin;

# ファイルとディレクトリの存在確認
my $file = "$FindBin::Bin/glob.pl";

my $file_none = "$FindBin::Bin/none.pl";

my $dir = "$FindBin::Bin/find_files";

if (-e $file) {
  print "-e File Found\n";
}

if (-e $dir) {
  print "-e Directory Found\n";
}

if (-f $file) {
  print "-f File Found\n";
}

if (-f $file_none) {
  
}
else {
  print "-f File Not Found\n";
}

if (-d $dir) {
  print "-d Directory Found\n";
}

# ファイルサイズ
my $file_size = -s $file;

print "File size $file_size bytes\n";

# 最終更新からの経過日数
my $file_dates_after_last_modify = -M $file;

print "Dates after last modify: $file_dates_after_last_modify\n";
