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

=pod

=head1 DESCRIPTION

Este script permite insertar y extraer registros de la base de datos pgODM usando los módulos odm_load y plwofclient, y acceder a servicios WOF-WML de terceros. El primer parametro debe ser una de las siguientes acciones, seguidas por parametros key=value y/o opciones precedidas por '-', p. ej, -U  

	addvariable     VariableCode=STRING VariableName=STRING VariableUnitsID=INTEGER  SampleMedium=STRING ValueType=STRING IsRegular=BOOLEAN DataType=STRING GeneralCategory=STRINGTimeSupport=INTEGERTimeUnitsID=INTEGERNoDataValue=FLOAT
	
	getvariables    VariableID=INTEGER VariableCode=STRING VariableName=STRING VariableUnitsID=INTEGER  SampleMedium=STRING ValueType=STRING IsRegular=BOOLEAN DataType=STRING  GeneralCategory=STRING TimeSupport=INTEGER TimeUnitsID=INTEGER
	
	addsource        SourceCode=STRING  Organization=STRING  SourceDescription=STRING  SourceLink=STRING  ContactName=STRING  Phone=STRING  Email=STRING  Address=STRING City=STRING State=STRING ZipCode=STRING Citation=STRING MetadataID=INTEGER
	
	getsources       SourceID=INTEGER Organization=STRING SourceDescription=STRING SourceLink=STRING ContactName=STRING Phone=STRING  Email=STRING Address=STRING City=STRING State=STRING ZipCode=STRING Citation=STRING MetadataID=INTEGER SourceCode=STRING
	
	addsite          SiteCode=STRING SiteName=STRING Latitude=FLOAT Longitude=FLOAT Elevation_m=FLOAT SiteType=STRING State=STRING County=STRING Comments=STRING Country=STRING
	
	addsites         SiteCode=STRING SiteName=STRING Latitude=FLOAT Longitude=FLOAT Elevation_m=FLOAT SiteType=STRING State=STRING County=STRING Comments=STRING Country=STRING
	
	getsiteinfo	     SiteCode=STRING
	addvalues        Values=ARRAY SiteID=INTEGER VariableID=INTEGER MethodID=INTEGER SourceID=INTEGER QualityControl=INTEGER UTCOffset=INTEGER
	
	getvalues        SiteCode=STRING VariableCode=STRING StartDate=STRING EndDate=STRING

	getunitsid       UnitsName=STRING UnitsType=STRING

	addseries        SiteCode=STRING  VariableCode=STRING  MethodCode=STRING  SourceID=STRING  SourceCode=STRING  MethodDescription=STRING  MethodLink=STRING  Organization=STRING  SourceDescription=STRING Citation=STRING QualityControlLevelCode=STRING QualityControlLevelDefinition=STRING ValueCount=INTEGER BeginDateTime=STRING EndDateTime=STRING BeginDateTimeUTC=STRING EndDateTimeUTC=STRING
	
	getfromserver    -s server[url], -r request[GetSites,GetSiteInfo,GetVariables,GetValues], -p params [key=val,key=val], =f output_format [default=waterml,csv,json], -O output_file [default STDOUT], -S separator [default=,], -R raw [default=false],-P pretty [default=false], -b no_proxy default=false, -I insert into own ODM, -U on conflict update (ODM)
	
	parsewml         -f output_format [default=waterml,csv,json], -O output_file [default STDOUT], -S separator [default=,], -P pretty [default=false], -i input_file [use - para stdin]
	

=cut

