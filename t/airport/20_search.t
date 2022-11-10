use strict;
use warnings;
use feature 'say';
use Data::Dump 'pp';
use Test::More;
use Airport::Data;
use_ok('Airport::Search');

Airport::Search::get_address_matching_airports(address => "London");

my $rah_airports = Airport::Data::parse_airports("t/data/airports1.csv");
is(scalar(@$rah_airports), 5, 'all airports read');

my @get_name_matching_testcases = (
    [ {
        matching_string => 'Air',
        is_word         => 0,
    } => 5 ],
    [ {
        matching_string => 'Air',
        is_word         => 1,
    } => 0 ],
    [ {
        matching_string => 'Airport',
        is_word         => 1,
    } => 5 ],
    [ {
        matching_string => 'Sydney',
        is_word         => 1,
    } => 1 ],
    [ {
        matching_string => 'Sydney',
        is_word         => 0,
    } => 1 ],
);

foreach (@get_name_matching_testcases) {
    my ($input, $expected) = @$_;
    run_get_name_matching_testcase($input, $expected);
}

sub run_get_name_matching_testcase {
    my ($input, $expected) = @_;
    say 'Testcase ' . (pp($input)) . '=>' . (pp $expected);
    my $result = Airport::Search::get_name_matching_airports(
        airports        => $rah_airports,
        matching_string => $input->{matching_string},
        word            => $input->{is_word},
    );

    is(scalar(grep {ref($_) ne 'HASH';} @$result), 0, 'each element of the array is a hash reference');
    my $size = scalar(@$result);
    is(scalar(@$result), $expected,
        "found airports number is correct, expected $expected, found $size");
}

my @get_latlong_matching_testcases = (
    [ {
        lat  => 0.0,
        long => 0.0,
        max  => 0.00001,
    } => 0 ],
    [ {
        lat  => 0.0,
        long => 0.0,
        max  => 180,
    } => scalar(@$rah_airports) ],
    [ {
        lat => $rah_airports->[0]->{latitude_deg},
        long => $rah_airports->[0]->{longitude_deg},
        max => 0.0001,
    } => 1 ]
);

foreach (@get_latlong_matching_testcases) {
    my ($input, $expected) = @$_;
    run_get_latlong_matching_testcase($input, $expected);
}

sub run_get_latlong_matching_testcase {
    my ($input, $expected) = @_;
    say 'Testcase ' . (pp($input)) . '=>' . (pp $expected);
    my $result = Airport::Search::get_latlong_matching_airports(
        airports => $rah_airports,
        lat      => $input->{lat},
        long     => $input->{long},
        max      => $input->{max},
    );

    is(scalar(grep {ref($_) ne 'HASH';} @$result), 0, 'each element of the array is a hash reference');
    my $size = scalar(@$result);
    is(scalar(@$result), $expected,
        "found airports number is correct, expected $expected, found $size");
}

done_testing();