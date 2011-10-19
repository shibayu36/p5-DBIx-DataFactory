package Test::Factory::DBI::Random;

use strict;
use warnings;
use Carp;

use Test::Factory::DBI::Type;

use Exporter::Lite;

sub random_from_type_info {
    my ($self, $type_info) = @_;
    return undef unless $type_info;

    my $type = $type_info->{type};
    my $size = $type_info->{size};

    my $code = Test::Factory::DBI::Type->type_to_random_sub($type);
    return undef unless $code;

    return $code->($size);
}

sub rand_int {
    my ($class, $size) = @_;
    return int (__PACKAGE__->rand_num($size));
}

sub rand_num {
    my ($class, $size) = @_;
    my $max = 10 ** $size - 1;
    return rand($max);
}

1;
