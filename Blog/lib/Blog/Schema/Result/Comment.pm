use utf8;
package Blog::Schema::Result::Comment;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Blog::Schema::Result::Comment

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

=head1 TABLE: C<comments>

=cut

__PACKAGE__->table("comments");

=head1 ACCESSORS

=head2 msg

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 auth_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 post_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 date

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "msg",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "auth_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "post_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
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
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 post

Type: belongs_to

Related object: L<Blog::Schema::Result::Post>

=cut

__PACKAGE__->belongs_to(
  "post",
  "Blog::Schema::Result::Post",
  { id => "post_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-19 10:14:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NLCbpcdWT5yQxiz0qnx09w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
