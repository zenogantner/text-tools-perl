#!/usr/bin/perl

# (c) 2009, 2010 by Zeno Gantner <zeno.gantner@gmail.com>

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

# example call: ./filter-columns.pl "2 4" file.txt

use strict;
use warnings;

use English qw( -no_match_vars );
use Getopt::Long;
use List::Util qw(min max);

GetOptions(
	   'help'             => \(my $help           = 0),
	   'ignore-lines=i'   => \(my $ignore_lines   = 0),
           'ignore-pattern=s' => \(my $ignore_pattern = 0),
	  ) or usage(-1);

usage(0) if $help;

my $column_string = shift;
my @columns_to_keep = split /\s+/, $column_string;

my $ignore_regex = qr{ $ignore_pattern };

#print STDERR "----\n";
# skip lines
for (my $i = 0; $i < $ignore_lines; $i++) { <>; }

LINE:
while (<>) {
    my $line = $_;
    chomp $line;

    next LINE if $line =~ /^$/; # ignore empty lines
    next LINE if $ignore_pattern && $line =~ $ignore_pattern;

    my @fields = split /\s+/, $line;

    if (scalar @fields < max(@columns_to_keep)) {
	die "Line is missing column: $line\n";
    }

    my @output_content = map { $fields[$_] } @columns_to_keep;

    my $text = join "\t", @output_content;

    print "$text\n";
}


sub usage {
    my ($return_code) = @_;

    print << "END";
    $PROGRAM_NAME.
    Keeps the specified columns. Column IDs are zero-based.

    usage: $PROGRAM_NAME "COLUMNS" [OPTIONS] [FILES]

    --help                      display this usage information
    --ignore-lines=N            ignore first N lines
    --ignore-pattern=REGEX      don't process lines that match REGEX
END
    exit $return_code;
}
