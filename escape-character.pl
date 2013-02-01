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
binmode STDOUT, ':utf8';
binmode STDERR, ':utf8';

use Carp;
use Getopt::Long;

my $character_to_escape = "'";
my $escape_character    = "\\";
my $n                   = 0;

GetOptions(
    #'help'              => \$help,
	'character-to-escape=s' => \$character_to_escape,
	'escape-character=s'    => \$escape_character,
	'n=i'                   => \$n,
) or croak 'Error parsing command line arguments';


my $string_to_insert = $escape_character . $character_to_escape;

LINE:
while (<>) {
	my $line = $_;

	if ($n == 0) {
		$line =~ s/$character_to_escape/$string_to_insert/g;
	}
	else {
		my $cutoff_position = nth_index($line, $character_to_escape, $n);
		if ($cutoff_position != -1) {
			my $first_part  = substr($line, 0, $cutoff_position);
			my $second_part = substr($line, $cutoff_position);

			$second_part =~ s/$character_to_escape/$string_to_insert/g;

			$line = $first_part . $second_part;
		}
	}
	print $line;
}


sub nth_index {
	my ($string, $substring, $n) = @_;

	my $current_position = 0;
	foreach my $time (1 .. $n) {
		$current_position = index($string, $substring, $current_position);

		last if $current_position == -1;

		$current_position++;
	}

	return $current_position;
}
