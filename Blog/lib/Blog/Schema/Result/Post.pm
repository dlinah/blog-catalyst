use utf8;
package Blog::Schema::Result::Post;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Blog::Schema::Result::Post

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

=head1 TABLE: C<posts>

=cut

__PACKAGE__->table("posts");

=head1 ACCESSORS

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 body

  data_type: 'varchar'
  is_nullable: 0
  size: 300

=head2 auth_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 date

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "title",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "body",
  { data_type => "varchar", is_nullable => 0, size => 300 },
  "auth_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "date",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 auth

Type: belongs_to

Related object: L<Blog::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "auth",
  "Blog::Schema::Result::User",
  { id => "auth_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 comments

Type: has_many

Related object: L<Blog::Schema::Result::Comment>

=cut

__PACKAGE__->has_many(
  "comments",
  "Blog::Schema::Result::Comment",
  { "foreign.post_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-19 10:00:58
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:enRgMBm6W9db4oFKHheGsg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
sub small_body{
    my ($self) = @_;

    return  substr $self->body,0,255;

}
1;
