use strict;
use warnings;

my $file = 'book.csv';
open my $fh, '<', $file
  or die "Can't open file \"$file\": $!";
