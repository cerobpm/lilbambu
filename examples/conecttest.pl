#!/usr/bin/perl
use strict; 
use warnings;
use POSIX qw(strftime);
use utf8;
use Encode;
use Getopt::Std;
use Switch;
binmode(STDOUT, ":utf8");
use Env;
#
### OVERALL PARAMETERS #####
#
use lib "/home/leyden/lilbambu/lib/perl";   #   <= DIR que contiene módulos perl
#~ use wml;
use odm_load;
my $lilbambu_conf_file="/home/leyden/lilbambu/config/lilbambu.ini"; # <= archivo de configuración

#~ if(!defined $ARGV[0]) {
	#~ print "#####   lilbambu.pl version 0.0 ######
	#~ sintaxis:
	#~ ./lilbambu.pl <accion> <-opciones><parametros key=value> \n";
	#~ exit;
#~ }
#
# opciones "-" validas
#
#~ my %validOpts=("U"=>"onConflictAction");
#
### connect to db ###
#
my %conpars=("user"=>"lalala","password"=>"lilili");
my $dbh=odm_load::dbConnect($lilbambu_conf_file,\%conpars);
#
