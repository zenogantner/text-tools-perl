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

my $string = shift;

# TODO
## write a routine that combines strings/specific characters
## write sth. that automatically escapes regexp characters

if (!defined $string) {
    die "Please give a string as first parameter!\n";
}

my $line_counter = 0;
my $occurrence_counter  = 0;
LINE:
while (<>) {
	my $line = $_;
	$line_counter++;
	while ($line =~ s/$string//) {
		$occurrence_counter++;
	}
}

print "$line_counter lines, $occurrence_counter occurrences of '$string'.\n";
