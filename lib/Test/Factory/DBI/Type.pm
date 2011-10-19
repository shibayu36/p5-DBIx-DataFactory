package Test::Factory::DBI::Type;

use strict;
use warnings;
use Carp;

use List::MoreUtils qw(any);
use Test::Factory::DBI::Random;

my $type_to_random_sub = {
    'int' => sub {
        my ($size) = @_;
        return Test::Factory::DBI::Random->rand_int($size);
    },
    'num' => sub {
        my ($size) = @_;
        return Test::Factory::DBI::Random->rand_num($size);
    },
};

sub type_to_random_sub {
    my ($class, $type) = @_;
    $type = lc $type;
    return $type_to_random_sub->{$type};
}

1;
