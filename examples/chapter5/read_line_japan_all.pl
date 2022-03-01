use strict;
use warnings;
use utf8;
use Encode 'encode', 'decode';

my $file = 'book.csv';
open my $fh, '<', $file
  or die "Can't open file \"$file\": $!";

# 一度に読み込む
my $content = do { local $/; <$fh> };
$content = decode('UTF-8', $content);

# 好きな処理
# ...

# UTF-8バイト列にエンコードして出力
print encode('UTF-8', $content);
