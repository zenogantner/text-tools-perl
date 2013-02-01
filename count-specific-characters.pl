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

my $character = shift;

if (!defined $character) {
    die "Please give a single character as first parameter!\n";
}
if (length $character != 1) {
    die "Parameter '$character' is not a single character";
}

my $line_counter = 0;
my $character_counter  = 0;
LINE:
while (<>) {
	my $line = $_;
	$line_counter++;
	my $characters_in_line;
	eval '$characters_in_line = ($line ' . " =~ tr/$character//)";
	if ($@) {
        print "Fehler: $@";
	} else {
	    #print "$characters_in_line\n";
	    $character_counter = $character_counter + $characters_in_line;
	}
}

print "$line_counter lines, $character_counter occurrences of '$character'.\n";
