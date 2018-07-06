package odm_load;

=head1 NAME

odm_load package

=head1 SYNOPSIS

	use odm_load;
	my $dbh=odm_load::dbConnect;
	my %params=("VariableCode"=>"2","VariableName"=>"Gage height","VariableUnitsID"=>52);
	my @opts=("-U");
	my $status=odm_load::addVariable($dbh,\%params,\@opts);

=head1 DESCRIPTION
	
	Este modulo sirve para insertar, editar y seleccionar registros de la base de datos ODM/PGSQL
	
=cut
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
@EXPORT      = qw(dbConnect,addVariable,columnTypeCheck,GetVariables);
@EXPORT_OK   = qw(dbConnect,addVariable,columnTypeCheck,GetVariables);
%EXPORT_TAGS = ( DEFAULT => [qw(dbConnect,addVariable,columnTypeCheck,GetVariables)]);

my $query_string = (defined $ENV{QUERY_STRING}) ? (defined $ENV{REQUEST_URI}) ? ( $ENV{HTTP_HOST} . $ENV{DOCUMENT_ROOT} .  $ENV{REQUEST_URI} . "?" . $ENV{QUERY_STRING} ) : $ENV{QUERY_STRING} : "local";

=head2 FUNCION dbConnect

	$_[0] => STRING   configuration file location .ini

=cut 

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
        #~ print "Conectado a $source\n";
		return $dbh;
}

=head2 FUNCION addVariables

	$_[0] => database handle object (from DBI->connect)
	$_[1] => HASHREF     parametros: ( "VariableCode"=> "10" , "VariableName"=> "Discharge","VariableUnitsID"=>36)
	$_[2] => ARRAYREF  options   -U => on conflict action do update 
=cut

