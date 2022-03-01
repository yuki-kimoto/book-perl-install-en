use strict;
use warnings;

my $in_file = 'book.csv';
open my $in_fh, '<', $in_file
  or die "Can't open file \"$in_file\": $!";

my $out_file = 'book_out.csv';
open my $out_fh, '>', $out_file
  or die "Can't open file \"$out_file\": $!";

while (my $line = <$in_fh>) {
  # ファイルへ書き込み
  print $out_fh $line;
}
