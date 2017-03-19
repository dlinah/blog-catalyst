use utf8;
package Blog::Schema::Result::Role;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Blog::Schema::Result::Role

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

=head1 TABLE: C<roles>

=cut

__PACKAGE__->table("roles");

=head1 ACCESSORS

=head2 role

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 id

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "role",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "id",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 users

Type: has_many

Related object: L<Blog::Schema::Result::User>

=cut

__PACKAGE__->has_many(
  "users",
  "Blog::Schema::Result::User",
  { "foreign.role_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-18 22:04:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wLK9cpZip2CDfijYk5MsLQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
