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
use lib "/home/jbianchi/lilbambu/lib/perl";
#~ use wml;
use odm_load;
my $lilbambu_conf_file="/home/jbianchi/lilbambu/config/lilbambu.ini";

if(!defined $ARGV[0]) {
	print "#####   lilbambu.pl version 0.0 ######
	sintaxis:
	./lilbambu.pl <accion> <-opciones><parametros key=value> \n";
	exit;
}
#
# opciones "-" validas
#
#~ my %validOpts=("U"=>"onConflictAction");
#
### connect to db ###
#
my $dbh=odm_load::dbConnect($lilbambu_conf_file);
#
### shift accion
#
my $accion = shift @ARGV;
chomp $accion;
switch(lc($accion)) {
	case "wml" {
		our($opt_i,$opt_v,$opt_s,$opt_e,$opt_r,$opt_O,$opt_E,$opt_S,$opt_N,$opt_I);
		getopts("i:v:s:e:r:O:E:S:N:I");
		my %OPTS;
		if(defined $opt_i) {
			$OPTS{siteCode}=$opt_i;
		}
		if(defined $opt_v) {
			$OPTS{variableCode}=$opt_v;
		}
		if(defined $opt_s) {
			$OPTS{startDate}=$opt_s;
		}
		if(defined $opt_e) {
			$OPTS{endDate}=$opt_e;
		}
		if(defined $opt_r) {
			$OPTS{request}=$opt_r;
		}
		if(defined $opt_O) {
			$OPTS{west}=$opt_O;
		}
		if(defined $opt_E) {
			$OPTS{east}=$opt_E;
		}
		if(defined $opt_S) {
			$OPTS{south}=$opt_S;
		}
		if(defined $opt_N) {
			$OPTS{north}=$opt_N;
		}
		if(defined $opt_I) {
			$OPTS{includeSeries}="true";
		}
		#~ foreach(keys %OPTS) {
			#~ print "key:$_, val:$OPTS{$_}\n";
		#~ }
		my $res = wml($dbh,\%OPTS);
		print "res:$res\n";
	}
	case "addvariable" {
		my ($params,$opciones) = getOptions(@ARGV);
		#~ foreach (keys %{$params}) {
			#~ print "$_:" . ${params}->{$_} . "\n";
		#~ }
		#~ print "options\n";
		#~ foreach(@{$opciones}) {
			#~ print "$_\n";
		#~ }
			
		my $res=odm_load::addVariable($dbh,$params,$opciones);
		print "$res\n";
		exit;
	} else {
	die "La funcion $accion de odm_load no es válida";
	}
}

## GET OPTIONS

sub getOptions {
    my (%params,@opciones);
    while (@_) {
        my $opt = shift;
        if ($opt=~ /^-/) {
			#~ if(!defined $validOpts{$1}) {
				#~ die "Opcion $opt no válida";
			#~ }
			#~ print "opcion:$opt\n";
			push @opciones, $opt;
		}elsif ($opt =~ /(^.+)=(.+$)/) {
            $params{$1} = $2;
        } else {
            $params{$opt} = 1;
        }
    }

    return (\%params,\@opciones);
}
