package TAPx::Harness::Callbacks::JobNumber;

use strict;
use warnings;

sub register {
    my ($class, $harness) = @_;

    my @jobs = (1 .. $harness->jobs);

    $harness->callback(
        'parser_args' => sub {
            $ENV{HARNESS_JOB_NUMBER} = $jobs[0];
        },
    );

    $harness->callback(
        'made_parser' => sub {
            my ($parser, $job) = @_;
            $parser->{job_number} = shift @jobs;
        },
    );

    $harness->callback(
        'after_test' => sub {
            my ($job, $parser) = @_;
            push @jobs, $parser->{job_number};
            delete $ENV{HARNESS_JOB_NUMBER};
        },
    );
}

1;

=head1 NAME

TAPx::Harness::Callbacks::JobNumber - Expose job number for parallel test runs

=head1 SYNOPSIS

  # Create a custom TAP::Harness, and load our callbacks into it
  package MY::TAP::Harness;

  use TAP::Harness;
  use TAPx::Harness::Callbacks::JobNumber;

  sub new {
      my $class = shift;

      # create a standard TAP Harness
      my $harness = TAP::Harness->new(@_);

      # register our callbacks against that harness
      TAPx::Harness::Callbacks::JobNumber->register($harness);

      return $harness;
  }

=head1 DESCRIPTION

C<TAPx::Harness::Callbacks::JobNumber> implements a series of C<TAP::Harness>
callbacks that expose the "job number" when doing parallel test runs.  Running
four tests in parallel?  You'll have jobs numbered 1 through 4.

The job number for the test is exposed in the C<HARNESS_JOB_NUMBER>
environment variable.

Although it'd be nice for tests to have minimal dependencies on the state of
the environment in which they're run, this isn't always the case.  Sometimes,
you have tests which need to have databases set up or need to have some test
data set to work against.  When running I<multiple> tests in parallel, this
can cause problems as tests stomp all over one another.  By exposing the job
number, it becomes possible for you to set up I<multiple> test environments
(one for each job number), thus giving each test its own separate environment
to work in/against.

=head1 AUTHOR

Graham TerMarsch (cpan@howlingfrog.com)

=head1 COPYRIGHT

Copyright (C) 2009-2011, Socialtext, Inc.  All Rights Reserved.

=head1 LICENSE

All the code in this distribution is copyrighted by Socialtext Incorporated,
licensed under CPAL; see the F<LICENSE> file in the package for details.

=cut
