#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Data::Types 'is_float';
use feature 'say';

use_ok('Airport::Data');

my $rah_airports = Airport::Data::parse_airports("t/data/airports1.csv");
is(ref($rah_airports), 'ARRAY', 'the return value is an array reference, and it is correct type');
is(scalar(@$rah_airports), 5, 'there are 5 elements in the arrayref which is returned, and 5 is correct number');
is(scalar(grep {ref($_) ne 'HASH';} @$rah_airports), 0, 'each element of the array is a hash reference');

foreach my $i (0 .. $#$rah_airports) {
    say '';
    say "Checking airport $i";
    my $v = $rah_airports->[$i];

    foreach (qw(id name iata_code)) {
        ok($v->{$_} ne '', "value for $_ not empty");
    }

    foreach (qw(latitude_deg longitude_deg)) {
        ok(is_float($v->{$_}), "value for $_ is floating point number");
    }
}

done_testing();