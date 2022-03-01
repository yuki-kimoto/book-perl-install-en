use strict;
use warnings;
use Data::Dumper;

# モジュールの読み込みと関数のインポート
use Getopt::Long 'GetOptions';

# オプションの処理
GetOptions(
  'help|h'  => \my $help,
  'conf|c=s'  => \my $conf_file,
  'include|I=s' => \my @includes,
);

# オプション以外の通常のコマンドライン引数を受け取る 
my @args = @ARGV;

# オプション引数と通常のコマンドライン引数を出力
warn Dumper [
  $help,
  $conf_file,
  \@includes,
  \@args,
];
