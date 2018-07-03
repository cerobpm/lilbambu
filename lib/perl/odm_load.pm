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
@EXPORT      = qw(dbConnect,addVariable);
@EXPORT_OK   = qw(dbConnect,addVariable);
%EXPORT_TAGS = ( DEFAULT => [qw(dbConnect,addVariable)]);

# FUNCION load_conf
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
		my $source = "dbi:" . $cfg->val('all','DBDRIVER') . ":" . $cfg->val('all','DBNAME') . $port;
        my $dbh = DBI->connect($source, $cfg->val('all','DBUSER'), $auth, { RaiseError => 1 }) or die $DBI::errstr;
		return $dbh;
}

# FUNCION add_variables
#
# $_[0] => database handle object (from DBI->connect)
# $_[1] => HASH     parametros: ( "VariableCode"=> "10" , "VariableName"=> "Discharge","VariableUnitsID"=>36)


sub add_variable {
	my @validColumns = ("VariableCode","VariableName","VariableUnitsID", "SampleMedium","ValueType","IsRegular","DataType", "GeneralCategory");
	my %validColumns  =  map { $_ => 1 } @validColumns;
	my @requiredColumns = ("VariableCode","VariableName","VariableUnitsID");
	my @ColumnsTypes = ("SCALAR","SCALAR","INTEGER","SCALAR","SCALAR","BOOLEAN","SCALAR","SCALAR"); 
	my @requiredColumnsTypes = ("SCALAR","SCALAR","INTEGER");
	if(!defined $_[1]) {
		die "Faltan parametros";
	}
	if(ref($_[1]) eq 'HASH') {
	
	#   CHEQUEA COLUMNAS OBLIGATORIAS   #
	
		for(my $i=0;$i<@requiredColumns;$i++)
		{
			if(!defined $_[1]->{$requiredColumns[$i]}) 
			{
				die "Falta $requiredColumns[$i]";
			}
			if(type($_[1]->{$requiredColumns[$i]}) ne $requiredColumnsTypes[$i]) {
				die "Parametro $requiredColumns[$i] es de tipo erroneo, debe ser $requiredColumnsTypes[$i]";
			}
		}
		
		# CREA SENTENCIA DE INSERCION ITERANDO $_[1] y CHEQUEANDO KEYS Y TIPOS   #
		
		my $varstr="";
		my $valstr="";
		foreach my $key (%$_[1]) {
			if(!defined $validColumns{$key}) {
				die "Parametro $key incorrecto";
			}
			my ($index) = grep { $validColumns[$_] eq $key } 0..$#validColumns;
			if(type($_[1]->{$key}) ne $ColumnsTypes[$index]) {
				die "Parametro $key es de tipo erroneo, debe ser $ColumnsTypes[$index]";
			}	
			$varstr.= "\"" . $key . "\",";
			if($ColumnsTypes[$index] eq "SCALAR") {
				$valstr.= "\"" . $_[1]->{$key} . "\",";
			} else {
				$valstr.= $_[1]->{$key} . ",";
			}
		}
		chop $varstr;
		chop $valstr;
		my $stmt =qq(insert into "Variables" ($varstr) values ($valstr) on conflict (\"\") do nothing);
		my $rows = $_[0]->do($stmt) or die $_[0]->errstr;
		return "$rows rows affected";
	}
}
