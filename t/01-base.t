package test::Test::Factory::DBI;
use strict;
use warnings;
use Test::More tests => 1;

use Test::Factory::DBI;
use String::Random;

Test::Factory::DBI->username('nobody');
Test::Factory::DBI->password('nobody');
Test::Factory::DBI->create_factory_method(
    method   => 'create_factory',
    dbi      => 'dbi:mysql:dbname=test_factory;host=localhost',
    table    => 'test_factory',
    columns => {
        int => {
            type => 'Int',
            size => 10,
        },
        double => {
            type => 'Num',
            size => 5,
        },
        string => sub {String::Random->new->randregex('[a-z]{100}')},
    },
);

my $factory = create_factory(nullable => 100);
use Data::Dumper;
warn Dumper($factory);
