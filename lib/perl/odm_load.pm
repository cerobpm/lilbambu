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
use LWP::UserAgent;
use HTTP::Request;
use XML::LibXML;
use JSON;

$VERSION     = 1.00;
@ISA         = qw(Exporter);
@EXPORT      = qw(dbConnect,addVariable,columnTypeCheck,GetVariables);
@EXPORT_OK   = qw(dbConnect,addVariable,columnTypeCheck,GetVariables);
%EXPORT_TAGS = ( DEFAULT => [qw(dbConnect,addVariable,columnTypeCheck,GetVariables)]);

my $query_string = (defined $ENV{QUERY_STRING}) ? (defined $ENV{REQUEST_URI}) ? ( $ENV{HTTP_HOST} . $ENV{DOCUMENT_ROOT} .  $ENV{REQUEST_URI} . "?" . $ENV{QUERY_STRING} ) : $ENV{QUERY_STRING} : "local";

=head2 FUNCION dbConnect()

	$_[0] => SCALAR   configuration file location .ini 
	$_[1] => HASH (DBUSER=>username,DBPASSWORD=>pass) (opcional, override conf file)
	
=head3 returns

	 database handle object (from DBI->connect)

=cut 

sub dbConnect {
	my $source;
	my $user;
	my $auth;
	my $section="all";
	my %validsections=("all",1,"master",1);
	if(ref(\$_[1]) eq "SCALAR") {
		if(!defined $validsections{$_[1]}) {
			die "section de archivo de configuracion erroneo\n";
		}
		$section = $_[1];
	}
	if(ref(\$_[0]) eq "SCALAR") {
	#
	#  LEE ARCHIVO DE CONFIGURACION   #
	#
        my $config_file = $_[0];
        my $cfg = Config::IniFiles->new( -file => $_[0] ) or die "No se encontro el archivo de configuracion $config_file";
        #~ die "Couldn't interpret the configuration file ($config_file) that was given.\nError details follow: $@\n" if $@;
        if(!defined $cfg->val($section,'DBDRIVER')) { die "Falta parametro DBDRIVER en archivo de configuracion '$config_file'\n"; }
        if(!defined $cfg->val($section,'DBHOST')) { die "Falta parametro DBHOST en archivo de configuracion '$config_file'\n"; }
        my $port = (!defined $cfg->val($section,'DBPORT')) ? "" : (":" . $cfg->val($section,'DBPORT'));
        if(!defined $cfg->val($section,'DBNAME')) { die "Falta parametro DBNAME en archivo de configuracion '$config_file'\n"; }
        if(!defined $cfg->val($section,'DBUSER')) { die "Falta parametro DBUSER en archivo de configuracion '$config_file'\n";}
        $user = $cfg->val($section,'DBUSER');
        $auth = (!defined $cfg->val($section,'DBPASSWORD')) ? "" : $cfg->val($section,'DBPASSWORD');
		$source = "dbi:" . $cfg->val($section,'DBDRIVER') . ":dbname=" . $cfg->val($section,'DBNAME') . $port;
	}
	if(defined $_[1]) {
		if(ref($_[1]) eq "HASH") {
			if(defined $_[1]->{DBUSER}) {
				$user = $_[1]->{DBUSER};
			} elsif (defined $_[1]->{dbuser}) {
				$user = $_[1]->{dbuser};
			} elsif (defined $_[1]->{USER}) {
				$user = $_[1]->{USER};
			} elsif (defined $_[1]->{user}) {
				$user = $_[1]->{user};
			}
			if(defined $_[1]->{DBPASSWORD}) {
				$auth = $_[1]->{DBPASSWORD};
			}elsif(defined $_[1]->{dbpassword}) {
				$auth = $_[1]->{dbpassword};
			}elsif(defined $_[1]->{PASSWORD}) {
				$auth = $_[1]->{PASSWORD};
			}elsif(defined $_[1]->{password}) {
				$auth = $_[1]->{password};
			}
		} 
		#~ elsif(ref($_[1]) ne "SCALAR") {
			#~ print STDERR "parameters element is not a HASH reference or SCALAR\n";
		#~ }
	} 
	#~ else {
		#~ print STDERR "HASH of parameters not defined\n";    #### 	PARA DEBUG
	#~ } 
	#
  	# CONECTA CON DATA SOURCE DB #
  	#
		#~ print STDERR "DBUSER: $user, DBSOURCE: \"$source\", DBPASSWORD: $auth\n";  ### PARA DEBUG
    my $dbh = DBI->connect($source, $user, $auth, 
    { RaiseError => 1,
		 AutoCommit => 1,
      PrintError => 1,
      pg_utf8_strings => 1,
      }) or die $DBI::errstr;
	$dbh->{pg_enable_utf8} = 1;
	$dbh->do("set names 'UTF8'");
	return $dbh;
}

=head2 FUNCION addVariables()

	$_[0] => database handle object (from DBI->connect)
	$_[1] => HASHREF     parametros: ( "VariableCode"=> "10" , "VariableName"=> "Discharge","VariableUnitsID"=>36)
	$_[2] => ARRAYREF  options   -U => on conflict action do update 
	
=head3 returns

	{"status":"200 OK","VariableID":"$inserted_variable_id"} o {"status":"400 Bad Request"}

=cut

sub addVariable {
	my %validColumns = ("VariableCode"=>"STRING","VariableName"=>"STRING","VariableUnitsID"=>"INTEGER", "SampleMedium"=>"STRING","ValueType"=>"STRING","IsRegular"=>"BOOLEAN","DataType"=>"STRING", "GeneralCategory"=>"STRING","TimeSupport"=>"INTEGER","TimeUnitsID"=>"INTEGER","NoDataValue"=>"FLOAT");
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
	#~ foreach(keys %types) {       ### PARA DEBUGGING
		#~ print STDERR "-------types{$_}=".$types{$_}. ".\n"; 
	#~ }
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
		#~ print STDERR "TYPECHECK: $key," . $types{$key} . "\n"; ### PARA DEBUGGING
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
	my $stmt =qq(insert into "Variables" ($varstr) values ($valstr) on conflict (\"VariableCode\") $onConflictAction returning "VariableID");
	print STDERR "$stmt\n"; 
	my $sth=$_[0]->prepare($stmt);
	my $rv=$sth->execute or die $_[0]->errstr;
	my $res = $sth->fetchrow_hashref;   #[0]->do($stmt) or die $_[0]->errstr;
	if(defined $res->{VariableID}) {
		return "{\"status\":\"200 OK\",\"VariableID\":" . $res->{VariableID} . "}";
	} else {
		return "{\"status\":\"400 Bad Request\"}";
	}
	#~ print $stmt . "\n";
	#~ return 1;
}


=head2 funcion columnTypeCheck()

	$_[0] => Column Names ARRAY
	$_[1] => Column Types ARRAY
	$_[2] => input Columns HASH
	$_[3] => 1:allRequired, 2:checkValid, 0:none

=head3 returns

	HASH of valid Column names=>{types}

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
					if($_[1]->{$key} !~ /^[+-]?\d*(\.\d*)?([Ee]([+-]?\d+))?$/) {
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
			#~ print STDERR "TYPECHECK.".$_[2].". key:$key, value:".$_[1]->{$key}." type:".$_[0]->{$key}.".\n";
		}
	}
	return %types;
}

