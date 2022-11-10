package Airport::Data;

use strict;
use warnings;
use Text::CSV;

sub parse_airports {
    my ($infile) = @_;
    my $encoding = "encoding(utf8)";
    open(my $fh_in, "<:$encoding", $infile) or die "Error opening input file: $!";

    my $csv = Text::CSV->new({ binary => 1, eol => $/,  });
    my $ra_colnames = $csv->getline($fh_in);
    $csv->column_names(@$ra_colnames);

    my $res = $csv->getline_hr_all($fh_in);
    close($fh_in);
    return $res
}

1;