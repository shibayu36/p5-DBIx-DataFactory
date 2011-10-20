package Test::Factory::DBI::Random;

use strict;
use warnings;
use Carp;

use List::MoreUtils qw(any);

my $type_to_random_sub = {
    'int' => sub {
        my ($size) = @_;
        return Test::Factory::DBI::Random->rand_int($size);
    },
    'num' => sub {
        my ($size) = @_;
        return Test::Factory::DBI::Random->rand_num($size);
    },
    'str' => sub {
        my ($size) = @_;
    },
};

sub type_to_random_sub {
    my ($class, $type) = @_;
    $type = lc $type;
    return $type_to_random_sub->{$type};
}

sub random_from_type_info {
    my ($self, $type_info) = @_;
    return undef unless $type_info;

    my $type = $type_info->{type};
    my $size = $type_info->{size};

    my $code = __PACKAGE__->type_to_random_sub($type);
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