=head2 funcion GetVariables()

	$_[0] => database connection handler
	$_[1] => parameters HASH [valid params=  VariableCode"=>"STRING","VariableName"=>"STRING","VariableUnitsID"=>"INTEGER", "SampleMedium"=>"STRING","ValueType"=>"STRING","IsRegular"=>"BOOLEAN","DataType"=>"STRING", "GeneralCategory"=>"STRING","TimeSupport"=>"INTEGER","TimeUnitsID"=>"INTEGER
	$_[2] => options ARRAY [valid opts -f=[wml,json,fwt,csv]  ]

=head3 returns

	VariablesResponse STRING in requested format (wml,json,fwt,csv) o {"status":"400 Bad Request"}

=cut

sub GetVariables {
	my %validColumns = ("VariableID"=>"INTEGER","VariableCode"=>"STRING","VariableName"=>"STRING","VariableUnitsID"=>"INTEGER", "SampleMedium"=>"STRING","ValueType"=>"STRING","IsRegular"=>"BOOLEAN","DataType"=>"STRING", "GeneralCategory"=>"STRING","TimeSupport"=>"INTEGER","TimeUnitsID"=>"INTEGER");
	#
	# crea filtro SQL iterando parametros
	#
	my %types; 
	my $filter="";
	if(defined $_[1]) {
		if(ref($_[1]) ne "HASH") {
			die "\$_[1] debe ser HASHREF, pero es" . ref($_[1]) . ".";
		}
		%types=columnTypeCheck(\%validColumns,$_[1],2);
		foreach my $key (keys %{$_[1]}) {
			if($types{$key} eq "STRING") {
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
			#~ print STDERR "STATEMENT: $stmt\n";
		} else {
			die "Formato $format incorrecto. opciones: wml json fwt csv\n";
		}
	}
	my $sth = $_[0]->prepare($stmt);
	$sth->execute() or die $_[0]->errstr;
	my @res = $sth->fetchrow_array;
	if(defined $res[0]) {
		return "$res[0]";
	} else {
		return "{\"status\":\"400 Bad Request\"}";
	}
}

=head2 funcion addSource()

	$_[0] => database connection handler
	$_[1] => parameters HASH [valid params=  "SourceID"=>"INTEGER","Organization"=>"STRING","SourceDescription"=>"STRING","SourceLink"=>"STRING","ContactName"=>"STRING","Phone"=>"STRING", "Email"=>"STRING","Address"=>"STRING","City"=>"STRING","State"=>"STRING","ZipCode"=>"STRING","Citation"=>"STRING","MetadataID"=>"INTEGER"
	$_[2] => options ARRAY [valid opts -U]  ]

=head3 returns

	{"status":"200 OK","SourceID":"$inserted_source_id"} o {"status":"400 Bad Request"}

=cut

sub addSource {
	my %validColumns = ("SourceID"=>"INTEGER","Organization"=>"STRING","SourceDescription"=>"STRING","SourceLink"=>"STRING","ContactName"=>"STRING","Phone"=>"STRING", "Email"=>"STRING","Address"=>"STRING","City"=>"STRING","State"=>"STRING","ZipCode"=>"STRING","Citation"=>"STRING","MetadataID"=>"INTEGER");
	my %requiredColumns = ("Organization"=>"STRING","SourceDescription"=>"STRING","Citation"=>"STRING");
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
	#~ foreach(keys %types) {       ### PARA DEBUGGING
		#~ print STDERR "-------types{$_}=".$types{$_}. ".\n"; 
	#~ }
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
		#~ print STDERR "TYPECHECK: $key," . $types{$key} . "\n"; ### PARA DEBUGGING
	}
	chop $varstr;
	chop $valstr;
	chop $updstr;
	my $onConflictAction="do nothing";
	if(defined $opts{"-U"}) {
		$onConflictAction="do update set $updstr";
	}
	my $stmt =qq(insert into "Sources" ($varstr) values ($valstr) on conflict (\"SourceID\") $onConflictAction returning "SourceID");
	#~ print STDERR "$stmt\n"; 
	my $sth=$_[0]->prepare($stmt);
	my $rv=$sth->execute or die $_[0]->errstr;
	my $res = $sth->fetchrow_hashref;   #[0]->do($stmt) or die $_[0]->errstr;
	if(defined $res->{SourceID}) {
		return "{\"status\":\"200 OK\",\"SourceID\":" . $res->{SourceID} . "}";
	} else {
		return "{\"status\":\"400 Bad Request\"}";
	}
	#~ print $stmt . "\n";
	#~ return 1;
}

=head2 funcion GetSources()

	$_[0] => database connection handler
	$_[1] => parameters HASH [valid params=  "SourceID"=>"INTEGER","Organization"=>"STRING","SourceDescription"=>"STRING","SourceLink"=>"STRING","ContactName"=>"STRING","Phone"=>"STRING", "Email"=>"STRING","Address"=>"STRING","City"=>"STRING","State"=>"STRING","ZipCode"=>"STRING","Citation"=>"STRING","MetadataID"=>"INTEGER"
	$_[2] => options ARRAY [valid opts -f [wml,json,fwt,csv]  ]

=head3 returns

	ArrayOfSourceInfo STRING in requested format (wml,json,fwt,csv) o {"status":"400 Bad Request"}

=cut

sub GetSources {
	my %validColumns = ("SourceID"=>"INTEGER","Organization"=>"STRING","SourceDescription"=>"STRING","SourceLink"=>"STRING","ContactName"=>"STRING","Phone"=>"STRING", "Email"=>"STRING","Address"=>"STRING","City"=>"STRING","State"=>"STRING","ZipCode"=>"STRING","Citation"=>"STRING","MetadataID"=>"INTEGER");
	#
	# crea filtro SQL iterando parametros
	#
	my %types; 
	my $filter="";
	if(defined $_[1]) {
		if(ref($_[1]) ne "HASH") {
			die "\$_[1] debe ser HASHREF, pero es" . ref($_[1]) . ".";
		}
		%types=columnTypeCheck(\%validColumns,$_[1],2);
		foreach my $key (keys %{$_[1]}) {
			if($types{$key} eq "STRING") {
				$filter.= " and \"Sources\".\"". $key . "\"='" . $_[1]->{$key} . "'";
			} else {
				$filter.= " and \"Sources\".\"". $key . "\"=" . $_[1]->{$key};
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
			$stmt = "select xmlelement(name \"sourcesResponse\",xmlattributes('http://www.cuahsi.org/waterML/1.1/' as \"xmlns:sr\"),xmlelement(name \"queryInfo\",xmlelement(name \"creationTime\",current_timestamp),xmlelement(name \"queryURL\",'$query_string')),xmlelement(name \"sources\", xmlagg(\"SourceInfoXML\"))) from \"SourceInfoXML\",\"Sources\" where \"SourceInfoXML\".\"SourceID\"=\"Sources\".\"SourceID\" $filter";
			#~ print STDERR "STATEMENT: $stmt\n";
		} else {
			die "Formato $format incorrecto. opciones: wml json fwt csv\n";
		}
	}
	my $sth = $_[0]->prepare($stmt);
	$sth->execute() or die $_[0]->errstr;
	my @res = $sth->fetchrow_array;
	if(defined $res[0]) {
		return "$res[0]";
	} else {
		return "{\"status\":\"400 Bad Request\"}";
	}
}

=head2 funcion makeRestRequest()

	$_[0] => database connection handler
	$_[1] => parameters HASH [valid params=  "Organization"=>"STRING"*,"RequestName"=>"STRING"*,"method"=>"STRING"       *:required
	$_[2] => options ARRAY [valid opts -f]  ]

=head3 returns

	HTTP Response content STRING in requested format (wml) o {"status":"400 Bad Request"}

=cut

sub makeRestRequest {
	my %validColumns = ("Organization"=>"STRING","RequestName"=>"STRING","method"=>"STRING");
	my %requiredColumns = ("Organization"=>"STRING","RequestName"=>"STRING");
	#
	# crea filtro SQL iterando parametros
	#
	my %types; 
	my $filter="";
	if(defined $_[1]) {
		if(ref($_[1]) ne "HASH") {
			die "\$_[1] debe ser HASHREF, pero es" . ref($_[1]) . ".";
		}
		%types=columnTypeCheck(\%validColumns,$_[1],2);
		foreach my $key (keys %{$_[1]}) {
			if($types{$key} eq "STRING") {
				$filter.= " and \"Sources\".\"". $key . "\"='" . $_[1]->{$key} . "'";
			} else {
				$filter.= " and \"Sources\".\"". $key . "\"=" . $_[1]->{$key};
			}
		}
	} else {
	 die "Faltan parametros";
	}
	my $method = (!defined $_[1]->{method}) ? "GET" : $_[1]->{method}; 
	#   CHEQUEA COLUMNAS OBLIGATORIAS   #
	#
	columnTypeCheck(\%requiredColumns,$_[1],1);
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
	
	#  LEE SourceLink de DB #
	my $source = GetSourceLink($_[0],$_[1]->{Organization});
	$source =~ s/\/$//;
	$source .= "/" . $_[1]->{RequestName};
	# CONECTA A SOURCELINK
	#
	my $request = HTTP::Request->new($method => $source);
	my $ua = LWP::UserAgent->new;
	my $response = $ua->request($request);
	my $code=$response->code;
	my $desc = HTTP::Status::status_message($code);
	my $headers=$response->headers_as_string;
	my $body =  $response->content;
	#~ return "status code: $code
#~ status message: $desc
#~ headers: $headers
#~ body: $body\n";
	if($code != 200) {
		die "{\"code\":$code,\"message\":\"desc\",\"body\":\"$body\"}";
	}
	my $data;
	eval {
		$data = XML::LibXML->load_xml(string=>$body);
	} or do {
		die "No se pudo parsear la respuesta pues no es XML valido\n";
	};
	return $data; #->toString();
}
		

=head2 funcion GetSourceLink()

	$_[0] => database connection handler
	$_[1] => Organization STRING
	$_[2] => options ARRAY [valid opts -U]  

=head3 returns

	STRING SourceLink 

=cut

sub GetSourceLink {
	#  LEE SourceLink de DB #
	my $sth=$_[0]->prepare("select \"SourceLink\" from \"Sources\" where \"Organization\"='" . $_[1] . "' and \"SourceLink\" is not null");
	$sth->execute();
	my @res = $sth->fetchrow_array;
	if(!defined $res[0]) {
		die "No se encontro SourceLink para Organization=$_[1]";
	}
	return $res[0];
}

=head2 funcion addSite()


	$_[0] => database connection handler
	$_[1] => parameters HASH [valid params=  "Organization"=>"STRING"*,"RequestName"=>"STRING"*,"method"=>"STRING"       *:required
	$_[2] => options ARRAY [valid opts -U]  ]
	
=head3 returns

 	{"status":"200 OK","SiteID":"$inserted_site_id"} o {"status":"400 Bad Request"}

=cut

sub addSite {
	my %validColumns = ("SiteCode"=>"STRING","SiteName"=>"STRING","Latitude"=>"FLOAT","Longitude"=>"FLOAT","Elevation_m"=>"FLOAT","SiteType"=>"STRING","State"=>"STRING","County"=>"STRING","Comments"=>"STRING","Country"=>"STRING");
	#~ my %validColumns  =  map { $_ => 1 } @validColumns;
	my %requiredColumns = ("SiteCode"=>"STRING","SiteName"=>"STRING","Latitude"=>"FLOAT","Longitude"=>"FLOAT");
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
	#~ foreach(keys %types) {       ### PARA DEBUGGING
		#~ print STDERR "-------types{$_}=".$types{$_}. ".\n"; 
	#~ }
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
		#~ print STDERR "TYPECHECK: $key," . $types{$key} . ", value: " . $_[1]->{$key} ."\n"; ### PARA DEBUGGING
	}
	chop $varstr;
	chop $valstr;
	chop $updstr;
	my $onConflictAction="do nothing";
	if(defined $opts{"-U"}) {
		$onConflictAction="do update set $updstr";
	}
	my $stmt =qq(insert into "Sites" ($varstr) values ($valstr) on conflict (\"SiteCode\") $onConflictAction returning "SiteID");
	#~ my $stmt =qq(select $valstr);
	#~ print STDERR "$stmt\n"; 
	my $sth=$_[0]->prepare($stmt);
	my $rv=$sth->execute or die $_[0]->errstr;
	my $res = $sth->fetchrow_hashref;   #[0]->do($stmt) or die $_[0]->errstr;
	#~ my $res = $sth->fetchrow_arrayref;
	#~ for(my $i=0;$i<@$res;$i++) {
		#~ print $res->[$i] . ",";
	#~ }
	#~ print "\n";
	#~ exit;
	if(defined $res->{SiteID}) {
		return "{\"status\":\"200 OK\",\"SiteID\":" . $res->{SiteID} . "}";
	} else {
		return "{\"status\":\"400 Bad Request\"}";
	}
	#~ print $stmt . "\n";
	#~ return 1;
}

=head2 funcion addSites()


	$_[0] => database connection handler
	$_[1] => sites ARRAY  
	$_[2] => options ARRAY [valid opts -U]  ]
	
=head3 returns

 	{"status":"200 OK","SiteID":"$inserted_site_ids"} o {"status":"400 Bad Request"}

=cut

sub addSites {
	my %validColumns = ("SiteCode"=>"STRING","SiteName"=>"STRING","Latitude"=>"FLOAT","Longitude"=>"FLOAT","Elevation_m"=>"FLOAT","SiteType"=>"STRING","State"=>"STRING","County"=>"STRING","Comments"=>"STRING","Country"=>"STRING");
	#~ my %validColumns  =  map { $_ => 1 } @validColumns;
	my %requiredColumns = ("SiteCode"=>"STRING","SiteName"=>"STRING","Latitude"=>"FLOAT","Longitude"=>"FLOAT");
	#~ my @ColumnsTypes = ("STRING","STRING","INTEGER","STRING","STRING","BOOLEAN","STRING","STRING"); 
	#~ my @requiredColumnsTypes = ("STRING","STRING","INTEGER");
	if(!defined $_[1]) {
		die "Falta sites";
	}
	if(ref($_[1]) ne 'ARRAY') {
		die "\$_[1] debe ser ARRAY ref, pero es" . ref($_[1]) . ".";
	}
	#
	# LEE OPCIONES
	#
	my %opts= map { $_ => 1 } @{$_[2]};
	#
	#   ITERA sites   #
	#
	for(my $i=0;$i<@{$_[1]};$i++) {
		# CHEQUEA COLUMNAS OBLIGATORIAS
		columnTypeCheck(\%requiredColumns,$_[1]->[$i],1);
		my %types=columnTypeCheck(\%validColumns,$_[1]->[$i],2);
		#~ foreach(keys %types) {       ### PARA DEBUGGING
			#~ print STDERR "-------types{$_}=".$types{$_}. ".\n"; 
		#~ }
	#
	# CREA SENTENCIA DE INSERCION ITERANDO $_[1]->[$i] y CHEQUEANDO KEYS Y TIPOS   #
	#
		my $varstr="";
		my $valstr="";
		my $updstr="";
		foreach my $key (keys %{$_[1]->[$i]}) {
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
			#~ print STDERR "TYPECHECK: $key," . $types{$key} . ", value: " . $_[1]->{$key} ."\n"; ### PARA DEBUGGING
		}
		chop $varstr;
		chop $valstr;
		chop $updstr;
		my $onConflictAction="do nothing";
		if(defined $opts{"-U"}) {
			$onConflictAction="do update set $updstr";
		}
		my $stmt =qq(insert into "Sites" ($varstr) values ($valstr) on conflict (\"SiteCode\") $onConflictAction returning "SiteID");
		#~ my $stmt =qq(select $valstr);
		#~ print STDERR "$stmt\n"; 
		my $sth=$_[0]->prepare($stmt);
		my $rv=$sth->execute or die $_[0]->errstr;
		my $res = $sth->fetchrow_hashref;   #[0]->do($stmt) or die $_[0]->errstr;
		#~ my $res = $sth->fetchrow_arrayref;
		#~ for(my $i=0;$i<@$res;$i++) {
			#~ print $res->[$i] . ",";
		#~ }
		#~ print "\n";
		#~ exit;
		if(defined $res->{SiteID}) {
			return "{\"status\":\"200 OK\",\"SiteID\":" . $res->{SiteID} . "}";
		} else {
			return "{\"status\":\"400 Bad Request\"}";
		}
		#~ print $stmt . "\n";
		#~ return 1;
	}
}


=head2 funcion GetSites

	$_[0] => database connection handler
	$_[1] => parameters HASH [valid params=  "SiteID"=>"INTEGER","SiteCode"=>"STRING","SiteName"=>"STRING","north"=>"FLOAT","south"=>"FLOAT","east"=>"FLOAT","west"=>"FLOAT","SiteType"=>"STRING","State"=>"STRING","County"=>"STRING"]
	$_[2] => options ARRAY [valid opts -f]  ]
	
=head3 returns

 	siteResponse STRING in requested format  or {"status":"400 Bad Request"}

=cut

sub GetSites {
	
	my %validColumns = ("SiteID"=>"INTEGER","SiteCode"=>"STRING","SiteName"=>"STRING","north"=>"FLOAT","south"=>"FLOAT","east"=>"FLOAT","west"=>"FLOAT","SiteType"=>"STRING","State"=>"STRING","County"=>"STRING");
		# crea filtro SQL iterando parametros #
	my %types; 
	my $filter="";
	if(defined $_[1]) {
		if(ref($_[1]) ne "HASH") {
			die "\$_[1] debe ser HASHREF, pero es" . ref($_[1]) . ".";
		}
		%types=columnTypeCheck(\%validColumns,$_[1],2);
		foreach my $key (keys %{$_[1]}) {
			if($types{$key} eq "STRING") {
				$filter.= " and \"Sites\".\"". $key . "\"='" . $_[1]->{$key} . "'";
			} elsif ($key eq "east") {
				$filter .= " and \"Sites\".\"Longitude\"<=" . $_[1]->{$key};
			} elsif ($key eq "north") { 
				$filter .= " and \"Sites\".\"Latitude\"<=" . $_[1]->{$key};
			}elsif ($key eq "west") {
				$filter .= " and \"Sites\".\"Longitude\">=" . $_[1]->{$key};
			} elsif ($key eq "south") {
				$filter .= " and \"Sites\".\"Latitude\">=" . $_[1]->{$key};
			} else {
				$filter.= " and \"Sites\".\"". $key . "\"=" . $_[1]->{$key};
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
			$stmt = "select xmlelement(name \"GetSitesResponse\",xmlattributes('http://www.cuahsi.org/waterML/1.1/' as \"xmlns:sr\", 'http://www.w3.org/2001/XMLSchema-instance' as \"xmlns:xsi\"),xmlagg(\"SiteInfoXML\")) from \"SiteInfoXML\",\"Sites\" where \"Sites\".\"SiteID\"=\"SiteInfoXML\".\"SiteID\" $filter";
			#~ print STDERR "STATEMENT: $stmt\n";
		} else {
			die "Formato $format incorrecto. opciones: wml json fwt csv\n";
		}
	}
	my $sth = $_[0]->prepare($stmt);
	$sth->execute() or die $_[0]->errstr;
	my @res = $sth->fetchrow_array;
	if(defined $res[0]) {
		return "$res[0]";
	} else {
		return "{\"status\":\"400 Bad Request\"}";
	}
	# Content-Type: text/xml; charset=utf-8\n\r\n\n
	#~ return "$res[0]"; 	
}

=head2 funcion GetSiteInfo()

	$_[0] => database connection handler
	$_[1] => parameters HASH [valid params=  "SiteCode"=>"STRING"]
	$_[2] => options ARRAY [valid opts -f]  ]
	
=head3 returns

 	SitesResponse STRING in requested format  or {"status":"400 Bad Request"}


=cut

sub GetSiteInfo {
	
	my %validColumns = ("SiteCode"=>"STRING");
	my %requiredColumns = ("SiteCode"=>"STRING");
		# crea filtro SQL iterando parametros #
	my %types; 
	my $filter="";
	if(defined $_[1]) {
		if(ref($_[1]) ne "HASH") {
			die "\$_[1] debe ser HASHREF, pero es" . ref($_[1]) . ".";
		}
	} else {
		die "";
	}
	#
	#   CHEQUEA COLUMNAS OBLIGATORIAS   #
	#
	columnTypeCheck(\%requiredColumns,$_[1],1);
	%types=columnTypeCheck(\%validColumns,$_[1],2);
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
			$stmt = "select xmlelement(name \"GetSiteInfoResponse\",xmlattributes('http://www.cuahsi.org/waterML/1.1/' as \"xmlns:sr\", 'http://www.w3.org/2001/XMLSchema-instance' as \"xmlns:xsi\"),\"SitesWithSeriesCatalogXML\".site) from \"SitesWithSeriesCatalogXML\",\"Sites\" where \"Sites\".\"SiteID\"=\"SitesWithSeriesCatalogXML\".\"SiteID\" and \"Sites\".\"SiteCode\"='" . $_[1]->{SiteCode} . "'";
			#~ print STDERR "STATEMENT: $stmt\n";
		} else {
			die "Formato $format incorrecto. opciones: wml json fwt csv\n";
		}
	}
	my $sth = $_[0]->prepare($stmt);
	$sth->execute() or die $_[0]->errstr;
	my @res = $sth->fetchrow_array;
	if(defined $res[0]) {
		return "$res[0]";
	} else {
		return "{\"status\":\"400 Bad Request\"}";
	}
}

=head2 funcion addValues


	$_[0] => database connection handler
	$_[1] => parameters HASH [valid params=  "Values"=>"ARRAY"*,"SiteID"=>"INTEGER"*,"VariableID"=>"INTEGER"*,"MethodID"=>"INTEGER","SourceID"=>"INTEGER"*,"QualityControl"=>"INTEGER","UTCOffset"=>"INTEGER"]    *:required
	$_[2] => options ARRAY [valid opts -U]  ]
	
=head3 returns

 	{"status":"200 OK","ValuesID":[valueID_1,ValuesID2...]}  or {"status":"400 Bad Request"}


=cut

sub addValues {
	my %validColumns = ("Values"=>"ARRAY","SiteID"=>"INTEGER","VariableID"=>"INTEGER","MethodID"=>"INTEGER","SourceID"=>"INTEGER","QualityControl"=>"INTEGER","UTCOffset"=>"INTEGER");
	#~ my %validColumns  =  map { $_ => 1 } @validColumns;
	my %requiredColumns = ("Values"=>"ARRAY","SiteID"=>"INTEGER","VariableID"=>"INTEGER","SourceID"=>"INTEGER");
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
	#~ foreach(keys %types) {       ### PARA DEBUGGING
		#~ print STDERR "-------types{$_}=".$types{$_}. ".\n"; 
	#~ }
	$_[1]->{UTCOffset} = (!defined $_[1]->{UTCOffset}) ? -3 : $_[1]->{UTCOffset};
	#
	# CREA SENTENCIA DE INSERCION ITERANDO $_[1] y CHEQUEANDO KEYS Y TIPOS   #
	#
	my $varstr="";
	my $fixedvalstr="";
	my $valstr="";
	#~ my $fixedupdstr="";
	#~ my $updstr="";
	my @values = @{$_[1]->{Values}};
	if(@values<=0) {
		die "El elemento Values está vacío";
	}
	delete $_[1]->{Values};
	foreach my $key (keys %{$_[1]}) {
		#~ my ($index) = grep { $validColumns[$_] eq $key } 0..$#validColumns;
		$varstr.= "\"" . $key . "\",";
		#~ $updstr.= "\"" . $key . "\"=";
		#~ if($ColumnsTypes[$index] eq "STRING") {
		if($types{$key} eq "STRING") {
			$fixedvalstr.= "'" . $_[1]->{$key} . "',";
			#~ $updstr .= "'" . $_[1]->{$key} . "',";
		} else {
			$fixedvalstr.= $_[1]->{$key} . ",";
			#~ $updstr .= $_[1]->{$key} . ",";
		}
		#~ print STDERR "TYPECHECK: $key," . $types{$key} . ", value: " . $_[1]->{$key} ."\n"; ### PARA DEBUGGING
	}
	$varstr .= "\"LocalDateTime\",\"DateTimeUTC\",\"DataValue\"";
	foreach my $reg (@values) {
		if(@$reg < 2) {
			die "elemento Values incorrecto. Debe ser una matriz de N x 2";
		}
		$valstr .= "($fixedvalstr '" . $reg->[0] . "'::timestamp+'" . $_[1]->{UTCOffset} . " hours'::interval, '" . $reg->[0] . "'::timestamp, " . $reg->[1] . "),";
	}
	#~ chop $varstr;
	chop $valstr;
	#~ chop $updstr;
	#~ my $onConflictAction="do nothing";
	#~ if(defined $opts{"-U"}) {
		#~ $onConflictAction="do update set $updstr";
	#~ }
	my $stmt =qq(insert into "DataValues" ($varstr) values $valstr on conflict do nothing returning "ValueID");
	#~ my $stmt =qq(select $valstr);
	#~ print STDERR "$stmt\n"; exit;
	my $sth=$_[0]->prepare($stmt);
	my $rv=$sth->execute or die $_[0]->errstr;
	my @res;
	while(my $row=$sth->fetchrow_hashref) {
		push @res, $row->{ValueID};
	}
	my $res = encode_json \@res;
	if(@res > 0) {
		return "{\"status\":\"200 OK\",\"SiteID\":" . $res . "}";
	} else {
		return "{\"status\":\"400 Bad Request\"}";
	}
	#~ print $stmt . "\n";
	#~ return 1;
}

=head2 funcion GetValues


	$_[0] => database connection handler
	$_[1] => parameters HASH [valid params=  "SiteCode"=>"STRING"*,"VariableCode"=>"STRING"*,"StartDate"=>"STRING"*,"EndDate"=>"STRING"*]    *:required
	$_[2] => options ARRAY [valid opts -f]  ]
	
=head3 returns

 	timeSeriesResponse STRING in required format  or {"status":"400 Bad Request"}


=cut

sub GetValues {
	
	my %validColumns = ("SiteCode"=>"STRING","VariableCode"=>"STRING","StartDate"=>"STRING","EndDate"=>"STRING");
	my %requiredColumns = ("SiteCode"=>"STRING","VariableCode"=>"STRING","StartDate"=>"STRING","EndDate"=>"STRING");
		# crea filtro SQL iterando parametros #
	my %types; 
	my $filter="";
	if(defined $_[1]) {
		if(ref($_[1]) ne "HASH") {
			die "\$_[1] debe ser HASHREF, pero es" . ref($_[1]) . ".";
		}
		%types=columnTypeCheck(\%validColumns,$_[1],2);
		foreach my $key (keys %{$_[1]}) {
			switch($key) {
				case "site" {
					$_[1]->{SiteCode} = $_[1]->{$key};
					delete $_[1]->{$key};
				} case "variable" {
					$_[1]->{VariableCode} = $_[1]->{$key};
					delete $_[1]->{$key};
				} case "startDate" {
					$_[1]->{StartDate} = $_[1]->{$key};
					delete $_[1]->{$key};
				} case "endDate" {
					$_[1]->{EndDate} = $_[1]->{$key};
					delete $_[1]->{$key};
				} 
			}
		}
	}
	#
	#   CHEQUEA COLUMNAS OBLIGATORIAS   #
	#
	columnTypeCheck(\%requiredColumns,$_[1],1);
	%types=columnTypeCheck(\%validColumns,$_[1],2);
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
			$stmt = "with a as (
   select 
    xmlelement(name \"queryInfo\",
                xmlelement(name \"creationTime\",current_timestamp),
                xmlelement(name \"queryURL\",'$query_string'),
                xmlelement(name \"criteria\",
                   xmlattributes('getValues' as \"methodCalled\"),
                   xmlelement(name \"locationParam\",'" . $_[1]->{SiteCode} . "'),
                   xmlelement(name \"variableParam\",'" . $_[1]->{VariableCode} . "'),
                   xmlelement(name \"timeParam\",
                       xmlelement(name \"beginDateTime\",'" . $_[1]->{StartDate} . "'),
                       xmlelement(name \"endDateTime\",'" . $_[1]->{EndDate} . "')
                       )
                   )
               ) as query_info,
      \"SiteInfoXML\".\"SiteInfoXML\" as site_info,
      \"VariableInfoXML\".\"VariableInfoXML\" as variable
    from \"Sites\",\"Variables\",\"SiteInfoXML\",\"VariableInfoXML\"
    where \"Sites\".\"SiteID\"=\"SiteInfoXML\".\"SiteID\"
    and \"Sites\".\"SiteCode\"='" . $_[1]->{SiteCode} . "'
    and \"Variables\".\"VariableID\"=\"VariableInfoXML\".\"VariableID\"
    and \"Variables\".\"VariableCode\"='" . $_[1]->{VariableCode} . "'
     limit 1
    ),
  b as (
   select min(\"UnitsID\") unit_id,
          xmlagg(\"ValueXML\") as values
   from (select \"Units\".\"UnitsID\",
                \"ValueXML\" 
         from \"Units\",\"ValuesXML\",\"DataValues\",\"UnitsXML\",\"Variables\",\"Sites\"
         where \"Sites\".\"SiteCode\"='" . $_[1]->{SiteCode} . "' 
         and \"Variables\".\"VariableCode\"='" . $_[1]->{VariableCode} . "' 
         and \"DataValues\".\"LocalDateTime\">='" . $_[1]->{StartDate} . "'
         and \"DataValues\".\"LocalDateTime\"<='" . $_[1]->{EndDate} ."'
         and \"DataValues\".\"ValueID\"=\"ValuesXML\".\"ValueID\" 
         and \"Units\".\"UnitsID\"=\"UnitsXML\".\"UnitsID\"
         and \"Units\".\"UnitsID\"=\"Variables\".\"VariableUnitsID\"
         and \"Variables\".\"VariableID\"=\"DataValues\".\"VariableID\"
         and \"Sites\".\"SiteID\"=\"DataValues\".\"SiteID\"
         ) values_xml 
    )
select xmlelement(name \"GetValuesResponse\",
                  xmlattributes('http://www.cuahsi.org/waterML/1.1/' as \"xmlns:sr\", 'http://www.w3.org/2001/XMLSchema-instance' as \"xmlns:xsi\"),
                  a.query_info,
                  xmlelement(name \"sr:timeSeries\",a.site_info,a.variable,xmlelement(name values,coalesce(b.values,''),coalesce(\"UnitsXML\".\"UnitsXML\",'')))
                  )
  from a 
       left join b on (a.query_info is not null) 
       left join \"UnitsXML\" on (b.unit_id=\"UnitsXML\".\"UnitsID\")";
			#~ print STDERR "STATEMENT: $stmt\n";
		} else {
			die "Formato $format incorrecto. opciones: wml json fwt csv\n";
		}
	}
	my $sth = $_[0]->prepare($stmt);
	$sth->execute() or die $_[0]->errstr;
	my @res = $sth->fetchrow_array;
	if(defined $res[0]) {
		return "$res[0]";
	} else {
		return "{\"status\":\"400 Bad Request\"}";
	}
}

=head2 funcion parseWML()

	$_[0] => database connection handler
	$_[1] => parameters  input=WMLSTRING* o file=FILENAME* , source=STRING* 
	$_[2] => options ARRAY [valid opts -f]  ]
	
=head3 returns

 	200 Ok or 400 Bad Request ; STRING in required format  si se indica -f wml,json,fwt,csv
=cut

sub parseWML
{
	my $str;
	if(ref($_[1]) ne "HASH") {
		die "\$_[1] debe ser un HASH\n";
	}
	if(defined $_[1]->{input}) {
		$str=$_[1]->{input};
	} elsif(defined $_[1]->{file}) {
		open(my $file,$_[1]->{file}) or die "No se pudo abrir el archivo " . $_[1]->{file} . " para lectura\n";
		while(<$file>) 
		{
			$str .= $_;
		}
	} else {
		die "Falta parametro input o file\n";
	}
	if(!defined $_[1]->{source}) {
		die "Falta parametro source\n";
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
	#~ print STDERR $str . "\n";
	my $data;
	eval {
		$data = XML::LibXML->load_xml(string=>$str);
	} or do {
		die "No se pudo parsear la respuesta pues no es XML valido\n";
	};
	my $format = (defined $opts{f}) ? $opts{f} : "pg";
	if($data->exists('//variables')) {
		my $allres = "";
		#~ print STDERR "variables Exists\n";
		my @variables = $data->find('//variables')->[0]->childNodes();
		#~ if(@variables > 0) {
		my $n=0;
		foreach my $var (@variables) {
			my $literal = $var->to_literal;
			print STDERR "varnum:$n,literal:$literal\n";
			my %params;
			my %validColumns = ("variableCode"=>"STRING","variableName"=>"STRING","variableDescription"=>"STRING", "unitsName"=>"STRING", "unitsType"=>"STRING","sampleMedium"=>"STRING","valueType"=>"STRING","isRegular"=>"BOOLEAN","dataType"=>"STRING", "generalCategory"=>"STRING","timeSupport"=>"INTEGER","timeUnitsID"=>"INTEGER");
			foreach my $key (keys %validColumns) {
				my $xpath=($key =~ /units/) ? ( "./unit/" . $key . "[1]" ) : "./" . $key . "[1]";
				if($var->exists($xpath)) {
					my $node = $var->findnodes($xpath)->[0];
					my $val = $node->textContent;
					$params{$key} = ($key eq "variableCode") ? $_[1]->{source} . ":" .  $val : $val;
					#~ print STDERR "varnum:$n;key:$key, val:$val\n";
				}
			}
			if($format eq "pg") {
				if(defined $params{variableCode} and defined $params{variableName} and defined $params{unitsName} and defined  $params{unitsType}) { 
					my %upperparams = map { ucfirst($_) => $params{$_} } keys %params;
					my $UnitsID = odm_load::GetUnitsID($_[0],\%upperparams);
					#~ print STDERR "unitsID:$UnitsID, variableName:" . $upperparams{VariableName} . "\n";
					#~ next;
					$upperparams{VariableUnitsID}=$UnitsID;
					delete $upperparams{UnitsName};
					delete $upperparams{UnitsType};
					delete $upperparams{VariableDescription};
					my @opts=("-U");
					my $res = odm_load::addVariable($_[0],\%upperparams,\@opts);
					$allres .= $res;
				}
			}
			$n++;
		}
		if($allres eq "") { 
			print STDERR "No se encontraron registros\n";
			return 1;
		} else {
			return $allres . "\n";
		} 
	}
}

=head2 funcion GetUnitsID()

	$_[0] => database connection handler
	$_[1] => parameters  UnitsName=STRING* UnitsType=STRING* 
	
=head3 returns

 	UnitsID INTEGER   or 349

=cut

sub GetUnitsID
{
	if(ref($_[1]) ne "HASH") {
		die "\$_[1] debe ser un HASH\n";
	}
	if(!defined $_[1]->{UnitsName} or !defined $_[1]->{UnitsType}) {
		die "Falte UnitsName o UnitsType\n";
	}
	my $sth = $_[0]->prepare(qq(select "UnitsID" from "Units" where "UnitsName"=') . $_[1]->{UnitsName} . qq(' and "UnitsType"=') . $_[1]->{UnitsType} . qq(' limit 1));
	$sth->execute() or die $_[0]->errstr;
	my @res = $sth->fetchrow_array;
	if(defined $res[0]) {
		return $res[0];
	} else {
		return 349;
	}
}


=head2 funcion addSeries()


	$_[0] => database connection handler
	$_[1] => parameters HASH [valid params=  "SiteCode"=>"STRING"*,"VariableCode"=>"STRING"*,"SourceCode"=>"STRING"*,"MethodCode"=>"STRING","MethodDescription"=>"STRING","MethodLink"=>"STRING","Organization"=>"STRING","SourceDescription"=>"STRING","citation"=>"STRING","qualityControlLevelCode"=>"STRING","qualityControlLevelDefinition"=>"STRING","valueCount"=>"INTEGER","beginDateTime"=>"STRING","endDateTime"=>"STRING","beginDateTimeUTC"=>"STRING","endDateTimeUTC"=>"STRING"       *:required
	$_[2] => options ARRAY [valid opts -U]  ]
	
=head3 returns

 	{"status":"200 OK","SiteID":"$inserted_series_id"} o {"status":"400 Bad Request"}

=cut

sub addSeries {
	my %validColumns = ("SiteCode"=>"STRING","VariableCode"=>"STRING","MethodCode"=>"STRING","SourceID"=>"STRING","SourceCode"=>"STRING","MethodDescription"=>"STRING","MethodLink"=>"STRING","Organization"=>"STRING","SourceDescription"=>"STRING","Citation"=>"STRING","QualityControlLevelCode"=>"STRING","QualityControlLevelDefinition"=>"STRING","ValueCount"=>"INTEGER","BeginDateTime"=>"STRING","EndDateTime"=>"STRING","BeginDateTimeUTC"=>"STRING","EndDateTimeUTC"=>"STRING");
	my %requiredColumns = ("SiteCode"=>"STRING","VariableCode"=>"STRING","SourceCode"=>"STRING");
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
	my $SourceCode=$_[1]->{SourceCode};
	#
	# CREA SENTENCIA DE INSERCion   #
	#
	my $varstr="\"SiteCode\",\"SiteID\",\"SiteName\",\"SiteType\",\"VariableCode\",\"VariableID\",\"VariableName\",\"Speciation\",\"VariableUnitsID\",\"VariableUnitsName\",\"SampleMedium\",\"ValueType\",\"TimeSupport\",\"TimeUnitsID\",\"TimeUnitsName\",\"DataType\",\"GeneralCategory\",";
	my $valstr="'$_[1]->{SiteCode}',\"Sites\".\"SiteID\",\"Sites\".\"SiteName\",\"Sites\".\"SiteType\",'$_[1]->{VariableCode}',\"Variables\".\"VariableID\",\"Variables\".\"VariableName\",\"Variables\".\"Speciation\",\"Variables\".\"VariableUnitsID\",\"Units\".\"UnitsName\",\"Variables\".\"SampleMedium\",\"Variables\".\"ValueType\",\"Variables\".\"TimeSupport\",\"Variables\".\"TimeUnitsID\",timeunits.\"UnitsName\",\"Variables\".\"DataType\",\"Variables\".\"GeneralCategory\",";
	my $updstr="";
	foreach my $key ("ValueCount","BeginDateTime","EndDateTime","BeginDateTimeUTC","EndDateTimeUTC") {
		if(defined $_[1]->{$key}) {
			$varstr.="\"$key\",";
			if($validColumns{$key} eq "STRING") {
				$valstr.="'$_[1]->{$key}',";
				$updstr.="\"$key\"='$_[1]->{$key}',";
			} else {
				$valstr .="$_[1]->{$key},";
				$updstr.="\"$key\"=$_[1]->{$key},";
			}
		}
	}
	#
	#  BUSCA MethodID e inserta registro si no existe
	my ($MethodID,$MethodDescription,$MethodLink,$MethodCode);
	if(defined $_[1]->{MethodCode}) {
		#~ my $filter = (defined $_[1]->{MethodDescription}) ? (" and \"MethodDescription\"='" . $_[1]->{MethodDescription} . "'") : "";
		#~ $filter .= (defined $_[1]->{MethodLink}) ? (" and \"MethodLink\"='" . $_[1]->{MethodLink} . "'") : "";
		#~ my $sth=$_[0]->prepare(qq(select "MethodCode","MethodID","MethodDescription","MethodLink" from "Methods" where "MethodCode"=') .  $_[1]->{MethodCode} . "'" . $filter);
		my $sth=$_[0]->prepare(qq(select "MethodCode","MethodID","MethodDescription","MethodLink" from "Methods" where "MethodCode"='$SourceCode:) .  $_[1]->{MethodCode} . "'");
		my $rv=$sth->execute or die $_[0]->errstr;
		my $res = $sth->fetchrow_hashref;
		if(defined $res->{MethodID}) {
			$MethodCode=$res->{MethodCode};
			$MethodID=$res->{MethodID};
			$MethodDescription = $res->{MethodDescription};
			$MethodLink = $res->{MethodLink};
		} else {
			$MethodCode="$SourceCode:" . $_[1]->{MethodCode};
			$MethodDescription = (defined $_[1]->{MethodDescription}) ? $_[1]->{MethodDescription} : "No description";
			$MethodLink = (defined $_[1]->{MethodLink}) ? $_[1]->{MethodLink}  : "";
			$sth=$_[0]->prepare(qq(insert into "Methods" ("MethodCode","MethodDescription","MethodLink") values ('$MethodCode','$MethodDescription','$MethodLink') returning "MethodID"));
			$rv=$sth->execute or die $_[0]->errstr;
			my $res=$sth->fetchrow_hashref;
			if(defined $res->{MethodID}) {
				$MethodID=$res->{MethodID};
			} else {
				die "Error al insertar Method";
			}
		}
		print STDERR "MethodID:$MethodID\n";
		$varstr.="\"MethodID\",\"MethodDescription\",";
		$valstr.="$MethodID,'$MethodDescription',";
		$updstr.="\"MethodID\"=$MethodID,\"MethodDescription\"='$MethodDescription',";
	}
	#
	# Busca SourceID e inserta registro si no existe
	my ($SourceID,$Organization,$SourceDescription,$citation);
	if(defined $_[1]->{SourceID}) {
		#~ my $filter = (defined $_[1]->{SourceDescription}) ? " and \"SourceDescription\"='" . $_[1]->{SourceDescription} . "'" : ""; 
		#~ my $sth=$_[0]->prepare(qq(select "SourceID","Organization","SourceDescription","Citation" from "Sources" where "Organization"=') .  $_[1]->{Organization} . "'" . $filter);
		my $sth=$_[0]->prepare(qq(select "SourceID","Organization","SourceDescription","Citation" from "Sources" where "SourceCode"='$SourceCode:) .  $_[1]->{SourceID} . "'");
		my $rv=$sth->execute or die $_[0]->errstr;
		my $res = $sth->fetchrow_hashref;
		if(defined $res->{SourceID}) {
			$SourceID=$res->{SourceID};
			$SourceDescription=$res->{SourceDescription};
			$Organization = $res->{Organization};
			$citation = $res->{Citation};
		} else {
			$Organization = $_[1]->{Organization};
			$SourceDescription = (defined $_[1]->{SourceDescription}) ? $_[1]->{SourceDescription} : "No description";
			$citation = (defined $_[1]->{citation}) ? $_[1]->{citation}  : "";
			$sth=$_[0]->prepare(qq(insert into "Sources" ("SourceCode","Organization","SourceDescription","Citation") values ('$SourceCode:$SourceID','$Organization','$SourceDescription','$citation') returning "SourceID"));
			$rv=$sth->execute or die $_[0]->errstr;
			my $res = $sth->fetchrow_hashref;
			if(defined $res->{SourceID}) {
				$SourceID=$res->{SourceID};
			} else {
				die "Error al insertar Source";
			}
		}
		print STDERR "SourceID:$SourceID\n";
		$varstr.="\"SourceID\",\"Organization\",\"SourceDescription\",\"Citation\",";
		$valstr.="$SourceID,'$Organization','$SourceDescription','$citation',";
		$updstr.="\"SourceID\"=$SourceID,\"Organization\"='$Organization',\"SourceDescription\"='$SourceDescription',\"Citation\"='$citation',";
	}	
	# Busca QualityControlLevelID e inserta registro si no existe
	my ($QualityControlLevelID,$QualityControlLevelCode,$Definition,$Explanation);
	if(defined $_[1]->{QualityControlLevelCode}) {
		my $filter = (defined $_[1]->{QualityControlLevelDefinition}) ? " and \"Definition\"='" . $_[1]->{QualityControlLevelDefinition} . "'" : ""; 
		my $sth=$_[0]->prepare(qq(select "QualityControlLevelCode","QualityControlLevelID","Definition","Explanation" from "QualityControlLevels" where "QualityControlLevelCode"=') .  $_[1]->{QualityControlLevelCode} . "'" . $filter);
		my $rv=$sth->execute or die $_[0]->errstr;
		my $res = $sth->fetchrow_hashref;
		if(defined $res->{QualityControlLevelID}) {
			$QualityControlLevelCode=$res->{QualityControlLevelCode};
			$QualityControlLevelID=$res->{QualityControlLevelID};
			$Definition=$res->{Definition};
			$Explanation = $res->{Explanation};
		} else {
			$QualityControlLevelCode = $_[1]->{QualityControlLevelCode};
			$Definition = (defined $_[1]->{QualityControlLevelDefinition}) ? $_[1]->{QualityControlLevelDefinition} : "No definition";
			$Explanation = (defined $_[1]->{QualityControlLevelExplanation}) ? $_[1]->{QualityControlLevelExplanation}  : "No explanation";
			$sth=$_[0]->prepare(qq(insert into "QualityControlLevels" ("QualityControlLevelCode","Definition","Explanation") values ('$QualityControlLevelCode','$Definition','$Explanation') returning "QualityControlLevelID"));
			$rv=$sth->execute or die $_[0]->errstr;
			my $res = $sth->fetchrow_hashref;
			if(defined $res->{QualityControlLevelID}) {
				$QualityControlLevelID=$res->{QualityControlLevelID};
			} else {
				die "Error al insertar QualityControlLevel";
			}
		}
		$varstr.="\"QualityControlLevelID\",\"QualityControlLevelCode\",";
		$valstr.="$QualityControlLevelID,'$QualityControlLevelCode',";
		$updstr.="\"QualityControlLevelID\"=$QualityControlLevelID,\"QualityControlLevelCode\"='$QualityControlLevelCode',";
	}	

	chop $varstr;
	chop $valstr;
	chop $updstr;
	# ON CONFLICT CLAUSE #
	my $onConflictAction="do nothing";
	if(defined $opts{"-U"}) {
		$onConflictAction="do update set $updstr";
	}
	my $stmt =qq(insert into "SeriesCatalog" ($varstr) select $valstr from "Sites","Variables","Units",(select * from "Units") timeunits  where "Sites"."SiteCode"=') . $_[1]->{SiteCode} . qq(' and "Variables"."VariableCode"=') . $_[1]->{VariableCode} . qq(' and "Units"."UnitsID"="Variables"."VariableUnitsID" and timeunits."UnitsID"="Variables"."TimeUnitsID" on conflict ("SiteID", "VariableID") $onConflictAction returning "SeriesID");
	#~ print STDERR "$stmt\n"; 
	my $sth=$_[0]->prepare($stmt);
	my $rv=$sth->execute or die $_[0]->errstr;
	my $res = $sth->fetchrow_hashref;   #[0]->do($stmt) or die $_[0]->errstr;
	#~ my $res = $sth->fetchrow_arrayref;
	#~ for(my $i=0;$i<@$res;$i++) {
		#~ print $res->[$i] . ",";
	#~ }
	#~ print "\n";
	#~ exit;
	if(defined $res->{SeriesID}) {
		return "{\"status\":\"200 OK\",\"SeriesID\":" . $res->{SeriesID} . "}";
	} else {
		return "{\"status\":\"400 Bad Request\"}";
	}
	#~ print $stmt . "\n";
	#~ return 1;
}


=head2 funcion insertDataValues


	$_[0] => database connection handler
	$_[1] => TimeSeries ARRAY of HASHES
	$_[2] => SiteCode varchar
	$_[3] => VariableCode varchar
	$_[4] => SourceCode varchar
	$_[5] => options ARRAY [valid opts -U]  ]
	
=head3 returns

 	{"status":"200 OK","ValuesID":[valueID_1,ValuesID2...]}  or {"status":"400 Bad Request"}


=cut

sub insertDataValues {
	my %validColumns = ("time"=>"STRING","DataValue"=>"FLOAT","UTCOffset"=>"INTEGER","Qualifier"=>"STRING","MethodCode"=>"STRING","SourceCode"=>"INTEGER","QualityControlLevelCode");
	#~ my %validColumns  =  map { $_ => 1 } @validColumns;
	my %requiredColumns = ("time"=>"STRING","DataValues"=>"FLOAT");
	columnTypeCheck((SiteCode=>"STRING", VariableCode=>"STRING"),(SiteCode=>$_[2], VariableCode=>$_[3]),1);  
	if(!defined $_[1]) {
		die "Falta TimeSeries";
	}
	if(ref($_[1]) ne 'ARRAY') {
		die "\$_[1] debe ser ARRAYREF, pero es" . ref($_[1]) . ".";
	}
	if(!defined $_[2]) {
		die "Falta SiteCode";
	}
	if(!defined $_[3]) {
		die "Falta VariableCode";
	}
	my $SourceCode = (!defined $_[4]) ? "Unknown" : $_[4];
	#
	# LEE OPCIONES
	#
	my %opts= map { $_ => 1 } @{$_[5]};
	#
	# INICIALIZA VALSTR
	my $valstr="";	
	#   ITERA TimeSeries   #
	#
	for(my $i=0;$i<@{$_[1]};$i++) {
		#   CHEQUEA COLUMNAS OBLIGATORIAS   #
		columnTypeCheck(\%requiredColumns,$_[1]->[$i],1);
		my %types=columnTypeCheck(\%validColumns,$_[1]->[$i],2);
		#~ foreach(keys %types) {       ### PARA DEBUGGING
			#~ print STDERR "-------types{$_}=".$types{$_}. ".\n"; 
		#~ }
		$_[1]->[$i]->{UTCOffset} = (!defined $_[1]->[$i]->{UTCOffset}) ? -3 : $_[1]->[$i]->{UTCOffset};
		$valstr .= "(" . $_[1]->[$i]->{time} . "'::timestamp+'" . $_[1]->{$i}->{UTCOffset} . " hours'::interval, '" . $_[1]->[$i]->{time} . "'::timestamp, " . $_[1]->[$i]->{DataValue} . "," . $_[1]->[$i]->{UTCOffset} . "," . ((defined $_[1]->{$i}->{Qualifier}) ? qq('$SourceCode:$_[1]->{$i}->{Qualifier}') : "null") . "," . ((defined $_[1]->{$i}->{SourceCode}) ? qq('$SourceCode:$_[1]->{$i}->{SourceCode}') : "null") . "," . ((defined $_[1]->{$i}->{MethodCode}) ? qq('$SourceCode:$_[1]->{$i}->{MethodCode}') : "null") . "," . ((defined $_[1]->{$i}->{QualityControlLevelCode}) ? $_[1]->{$i}->{QualityControlLevelCode} : "-9999") . "),";
	}
	chop $valstr;
	#~ my $onConflictAction="do nothing";
	#~ if(defined $opts{"-U"}) {
		#~ $onConflictAction="do update set $updstr";
	#~ }
	my $stmt =qq(begin;
create temporary table datavalues_tmp ("LocalDateTime" timestamp,"DateTimeUTC" timestamp,"DataValue" float,"UTCOffset" integer,"SiteCode" varchar,"VariableCode" varchar,"Qualifier" varchar,"MethodCode" varchar,"SourceCode" varchar,"QualityControlLevelCode" integer);
copy datavalues_tmp from stdin;
insert into "DataValues" select "LocalDateTime","DateTimeUTC","DataValue","UTCOffset","Sites"."SiteID","Variables"."VariableID","Qualifiers"."Qualifier",coalesce("Methods"."MethodCode",0),coalesce("Sources"."SourceID",0) ,coalesce("QualityControlLevels"."QualityControlLevelID",0) from datavalues_tmp  join "Sites" on (datavalues_tmp."SiteCode"="Sites"."SiteCode") join "Variables" on (datavalues_tmp."VariableCode"="Variables"."VariableCode") left join "Methods" on (datavalues_tmp."MethodCode"="Methods"."MethodCode") left join "Sources" on (datavalues_tmp."SourceCode"="Sources"."SourceCode") left join "QualityControlLevels" on (datavalues_tmp."QualityControlLevelCode"="QualityControlLevels"."QualityControlLevelCode") left join "Qualifiers" on (datavalues_tmp."Qualifier"="Qualifiers"."QualifierCode") on conflict ("SiteID", "VariableID", "SourceID", "DateTimeUTC") do nothing returning count("SiteID");
commit;);
	#~ my $stmt =qq(select $valstr);
	#~ print STDERR "$stmt\n"; exit;
	my $sth=$_[0]->prepare($stmt);
	my $rv=$sth->execute or die $_[0]->errstr;
	my @res;
	while(my $row=$sth->fetchrow_hashref) {
		push @res, $row->{ValueID};
	}
	my $res = encode_json \@res;
	if(@res > 0) {
		return "{\"status\":\"200 OK\",\"SiteID\":" . $res . "}";
	} else {
		return "{\"status\":\"400 Bad Request\"}";
	}
	#~ print $stmt . "\n";
	#~ return 1;
}
