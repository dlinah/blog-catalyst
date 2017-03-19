package Blog::Controller::views;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Blog::Controller::views - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut


sub post :Path('/post'){
     my ($self, $c,$id) = @_;
    if(!$id){$c->stash(error_msg=>'not found');}
        $c->stash(comments => [$c->model('DB::Comment')->search({post_id => $id},{ order_by => 'id DESC' })]);

    $c->stash(post_view => $c->model('DB::Post')->find($id),wrapper=>'layout3.html',template => 'post.html');


}



=encoding utf8

=head1 AUTHOR

lina

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
