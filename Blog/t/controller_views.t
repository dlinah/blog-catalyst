use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Blog';
use Blog::Controller::views;

ok( request('/views')->is_success, 'Request should succeed' );
done_testing();
