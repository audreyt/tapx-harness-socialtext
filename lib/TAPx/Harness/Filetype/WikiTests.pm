package TAPx::Harness::Filetype::WikiTests;

use strict;
use warnings;

sub register {
    my ($class, $harness) = @_;

    # Figure out what we're using to run WikiTests.  Allow for it to be
    # over-ridden via ENV, though, in case the Tester wants to use a script
    # that hands in custom cmd line arguments.
    my $exec = $ENV{RUN_WIKI_TESTS} || 'run-wiki-tests';

    # Add in custom executor for WikiTests
    $class->_add_executor( {
        'harness' => $harness,
        'match'   => qr{/wikitests/},
        'exec'    => [$exec, '-f'],
    } );

    # Allow for WikiTests to be parallelized
    $class->_add_rule( {
        'harness' => $harness,
        'rule'    => {
            seq => [
                { seq => '**.wiki' },           # wikiD tests must be sequential
                { par => '**/wikitests/**' },   # wikiQ can be parallelized
            ],
        },
    } );
}

sub _add_rule {
    my ($class, $args) = @_;
    my $harness = $args->{harness};
    my $rule    = $args->{rule};

    my $old_rule = $harness->rules() || +{ par => '**' };
    $harness->rules( {
        par => [ $rule, $old_rule ],
    } );
}

sub _add_executor {
    my ($class, $args) = @_;
    my $harness = $args->{harness};
    my $match   = $args->{match};
    my $exec    = $args->{exec};

    my $old_exec = $harness->exec() || sub { };
    $harness->exec( sub {
        my ($h, $test) = @_;
        return [@{$exec}, $test] if ($test =~ /$match/);
        return $old_exec->($h, $test);
    } );
}

1;

=head1 NAME

TAPx::Harness::Filetype::WikiTests - Adds WikiTests as a known filetype

=head1 SYNOPSIS

  # Create a custom TAP::Harness, and register our filetype into it
  package MY::TAP::Harness;

  use TAP::Harness;
  use TAPx::Harness::Filetype::WikiTests;

  sub new {
      my $class = shift;

      # create a standard TAP Harness
      my $harness = TAP::Harness->new(@_);

      # register our new file type in that harness
      TAPx::Harness::Filetype::WikiTests->register($harness);

      return $harness;
  }

=head1 DESCRIPTION

C<TAPx::Harness::Filetype::WikiTests> adds WikiTests (both wikiQ and wikiD) as
a known filetype for testing.

wikiQ tests are allowed to be parallelized, while wikiD tests are run
sequentially.  All while at the same time potentially running other unit tests
in parallel.

By default, F<run-wiki-tests> is used to run the tests.  If you wish to pass
through custom command line arguments to F<run-wiki-tests> to have it use a
different test Workspace, server, etc., you will B<need> to create a small
shell script which wraps your command line arguments.  Once done, export
C<RUN_WIKI_TESTS> in your environment with the name of that script, and we'll
pick that up and use I<that> script for running the tests instead of the
standard F<run-wiki-tests>.

Please note that I<this> module will pass through the C<-f> option to
F<run-wiki-tests> automatically; if you over-ride the script with
C<RUN_WIKI_TESTS> in your environment you do I<not> need to provide that
command line argument.

=head1 AUTHOR

Graham TerMarsch (cpan@howlingfrog.com)

=head1 COPYRIGHT

Copyright (C) 2009-2011, Socialtext, Inc.  All Rights Reserved.

=head1 LICENSE

All the code in this distribution is copyrighted by Socialtext Incorporated,
licensed under CPAL; see the F<LICENSE> file in the package for details.

=cut
