#!/usr/bin/perl

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
binmode STDOUT, ':utf8';
binmode STDERR, ':utf8';

use File::Slurp;
use Getopt::Long;

# quick and dirty, this could of course be optimized, and generalized

## TODO: get tagged bibtex items which have NO description??

my $file1 = shift;
my $file2 = shift;

my @lines1 = read_file($file1);
my %lines1 = ();
foreach my $line (@lines1) {
    $lines1{$line} = 1;
}

my @lines2 = read_file($file2);
foreach my $line (@lines2) {
    if (exists $lines1{$line}) {
        print $line;
    }
}
