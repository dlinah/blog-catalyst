use utf8;
package Blog::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Blog::Schema::Result::User

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::TimeStamp>

=item * L<DBIx::Class::PassphraseColumn>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "PassphraseColumn");

=head1 TABLE: C<users>

=cut

__PACKAGE__->table("users");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 fname

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=head2 lname

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=head2 username

  data_type: 'varchar'
  is_nullable: 1
  size: 40

=head2 password

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 gender

  data_type: 'varchar'
  is_nullable: 0
  size: 10

=head2 contry

  data_type: 'varchar'
  is_nullable: 1
  size: 40

=head2 email

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 role_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "fname",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "lname",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "username",
  { data_type => "varchar", is_nullable => 1, size => 40 },
  "password",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "gender",
  { data_type => "varchar", is_nullable => 0, size => 10 },
  "contry",
  { data_type => "varchar", is_nullable => 1, size => 40 },
  "email",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "role_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 comments

Type: has_many

Related object: L<Blog::Schema::Result::Comment>

=cut

__PACKAGE__->has_many(
  "comments",
  "Blog::Schema::Result::Comment",
  { "foreign.auth_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 posts

Type: has_many

Related object: L<Blog::Schema::Result::Post>

=cut

__PACKAGE__->has_many(
  "posts",
  "Blog::Schema::Result::Post",
  { "foreign.auth_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 role

Type: belongs_to

Related object: L<Blog::Schema::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "role",
  "Blog::Schema::Result::Role",
  { id => "role_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-19 10:00:58
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:iT1O7Wb6rKoBZeg1PPnYvQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
sub full_name {
    my ($self) = @_;

    return $self->fname . ' ' . $self->lname;
}
__PACKAGE__->add_columns(
    'password' => {
        passphrase       => 'rfc2307',
        passphrase_class => 'SaltedDigest',
        passphrase_args  => {
            algorithm   => 'SHA-1',
            salt_random => 20.
        },
        passphrase_check_method => 'check_password',
    },
);
1;
