#!/usr/bin/perl
use strict; 
use warnings;
use POSIX qw(strftime);
use utf8;
use Encode;
use Getopt::Std;
use Switch;
use JSON;
binmode(STDOUT, ":utf8");
use Env;
#
### OVERALL PARAMETERS #####
#
use lib "/usr/lib/perl5";   #   <= DIR que contiene módulos perl
#~ use wml;
use odm_load;
my $lilbambu_conf_file="/etc/lilbambu/lilbambu.ini"; # <= archivo de configuración
my $lilbambu_data_dir="/home/leyden/lilbambu/data";

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
my $dbh=odm_load::dbConnect($lilbambu_conf_file,"master");
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
		my $res=odm_load::addVariable($dbh,$params,$opciones);
		print "$res\n";
		exit;
	} case "getvariables" {
		my ($params,$opciones) = getOptions(@ARGV);
		my $res=odm_load::GetVariables($dbh,$params,$opciones);
		print "$res\n";
		exit;
	} case "addsource" {
		my ($params,$opciones) = getOptions(@ARGV);
		my $res=odm_load::addSource($dbh,$params,$opciones);
		print "$res\n";
		exit; 
	} case "getsources" {
		my ($params,$opciones) = getOptions(@ARGV);
		my $res=odm_load::GetSources($dbh,$params,$opciones);
		print "$res\n";
		exit; 
	} case "makerestrequest" {
		my ($params,$opciones) = getOptions(@ARGV);
		my $res=odm_load::makeRestRequest($dbh,$params,$opciones);
		my %opt= map { $_ => 1;  } @{$opciones};
		if(defined $opt{"-s"}) {
			open(my $out,">$lilbambu_data_dir/wml/response.wml") or die "no se pudo abrir $lilbambu_data_dir/wml/response.wml para escritura\n";
			print $out $res;
		}else { 
			print "$res\n";
		}
		exit;
	} case "addsite" {
		my ($params,$opciones) = getOptions(@ARGV);
		my $res=odm_load::addSite($dbh,$params,$opciones);
		print "$res\n";
		exit;
	} case "getsites" {
		my ($params,$opciones) = getOptions(@ARGV);
		my $res=odm_load::GetSites($dbh,$params,$opciones);
		print "$res\n";
		exit;
	} case "getsiteinfo" {
		my ($params,$opciones) = getOptions(@ARGV);
		my $res=odm_load::GetSiteInfo($dbh,$params,$opciones);
		print "$res\n";
		exit;
	} case "addvalues" {
		my ($params,$opciones) = getOptions(@ARGV);
		my $res=odm_load::addValues($dbh,$params,$opciones);
		print "$res\n";
		exit; 
	} case "getvalues" {
		my ($params,$opciones) = getOptions(@ARGV);
		my $res=odm_load::GetValues($dbh,$params,$opciones);
		print "$res\n";
		exit; 
	}case "harvestmetadata" {                         ########  NO operativo ###
		my ($params,$opciones) = getOptions(@ARGV);
		$params->{RequestName}="GetVariables";
		my $res=odm_load::makeRestRequest($dbh,$params,$opciones);
		#~ print "REF:" . ref($res) . "\n";
		#~ exit;
		my $variables = $res->findnodes('/variablesResponse/variables/sr:variable');
		if(!defined $variables) {
			die "No se encontraron variables en el servidor consultado\n";
		}
		#~ if(@$res->{variables} == 0) {
			#~ die "No se encontraron variables en el servidor consultado\n";
		#~ }
		my $i;
		for($i=0;$i<@$variables;$i++) {
			my $var = $variables->[$i];
			#~ print STDERR $var->findnodes('variableCode')->[0]->to_literal() . "\n";
			#~ next;
			if($var->findvalue("count(variableCode)")<=0) {
				print STDERR "Falta variableCode para variable $i\n";
				next;
			}
			if($var->findvalue("count(variableName)")<=0) {
				print STDERR "Falta  variableName para variable $i\n";
				next;
			}
			if($var->findvalue('count(unit/@unitsID)')<=0) {
				print STDERR "Falta unit/\@unitsID para variable $i\n";
				next;
			}
			#~ my $VariableID = $var->findnodes('variableCode/@variableID')->[0]; 
			my %params;
			$params{VariableName} = $var->findnodes('variableName')->[0]->to_literal();
			$params{VariableCode} = $params->{Organization} . ":" . $var->findnodes('variableCode')->[0]->to_literal();
			$params{VariableUnitsID} = $var->findnodes('unit/@unitsID')->[0]->to_literal();
			$params{ValueType} = ($var->findvalue('count(valueType)')>0) ? $var->findnodes('valueType')->[0]->to_literal() : "Unknown";
			$params{DataType} = ($var->findvalue('count(dataType)')>0) ? $var->findnodes('dataType')->[0]->to_literal() : "Unknown";
			$params{GeneralCategory} = ($var->findvalue('count(GeneralCategory)')>0) ? $var->findnodes('GeneralCategory')->[0]->to_literal() : "Unknown";
			$params{SampleMedium} = ($var->findvalue('count(SampleMedium)')>0) ? $var->findnodes('SampleMedium')->[0]->to_literal() : "Unknown";
			$params{UnitsName} = ($var->findvalue('count(unit/unitsName)')>0) ? $var->findnodes('unit/unitsName')->[0]->to_literal() : "Unknown";
			$params{UnitsType} = ($var->findvalue('count(unit/unitsType)')>0) ? $var->findnodes('unit/unitsType')->[0]->to_literal() : "Unknown";
			$params{UnitsAbbreviation} = ($var->findvalue('count(unit/UnitsAbbreviation)')>0) ? $var->findnodes('unit/UnitsAbbreviation')->[0]->to_literal() : "Unknown";
			$params{NoDataValue} = ($var->findvalue('count(NoDataValue)')>0) ? $var->findnodes('NoDataValue')->[0]->to_literal() : 0;
			$params{IsRegular} = ($var->findvalue('count(IsRegular)')>0) ? $var->findnodes('IsRegular')->[0]->to_literal() : "false";
			$params{TimeUnitsName} = ($var->findvalue('count(TimeUnitsName)')>0) ? $var->findnodes('TimeUnitsName')->[0]->to_literal() : "Unknown";
			$params{TimeUnitsAbbreviation} = ($var->findvalue('count(TimeUnitsAbbreviation)')>0) ? $var->findnodes('TimeUnitsAbbreviation')->[0]->to_literal() : "Unknown";
			$params{TimeSupport} = ($var->findvalue('count(TimeSupport)')>0) ? $var->findnodes('TimeSupport')->[0]->to_literal() : 0;
			$params{Speciation} = ($var->findvalue('count(Speciation)')>0) ? $var->findnodes('Speciation')->[0]->to_literal() : 0;
			my $res = odm_load::addVariable($dbh,\%params,$opciones);
			print "$res\n";
		}
		print STDERR "Se insertaron $i registros a \"Variables\" (de ". @$variables  . ")\n";
		exit;
	
	} case "parsewml" {
		my ($params,$opciones) = getOptions(@ARGV);
		my $res=odm_load::parseWML($dbh,$params,$opciones);
		print "$res\n";
		exit; 
	} case "getunitsid" {
		my ($params,$opciones) = getOptions(@ARGV);
		my $res=odm_load::GetUnitsID($dbh,$params);
		print "$res\n";
		exit; 
	}  case "addseries" {
		my ($params,$opciones) = getOptions(@ARGV);
		my $res=odm_load::addSeries($dbh,$params,$opciones);
		print "$res\n";
		exit; 
	} else {
	die "La funcion $accion no es válida";
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
		} elsif ($opt =~ /(^.+)=@(.+$)/) {
			open(my $file,$2) or die "Archivo $2 no encontrado";
			eval {
				$params{$1} = decode_json <$file>;
			} or do {
				die "El archivo $2 no es un JSON válido";
			};
		} elsif ($opt =~ /(^.+)=(.+$)/) {
            $params{$1} = $2;
        } else {
            $params{$opt} = 1;
        }
    }

    return (\%params,\@opciones);
}
