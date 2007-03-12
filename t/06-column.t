#!perl -T
use strict;
use warnings;
use File::Spec;
use lib File::Spec->catdir('lib');
use lib File::Spec->catdir('t', 'lib');

ThisTest->runtests;

# ThisTest
package ThisTest;
use base qw/Test::Class/;
use Test::More;
use DBIx::MoCo::Column;
use Blog::Entry;
use MySQLUser;

sub use_test : Tests {
    use_ok 'DBIx::MoCo::Column';
}

sub new_test : Tests {
    my $str = 'hello test';
    my $col = DBIx::MoCo::Column->new($str);
    ok $col;
    isa_ok $col, 'DBIx::MoCo::Column';
    is $$col, $str;
}

sub column : Tests {
    my $e = Blog::Entry->retrieve(1);
    ok $e;
    my $uri = $e->column('uri');
    ok $uri;
    isa_ok $uri, 'DBIx::MoCo::Column';
    is $$uri, $e->uri;
}

sub uri : Tests {
    my $e = Blog::Entry->retrieve(1);
    ok $e;
    my $uri = $e->uri_as_URI;
    ok $uri;
    isa_ok $uri, 'URI';
    is $uri->host, 'test.com';
}

sub my_column : Tests {
    my $e = Blog::Entry->retrieve(1);
    ok $e;
    my $title = $e->title;
    ok $title;
    is $e->title_as_MyColumn, 'My Column ' . $title;
}

sub has_column : Tests {
    MySQLDB->dbh or return('skipped mysql tests');
    ok (MySQLUser->has_column('User'));
    ok (!MySQLUser->has_column('fake'));
    my $u = MySQLUser->search(where => '1 = 1')->first;
    $u or return;
    ok $u;
    ok ($u->has_column('User'), 'User');
    ok (!$u->has_column('fake'), 'fake');
}

1;