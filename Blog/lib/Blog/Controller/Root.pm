package Blog::Controller::Root;
use Moose;
use namespace::autoclean;
use Data::Dumper;



BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=encoding utf-8

=head1 NAME

Blog::Controller::Root - Root Controller for Blog

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut
sub auto :Private{
    my ($self, $c) = @_;

    if ($c->action eq $c->controller('user')->action_for('login')) {
            return 1;
        }
    if ($c->action eq $c->controller('posts')->action_for('list')) {
            return 1;
        }
     if ($c->action eq $c->controller('user')->action_for('goregister')) {
                return 1;
            }
     if ($c->action eq $c->controller('user')->action_for('register')) {
                     return 1;
                 }
     if ($c->controller eq $c->controller('posts')) {
             return 1;
         }
    if (!$c->user_exists) {
         $c->log->debug('***Root::auto User not found, forwarding to /login');
         $c->stash(status_msg => "please login first");
         $c->stash(wrapper => 'layoutsub.html',template =>'login.html');
         #$c->response->redirect($c->uri_for($c->controller('user')->action_for('login')));
         return 0;
    }
    return 1;
}

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash(posts => [$c->model('DB::Post')->search({},{ order_by => 'id DESC ' })],);
    #$c->stash(status=>[schema->storage->debug(1)])
    #my %posts =$c->model('DB::Post')->search({},{join => 'auth' ,'+select' => [ 'title' ],
                                           #            '+as'=> [ 'name' ],});
      # my $rs = $schema->resultset('User')->search({},{ join => 'posts' });

   # $c->response->body( $c->welcome_message);
    $c->response->redirect($c->uri_for("/posts/list"));
}



=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

lina

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
