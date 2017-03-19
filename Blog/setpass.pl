#!/usr/bin/perl

use strict;
use warnings;

use Blog::Schema;

my $schema = Blog::Schema->connect('dbi:mysql:myfristblog','root','root');

my @users = $schema->resultset('User')->all;

foreach my $user (@users) {
    $user->password('lina');
    $user->update;
}