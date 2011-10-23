use strict;
use warnings;
use Test::More tests => 1;

use DBIx::DataFactory::Type;

warn DBIx::DataFactory::Type->type_to_random_sub('num')->(3);
