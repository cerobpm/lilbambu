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
use CGI;
use JSON;

=head2 web app JSONRequestParser

=cut


### OVERALL PARAMETERS #####
#
use lib "/usr/lib/perl5";   #   <= DIR que contiene módulos perl
use odm_load;
my $lilbambu_conf_file="/etc/lilbambu/lilbambu.ini"; # <= archivo de configuración

# FETCH COMMAND LINE ARGUMENTS
#
my %cmdlineargs;
foreach(@ARGV)
{
	if($_ =~ /^(.+)=(.+)$/) {
		$cmdlineargs{$1}=$2;
	} else {
		$cmdlineargs{$_}=1;
	}
}

# FETCH REQUEST METHOD & CONTENT TYPE
#
my $cgi = CGI->new();
my $method = $cgi->request_method();
my $content_type = $cgi->content_type();

#~ my @names = $cgi->param;
#~ my $request=$cgi->param('request');

# GET QUERY_STRING PARAMETERS
my $query_string=$ENV{QUERY_STRING};
my @params;
if(defined $query_string) {
	@params=split(/&/,$query_string);
}
my %params;
foreach(@params) {
	my @a=split(/=/,$_);
	$params{$a[0]}=$a[1];
	#~ print "par:  $a[0] $params{$a[0]}\n";
} 

#  parse postdata
#
my $pars;
if(defined $method) {
	if($method eq "POST" && defined $cgi->param('POSTDATA')) {
		if( length($cgi->param('POSTDATA')) > 0) {
			my $postdata = $cgi->param('POSTDATA');
			switch ($content_type) {
				case "application/json" {
					eval {
						$pars = decode_json $postdata;
					 }or do {
						err("400 Bad Request",$@);
					};
				}
				case "application/xml" {
					my $parser = new XML::Parser ;
					eval {
						$pars = $parser->parse($postdata);
					} or do {
						err("400 Bad Request",$@);
					};
				} else {
					err("400 Bad Request",$@);
				}
			}
		}
	} else {
		my %p = %params;
		delete $p{request}; 
		$pars = \%p;
	}
}

### fetch connection parameters
#
my @validconpars=("DBUSER","USER","dbuser","user","DBPASSWORD","PASSWORD","dbpassword","password");
my %conpars;
foreach(@validconpars) {
	if(defined $pars->{$_}) {
		$conpars{$_}=$pars->{$_};
		delete $pars->{$_};
	}
}
#~ if(keys %conpars <= 0) {
	#~ print STDERR "Element 'conpars' esta vacio\n";
#~ }
### connect to db ###
#
my $dbh;
eval {
	$dbh=odm_load::dbConnect($lilbambu_conf_file,\%conpars);
} or do {
	print STDERR $@;
	err("401 Unauthorized",$@);
};
#~ $dbh=odm_load::dbConnect($lilbambu_conf_file);
my @opts;
my %actions = ( "AddVariables"=> \&odm_load::addVariable,"GetVariables"=>\&odm_load::GetVariables,"AddSource"=> \&odm_load::addSource, "GetSources"=>\&odm_load::GetSources,"AddSite"=>\&odm_load::addSite,"GetSites",\&odm_load::GetSites);

# fetch request param
#
my $request=(defined $params{'request'}) ? $params{'request'} : undef;
if(!defined $request) {
	print STDERR "Funcion no definida (vacio)\n";
	err("400 Bad Request","Request unknown");
}
if(!defined $actions{$request}) {
	print STDERR "Funcion no definida ($request)\n";
	err("400 Bad Request","Accion no definida");
}
my $responsetype = (lc($request) =~ /^add/) ? "application/json" : "application/xml";
my $res;
eval {
	$res=$actions{$request}->($dbh,$pars,\@opts);
} or do {
	print STDERR "Error en la ejecucion de la funcion seleccionada ($request). Mensaje: $@\n";
	err("400 Bad Request","Bad parameters or missing");
};
print $cgi->header(
   -type=>$responsetype,
   -status=> '200 Success'
	);
print "$res";
exit;

###########################################################

#~ switch ($request) {
	#~ case /AddVariables/ {
		#~ print $cgi->header(
   #~ -type=>'text/plain',
   #~ -status=> '200 Success'
	#~ );
	#~ print "service: AddVariables \n";
	#~ exit 1;
	#~ } 
	#~ case /GetVariables/ {
		#~ print $cgi->header(
   #~ -type=>'text/plain',
   #~ -status=> '200 Success'
	#~ );
	#~ print "service: GetVariables\n";
	#~ exit 1;
	#~ }
	#~ else {
		#~ print $cgi->header(
   #~ -type=>'text/plain',
   #~ -status=> '200 Success'
	#~ );
	#~ print "service: Unknown ($query_string)";
	#~ foreach(keys %params) {
		#~ print "par: $_ =>" . $params{$_} . ".\n";
	#~ }
	#~ exit 1;
	#~ }
#~ }


	

#~ print "Content-Type: application/json; charset=\"utf-8\"


#~ $json";


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
### shift accion
#
#~ my $accion = shift @ARGV;
#~ chomp $accion;
#~ switch(lc($accion)) {
	#~ case "wml" {


sub err {
	print STDERR "$_[1]\n";
	print $cgi->header(
   -type=>'text/plain',
   -status=> $_[0]
	);
	print "Error message: $_[1]\n";
	exit 1;
}
