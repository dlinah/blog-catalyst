package Blog::Controller::user;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Blog::Controller::user - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Blog::Controller::user in user.');
}
sub login :Path('/login') {
    my ($self, $c) = @_;
    $c->load_status_msgs;
    my $name = $c->request->params->{name};
    if($name){
        my $username = $c->request->params->{username};
        my $password = $c->request->params->{password};

        if ($username && $password) {
            if ($c->authenticate({ username => $username,
                                   password => $password  } )) {
                $c->response->redirect($c->uri_for( $c->controller('posts')->action_for('list')));
                return;
            } else {
                $c->stash(error_msg => "Bad username or password.");
            }
        } else {
            $c->stash(error_msg => "Empty username or password.")
                unless ($c->user_exists);

        }
    }

    $c->stash( wrapper => 'layoutsub.html' ,template => 'login.html');
}
sub logout :Path('/logout') :Args(0){
    my ($self, $c) = @_;

    $c->logout;

    $c->stash(wrapper => 'layoutsub.html',template=>'login.html');

}
sub goregister :Path('/register') :Args(0){
    my ($self, $c) = @_;

    $c->stash( wrapper => 'layoutsub.html' ,template => 'register.html');

}

sub register :Path('/registerr'){
    my ($self, $c) = @_;

    my $username = $c->request->params->{username};
    my $fname = $c->request->params->{fname};
    my $lname = $c->request->params->{lname};
    my $email = $c->request->params->{email};
    my $gender = $c->request->params->{gender};
    my $contry = $c->request->params->{contry};
    my $password = $c->request->params->{password};
    my $repassword = $c->request->params->{repassword};
    if ($repassword && $password) {
        if($repassword!=$password){$c->stash(error_msg => "passowrd dosent match");}
        elsif($username && $fname && $lname && $email && $gender && $contry){
            my $user = $c->model('DB::User')->create({
                                    username   => $username,
                                    fname   => $fname,
                                    lname   => $lname,
                                    email   => $email,
                                    gender   => $gender,
                                    contry   => $contry,
                                    password  => $password,
                                    role_id => 2,
                                });
            $c->response->redirect($c->uri_for( $c->controller('user')->action_for('login'),{mid => $c->set_status_msg(" resgistration complete Please login")}));
            return;
        }
        else{$c->stash(error_msg => "form incomplete");}
    }
    else{$c->stash(error_msg => "form incomplete");}
$c->stash(error_msg => "form incomplete");
        $c->stash( wrapper => 'layoutsub.html' ,template => 'register.html');
}
sub list :Path('list'){
    my ($self, $c) = @_;

       if( $c->user->role_id==1) {
             $c->stash(users => [$c->model('DB::User')->search({},{ order_by => 'id ' })]);
             $c->stash(wrapper =>'layout3.html',template => 'users.html');
       }
       else{
           $c->detach("/error_404");

       }


}
sub findd {
    my ( $c, $id) = @_;
    $c->stash(pp => 'fff');

    $c->stash(object => $c->model('DB::User')->find($id));

    $c->detach("id not found in find user") if !$c->stash->{object};

}
sub edit :Path('edit'){
    my ($self, $c,$edit) = @_;
    if( $c->user->role_id==1) {

        $c->stash(edit=>$edit);
        if($edit ){
           findd($c,$edit);
           $c->stash(wrapper=>'layout3.html',template => 'edituser.html');
        }
        else{$c->detach("id not found in edit user");}

       }
}
sub doedit :Path('doedit'){
    my ($self, $c) = @_;
    my $username = $c->request->params->{username};
    my $fname = $c->request->params->{fname};
    my $lname = $c->request->params->{lname};
    my $email = $c->request->params->{email};
    my $gender = $c->request->params->{gender};
    my $contry = $c->request->params->{contry};
    my $password = $c->request->params->{password};
    my $repassword = $c->request->params->{repassword};
    my $id    = $c->request->params->{id}     ;

   if( $c->user->role_id==1) {
        if ($repassword && $password) {
            if($repassword!=$password){$c->stash(error_msg => "passowrd dosent match");}
            elsif($username && $fname && $lname && $email && $gender && $contry){
                findd($c,$id);
                $c->stash->{object}->username($username) ;
                $c->stash->{object}->fname($fname) ;
                $c->stash->{object}->lname($lname) ;
                $c->stash->{object}->email($email) ;
                $c->stash->{object}->gender($gender) ;
                $c->stash->{object}->contry($contry) ;
                $c->stash->{object}->password($password) ;
                $c->stash->{object}->update;


                $c->response->redirect($c->uri_for( $c->controller('user')->action_for('list'),{mid => $c->set_status_msg("user edited $id")}));
                return;
            }
            else{$c->stash(error_msg => "form incomplete");}
        }
        else{$c->stash(error_msg => "form incomplete");}
        }
    else{$c->stash(error_msg => "permision denied");}
        $c->stash(error_msg => "form incomplete");
        $c->stash->{user=>$c->stash->{object}};
        $c->response->redirect($c->uri_for( $c->controller('user')->action_for('edit'),$id));
        #$c->stash( wrapper => 'layout3.html' ,template => 'edituser.html');
}
sub  del :Path('del'){
    my ($self, $c,$del) = @_;
    if($del){
         findd($c,$del);
       if( $c->user->role_id==1) {
            $c->stash->{object}->delete;
            $c->response->redirect($c->uri_for( $c->controller('user')->action_for('list')));
            }

       else{ $c->response->redirect($c->uri_for( $c->controller('user')->action_for('list'),{mid => $c->set_status_msg("permission dinied")}));}

    }
    else{ $c->response->redirect($c->uri_for( $c->controller('user')->action_for('list'),{mid => $c->set_status_msg(" id not found")}));}
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
