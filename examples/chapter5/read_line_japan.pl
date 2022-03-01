use strict;
use warnings;
use utf8;
use Encode 'encode', 'decode';

my $file = 'book.csv';
open my $fh, '<', $file
  or die "Can't open file \"$file\": $!";

while (my $line = <$fh>) {
  
  # Perlの内部文字列にデコード
  $line = decode('UTF-8', $line);
  
  # 改行を削除
  chomp $line;
  
  # 好きな処理
  # ...
  
  # UTF-8バイト列にエンコードして出力
  print encode('UTF-8', $line) . "\n";
}
