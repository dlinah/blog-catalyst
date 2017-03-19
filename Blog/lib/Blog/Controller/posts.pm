package Blog::Controller::posts;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Blog::Controller::posts - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut
sub base :Chained('/') :PathPart('posts') :CaptureArgs(0) {
     my ($self, $c) = @_;
     $c->load_status_msgs;
}

sub list :Chained('base') :PathPart('list') :Args(0) {
    my ($self, $c) = @_;
    $c->stash(posts => [$c->model('DB::Post')->search({},{ order_by => 'id DESC' })]);

    $c->stash(template => 'Home.html');
}

sub addpost :Chained('base') :PathPart('addpost') :Args(0) {
    my ($self, $c) = @_;
    my $body     = $c->request->params->{post}     ;
    my $title    = $c->request->params->{title}     ;
    if ($title && $body) {
            my $post = $c->model('DB::Post')->create({
                        title   => $title,
                        body  => $body,
                        auth_id => $c->user->id,
                    });
            $c->response->redirect($c->uri_for("/posts/list"));

            return;
        }
         else {
          $c->detach("Empty title or content.");

        }

}
sub findd {
    my ( $c, $id) = @_;
    $c->stash(pp => 'fff');

    $c->stash(object => $c->model('DB::Post')->find($id));

    $c->detach("/error_404  post not found") if !$c->stash->{object};

}
sub delpost :Chained('base') :PathPart('del') :Args() {
    my ($self, $c,$del) = @_;
    if($del){
    my $id = $del;
         findd($c,$id);
       if($c->user->id ==$c->stash->{object}->auth->id || $c->user->role_id==1) {
            $c->stash->{object}->comments->delete;
            $c->stash->{object}->delete;$c->response->redirect($c->uri_for("/posts/list"));}

       else{$c->response->redirect($c->uri_for("/posts/list",{mid => $c->set_status_msg("permission dinied")}));}

    }
    else{$c->response->redirect($c->uri_for("/posts/list",{mid => $c->set_status_msg(" id not found")}));}
}
sub edit_post :Chained('base') :PathPart('edit') :Args() {
    my ($self, $c,$edit) = @_;
        if($edit){
           my $id     = $edit;
           findd($c,$id);
           $c->stash(template => 'editpost.html');

        }
        else{$c->detach("post not found");}
}
sub doedit_post :Path('doedit') :Args() {
        my ($self, $c) = @_;
            my $body     = $c->request->params->{post}     ;
            my $title    = $c->request->params->{title}     ;
            my $id    = $c->request->params->{id}     ;

            if ($title && $body) {
                    findd($c,$id);
               if($c->user->id ==$c->stash->{object}->auth->id || $c->user->role_id==1) {

                    $c->stash->{object}->title($title);
                    $c->stash->{object}->body($body);
                    $c->stash->{object}->update;

                    $c->response->redirect($c->uri_for("/posts/list"));

                    return;}
                    else{$c->response->redirect($c->uri_for("/posts/list",{mid => $c->set_status_msg(" permission denied")}));}
                }
                 else {
                    $c->response->redirect($c->uri_for("/posts/list",{mid => $c->set_status_msg(" not found")}));}

}



=encoding utf8

=head1 AUTHOR

lina1111

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
