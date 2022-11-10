package Airport::Search;

use feature 'say';

use warnings;
use strict;
use Data::Dump 'pp';
use List::Util 'min';

sub get_name_matching_airports {
    my %args = @_;
    my ($airports, $matching_string, $word) = _destruct(\%args, qw(airports matching_string word));

    my $regex = $matching_string;
    if (defined($word) && $word != 0) {
        $regex = "\\b" . $regex . "\\b";
    }

    return [ grep {$_->{name} =~ m/$regex/i} @$airports ];
}

sub get_latlong_matching_airports {
    my %args = @_;
    my ($airports, $lat, $long, $max) = _destruct(\%args, qw(airports lat long max));

    my $matches = sub {
        my ($airport) = @_;
        my ($my_lat, $my_long) = _destruct($airport, 'latitude_deg', 'longitude_deg');
        my ($y1, $x1) = ($my_lat, $my_long);
        my ($y2, $x2) = ($lat, $long);
        my $dist = sqrt(abs($y1 - $y2) ** 2 + (min(abs($x1 - $x2), abs(360 - abs($x1 - $x2)))) ** 2);
        return $dist < $max;
    };

    return [ grep {$matches->($_)} @$airports ];
}

sub _destruct {
    my ($hash, @args) = @_;
    return map {$hash->{$_}} @args;
}

1;