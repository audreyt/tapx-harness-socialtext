package TAPx::Harness::Socialtext;

use strict;
use warnings;
use 5.008;
our $VERSION = '0.01';
use TAP::Harness;
use TAPx::Harness::Callbacks::JobNumber;
use TAPx::Harness::Filetype::WikiTests;

sub new {
    my $class   = shift;
    my $harness = TAP::Harness->new(@_);

    # register our add-ons/callbacks with the TAP::Harness
    TAPx::Harness::Callbacks::JobNumber->register($harness);
    TAPx::Harness::Filetype::WikiTests->register($harness);

    return $harness;
}

1;

=head1 NAME

TAPx::Harness::Socialtext - ST extended TAP::Harness

=head1 SYNOPSIS

  prove --harness TAPx::Harness::Socialtext ...

=head1 DESCRIPTION

C<TAPx::Harness::Socialtext> extends C<TAP::Harness>, adding in some extra
callbacks and setup that's useful for Socialtext:

=over

=item *

Expose C<HARNESS_JOB_NUMBER> into the environment, for parallel test runs

=item *

Support for wikiD and wikiQ tests, run via F<run-wiki-tests>.

=back

=head1 SEE ALSO

L<TAPx::Harness::Callbacks::JobNumber>,
L<TAPx::Harness::Filetype::WikiTests>,

=head1 AUTHOR

Graham TerMarsch (cpan@howlingfrog.com)

=head1 COPYRIGHT

Copyright (C) 2009-2011, Socialtext, Inc.  All Rights Reserved.

=head1 LICENSE

All the code in this distribution is copyrighted by Socialtext Incorporated,
licensed under CPAL; see the F<LICENSE> file in the package for details.

=cut
