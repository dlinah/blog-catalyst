use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Blog';
use Blog::Controller::login;

ok( request('/login')->is_success, 'Request should succeed' );
done_testing();
