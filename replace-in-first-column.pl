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

use English qw( -no_match_vars );
use File::Slurp;
use Getopt::Long;


GetOptions(
	   'help'                => \(my $help              = 0),
	   'ignore-lines=i'      => \(my $ignore_lines      = 0),
	   'rest-separator=s'    => \(my $rest_separator    = ' '),
	  ) or usage(-1);

usage(0) if $help;

my $mapping_file = shift;
my @lines = read_file($mapping_file);

# TODO: this should be in a library
my %mapping = ();
foreach my $line (@lines) {
    chomp $line;

    my @fields = split /\s+/, $line;
    if (scalar @fields != 2) {
	die "Could not read line '$line'\n";
    }
    my ($key, $value) = @fields;

    $mapping{$key} = $value;
}

# skip lines
for (my $i = 0; $i < $ignore_lines; $i++) { <>; }

LINE:
while (<>) {
    my $line = $_;
    chomp $line;

    my @fields = split /\s+/, $line;

    my ($first_column, @rest) = @fields;

    my $rest = join $rest_separator, @rest;
    print "$mapping{$first_column}${rest_separator}${rest}\n";
}


sub usage {
    my ($return_code) = @_;

    print << "END";
    $PROGRAM_NAME.

    usage: $PROGRAM_NAME MAPPING_FILE [OPTIONS]

    --help                      display this usage information
    --ignore-lines=N
    --rest-separator=SEP
END
    exit $return_code;
}
