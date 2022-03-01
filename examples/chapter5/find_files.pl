use strict;
use warnings;

use FindBin;
use File::Find 'find';

my $root_dir = "$FindBin::Bin/find_files";

find(
  {
    wanted => sub {
      my $abs_name = $File::Find::name;
      my $rel_name = $abs_name;
      $rel_name =~ s/^\Q$root_dir\///;
      
      print "$rel_name\n";
    },
    no_chdir => 1
  }, 
  $root_dir
);
