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

#
### OVERALL PARAMETERS #####
#
use lib "/home/jbianchi/lilbambu/lib/perl";   #   <= DIR que contiene módulos perl
#~ use wml;
use odm_load;
my $lilbambu_conf_file="/home/jbianchi/lilbambu/config/lilbambu.ini"; # <= archivo de configuración
my $lilbambu_log_dir="/home/jbianchi/lilbambu/logs"; # <= dir de logs

my $cgi = CGI->new();
#~ my @names = $cgi->param;
#~ my $request=$cgi->param('request');
my $query_string=$ENV{QUERY_STRING};
my @params=split(/&/,$query_string);
my %params;
foreach(@params) {
	my @a=split(/=/,$_);
	$params{$a[0]}=$a[1];
	#~ print "par:  $a[0] $params{$a[0]}\n";

} 

#
#  parse postdata
#

my %pars;
if(defined $cgi->param('POSTDATA')) {
	if( length($cgi->param('POSTDATA')) > 0) { 
		my $json = $cgi->param('POSTDATA');
		eval {
			%pars = decode_json $json;
		 }or do {
			err("400 Bad Request",$@);
		};
	}
}
#
### connect to db ###
#
my $dbh;
eval {
	odm_load::dbConnect($lilbambu_conf_file);
} or do {
	 #~ print $cgi->header(
   #~ -type=>'text/plain',
   #~ -status=> '200 Success'
	#~ );
#~ print "error: $@\n";
#~ exit;
	print STDERR $@;
	err("500 Internal Server Error",$@);
};
$dbh=odm_load::dbConnect($lilbambu_conf_file);
my @opts;
my %actions = ( "AddVariables"=> \&odm_load::addVariable,"GetVariables"=>\&odm_load::GetVariables);
#~ "VariableCode"=>"STRING","VariableName"=>"STRING","VariableUnitsID"=>"INTEGER", "SampleMedium"=>"STRING","ValueType"=>"STRING","IsRegular"=>"BOOLEAN","DataType"=>"STRING", "GeneralCategory"=>"STRING","TimeSupport"=>"INTEGER","TimeUnitsID"=>"INTEGER"),
    #~ "GetVariables"=> ("VariableCode"=>"STRING","VariableName"=>"STRING","VariableUnitsID"=>"INTEGER", "SampleMedium"=>"STRING","ValueType"=>"STRING","IsRegular"=>"BOOLEAN","DataType"=>"STRING", "GeneralCategory"=>"STRING","TimeSupport"=>"INTEGER","TimeUnitsID"=>"INTEGER"));
#
# get request param
#
my $request=(defined $params{'request'}) ? $params{'request'} : "GetVariables";
#~ print $cgi->header(
   #~ -type=>'text/plain',
   #~ -status=> '200 Success'
	#~ );
#~ print "request: $request\n";
#~ exit;
if(!defined $request) {
	err("404 Bad Request","Request unknown");
}
if(!defined $actions{$request}) {
	err("404 Bad Request","Accion no definida");
}
my $res=$actions{$request}->($dbh,\%pars,\@opts);
print $cgi->header(
   -type=>'text/plain',
   -status=> '200 Success'
	);
print "request: $request
result: $res\n";
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
	print $cgi->header(
   -type=>'text/plain',
   -status=> $_[0]
	);
	print "Error message: $_[1]\n";
	exit 1;
}
