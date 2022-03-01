use strict;
use warnings;
use utf8;

use Giblog;
use Mojolicious::Lite;

# Build
Giblog->build;

# Mojolicious::Lite Application
my $app = app;

# 書籍のPDFの作成
my $cmd = 'perl create_book_pdf.pl';
system($cmd) == 0
  or die "Fail executing command $cmd";

# Serve
Giblog->serve($app);
