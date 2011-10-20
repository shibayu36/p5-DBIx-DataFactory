package Test::Factory::DBI::Type;

use strict;
use warnings;
use Carp;

use List::MoreUtils qw(any);
use Smart::Args;
use String::Random;

my $type_to_random_sub = {
    'int' => sub {
        return Test::Factory::DBI::Type->rand_int(@_);
    },
    'num' => sub {
        return Test::Factory::DBI::Type->rand_num(@_);
    },
    'str' => sub {
        return Test::Factory::DBI::Type->rand_str(@_);
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

    my $type = delete $type_info->{type};

    my $code = __PACKAGE__->type_to_random_sub($type);
    return undef unless $code;

    return $code->(%$type_info);
}

sub rand_int {
    my $class = shift;
    return int ($class->rand_num(@_));
}

sub rand_num {
    args my $class => 'ClassName',
         my $size  => 'Int';
    my $max = 10 ** $size - 1;
    return rand($max);
}

sub rand_str {
    args my $class  => 'ClassName',
         my $size   => {isa => 'Int', optional => 1, default => 20},
         my $regexp => {isa => 'Str', optional => 1};

    $regexp = "[a-zA-Z0-9]{$size}" unless $regexp;
    return String::Random->new->randregex($regexp);
}

1;
