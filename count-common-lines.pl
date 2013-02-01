#!/usr/bin/perl

# count number of common lines of two or more files (order does not matter)

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

use File::Slurp;

my $newline = "\n";
if ($ARGV[0] eq '-n') {
    $newline = '';
    shift @ARGV;
}


my @line_hashes = ();
foreach my $filename (@ARGV) {
    my @lines = read_file($filename);
    my %line_hash = map { $_ => 1} @lines;
    push @line_hashes, \%line_hash;
}

my $common_counter = 0;
my $line_hash_one_ref = pop @line_hashes;
foreach my $line (keys %$line_hash_one_ref) {
    my $occurence_count = 0;
    foreach my $line_hash_ref (@line_hashes) {
	if (exists $line_hash_ref->{$line}) {
	    $occurence_count++;
	}
    }

    if ($occurence_count == scalar @line_hashes) {
	$common_counter++;
    }
}
print "$common_counter$newline";
