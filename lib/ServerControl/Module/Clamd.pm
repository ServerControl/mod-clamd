#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package ServerControl::Module::Clamd;

use strict;
use warnings;

our $VERSION = '0.96';

use ServerControl::Module;
use ServerControl::Commons::Process;

use base qw(ServerControl::Module);

__PACKAGE__->Implements( qw(ServerControl::Module::PidFile) );

__PACKAGE__->Parameter(
   help  => { isa => 'bool', call => sub { __PACKAGE__->help; } },
);

sub help {
   my ($class) = @_;

   print __PACKAGE__ . " " . $ServerControl::Module::Clamd::VERSION . "\n";

   printf "  %-30s%s\n", "--name=", "Instance Name";
   printf "  %-30s%s\n", "--path=", "The path where the instance should be created";
   print "\n";
   printf "  %-30s%s\n", "--create", "Create the instance";
   printf "  %-30s%s\n", "--start", "Start the instance";
   printf "  %-30s%s\n", "--stop", "Stop the instance";

}

sub start {
   my ($class) = @_;

   my $clamd_conf_file		= ServerControl::FsLayout->get_file("Configuration", "clamd_conf");
   my $freshclam_conf_file	= ServerControl::FsLayout->get_file("Configuration", "freshclam_conf");

   my ($name, $path)    = ($class->get_name, $class->get_path);

   my $exec_file   = ServerControl::FsLayout->get_file("Exec", "clamd");
   my $fresh_clam  = ServerControl::FsLayout->get_file("Exec", "freshclam");

   # get updates first
   spawn("$path/$fresh_clam --config-file $path/$freshclam_conf_file");

   # then start clamd
   spawn("$path/$exec_file -c $path/$clamd_conf_file");

   # and at the end start freshclam as daemon
   spawn("$path/$fresh_clam --config-file $path/$freshclam_conf_file -d");
}


1;
