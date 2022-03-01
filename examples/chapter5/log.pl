use strict;
use warnings;
use Time::Piece;

# 現在時刻を取得(2021-09-14 17:19:00)
my $now_tp = Time::Piece::localtime;
my $now = $now_tp->strftime('%Y-%m-%d %H:%M:%S');

my $log_file = 'app.log';
open my $log_fh, '>>', $log_file
  or die "Can't open file \"$log_file\": $!";

# [現在時刻]Perl
my $output = "[$now]Perl\n";

# ファイルへ書き込み
print $log_fh $output;
