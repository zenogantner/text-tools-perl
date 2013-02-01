#!/usr/bin/perl

# (c) 2008, 2009 by Zeno Gantner <zeno.gantner@gmail.com>

# This is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This software is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with MyMediaLite.  If not, see <http://www.gnu.org/licenses/>.

use strict;
use warnings;

use Carp;
use File::Basename;
#use File::Slurp;
use Getopt::Long;

# TODO: usage, add randomness

GetOptions(
	   'k=i'         => \(my $k = 5),
	   'name=s'      => \(my $name = ''),
	   'suffix=s'    => \(my $suffix = ''),
	   'target-dir=s'=> \(my $target_dir = ''),
	  )
  or croak 'Error parsing command line arguments';

my $filename;
my $path   = '';

if ($name eq '') {
    if (scalar @ARGV > 0) {
	($filename, $path, $suffix) = fileparse($ARGV[0], qr/\..+/);

	$name = $filename;
    }
    else {
	$name = 'split';
    }
}

# create output filehandles
my @target_handles = ();
foreach my $fold (1 .. $k) {
    my $filename = "$target_dir/$name.$fold$suffix";

    open my $FILEHANDLE, '>', $filename
      or croak "Could not open file $filename for reading";
    push @target_handles, $FILEHANDLE;
}

# read lines and distribute to the different files
my $line_number = 0;
while (<>) {
    my $line = $_;

    my $CURRENT_HANDLE = $target_handles[$line_number % $k];
    print $CURRENT_HANDLE $line;

    $line_number++;
}

exit 0;
