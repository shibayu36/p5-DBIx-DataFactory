use strict;
use warnings;
use inc::Module::Install;
use Module::Install::AuthorTests;

name     'Test-Factory-DBI';
author   'Yuki Shibazaki <shibayu36 {at} gmail.com>';
all_from 'lib/Test/Factory/DBI.pm';

# requires 'Class::Accessor::Fast';

# test_requires 'Test::More';
# test_requires 'Test::Class';

recursive_author_tests('xt');

auto_install;
WriteAll;