#
### OVERALL PARAMETERS #####
#
use lib "/usr/lib/perl5";   #   <= DIR que contiene módulos perl
#~ use wml;
use odm_load;
use plwofclient;
my $lilbambu_conf_file="~/lilbambu/lilbambu.ini"; # <= archivo de configuración
my $lilbambu_data_dir="~/lilbambu/data";

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
	} case "addsites" {
		my ($params,$opciones) = getOptions(@ARGV);
		if(!defined $params->{sites}) {
			die "falta sites=json_array_of_sites";
		}
		my $res=odm_load::addSites($dbh,\@{$params->{sites}},$opciones); 
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
	
	} 
	#~ case "parsewml" {  ### creo que no
		#~ my ($params,$opciones) = getOptions(@ARGV);
		#~ my $res=odm_load::parseWML($dbh,$params,$opciones);
		#~ print "$res\n";
		#~ exit; 
	#~ }
	 case "getunitsid" {
		my ($params,$opciones) = getOptions(@ARGV);
		my $res=odm_load::GetUnitsID($dbh,$params);
		print "$res\n";
		exit; 
	}  case "addseries" {
		my ($params,$opciones) = getOptions(@ARGV);
		my $res=odm_load::addSeries($dbh,$params,$opciones);
		print "$res\n";
		exit; 
	} case "getfromserver" {
		our($opt_s,$opt_r,$opt_p,$opt_f,$opt_O,$opt_S,$opt_R,$opt_P,$opt_n,$opt_I,$opt_U);   # (-s server[url], -r request[GetSites,GetSiteInfo,GetVariables,GetValues], -p params [key=val,key=val], =f output_format [default=waterml,csv,json], -O output_file [default STDOUT], -S separator [default=,], -R raw [default=false],-P pretty [default=false], -b no_proxy default=false, -I insert into own ODM, -U on conflict update (ODM))
		getopts("s:r:p:f:O:S:RPnIU");
		if(! $opt_s) {
			die "falta -s server";
		}
		my $server=$opt_s;
		if(! $opt_r) {
			die "falta -r request";
		}
		my %valid_requests=("GetSites"=>1,"GetSiteInfo"=>1,"GetVariables"=>1,"GetValues"=>1);
		if(!defined $valid_requests{$opt_r}) {
			die "Request $opt_r no valido. Opciones: GetSites,GetSiteInfo,GetVariables,GetValues";
		}
		my $request=$opt_r;
		my ($params,$opciones);
		if($opt_p) {
			my @par=split(",",$opt_p);
			($params,$opciones) = getOptions(@par);
		}
		my $output_format = ($opt_f) ? $opt_f : "waterml";
		my %valid_formats = ("waterml"=>1, "csv"=>1, "json"=>1);
		if(!defined $valid_formats{$output_format}) {
			die "Formato $output_format no valido. opciones: waterml,csv,json";
		}
		$output_format .= ($opt_P) ? "_pretty" : "";
		my $separator = ($opt_S) ? substr($opt_S,0,1) : ",";
		#~ my $response;
		my %opts;
		if($opt_n) {
			$opts{"no_proxy"}=1;
		}
		my $wml=plwofclient::MakeWOFRequest($server,$request,$params,\%opts);
		if($opt_I) {
			my %opts = ("output_format"=>"array");
			my $parsed = plwofclient::parseWML($wml,\%opts);

			if( $request eq "GetValues" ) {
				my $UTCOffset = (defined $parsed->[0]->{"UTCOffset"}) ? $parsed->[0]->{"UTCOffset"} : "+00:00";
				my @values;
				my @obj;
				if(ref($parsed) eq "ARRAY") {
					@obj = @{$parsed};
				} elsif(ref($parsed) eq "HASH") {
					if(defined $parsed->{"Values"}) {
						if(ref($parsed->{"Values"}) ne "ARRAY") {
							die "La propiedad Values debe ser ARRAY";
						}
						@obj = @{$parsed->{"Values"}};
						if (defined $parsed->{"method"}) {
							#~ my %opts = ("MethodCode"=$parsed->{"method"}->{"FullMethodCode"}
						}
						if(defined $parsed->{"source"}) {
							addSource($dbh,$parsed->{"source"});
						}
					} else {
						die "Propiedad Values no existe";
					}
				} else {
					die "El objeto debe ser un ARRAY o contener una propiedad Values = ARRAY";
				} 
				for(my $i=0;$i<@obj;$i++) {
					#~ foreach(keys %{$obj[$i]}) {
						#~ if($obj[$i]->{$_} eq "") {
							#~ delete $obs[$i]->{$_};
						#~ }
					#~ } 
					#~ my $datetimeutc = (defined $obj[$i]->{"DateTimeUTC"}) ? $obj[$i]->{"DateTimeUTC"} : (defined $obs[$i]->{"DateTime"} && defined $obs[$i]->{"UTCOffset"}) ? ( $obs[$i]->{"DateTime"} . $obs[$i]->{"UTCOffset"}
					%{$values[$i]} = ( $obj[$i]->{"DateTime"}, $obj[$i]->{"DataValue"} );
				}
				
			} else {
				my @obj;
				my %hash;
				if(ref($parsed) eq "ARRAY") {
					if( @$parsed == 0 ) {
						die "Arreglo vacio en objeto waterml";
					} else {
						@obj = @{$parsed};
					}
				} else {
					die "Object must be an ARRAY";
				}
				my $rowno=-1;
				my @ids;
				my @opts;
				if($opt_U) {
					push @opts, "-U";
				}				
				ROW: foreach my $row (@obj) {
					$rowno++;
					my %columns;
					my $res;
					my $IDcol;
					switch($request) {
						case "GetSites" {
							$IDcol="SiteID";
							%columns = ("SiteCode"=>$row->{"FullSiteCode"}, "SiteName"=>$row->{"SiteName"}, "Latitude"=>$row->{"Latitude"},"Longitude"=>$row->{"Longitude"},"Elevation_m"=>$row->{"Elevation_m"},"SiteType"=>$row->{"SiteType"},"State"=>$row->{"State"},"County"=>$row->{"County"}, "Comments"=>$row->{"Comments"},"Country"=>$row->{"Country"});
							eval {
								$res = odm_load::addSite($dbh,\%columns,\@opts);
							} or do {
								print STDERR "lilbambu: Error al ejecutar odm_load::addSite fila numero $rowno.\n $@\n";
								next;
							};
						} case "GetSiteInfo" {
							$IDcol="SeriesID";
							%columns = ("SiteCode"=>$row->{"FullSiteCode"},"VariableCode"=>$row->{"FullVariableCode"},"MethodCode"=>$row->{"MethodCode"},"SourceID"=>$row->{"SourceID"},"SourceCode"=>$row->{"Network"},"MethodDescription"=>$row->{"MethodDescription"},"MethodLink"=>$row->{"MethodLink"},"Organization"=>$row->{"Organization"},"SourceDescription"=>$row->{"SourceDescription"},"Citation"=>$row->{"Citation"},"QualityControlLevelCode"=>$row->{"QualityControlLevelCode"},"QualityControlLevelDefinition"=>$row->{"QualityControlLevelDefinition"},"ValueCount"=>$row->{"ValueCount"},"BeginDateTime"=>$row->{"BeginDateTime"},"EndDateTime"=>$row->{"EndDateTime"},"BeginDateTimeUTC"=>$row->{"BeginDateTimeUTC"},"EndDateTimeUTC"=>$row->{"EndDateTimeUTC"});
							#~ print STDERR "adding series $rowno...\n";
							eval {
								$res = odm_load::addSeries($dbh,\%columns,\@opts);
							} or do {
								print STDERR "lilbambu: Error al ejecutar odm_load::addSeries fila numero $rowno.\n $@\n";
								next;
							};
						} case "GetVariables" {
							$IDcol="VariableID";
							%columns = ("VariableCode"=>$row->{"FullVariableCode"},"VariableName"=>$row->{"VariableName"},"VariableUnitsID"=>$row->{"UnitCode"}, "SampleMedium"=>$row->{"SampleMedium"},"ValueType"=>$row->{"ValueType"},"IsRegular"=>$row->{"IsRegular"},"DataType"=>$row->{"DataType"}, "GeneralCategory"=>$row->{"GeneralCategory"},"TimeSupport"=>$row->{"TimeSupport"},"TimeUnitsID"=>$row->{"TimeUnitID"},"NoDataValue"=>$row->{"NoDataValue"});
							eval {
								$res = odm_load::addVariable($dbh,\%columns,\@opts);
							};
							if($@) {
							 #~ or do {
								print STDERR "lilbambu: Error al ejecutar odm_load::addVariable fila numero $rowno.\n $@\n";
								next ROW;
							} #;
						} 
					}
							#~ print STDERR "add**** response: $res\n";
					my $result;
					eval {
						$result = decode_json $res;
					} or do {
						print STDERR "lilbambu getfromserver: Error al ejecutar odm_load::add**** fila numero $rowno.\n $@\n";
						next;
					};
					if(!defined $result->{"status"}) {
						print STDERR "lilbambu: no se pudo leer status code de salida de odm_load::addSite\n";
					} else {
						#~ print STDERR "status:" . $result->{"status"} . "\n";
						if($result->{"status"} eq "200 OK") {
							#~ foreach(keys %{$result}) {
								#~ print STDERR "$_: " . $result->{$_} . "\n";
							#~ }
							if(defined $result->{$IDcol}) {
								push @ids, $result->{$IDcol};
							}
						} else {
							print STDERR "lilbambu: error en odm_load::add***\n";
						}
					}
				}
				$rowno++;
				print STDERR "Filas leidas: $rowno. Registros insertados: " . @ids . "\n";
			}
					

					#~ my $result = odm_load::addSites($dbh,\@obj);
					#~ my %result;
					#~ eval {
						#~ %result = decode_json $result;
					#~ } or do {
						#~ die "lilbambu: Error: no se pudo leer la salida de odm_load::addSites";
					#~ };
					#~ %result = decode_json $result;
					#~ if(!defined $result{"status"}) {
						#~ die "lilbambu: error al ejecutar odm_load::addSites";
					#~ } else {
						#~ print STDERR "status:" . $result{"status"} . "\n";
						#~ if($result{"status"} eq "200 OK") {
							#~ foreach(keys %result) {
								#~ print STDERR "$_: " . $result{$_} . "\n";
							#~ }
						#~ }
					#~ }
							 
		} elsif($opt_R) {
			#~ print STDERR "printing raw...\n";
			if($opt_O) {
				open(my $out,">$opt_O") or die "No se pudo abrir archivo $opt_O para escritura";
				print $out $wml;
			} else {
				print STDOUT $wml;
			}
		} else {
			my %opts = ("output_format"=>$output_format, "sep"=>$separator);
			my $obj = plwofclient::parseWML($wml,\%opts);
			if($opt_O) {
				open(my $out,">$opt_O") or die "No se pudo abrir archivo $opt_O para escritura";
				print $out $obj;
			} else {
				print STDOUT $obj;
			}
		}
		exit;
	} case "parsewml" {
		our($opt_f,$opt_O,$opt_S,$opt_P,$opt_i);   # (-f output_format [default=waterml,csv,json], -O output_file [default STDOUT], -S separator [default=,], -P pretty [default=false], -i input_file [use - para stdin])
		getopts("f:O:S:Pi:");
		if(!$opt_i) {
			die "Falta -i input_file (.waterml)";
		}
		my $output_format = ($opt_f) ? $opt_f : "waterml";
		my %valid_formats = ("waterml"=>1, "csv"=>1, "json"=>1);
		if(!defined $valid_formats{$output_format}) {
			die "Formato $output_format no valido. opciones: waterml,csv,json";
		}
		$output_format .= ($opt_P) ? "_pretty" : "";
		my $separator = ($opt_S) ? substr($opt_S,0,1) : ",";
		my $wml;
		if($opt_i eq "-") {
			$wml=<>;
		} else {
			open(my $input_file,$opt_i) or die "no se pudo abrir archivo $opt_i para lectura";
			while(<$input_file>) {
				$wml .= $_;
			}
			close($input_file);
		}
		my %opts = ("output_format"=>$output_format, "sep"=>$separator);
		print STDERR "ejecutando parseWML...\n";
		my $obj = plwofclient::parseWML($wml,\%opts);
		if($opt_O) {
			open(my $out,">$opt_O") or die "No se pudo abrir archivo $opt_O para escritura";
			print $out $obj;
		} else {
			print STDOUT $obj;
		}
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
			if($2 eq "") {
				eval {
					$params{$1} = decode_json <STDIN>;
				} or do {
					die "STDIN no es JSON valido";
				}
			} else {
				open(my $file,$2) or die "Archivo $2 no encontrado";
				eval {
					$params{$1} = decode_json <$file>;
				} or do {
					die "El archivo $2 no es un JSON válido";
				};
			}
		} elsif ($opt =~ /(^.+)=(.+=.+)$/) {
			$params{$1} = $2;
		} elsif ($opt =~ /(^.+)=(.+$)/) {
            $params{$1} = $2;
            #~ print STDERR "param:$1 = $params{$1}\n";
        } else {
            $params{$opt} = 1;
        }
    }

    return (\%params,\@opciones);
}
