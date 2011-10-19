package test::Test::Factory::DBI;
use strict;
use warnings;
use Test::More tests => 1;

use Test::Factory::DBI;

Test::Factory::DBI->create_factory_method(
    method   => 'create_factory',
    dbi      => 'dbi:mysql:dbname=test_factory;host=localhost',
    table    => 'test_factory',
    username => 'nobody',
    password => 'nobody',
    params => {
        int => {
            type => 'Int',
            size => 10,
        },
        double => {
            type => 'Num',
            size => 5,
        }
    },
);

create_factory();