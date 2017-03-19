package Blog::Controller::comments;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Blog::Controller::comments - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub base :Chained('/') :PathPart('comments') :CaptureArgs(0) {
     my ($self, $c) = @_;
     $c->load_status_msgs;
}


sub add :Chained('base') :PathPart('add') :Args(0) {
    my ($self, $c) = @_;
    my $body     = $c->request->params->{post}     ;
    my $post_id     = $c->request->params->{post_id}     ;

    if ( $body && $post_id) {
            my $post = $c->model('DB::Comment')->create({
                        msg  => $body,
                        auth_id => $c->user->id,
                        post_id => $post_id
                    });

        }
         else {
          $c->stash(error_msg =>"Empty comment.");
        }
    $c->response->redirect($c->uri_for($c->controller('views')->action_for('post'),$post_id||"NA"));

}
sub findd {
    my ( $c, $id) = @_;

    $c->stash(object => $c->model('DB::Comment')->find($id));

    $c->detach("/error_404  post not found $id") if !$c->stash->{object};


}
sub del :Chained('base') :PathPart('del') :Args() {
    my ($self, $c,$del,$post_id) = @_;

    if($del && $post_id){

         findd($c,$del);
       if($c->user->id ==$c->stash->{object}->auth->id || $c->user->role_id==1) {
            $c->stash->{object}->delete;
            $c->response->redirect($c->uri_for($c->controller('views')->action_for('post'),$post_id||"NA"));

            }

       else{$c->response->redirect($c->uri_for($c->controller('views')->action_for('post'),$post_id||"NA",{mid => $c->set_status_msg("permission dinied")}));}

    }
    else{$c->response->redirect($c->uri_for($c->controller('views')->action_for('post'),$post_id||"NA",{mid => $c->set_status_msg(" id not found")}));}
}
sub edit :Chained('base') :PathPart('edit') :Args() {
    my ($self, $c,$edit,$post_id) = @_;
        $c->session(post_id =>$post_id,edit=>$edit);
        if(!$post_id){$c->detach("/no id edit") ;return;}
        if($edit){
           findd($c,$edit);
           $c->stash(wrapper =>'layout3.html',template => 'editcomment.html');

        }
        else{$c->detach("post not found");}
}
sub doedit :Path('doedit') :Args() {
        my ($self, $c) = @_;
            my $msg     = $c->request->params->{post}     ;
        #if(!$c->session->{post_id}){$c->detach("/no id doedit") ;return;}else{$c->detach("/yes id doedit") ;return;}

            if ($msg) {
                    findd($c,$c->session->{edit});
               if($c->user->id ==$c->stash->{object}->auth->id || $c->user->role_id==1) {

                    $c->stash->{object}->msg($msg);
                    $c->stash->{object}->update;
                    $c->response->redirect($c->uri_for($c->controller('views')->action_for('post'),$c->session->{post_id}||"NA"));

                    return;}
                    else{$c->response->redirect($c->uri_for($c->controller('views')->action_for('post'),$c->session->{post_id}||"NA",{mid => $c->set_status_msg(" permission denied")}));}
                }
                 else {
                    $c->response->redirect($c->uri_for($c->controller('views')->action_for('post'),$c->session->{post_id}||"NA",{mid => $c->set_status_msg(" id  not found")}));}

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
