package DBIx::DataFactory;

use strict;
use warnings;
use Carp;

our $VERSION = '0.0.1';

use base qw(Class::Data::Inheritable Class::Accessor::Fast);
__PACKAGE__->mk_classdata('defined_types' => {});
__PACKAGE__->mk_accessors(qw(
    username password dsn
));

__PACKAGE__->add_type('DBIx::DataFactory::Type::Int');
__PACKAGE__->add_type('DBIx::DataFactory::Type::Num');
__PACKAGE__->add_type('DBIx::DataFactory::Type::Str');
__PACKAGE__->add_type('DBIx::DataFactory::Type::Set');

use Smart::Args;
use DBIx::Inspector;
use DBI;
use SQL::Maker;
use Sub::Install;
use Class::Load qw/load_class/;

use DBIx::DataFactory::Type;

sub create_factory_method {
    args my $self,
         my $method   => 'Str',
         my $dsn      => {isa => 'Str', optional => 1},
         my $table    => 'Str',
         my $username => {isa => 'Str', optional => 1},
         my $password => {isa => 'Str', optional => 1},
         my $auto_inserted_columns => {isa => 'HashRef', optional => 1};

    $username = $self->username unless $username;
    $password = $self->password unless $password;
    $dsn      = $self->dsn      unless $dsn;
    unless ($username && $password && $dsn) {
        croak('username, password and dsn for database are all required');
    }

    my $dbh = DBI->connect($dsn, $username, $password);
    my $inspector = DBIx::Inspector->new(dbh => $dbh)
        or croak('cannot connect database');

    my ($inspector_table) = grep {$_->name eq $table} $inspector->tables;
    croak("cannot find table named $table") unless $inspector_table;

    my $table_columns = [map {$_->name} $inspector_table->columns];

    my ($package) = caller;
    Sub::Install::install_sub({
        code => sub {
            my (%args) = @_;
            return $self->_factory_method(
                dsn            => $dsn,
                username       => $username,
                password       => $password,
                table          => $table,
                column_names   => $table_columns,
                params_default => $auto_inserted_columns,
                params         => \%args,
            );
        },
        into => $package,
        as   => $method,
    });

    return;
}

sub add_type {
    my ($class, $type) = @_;
    load_class($type);
    $class->defined_types->{$type->type_name} = $type;
}

sub make_value_from_type_info {
    my ($class, $args) = @_;
    my $type_name  = delete $args->{type};
    my $type_class = $class->defined_types->{$type_name}
        or croak("$type_name is not defined as type");
    return $type_class->make_value(%$args);
}

sub _factory_method {
    my ($self, %args) = @_;
    my $dsn            = $args{dsn};
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

        # insert setting columns value
        my $default = $params_default->{$column};
        if (ref $default eq 'CODE') {
            $values->{$column} = $default->();
            next;
        }
        elsif (ref $default eq 'HASH') {
            my $value = DBIx::DataFactory->make_value_from_type_info($default);
            $values->{$column} = $value;
            next;
        }
    }

    # make sql
    my ($driver)  = $dsn =~ /^dbi:([^:]+)/;
    my $builder = SQL::Maker->new(driver => $driver);
    my ($sql, @binds) = $builder->insert($table, $values);

    # insert
    my $dbh = DBI->connect($dsn, $username, $password);
    my $sth = $dbh->prepare($sql);
    $sth->execute(@binds);

    return $values;
}

1;

__END__

=head1 NAME

DBIx::DataFactory - [One line description of module's purpose here]


=head1 SYNOPSIS

    use DBIx::DataFactory;

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
