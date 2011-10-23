package test::DBIx::DataFactory;
use strict;
use warnings;
use Test::More tests => 1;

use DBIx::DataFactory;
use String::Random;

# DBIx::DataFactory->username('nobody');
# DBIx::DataFactory->password('nobody');
# DBIx::DataFactory->create_factory_method(
#     method   => 'create_factory',
#     dbi      => 'dbi:mysql:dbname=test_factory;host=localhost',
#     table    => 'test_factory',
#     columns => {
#         int => {
#             type => 'Int',
#             size => 10,
#         },
#         double => {
#             type => 'Num',
#             size => 5,
#         },
#         string => {
#             type => 'Set',
#             set  => ['test', 'test2', 'test3'],
#         },
#     },
# );

# my $factory = create_factory(nullable => 100);
# use Data::Dumper;
# warn Dumper($factory);

use DBIx::DataFactory;
DBIx::DataFactory->username('nobody');
DBIx::DataFactory->password('nobody');
DBIx::DataFactory->create_factory_method(
    method   => 'create_factory_data',
    dbi      => 'dbi:mysql:dbname=test_factory;host=localhost',
    table    => 'test_factory',
    columns => {
        int => {
            type => 'Int',
            size => 10,
        },
        string => {
            type => 'Str',
            size => 10,
        },
    },
);

my $values = create_factory_data(
    text => 'test text',
);
