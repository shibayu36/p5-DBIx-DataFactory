use strict;
use warnings;
use inc::Module::Install;
use Module::Install::AuthorTests;

name     'Test-Factory-DBI';
author   'Yuki Shibazaki <shibayu36 {at} gmail.com>';
all_from 'lib/Test/Factory/DBI.pm';

requires 'Carp';
requires 'Class::Accessor::Fast';
requires 'Class::Data::Inheritable';
requires 'Smart::Args';
requires 'DBIx::Inspector';
requires 'DBI';
requires 'SQL::Maker';
requires 'Sub::Install';
requires 'Class::Load';
requires 'String::Random';

test_requires 'Test::More';
test_requires 'Test::Class';
test_requires 'Test::TypeConstraints';

recursive_author_tests('xt');

WriteAll;
