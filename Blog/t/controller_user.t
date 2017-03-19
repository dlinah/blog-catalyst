use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Blog';
use Blog::Controller::user;

ok( request('/user')->is_success, 'Request should succeed' );
done_testing();
