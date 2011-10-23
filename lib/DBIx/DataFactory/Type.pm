package DBIx::DataFactory::Type;

use strict;
use warnings;
use Carp;

sub type_name {
    croak 'must be implemented in sub class';
}

sub make_value {
    croak 'must be implemented in sub class';
}

1;