sub addVariable {
	my %validColumns = ("VariableCode"=>"STRING","VariableName"=>"STRING","VariableUnitsID"=>"INTEGER", "SampleMedium"=>"STRING","ValueType"=>"STRING","IsRegular"=>"BOOLEAN","DataType"=>"STRING", "GeneralCategory"=>"STRING","TimeSupport"=>"INTEGER","TimeUnitsID"=>"INTEGER");
	#~ my %validColumns  =  map { $_ => 1 } @validColumns;
	my %requiredColumns = ("VariableCode"=>"STRING","VariableName"=>"STRING","VariableUnitsID"=>"INTEGER");
	#~ my @ColumnsTypes = ("STRING","STRING","INTEGER","STRING","STRING","BOOLEAN","STRING","STRING"); 
	#~ my @requiredColumnsTypes = ("STRING","STRING","INTEGER");
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
	columnTypeCheck(\%requiredColumns,$_[1],1);
	my %types=columnTypeCheck(\%validColumns,$_[1],2);
	#
	# CREA SENTENCIA DE INSERCION ITERANDO $_[1] y CHEQUEANDO KEYS Y TIPOS   #
	#
	my $varstr="";
	my $valstr="";
	my $updstr="";
	foreach my $key (keys %{$_[1]}) {
		#~ my ($index) = grep { $validColumns[$_] eq $key } 0..$#validColumns;
		$varstr.= "\"" . $key . "\",";
		$updstr.= "\"" . $key . "\"=";
		#~ if($ColumnsTypes[$index] eq "STRING") {
		if($types{$key} eq "STRING") {
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


=head2 funcion columnTypeCheck

	$_[0] => Column Names ARRAY
	$_[1] => Column Types ARRAY
	$_[2] => input Columns HASH
	$_[3] => 1:allRequired, 2:checkValid, 0:none
=cut

sub columnTypeCheck {
	my %types;
	if($_[2] == 2) {
		#~ my %cnames;
		#~ @cnames{@{$_[0]}}=@{$_[1]};
		#~ foreach my $k (keys %cnames) {
			#~ print "validColumns $k: $cnames{$k}\n";
		#~ }
		foreach my $key (keys %{$_[1]}) {
			if(!defined $_[0]->{$key}) {
				die "Parametro " . $key . " incorrecto";
			}
		}
	}
	foreach my $key (keys %{$_[0]})
	{
		if($_[2] == 1 && !defined $_[1]->{$key}) 
		{
			die "Falta $key";
		}
		if($_[1]->{$key} =~ /[';]/) {
			die "Parametro $key (" . $_[1]->{$key} . ") contiene caracteres no admitidos [';]";
		}
		elsif (defined $_[1]->{$key}) {
			switch ($_[0]->{$key}) {
				case "INTEGER" {
					if($_[1]->{$key} !~ /^\d+$/) {
						die "Parametro $key (" . $_[1]->{$key} . ") es de tipo erroneo, debe ser INTEGER";
					}
				} case "FLOAT" {
					if($_[1]->{$key} !~ /^([+-]?)(?=\d&\.\d)\d*(\.\d*)?([Ee]([+-]?\d+))?$/) {
							die "Parametro $key (" . $_[1]->{$key} . ") es de tipo erroneo, debe ser FLOAT";
						}
				} case "BOOLEAN" {
					if($_[1]->{$key} !~ /^(true|TRUE|false|FALSE)$/) {
							die "Parametro $key (" . $_[1]->{$key} . ") es de tipo erroneo, debe ser BOOLEAN";
						}
				} else {
					if(type($_[1]->{$key}) ne $_[0]->{$key}) {
						die "Parametro $key (" . $_[1]->{$key} . ") es de tipo erroneo, debe ser " . $_[0]->{$key} . " , pero es " . type($_[1]->{$key}) . ".";
					}
				}
			}
			$types{$key}=$_[0]->{$key};
		}
	}
	return \%types;
}

=head2 funcion GetVariables

	$_[0] => database connection handler
	$_[1] => parameters HASH [valid params=  VariableCode"=>"STRING","VariableName"=>"STRING","VariableUnitsID"=>"INTEGER", "SampleMedium"=>"STRING","ValueType"=>"STRING","IsRegular"=>"BOOLEAN","DataType"=>"STRING", "GeneralCategory"=>"STRING","TimeSupport"=>"INTEGER","TimeUnitsID"=>"INTEGER
	$_[2] => options ARRAY [valod opts -f=[wml,json,fwt,csv]  ]

=cut

sub GetVariables {
	my %validColumns = ("VariableCode"=>"STRING","VariableName"=>"STRING","VariableUnitsID"=>"INTEGER", "SampleMedium"=>"STRING","ValueType"=>"STRING","IsRegular"=>"BOOLEAN","DataType"=>"STRING", "GeneralCategory"=>"STRING","TimeSupport"=>"INTEGER","TimeUnitsID"=>"INTEGER");
	#
	# crea filtro SQL iterando parametros
	#
	my $types; 
	my $filter="";
	if(defined $_[1]) {
		if(ref($_[1]) ne "HASH") {
			die "\$_[1] debe ser HASHREF, pero es" . ref($_[1]) . ".";
		}
		$types=columnTypeCheck(\%validColumns,$_[1],2);
		foreach my $key (keys %{$_[1]}) {
			if($types->{$key} eq "STRING") {
				$filter.= " and \"". $key . "\"='" . $_[1]->{$key} . "'";
			} else {
				$filter.= " and \"". $key . "\"=" . $_[1]->{$key};
			}
		}
	}
	#
	# LEE OPCIONES
	#
	my %opts;
	if(defined $_[2]) {
		if(ref($_[2]) ne "ARRAY") {
			die "\$_[2] debe ser ARRAY ref, pero es" . ref($_[2]) . ".";
		}
		foreach(@$_[2]) {
			$_ =~ s/^-+//g;
			if($_ =~ /^(\.+)=(\.+)$/) {
				$opts{$1}=$2;
			} else {
				$opts{$_}=1;
			}
		}
		#~ %opts= map { $_ => 1 } @{$_[2]};
	}
	my $stmt;
	my $format = (defined $opts{f}) ? $opts{f} : "wml";
	switch(lc($format)) {
		case "wml" {
			$stmt = "select xmlelement(name \"variablesResponse\",xmlattributes('http://www.cuahsi.org/waterML/1.1/' as \"xmlns:sr\"),xmlelement(name \"queryInfo\",xmlelement(name \"creationTime\",current_timestamp),xmlelement(name \"queryURL\",'$query_string')),xmlelement(name \"variables\", xmlagg(\"VariableInfoXML\"))) from \"VariableInfoXML\" where \"VariableCode\" is not null $filter";
		} else {
			die "Formato $format incorrecto. opciones: wml json fwt csv\n";
		}
	}
	my $sth = $_[0]->prepare($stmt);
	$sth->execute() or die $_[0]->errstr;
	my @res = $sth->fetchrow_array;
	if(!defined $res[0]) {
		err("No se encontraron datos para los parametros especificados");
	}
	# Content-Type: text/xml; charset=utf-8\n\r\n\n
	return "$res[0]"; 	
}
