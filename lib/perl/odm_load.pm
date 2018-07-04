package odm_load;

use strict;
use Exporter;
use CGI;
#use Astro::Time;
use POSIX qw(strftime);
use DBI;
use utf8;
use Encode;
use Switch;
use autobox::universal qw(type);
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
use Config::IniFiles;

$VERSION     = 1.00;
@ISA         = qw(Exporter);
@EXPORT      = qw(dbConnect,addVariable,columnTypeCheck);
@EXPORT_OK   = qw(dbConnect,addVariable,columnTypeCheck);
%EXPORT_TAGS = ( DEFAULT => [qw(dbConnect,addVariable,columnTypeCheck)]);

# FUNCION dbConnect
#
# $_[0] => STRING   configuration file location .ini

sub dbConnect {
	#
	#  LEE ARCHIVO DE CONFIGURACION   #
	#
        my $config_file = $_[0];
        my $cfg = Config::IniFiles->new( -file => $_[0] ) or die "No se encontro el archivo de configuracion $config_file";
        #~ die "Couldn't interpret the configuration file ($config_file) that was given.\nError details follow: $@\n" if $@;
        if(!defined $cfg->val('all','DBDRIVER')) { die "Falta parametro DB_HOST en archivo de configuracion '$config_file'\n"; }
        if(!defined $cfg->val('all','DBHOST')) { die "Falta parametro DB_HOST en archivo de configuracion '$config_file'\n"; }
        my $port = (!defined $cfg->val('all','DBPORT')) ? "" : (":" . $cfg->val('all','DBPORT'));
        if(!defined $cfg->val('all','DBNAME')) { die "Falta parametro DB_NAME en archivo de configuracion '$config_file'\n"; }
        if(!defined $cfg->val('all','DBUSER')) { die "Falta parametro DB_USER en archivo de configuracion '$config_file'\n";}
        my $auth = (!defined $cfg->val('all','DBPASSWORD')) ? "" : $cfg->val('all','DBPASSWORD');
	#
  	# CONECTA CON DATA SOURCE DB #
  	#
		my $source = "dbi:" . $cfg->val('all','DBDRIVER') . ":dbname=" . $cfg->val('all','DBNAME') . $port;
		#~ print "DBSOURCE: \"$source\"\n";
        #~ my $dbh = DBI->connect("dbi:Pg:db=ODM","jbianchi","",{ RaiseError => 1 }) or die $DBI::errstr;

        my $dbh = DBI->connect($source, $cfg->val('all','DBUSER'), $auth, { RaiseError => 1 }) or die $DBI::errstr;
		return $dbh;
}

# FUNCION add_variables
#
# $_[0] => database handle object (from DBI->connect)
# $_[1] => HASHREF     parametros: ( "VariableCode"=> "10" , "VariableName"=> "Discharge","VariableUnitsID"=>36)
# $_[2] => ARRAYREF  options   -U => on conflict action do update 


