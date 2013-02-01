#!/usr/bin/perl

# (c) 2009, 2010 Zeno Gantner <zeno.gantner@gmail.com>

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

# averages the specified columns
# column IDs are zero-based

# call: ./average-columns.pl "2 4" file.txt

use strict;
use warnings;
use Getopt::Long;

# TODO: standard deviation

my $DEFAULT_PRECISION = 4;

# TODO: usage
GetOptions(
	   'labels=s'     => \(my $label_string     = ''),
	   'precisions=s' => \(my $precision_string = ''),
	   'show-min'     => \(my $show_min         = 0),
	   'show-max'     => \(my $show_max         = 0),
	   'one-line'     => \(my $one_line         = 0),
) or die 'Error parsing command line arguments';

my $column_string = shift;
my @columns_to_average = split /\s+/, $column_string;

my @column_labels = ();
if ($label_string) {
    @column_labels = split /\s+/, $label_string;
    if (scalar @column_labels != scalar @columns_to_average) {
        die "Number of labels must match number of columns"
    }
}

my @column_precisions = ();
if ($precision_string) {
    @column_precisions = split /\s+/, $precision_string;
    if (scalar @column_precisions != scalar @columns_to_average) {
        die "Number of precisions must match number of columns"
    }
}

my %count = map { $_ => 0 } @columns_to_average;
my %sum   = map { $_ => 0 } @columns_to_average;
my %max   = map { $_ => 0 } @columns_to_average;
my %min   = map { $_ => 5_000_000 } @columns_to_average;

my $counter = 0;

LINE:
while (<>) {
    my $line = $_;
    chomp $line;

    my @fields = split /\s+/, $line;


    foreach my $col (@columns_to_average) {

	next LINE if $col >= scalar @fields;

	my $value = $fields[$col];

	if ($value =~ /:/) { # time span case
	    my @values = split /:/, $value;
	    my $multiplier = 1;
	    $value = 0;
	    foreach my $number (reverse @values) {
		$value += $number * $multiplier;
		$multiplier *= 60;
	    }
	}

	$sum{$col} += $value;
	if ($value > $max{$col}) {
	    $max{$col} = $value;
	}
	if ($value < $min{$col}) {
	    $min{$col} = $value;
	}

	$count{$col}++;
    }

    $counter++;
}

print "Averaged result for $counter lines:\n";
for (my $i = 0; $i < scalar @columns_to_average; $i++) {
    my $col = $columns_to_average[$i];
    my $avg = $sum{$col} / $count{$col};
    if (@column_labels) {
        # TODO: use the same amount of space for all labels, so that the output is aligned
	print "$column_labels[$i] ";
    }
    my $precision = @column_precisions ? $column_precisions[$i] : $DEFAULT_PRECISION;
    printf "%.${precision}f", $avg;
    
    printf " max=%.${precision}f", $max{$col} if $show_max;
    printf " min=%.${precision}f", $min{$col} if $show_min;
    
    if ($one_line) {
	    print ' ';
    }
    else {
	print "\n";
    }
}
