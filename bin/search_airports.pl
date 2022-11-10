#!/usr/bin/perl -Ilib -Iextlib/lib/perl5

use warnings;
use strict;

use feature 'say';

use Data::Dump 'pp';

use Airport::Search;
use Airport::Data;
use Getopt::Long;
use Geo::Coder::Google;

my $token;
my $filename = '/home/student/perl-basic/findairport/data/iata_airports.csv';
my $number = 3;
my $matching;
my $word;

my $address;

my $latitude;
my $longitude;
my $distance = 2;

GetOptions(
    "filename=s"  => \$filename,
    "number=i"    => \$number,
    "token=s"     => \$token,
    "matching=s"  => \$matching,
    "word"        => \$word,
    "address=s"   => \$address,
    "longitude=f" => \$longitude,
    "latitude=f"  => \$latitude,
    "distance=f"  => \$distance,
) or die("Error in command line arguments\n");

my $rah_airports = Airport::Data::parse_airports($filename);
my $rah_airports_found = [];

if (defined $matching) {
    say "Up to $number airports matching $matching in $filename:";
    $rah_airports_found = Airport::Search::get_name_matching_airports(
        airports        => $rah_airports,
        matching_string => $matching,
        word            => $word,
    );
}
elsif (defined $address && $address ne '') {
    say "Up to $number airports near '$address'";

    my $geocoder = Geo::Coder::Google->new(apiver => 3, key => $token);
    my $response = $geocoder->geocode(location => $address);

    if (!defined($response)) {
        return [];
    }

    my ($lat, $long) = _destruct($response->{geometry}->{location}, 'lat', 'lng');
    $rah_airports_found = Airport::Search::get_latlong_matching_airports(
        airports => $rah_airports,
        lat      => $lat,
        long     => $long,
        max      => $distance,
    );
}
elsif ($latitude && $longitude) {
    say "Up to $number airports near [$latitude, $longitude] in $filename:";
    $rah_airports = Airport::Search::get_latlong_matching_airports(
        airports => $rah_airports,
        lat      => $latitude,
        long     => $longitude,
        max      => $distance,
    )
}
else {
    say "Must have at least --matching, or --latitude and --longitude, or --address as arguments";
}

print pp($rah_airports_found);

sub _destruct {
    my ($hash, @args) = @_;
    return map {$hash->{$_}} @args;
}