sub addVariable {
	my @validColumns = ("VariableCode","VariableName","VariableUnitsID", "SampleMedium","ValueType","IsRegular","DataType", "GeneralCategory","TimeSupport","TimeUnitsID","SampleMedium");
	my %validColumns  =  map { $_ => 1 } @validColumns;
	my @requiredColumns = ("VariableCode","VariableName","VariableUnitsID");
	my @ColumnsTypes = ("STRING","STRING","INTEGER","STRING","STRING","BOOLEAN","STRING","STRING"); 
	my @requiredColumnsTypes = ("STRING","STRING","INTEGER");
	if(!defined $_[1]) {
		die "Faltan parametros";
	}
	if(ref($_[1]) ne 'HASH') {
		die "\$_[1] debe ser HASHREF, pero es" . ref($_[1]) . ".";
	}
	#
	# LEE OPCIONES
	#
	my %opts= map { $_ => 1 } @{$_[2]};
	#
	#   CHEQUEA COLUMNAS OBLIGATORIAS   #
	#
	columnTypeCheck(\@requiredColumns,\@requiredColumnsTypes,$_[1],1);
	columnTypeCheck(\@validColumns,\@ColumnsTypes,$_[1],2);
	#
	# CREA SENTENCIA DE INSERCION ITERANDO $_[1] y CHEQUEANDO KEYS Y TIPOS   #
	#
	my $varstr="";
	my $valstr="";
	my $updstr="";
	foreach my $key (keys %{$_[1]}) {
		#~ if(!defined $validColumns{$key}) {
			#~ die "Parametro $key incorrecto";
		#~ }
		my ($index) = grep { $validColumns[$_] eq $key } 0..$#validColumns;
		#~ if(type($_[1]->{$key}) ne $ColumnsTypes[$index]) {
			#~ die "Parametro $key es de tipo erroneo, debe ser $ColumnsTypes[$index]";
		#~ }	
		$varstr.= "\"" . $key . "\",";
		$updstr.= "\"" . $key . "\"=";
		if($ColumnsTypes[$index] eq "STRING") {
			$valstr.= "'" . $_[1]->{$key} . "',";
			$updstr .= "'" . $_[1]->{$key} . "',";
		} else {
			$valstr.= $_[1]->{$key} . ",";
			$updstr .= $_[1]->{$key} . ",";
		}
	}
	if(!defined $_[1]->{TimeUnitsID}) {
		$varstr.= "\"TimeUnitsID\""; #chop $varstr;
		$valstr.= "352"; #chop $valstr;
		$updstr.="\"TimeUnitsID\"=352"; #chop $updstr;
	} else {
		chop $varstr;
		chop $valstr;
		chop $updstr;
	}
	my $onConflictAction="do nothing";
	if(defined $opts{"-U"}) {
		$onConflictAction="do update set $updstr";
	}
	my $stmt =qq(insert into "Variables" ($varstr) values ($valstr) on conflict (\"VariableCode\") $onConflictAction);
	my $rows = $_[0]->do($stmt) or die $_[0]->errstr;
	return "$rows rows affected";
	#~ print $stmt . "\n";
	#~ return 1;
}

#
# funcion columnTypeCheck
#
# $_[0] => Column Names ARRAY
# $_[1] => Column Types ARRAY
# $_[2] => input Columns HASH
# $_[3] => 1:allRequired, 2:checkValid, 0:none
sub columnTypeCheck {
	if($_[3] == 2) {
		my %cnames = map { $_ => 1 } @{$_[0]};
		#~ foreach my $k (keys %cnames) {
			#~ print "validColumns $k: $cnames{$k}\n";
		#~ }
		foreach my $key (keys %{$_[2]}) {
			if(!defined $cnames{$key}) {
				die "Parametro " . $key . " incorrecto";
			}
		}
	}
	for(my $i=0;$i<@$_[0];$i++)
	{
		if($_[3] == 1 && !defined $_[2]->{$_[0]->[$i]}) 
		{
			die "Falta $_[0]->[$i]";
		}
		switch ($_[1]->[$i]) {
			case "INTEGER" {
				if($_[2]->{$_[0]->[$i]} !~ /^\d+$/) {
					die "Parametro $_[0]->[$i] (" . $_[2]->{$_[0]->[$i]} . ") es de tipo erroneo, debe ser INTEGER";
				}
			} case "FLOAT" {
				if($_[2]->{$_[0]->[$i]} !~ /^([+-]?)(?=\d&\.\d)\d*(\.\d*)?([Ee]([+-]?\d+))?$/) {
						die "Parametro $_[0]->[$i] (" . $_[2]->{$_[0]->[$i]} . ") es de tipo erroneo, debe ser FLOAT";
					}
			} case "BOOLEAN" {
				if($_[2]->{$_[0]->[$i]} !~ /^(true|TRUE|false|FALSE)$/) {
						die "Parametro $_[0]->[$i] (" . $_[2]->{$_[0]->[$i]} . ") es de tipo erroneo, debe ser BOOLEAN";
					}
			} else {
				if(type($_[2]->{$_[0]->[$i]}) ne $_[1]->[$i]) {
					die "Parametro $_[0]->[$i] (" . $_[2]->{$_[0]->[$i]} . ") es de tipo erroneo, debe ser $_[1]->[$i], pero es " . type($_[2]->{$_[0]->[$i]}) . ".";
				}
			}
		}
	}
}
