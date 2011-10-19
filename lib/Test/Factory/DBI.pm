package Test::Factory::DBI;

use strict;
use warnings;
use Carp;

our $VERSION = '0.0.1';

use Smart::Args;
use DBIx::Inspector;
use DBI;
use SQL::Maker;
use Sub::Install;

use Test::Factory::DBI::Random;

sub create_factory_method {
    args my $class    => 'ClassName',
         my $method   => 'Str',
         my $dbi      => 'Str',
         my $table    => 'Str',
         my $username => 'Str',
         my $password => 'Str',
         my $params   => {isa => 'HashRef', optional => 1};

    my $dbh = DBI->connect($dbi, $username, $password);
    my $inspector = DBIx::Inspector->new(dbh => $dbh)
        or croak('cannot connect database');

    my ($inspector_table) = grep {$_->name eq $table} $inspector->tables;
    croak("cannot find table named $table") unless $inspector_table;

    my $columns = [map {$_->name} $inspector_table->columns];

    my ($package) = caller;
    Sub::Install::install_sub({
        code => sub {
            my (%args) = @_;
            return $class->_factory_method(
                dbi            => $dbi,
                username       => $username,
                password       => $password,
                table          => $table,
                column_names   => $columns,
                params_default => $params,
                params         => \%args,
            );
        },
        into => $package,
        as   => $method,
    });

    return;
}

sub _factory_method {
    my ($class, %args) = @_;
    my $dbi            = $args{dbi};
    my $username       = $args{username};
    my $password       = $args{password};
    my $table          = $args{table};
    my $columns        = $args{column_names};
    my $params_default = $args{params_default};
    my $params         = $args{params};

    my $values = {};
    for my $column (@$columns) {
        # insert specified value if specified
        my $specified = $params->{$column};
        if (defined $specified) {
            $values->{$column} = $specified;
            next;
        }

        # insert default random value
        my $default = $params_default->{$column};
        my $random = Test::Factory::DBI::Random->random_from_type_info($default);
        if (defined $random) {
            $values->{$column} = $random;
            next;
        }
    }

    # make sql
    my ($driver)  = $dbi =~ /^dbi:([^:]+)/;
    my $builder = SQL::Maker->new(driver => $driver);
    my ($sql, @binds) = $builder->insert($table, $values);

    # insert
    my $dbh = DBI->connect($dbi, $username, $password);
    my $sth = $dbh->prepare($sql);
    $sth->execute(@binds);

    return $values;
}

1;

__END__

=head1 NAME

Test::Factory::DBI - [One line description of module's purpose here]


=head1 SYNOPSIS

    use Test::Factory::DBI;

=for author to fill in:
    Brief code example(s) here showing commonest usage(s).
    This section will be as far as many users bother reading
    so make it as educational and exeplary as possible.


=head1 DESCRIPTION

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.

=head1 REPOSITORY

https://github.com/shibayu36

=head1 AUTHOR

  C<< <shibayu36 {at} gmail.com> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2011, Yuki Shibazaki C<< <shibayu36 {at} gmail.com> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.
