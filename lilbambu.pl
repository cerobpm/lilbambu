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

### OVERALL PARAMETERS #####
use lib "/home/jbianchi/lilbambu/lib/perl";
#~ use wml;
use ODM_load;
my $lilbambu_conf_file="/home/jbianchi/lilbambu/conf/config.ini";

if(!defined $ARGV[0]) {
	print "#####   lilbambu.pl version 0.0 ######
	sintaxis:
	./lilbambu.pl <accion> <parametros key=value> \n";
	exit;
}
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
		my $res = wml($config_file,\%OPTS);
		print "res:$res\n";
	}
	case "ODM_load"
	{
		my @validFunctions = ("addVariable");
		my %validFunctions = map { $_=> 1 } @validFunctions;
		my $funcion = shift @ARGV;
		if(!defined $validFunctions{$funcion}) {
			die "La funcion $funcion de ODM_load no es válida";
		}
		my (%opts) = getOptions(\@ARGV);
		switch($funcion) {
			case "addVariable" {
				my $res=addVariable(\%opts);
				print "$res\n";
				exit;
			} else {
				die "La funcion $funcion de ODM_load no es válida";
			}
		}
	}
}

## GET OPTIONS

sub getOptions {
    my (%opts);
    while (@_) {
        my $opt = shift;
        if ($opt =~ /(^.+)=(.+$)/) {
            $opts{$1} = $2;
        } else {
            $opts{$opt} = 1;
        }
    }

    return (\%opts);
}
