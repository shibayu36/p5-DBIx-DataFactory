use strict;
use warnings;
use Test::More tests => 1;

use Test::Factory::DBI::Type;

warn Test::Factory::DBI::Type->type_to_random_sub('num')->(3);
