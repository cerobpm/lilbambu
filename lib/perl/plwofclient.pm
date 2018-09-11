package plwofclient;

=head1 NAME

plwofclient

=head1 SYNOPSIS

	use plwofclient;
	my $envelope=plwofclient::MAkeSoapEnvelope("http://www.cuahsi.org/his/1.1/ws/", "GetSitesObject");

=head1 DESCRIPTION
	
	This is a perl client for WaterOneFlow Web Service
	
=cut

use strict;
use Exporter;
use XML::LibXML;
use XML::LibXML::XPathContext;
use XML::LibXML::PrettyPrint;
#~ use LWP::Simple;
use LWP::UserAgent;
use HTTP::Request;
use URI;
use Env;
use JSON;
use Switch;
#~ binmode(STDOUT, ":utf8");
#~ use open qw(:std :utf8);
use Encode;# qw(decode_utf8);
#~ @ARGV = map { decode_utf8($_, 1) } @ARGV;#~ use open ':std', ':encoding(UTF-8)';
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION     = 1.00;
@ISA         = qw(Exporter);
@EXPORT      = qw(MakeSoapEnvelope);
@EXPORT_OK   = qw(MakeSoapEnvelope);
%EXPORT_TAGS = ( DEFAULT => [qw(MakeSoapEnvelope)]);

=head2 function MakeSoapEnvelope

=cut

sub MakeSOAPEnvelope { #     <- function(CUAHSINamespace, MethodName, parameters=NULL) {
  my $CUAHSINamespace = shift @_;
  if(!defined $CUAHSINamespace) {
	die "CUAHSINamespace not defined with no default\n";
  }
  my $MethodName = shift @_;
  if(!defined $MethodName) {
	die "MethodName not defined with no default\n";
  }
  my %parameters;
  if(defined $_[0]) {
	%parameters = (%parameters,%{shift @_});
  }
  #check CUAHSINamespace parameter
  my $validNamespace_1_0 = "http://www.cuahsi.org/his/1.0/ws/";
  my $validNamespace_1_1 = "http://www.cuahsi.org/his/1.1/ws/";
  if ($CUAHSINamespace ne $validNamespace_1_0 && $CUAHSINamespace ne $validNamespace_1_1) {
    die "The CUAHSINamespace parameter must be either " .$validNamespace_1_0 . " or " . $validNamespace_1_1;
  }
  #check MethodName
  my @validMethodNames = ("GetSites", "GetSitesObject", "GetSitesByBoxObject","GetSiteInfoObject", "GetVariableInfoObject", "GetValuesObject");
  my %vm = map { $_ => 1 } @validMethodNames;
  if (!exists $vm{$MethodName}) {
    my $message = join(", ", @validMethodNames);
    die "The MethodName must be one of the following:" . $message;
  }
  
  my $soapAction = $CUAHSINamespace . $MethodName;
  #make the XML for parameters
  my  @XMLParameters;
  if ($MethodName eq "GetSitesObject") { # || $MethodName eq "GetSites") {
    @XMLParameters = ('<site></site>');
  } else {
   @XMLParameters = map { '<' . $_ . '>' . $parameters{$_} . '</' . $_ . ">\n" } keys %parameters;
  }
  #~ foreach(keys %parameters) {
	  #~ print STDERR "\n---\nkey:$_, value:".$parameters{$_}."\n---\n";
  #~ }
  my $envelope = '<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
<soap:Body>
<' . $MethodName .' xmlns="' . $CUAHSINamespace . '">
' . join('',@XMLParameters) . '<authToken></authToken>
</' . $MethodName . '>
</soap:Body>
</soap:Envelope>';
  return $envelope;
}

=head2 function GetSitesFromWOF

	GetSitesFromWOF($url, \%parameters, \%options=("no_proxy"=>1,"output_format"=>"json"|"waterml"|"array") );
	default options:
	 no_proxy 0
	 output_format array

=cut

sub GetSitesFromWOF {
	my $namespace = "http://www.cuahsi.org/his/1.1/ws/";
	
	my $server = shift @_;
	if(!defined $server) {
	  die "Falta parametro server";
	}
	my %parameters;
	if(defined $_[0]) {
	%parameters = (%parameters,%{shift @_});
	}
	my %options;
	if(defined $_[0]) {
		%options = (%options,%{shift @_});
	}
	my $no_proxy = (defined $options{no_proxy}) ? ($options{no_proxy} =~ /^[sStT1vV]/) ? 1 : 0 : 0;
	my $output_format = (defined $options{output_format}) ? lc($options{output_format}) : "array";
	my %valid_output_formats = ("array"=>1,"json"=>1,"waterml"=>1,"waterml_pretty"=>1, "json_pretty"=>1, "csv"=>1, "csv_pretty"=>1);
	if(!defined $valid_output_formats{$output_format}) {
		die "GetSitesFromWOF: output_format no valido. opciones: array, json, waterml, json_pretty, waterml_pretty, csv, csv_pretty";
	} 
	# declare the default download timeout in seconds
	my $max_timeout = 360;

	# declare empty return data frame
	my %df; 

	# trim any leading and trailing whitespaces in server
	$server  =~ /^\s+|\s+$/;

	my $version="1.1";
	my $validnamespace="http://www.cuahsi.org/his/1.1/ws/";

	# if server ends with ?WSDL or ?wsdl, we assume that service is SOAP
	# otherwise, assume that service is REST
	my $SOAP = 1;

	# if server ends with .asmx, we also assume that the service is SOAP and we add ?WSDL
	$server .= ($server =~ /asmx$/) ? "?WSDL" : "";

	my $url;
	if(($url = $server) =~ s/\?WSDL|\?wsdl//) {
		#~ ($url = $server) =~ s/$1//;
		$SOAP = 1;
	} else {
	# in other cases we leave the URL as it is
		$SOAP = 0;
	}
	#~ print "url:$url\n"; exit;
	my $response;

	#if the service is SOAP:
	if ($SOAP == 1) {
		print STDERR "Is SOAP...($url) \n";
		#~ versionInfo <- WaterOneFlowVersion(server)
		#~ namespace <- versionInfo$Namespace
		#~ version <- versionInfo$Version

	#choose the right SOAP web method based on WaterML version and parameters
	#~ if (version == "1.0") {
      #~ methodName <- "GetSites"

      #~ envelope <- MakeSOAPEnvelope(namespace, methodName)
    #~ } else {
		my $methodName;
		my $envelope;
		if (!defined $parameters{"west"} || !defined $parameters{"south"} || !defined $parameters{"east"} || !defined $parameters{"north"} ) {
			$methodName = "GetSitesObject";
			$envelope = MakeSOAPEnvelope($namespace, $methodName);
		} else {
			$methodName = "GetSitesByBoxObject";
			my %env_parameters = ("west"=>$parameters{"west"}, "south"=>$parameters{"south"}, "north"=>$parameters{"north"}, "east"=>$parameters{"east"},"IncludeSeries"=>"false");
			$envelope = MakeSOAPEnvelope($namespace, $methodName, \%env_parameters );
		}
    #~ }
		my $SOAPAction = "$namespace$methodName";
		#~ my %headers = ("Content-Type" => "text/xml", "SOAPAction" => $SOAPAction);

		print STDERR "downloading sites from: $url ...\n";

		my $downloaded = 0;
		my $status;
		my $userAgent = LWP::UserAgent->new(agent => "perl post"); 
		if(defined $ENV{http_proxy}  && $no_proxy == 0) {
			$userAgent->proxy('http', $ENV{http_proxy});
		}
		my $request = HTTP::Request->new(
			POST => $url,
			HTTP::Headers->new(
			'SOAPAction' => $SOAPAction,
			'Content-Type' => 'text/xml')
			);
		$request->content($envelope);
		#~ $request->content_type("text/xml; charset=utf-8");
		my $start=time();
		$response = $userAgent->request($request);
		if($response->code == 200) {
			print STDERR "Descarga exitosa ...\n"; #$response->as_string;
		}
		else {
			print STDERR "Error en la descarga: " . $response->error_as_HTML . "\n";
		}
		#~ my $content = $ua->request($request)->as_string(); 
		$status = $response->code;
		$downloaded = 1;
		#~ if (!downloaded) {
		  #~ attr(df, "download.time") <- download.time["elapsed"]
		  #~ attr(df, "download.status") <- err
		  #~ attr(df, "parse.time") <- NA
		  #~ attr(df, "parse.status") <- NA
		  #~ return(df)
		#~ }

		my $status_code = $response->message;
		my $end=time();
		my $elapsed = $end - $start;
		print STDERR "download time: $elapsed seconds, status: $status_code\n";

		#in case of server error, print the error and exit
		if (lc($status_code) eq "server error") {
			print STDERR $response->as_string() . "\n";
			print STDERR "download.time: $elapsed\n";
			print STDERR "download.status: $status\n";
			print STDERR "parse.time: NA\n";
			print STDERR "parse.status: NA\n";
			die "server error";
		}
	} else {
		# If the service is REST:
		if (defined $parameters{"west"} && defined $parameters{"south"} && defined $parameters{"east"} && defined $parameters{"north"} ) {
			$server =~ s/\?$//;
			$server =~ s/\/$//;
			my $uri = URI->new($server);
			$uri->query_form("west"=>$parameters{"west"}, "south"=>$parameters{"south"}, "east"=>$parameters{"east"}, "north"=>$parameters{"north"});
			$url = $uri; # "?west=" . $parameters{"west"} . "&south=" . $parameters{"south"} . "&east=" . $parameters{"east"} . "&north=" . $parameters{"north"};
		}
		print STDERR "downloading sites from: $server ...\n";
		my $downloaded = 0;
		my $status;
			#~ print $url; exit;
		my $userAgent = LWP::UserAgent->new(agent => "perl get"); 
		if(defined $ENV{http_proxy} && $no_proxy == 0) {
			$userAgent->proxy('http', $ENV{http_proxy});
		}
		my $request = HTTP::Request->new(GET => $url);
		my $start=time();
		$response = $userAgent->request($request);
		if($response->code == 200) {
			print STDERR "Descarga exitosa ...\n"; #$response->as_string;
		}
		else {
			print STDERR "Error en la descarga: " . $response->error_as_HTML . "\n";
		}
				$status = $response->code;
		$downloaded = 1;
		#~ if (!downloaded) {
		  #~ attr(df, "download.time") <- download.time["elapsed"]
		  #~ attr(df, "download.status") <- err
		  #~ attr(df, "parse.time") <- NA
		  #~ attr(df, "parse.status") <- NA
		  #~ return(df)
		#~ }

		my $status_code = $response->message;
		my $end=time();
		my $elapsed = $end - $start;
		print STDERR "download time: $elapsed seconds, status: $status_code\n";

		#in case of server error, print the error and exit
		if (lc($status_code) eq "server error") {
			print STDERR $response->as_string() . "\n";
			print STDERR "download.time: $elapsed\n";
			print STDERR "download.status: $status\n";
			print STDERR "parse.time: NA\n";
			print STDERR "parse.status: NA\n";
			die "server error";
		}
	}
  #~ attr(df, "download.time") <- download.time["elapsed"]
  #~ attr(df, "download.status") <- status.code

  ######################################################
  # Parsing the WaterML XML Data                       #
  ######################################################

	my $begin_parse_time = time();

	print STDERR "reading sites WaterML data...\n";
	my $doc;
	my $res_string = $response->decoded_content();
	#~ eval {
		my $parser = XML::LibXML->new;
		$doc = $parser->parse_string($res_string); #load_xml(string=>$response->as_string());
	#~ } or do {
		#~ print STDERR $res_string . "\n";
		#~ die "Error reading WaterML: Bad XML format.\nparse.status: Bad XML format\nparse.time: 0";
	#~ };
	if (!defined($doc)) {
		die "Error reading WaterML: Bad XML format.\nparse.status: Bad XML format\nparse.time: 0";
	}
		if($output_format eq "waterml") {
		return $res_string . "\n";
	} elsif($output_format eq "waterml_pretty") {
		my $pp = XML::LibXML::PrettyPrint->new(indent_string => "  ");
		$pp->pretty_print($doc);
		return $doc->toString;
	}
	# specify the namespace information
	my $xpc = XML::LibXML::XPathContext->new($doc);
	$xpc->registerNs("soap","http://schemas.xmlsoap.org/soap/envelope/");
	$xpc->registerNs("xsd","http://www.w3.org/2001/XMLSchema");
	$xpc->registerNs("xsi","http://www.w3.org/2001/XMLSchema-instance");
	$xpc->registerNs("sr","http://www.cuahsi.org/waterML/1.1/");
	$xpc->registerNs("gsr","http://www.cuahsi.org/his/1.1/ws/");
	#~ $xpc->registerNs("wml","http://www.cuahsi.org/waterML/1.1/");
	
	# extract the data columns with XPath
	my @SiteInfo = $xpc->findnodes("//sr:siteInfo"); # $xpc->find("//gsr:siteInfo",$doc);

	my $N = @SiteInfo;
	print STDERR "found $N sites\n";
	my $bigData = 10000;
	if ($N > $bigData) {
		print STDERR "processing Sites...\n";
	}
	my @Sites;
	my $i=0;
	foreach my $site (@SiteInfo) {
		my $xpcc = XML::LibXML::XPathContext->new($site);
		$xpcc->registerNs("sr","http://www.cuahsi.org/waterML/1.1/");
		my $SiteName = $xpcc->findvalue('./sr:siteName');
		my $SiteCode = $xpcc->findvalue('./sr:siteCode');
		
		my $Network = $xpcc->findvalue('./sr:siteCode/@network');
		my $SiteID = $xpcc->findvalue('./sr:siteCode/@siteID');
		my $Latitude = $xpcc->findvalue('./sr:geoLocation/sr:geogLocation/sr:latitude');
		my $Longitude = $xpcc->findvalue('./sr:geoLocation/sr:geogLocation/sr:longitude');
		my $Elevation = $xpcc->findvalue('./sr:elevation_m');
		my $Country = $xpcc->findvalue('./sr:siteProperty[@title="Country"]');
		my $State = $xpcc->findvalue('./sr:siteProperty[@title="State"]');
		my $County = $xpcc->findvalue('./sr:siteProperty[@title="County"]');
		my $Comments = $xpcc->findvalue('./sr:siteProperty[@title="Site Comments"]');
		%{$Sites[$i]} = ("SiteName"=>$SiteName, "SiteCode"=>$SiteCode, "Network"=>$Network, "SiteID"=>$SiteID, "Longitude"=>$Longitude, "Latitude"=>$Latitude, "Elevation"=>$Elevation, "Country"=>$Country, "State"=>$State, "County"=>$County, "Comments"=>$Comments);
		$i++;
	}
	my $sep = (defined $options{"sep"}) ? substr($options{"sep"},0,1) : ",";
	if($output_format eq "json") {
		return toJSON(\@Sites);
	} elsif ($output_format eq "json_pretty") {
		return toJSON(\@Sites,1);
	} elsif ($output_format eq "csv") {
		my %opts = ("sep"=>$sep);
		return toCSV(\@Sites,\%opts);
	} elsif ($output_format eq "csv_pretty") {
		my %opts = ("pretty"=>1,"sep"=>$sep);
		return toCSV(\@Sites,\%opts);
	} else {
		return @Sites; #, @SiteCode, @Network, @SiteID];
	}
}

=head2 toJSON

	toJSON(\@Arr,pretty);
	
=cut

sub toJSON {
	my $arr = shift @_;
	switch(ref($arr)) {
		case "HASH" {
			my $res;
			eval {
				if(defined $_[0]) {
					my $json = JSON->new->allow_nonref;
					$json = $json->canonical([]);
					$res = $json->pretty->encode($arr);
				} else {
					$res = encode_json \%$arr;
				}
			} or do {
				die "toJSON: No se pudo encodificar";
			};
			return $res;
		} case "ARRAY" {
			my $res;
			eval {
				if(defined $_[0]) {
					my $json = JSON->new->allow_nonref;
					$json = $json->canonical([]);
					$res = $json->pretty->encode($arr);
				} else {
					$res = encode_json \@$arr;
				}
			} or do {
				die "toJSON: No se pudo encodificar";
			};
			return $res;
		} else {
			die "toJSON: _[0] debe ser ARRAY REF o HASH REF";
		}
	}
} 

=head2 toText

	toText(\%Hash)
	
=cut

sub toText {
	my $hash = shift @_;
	my $res ="START METADATA\n";
	if(ref($hash) ne "HASH") {
		die "toText: _[0] debe ser HASH REF";
	}
	foreach my $key (keys %$hash) {
		$res .= elem2text($hash->{$key},$key) . "\n";
	}
	$res .= "END METADATA";
	return $res;
}

sub elem2text {
	my $res;
	if(ref($_[0]) eq "HASH") {
		foreach my $key (keys %{$_[0]}) {
			$res .= elem2text($_[0]->{$key},$_[1] . ":" . $key);
		}
	} else {
		$res .= "$_[1]:$_[0]\n";
	}
	return $res;
}

=head2 toCSV

	toCSV(\@Arr,\%options("sep"=>",","pretty"=>0);
	default sep=, pretty=false
	
=cut

sub toCSV {
	my $arr = shift @_;
	if(ref($arr) ne "ARRAY") {
		die "toCSV: _[0] debe ser ARRAY REF";
	}
	my %options;
	if(defined $_[0]) {
		if(ref($_[0]) ne "HASH") {
			die "toCSV: options debe ser HASH REF";
		}
		%options = (%options,%{shift @_});
	}
	my $sep = (defined $options{"sep"}) ? substr($options{"sep"},0,1) : ",";
	my $pretty = (defined $options{"pretty"}) ? ($options{"pretty"}=~ /^[tTsSyY1vV]/) ? 1 : 0 : 0;
	my %all_keys;
	foreach my $i (@$arr) {
		foreach my $k (keys %$i) {
			if(!defined $all_keys{$k}) {
				$all_keys{$k} = (length(%$i{$k}) > length($k)) ? length(%$i{$k}) : length($k);
			} else {
				$all_keys{$k} = (length(%$i{$k}) > $all_keys{$k}) ? length(%$i{$k}) : $all_keys{$k};
			}
		}
	}
	my $res;
	my @keys = sort keys %all_keys;
	foreach my $k (@keys) {
		my $format = '%-' . $all_keys{$k} . 's' . $sep;
		$res .= sprintf $format, $k;
	}
	chop $res;
	$res .= "\n";
	foreach my $i (@$arr) {
		foreach my $k (@keys) {
			my $format = '%-' . $all_keys{$k} . 's' . $sep;
			if(defined %$i{$k}) {
				#~ print STDERR %$i{$k} . "\n";
				my $value = %$i{$k};
				$res .= sprintf $format, $value;
			} else {
				$res .= sprintf $format, "";
			}
		}
		chop $res;
		$res.= "\n";
	}
	
	return $res;
} 

=head2 parseWML

	_[0]: waterML string
	_[1]: %opciones = ( "output_format"=> (array | waterml | json | csv | waterml_pretty | csv_pretty | json_pretty), "sep"=>)

=cut 

sub parseWML {
	  ######################################################
  # Parsing the WaterML XML Data                       #
  ######################################################

	if(!defined $_[0]) {
		die "Falta WaterML string";
	} elsif ($_[0] eq "") {
		die "WaterML string vacío";
	}
	my $res_string =  decode('utf-8',shift @_); # shift @_; #
	#~ return encode('utf-8',$res_string);
	
		my %options;
	if(defined $_[0]) {
		%options = (%options,%{shift @_});
	}
	my $output_format = (defined $options{output_format}) ? lc($options{output_format}) : "array";
	my %valid_output_formats = ("array"=>1,"json"=>1,"waterml"=>1,"waterml_pretty"=>1, "json_pretty"=>1, "csv"=>1, "csv_pretty"=>1);
	if(!defined $valid_output_formats{$output_format}) {
		die "parseWML: output_format no valido. opciones: array, json, waterml, json_pretty, waterml_pretty, csv, csv_pretty";
	} 

	my $begin_parse_time = time();

	print STDERR "reading WaterML data...\n";
	my $doc;
	#~ eval {
		my $parser = XML::LibXML->new();
		$doc = $parser->parse_string($res_string); #load_xml(string=>$response->as_string());
		$doc->setEncoding('UTF-8');
	#~ } or do {
		#~ print STDERR $res_string . "\n";
		#~ die "Error reading WaterML: Bad XML format.\nparse.status: Bad XML format\nparse.time: 0";
	#~ };
	if (!defined($doc)) {
		die "Error reading WaterML: Bad XML format.\nparse.status: Bad XML format\nparse.time: 0";
	}
		if($output_format eq "waterml") {
		return encode('utf-8',$res_string); # $res_string; # 
	} elsif($output_format eq "waterml_pretty") {
		my $pp = XML::LibXML::PrettyPrint->new(indent_string => "  ");
		$pp->pretty_print($doc);
		return $doc->toString; # encode('utf-8',$doc->toString);
	}
	# specify the namespace information
	my $xpc = XML::LibXML::XPathContext->new($doc);
	$xpc->registerNs("soap","http://schemas.xmlsoap.org/soap/envelope/");
	$xpc->registerNs("xsd","http://www.w3.org/2001/XMLSchema");
	$xpc->registerNs("xsi","http://www.w3.org/2001/XMLSchema-instance");
	$xpc->registerNs("sr","http://www.cuahsi.org/waterML/1.1/");
	$xpc->registerNs("gsr","http://www.cuahsi.org/his/1.1/ws/");
	#~ $xpc->registerNs("wml","http://www.cuahsi.org/waterML/1.1/");
	
	my $top;
	my @result;
	my %metadata;
	if($xpc->exists("//sr:siteResponse") || $xpc->exists("//sr:sitesResponse")) {
		#~ my $name = $top->item(0)->nodeName();
		#~ print STDERR $name . "\n"; exit;
	#~ switch ($name) {
		#~ case /sites?Response/ {
			# extract the data columns with XPath
			my @SiteInfo = $xpc->findnodes("//sr:site"); # $xpc->find("//gsr:siteInfo",$doc);

			my $N = @SiteInfo;
			print STDERR "found $N sites\n";
			my $bigData = 10000;
			if ($N > $bigData) {
				print STDERR "processing $N Sites...\n";
			}
			#~ my @Sites;
			my $i=0;
			foreach my $site (@SiteInfo) {
				my %row;
				my $xpcc = XML::LibXML::XPathContext->new($site);
				$xpcc->registerNs("sr","http://www.cuahsi.org/waterML/1.1/");
				$row{'SiteName'} = $xpcc->findvalue('./sr:siteInfo/sr:siteName');
				$row{'SiteCode'} = $xpcc->findvalue('./sr:siteInfo/sr:siteCode');
				$row{'Network'} = $xpcc->findvalue('./sr:siteInfo/sr:siteCode/@network');
				$row{'FullSiteCode'} = ($row{'Network'} ne "") ? ($row{'Network'} . ":" . $row{'SiteCode'} ) : $row{'SiteCode'};
				$row{'SiteID'} = $xpcc->findvalue('./sr:siteInfo/sr:siteCode/@siteID');
				$row{'Latitude'} = $xpcc->findvalue('./sr:siteInfo/sr:geoLocation/sr:geogLocation/sr:latitude');
				$row{'Longitude'} = $xpcc->findvalue('./sr:siteInfo/sr:geoLocation/sr:geogLocation/sr:longitude');
				$row{'Elevation'} = $xpcc->findvalue('./sr:siteInfo/sr:elevation_m');
				$row{'Country'} = $xpcc->findvalue('./sr:siteInfo/sr:siteProperty[@title="Country"]');
				$row{'State'} = $xpcc->findvalue('./sr:siteInfo/sr:siteProperty[@title="State"]');
				$row{'County'} = $xpcc->findvalue('./sr:siteInfo/sr:siteProperty[@title="County"]');
				$row{'Comments'} = $xpcc->findvalue('./sr:siteInfo/sr:siteProperty[@title="Site Comments"]');
							### Case w/SeriesCatalog
				my @SeriesCatalog = $xpcc->findnodes("./sr:seriesCatalog/sr:series");
				my $NS = @SeriesCatalog;
				if($NS > $bigData) {
					print STDERR "processing $NS Series ...\n";
				}
				if($NS > 0) {
					#~ my $j=0;
					foreach my $series (@SeriesCatalog) {
						my $xps = XML::LibXML::XPathContext->new($series);
						$xps->registerNs("sr","http://www.cuahsi.org/waterML/1.1/");
						$row{'VariableCode'} = $xps->findvalue('./sr:variable/sr:variableCode');
						$row{'VariableName'} = $xps->findvalue('./sr:variable/sr:variableName');
						$row{'VariableID'} = $xps->findvalue('./sr:variable/sr:variableCode/@variableID');
						$row{'Vocabulary'} = $xps->findvalue('./sr:variable/sr:variableCode/@vocabulary');
						if ($row{'Vocabulary'} ne "") {
							$row{'FullVariableCode'} = $row{'Vocabulary'} . ":" . $row{'VariableCode'};
						} else {
							$row{'FullVariableCode'} = $row{'VariableCode'};
						}
						$row{'ValueType'} = $xps->findvalue('./sr:variable/sr:valueType');
						$row{'DataType'} = $xps->findvalue('./sr:dataType');  
						$row{'GeneralCategory'} = $xps->findvalue('./sr:generalCategory'); 
						$row{'SampleMedium'} = $xps->findvalue('./sr:sampleMedium');
    #~ if (version == "1.1") {
						$row{'UnitName'} = (!defined $xps->findvalue('./sr:variable/sr:unit/sr:unitName')) ? (!defined $xps->findvalue('./sr:variable/sr:units/sr:unitName')) ? $xps->findvalue('./sr:variable/sr:unit/sr:unitsName') : $xps->findvalue('./sr:variable/sr:units/sr:unitName') : $xps->findvalue('./sr:variable/sr:unit/sr:unitName');
						$row{'UnitType'} = (!defined $xps->findvalue('./sr:variable/sr:unit/sr:unitType')) ? $xps->findvalue('./sr:variable/sr:unit/sr:unitsType') : $xps->findvalue('./sr:variable/sr:unit/sr:unitType');
						$row{'UnitAbbreviation'} = (!defined $xps->findvalue('./sr:variable/sr:units/sr:unitAbbreviation')) ? $xps->findvalue('./sr:variable/sr:units/sr:unitsAbbreviation') : $xps->findvalue('./sr:variable/sr:units/sr:unitAbbreviation');
						$row{'IsRegular'} = (!defined $xps->findvalue('./sr:timeScale/@isRegular')) ? $xps->findvalue('./sr:timeScale/sr:isRegular') : $xps->findvalue('./sr:timeScale/@isRegular');
						$row{'TimeUnitName'} = $xps->findvalue('./sr:timeScale/sr:unit/sr:unitName');
						$row{'TimeUnitAbbreviation'} = $xps->findvalue('./sr:timeScale/sr:unit/sr:unitAbbreviation');
						$row{'TimeSupport'} = $xps->findvalue('./sr:timeScale/sr:timeSupport');
						$row{'Speciation'} = $xps->findvalue('./sr:variable/sr:speciation');
						$row{'NoDataValue'} = $xps->findvalue('./sr:variable/sr:noDataValue');
						$row{'MethodID'} = $xps->findvalue('./sr:method/@methodID');
						$row{'MethodCode'} = $xps->findvalue('./sr:methodCode');
						$row{'MethodDescription'} = $xps->findvalue('./sr:method/sr:methodDescription');
						$row{'MethodLink'} = $xps->findvalue("./sr:methodLink");
						$row{'SourceID'} = $xps->findvalue('./sr:source/@sourceID');
						$row{'Organization'} = $xps->findvalue('./sr:source/sr:organization');
						$row{'SourceDescription'} = $xps->findvalue('./sr:source/sr:sourceDescription');
						$row{'Citation'} = $xps->findvalue('./sr:source/sr:citation');
						$row{'QualityControlLevelID'} = $xps->findvalue('./sr:qualityControlLevel/@qualityControlLevelID');
						$row{'QualityControlLevelCode'} = $xps->findvalue('./sr:qualityControlLevelCode');
						$row{'QualityControlLevelDefinition'} = $xps->findvalue('./sr:QualityControlLevel');
						$row{'ValueCount'} = $xps->findvalue('./sr:valueCount');
						if($xps->exists('./sr:variableTimeInterval')) {
							$row{'BeginDateTime'} = $xps->findvalue('./sr:variableTimeInterval/sr:beginDateTime');
							$row{'EndDateTime'} = $xps->findvalue('./sr:variableTimeInterval/sr:endDateTime');
							$row{'BeginDateTimeUTC'} = $xps->findvalue('./sr:variableTimeInterval/sr:beginDateTimeUTC');
							$row{'EndDateTimeUTC'} = $xps->findvalue('./sr:variableTimeInterval/sr:endDateTimeUTC');
						} else {
							$row{'BeginDateTime'} = $xps->findvalue('./sr:beginDateTime');
							$row{'EndDateTime'} = $xps->findvalue('./sr:endDateTime');
							$row{'BeginDateTimeUTC'} = $xps->findvalue('./sr:beginDateTimeUTC');
							$row{'EndDateTimeUTC'} = $xps->findvalue('./sr:endDateTimeUTC');
						}
						%{$result[$i]} = %row;
						$i++;
					}
					
				} else {
					%{$result[$i]} = %row;
					$i++;
					#~ %{$result[$i]} = ("SiteName"=>$SiteName, "SiteCode"=>$SiteCode, "Network"=>$Network, "SiteID"=>$SiteID, "Longitude"=>$Longitude, "Latitude"=>$Latitude, "Elevation"=>$Elevation, "Country"=>$Country, "State"=>$State, "County"=>$County, "Comments"=>$Comments);
				}
			}
		#~ } 
		#~ case "siteResponse" {
			#~ my @SiteInfo = $xpc->findnodes("//sr:siteInfo"); # $xpc->find("//gsr:siteInfo",$doc);
			#~ my $N = @SiteInfo;
			#~ print STDERR "found $N sites\n";
			#~ #my @Sites;
			#~ #my $i=0;
			#~ #foreach my $site (@SiteInfo) {
			#~ my $site = $SiteInfo[0]; 
			#~ my $xpcc = XML::LibXML::XPathContext->new($site);
			#~ $xpcc->registerNs("sr","http://www.cuahsi.org/waterML/1.1/");
			#~ my $SiteName = $xpcc->findvalue('./sr:siteName');
			#~ my $SiteCode = $xpcc->findvalue('./sr:siteCode');
			
			#~ my $Network = $xpcc->findvalue('./sr:siteCode/@network');
			#~ my $SiteID = $xpcc->findvalue('./sr:siteCode/@siteID');
			#~ my $Latitude = $xpcc->findvalue('./sr:geoLocation/sr:geogLocation/sr:latitude');
			#~ my $Longitude = $xpcc->findvalue('./sr:geoLocation/sr:geogLocation/sr:longitude');
			#~ my $Elevation = $xpcc->findvalue('./sr:elevation_m');
			#~ my $Country = $xpcc->findvalue('./sr:siteProperty[@title="Country"]');
			#~ my $State = $xpcc->findvalue('./sr:siteProperty[@title="State"]');
			#~ my $County = $xpcc->findvalue('./sr:siteProperty[@title="County"]');
			#~ my $Comments = $xpcc->findvalue('./sr:siteProperty[@title="Site Comments"]');
			#~ %{$result[0]} = ("SiteName"=>$SiteName, "SiteCode"=>$SiteCode, "Network"=>$Network, "SiteID"=>$SiteID, "Longitude"=>$Longitude, "Latitude"=>$Latitude, "Elevation"=>$Elevation, "Country"=>$Country, "State"=>$State, "County"=>$County, "Comments"=>$Comments);
		#~ #		$i++;
		#~ #	}
		#~ }
	} elsif($xpc->exists("//sr:variablesResponse")) {
		#~ my $name = $top->item(0)->nodeName();
		#~ print STDERR $name . "\n"; exit;
		 #~ case "variablesResponse" {
			my @Variable = $xpc->findnodes("//sr:variable"); # $xpc->find("//gsr:siteInfo",$doc);
			my $N = @Variable;
			print STDERR "found $N variables\n";
			my $bigData = 10000;
			if ($N > $bigData) {
				print STDERR "processing Variables...\n";
			}
			my $i=0;
			foreach my $var (@Variable) {
				my %row;
				my $xpcc = XML::LibXML::XPathContext->new($var);
				$xpcc->registerNs("sr","http://www.cuahsi.org/waterML/1.1/");
				$row{'VariableCode'} = $xpcc->findvalue('./sr:variableCode');
				$row{'VariableName'} = $xpcc->findvalue('./sr:variableName');
				$row{'Vocabulary'} = $xpcc->findvalue('./sr:variableCode/@vocabulary');
				$row{'FullVariableCode'} = ( $row{'Vocabulary'} ne "" ) ? ( $row{'Vocabulary'} . ":" . $row{'VariableCode'} ) : $row{'VariableCode'};
				$row{'ValueType'} = $xpcc->findvalue('./sr:valueType');
				$row{'DataType'} = $xpcc->findvalue('./sr:dataType');  
				$row{'GeneralCategory'} = $xpcc->findvalue('./sr:generalCategory'); 
				$row{'SampleMedium'} = $xpcc->findvalue('./sr:sampleMedium');
    #~ if (version == "1.1") {
				#~ $row{'UnitID'} = (!defined $xpcc->findvalue('./sr:unit/@unitID')) ? (!defined $xpcc->findvalue('./sr:units/@unitsID')) ? $xpcc->findvalue('./sr:unit/@unitID') : $xpcc->findvalue('./sr:units/@unitsID') : $xpcc->findvalue('./sr:unit/@unitID');
				$row{'UnitName'} = (!defined $xpcc->findvalue('./sr:unit/sr:unitName')) ? (!defined $xpcc->findvalue('./sr:units/sr:unitName')) ? $xpcc->findvalue('./sr:unit/sr:unitsName') : $xpcc->findvalue('./sr:units/sr:unitName') : $xpcc->findvalue('./sr:unit/sr:unitName');
				$row{'UnitType'} = (!defined $xpcc->findvalue('./sr:unit/sr:unitType')) ? $xpcc->findvalue('./sr:unit/sr:unitsType') : $xpcc->findvalue('./sr:unit/sr:unitType');
				$row{'UnitAbbreviation'} = (!defined $xpcc->findvalue('./sr:unit/sr:unitAbbreviation')) ? $xpcc->findvalue('./sr:unit/sr:unitsAbbreviation') : $xpcc->findvalue('./sr:unit/sr:unitAbbreviation');
				$row{'UnitCode'} = (!defined $xpcc->findvalue('./sr:unit/sr:unitCode')) ? $xpcc->findvalue('./sr:units/@unitsCode') : $xpcc->findvalue('./sr:unit/sr:unitCode');
				#~ $row{'FullUnitCode'} = ( $row{'Vocabulary'} ne "" ) ? ($row{'UnitCode'} ne "") ? ( $row{'Vocabulary'} . ":" . $row{'UnitCode'} ) : ( $row{'Vocabulary'} . ":" . $row{'UnitID'} )  : ($row{'UnitCode'} ne "") ? $row{'UnitCode'} : $row{'UnitID'};
				$row{'IsRegular'} = (!defined $xpcc->findvalue('./sr:timeScale/@isRegular')) ? $xpcc->findvalue('./sr:timeScale/sr:isRegular') : $xpcc->findvalue('./sr:timeScale/@isRegular');
				$row{'TimeUnitName'} = $xpcc->findvalue('./sr:timeScale/sr:unit/sr:unitName');
				$row{'TimeUnitID'} = $xpcc->findvalue('./sr:timeScale/sr:unit/@unitID');
				$row{'TimeUnitAbbreviation'} = $xpcc->findvalue('./sr:timeScale/sr:unit/sr:unitAbbreviation');
				$row{'TimeSupport'} = $xpcc->findvalue('./sr:timeScale/sr:timeSupport');
				$row{'NoDataValue'} = $xpcc->findvalue('./sr:noDataValue');
				%{$result[$i]} = %row; # ("VariableCode"=>$VariableCode, "VariableName"=>$VariableName, "FullVariableCode"=>$FullVariableCode, "ValueType"=>$ValueType, "DataType"=>$DataType, "GeneralCategory"=>$GeneralCategory, "SampleMedium"=>$SampleMedium, "UnitName"=>$UnitName, "UnitType"=>$UnitType, "UnitAbbreviation"=>$UnitAbbreviation, "IsRegular"=>$IsRegular, "TimeUnitName"=>$TimeUnitName, "TimeUnitAbbreviation"=>$TimeUnitAbbreviation, "TimeSupport"=>$TimeSupport, "NoDataValue"=>$NoDataValue);
				$i++;
			}
	} elsif($xpc->exists('//sr:timeSeriesResponse')) {
		#~ } case "timeSeriesResponse" {
			my @Values = $xpc->findnodes("//sr:value"); # $xpc->find("//gsr:siteInfo",$doc);
			my $N = @Values;
			print STDERR "found $N Values\n";
			my $bigData = 10000;
			if ($N > $bigData) {
				print STDERR "processing DataValues...\n";
			}
			#### LEE METADATA ###
			if($xpc->exists('//sr:values/sr:source')) {
				$metadata{"source"}{sourceID} = $xpc->findvalue('//sr:values/sr:source/@sourceID'); 
				$metadata{"source"}{Organization} = $xpc->findvalue('//sr:values/sr:source/sr:organization'); 
				$metadata{"source"}{SourceCode} = $xpc->findvalue('//sr:values/sr:source/sr:sourceCode'); 
				$metadata{"source"}{SourceDescription} = $xpc->findvalue('//sr:values/sr:source/sr:sourceDescription'); 
				$metadata{"source"}{SourceLink} = $xpc->findvalue('//sr:values/sr:source/sr:sourceLink'); 
				$metadata{"source"}{Citation} = $xpc->findvalue('//sr:values/sr:source/sr:citation'); 
				if($xpc->exists('//sr:values/sr:source/sr:metadata')) {
					$metadata{"source"}{"Metadata"}{TopicCategory} = $xpc->findvalue('//sr:values/sr:source/sr:metadata/sr:topicCategory'); 
					$metadata{"source"}{"Metadata"}{Title} = $xpc->findvalue('//sr:values/sr:source/sr:metadata/sr:title'); 
					$metadata{"source"}{"Metadata"}{Abstract} = $xpc->findvalue('//sr:values/sr:source/sr:metadata/sr:abstract'); 
					$metadata{"source"}{"Metadata"}{ProfileVersion} = $xpc->findvalue('//sr:values/sr:source/sr:metadata/sr:profileVersion'); 
					$metadata{"source"}{"Metadata"}{MetadataLink} = $xpc->findvalue('//sr:values/sr:source/sr:metadata/sr:metadataLink'); 
				}
				if($xpc->exists('//sr:values/sr:source/sr:contactInformation')) {
					$metadata{"source"}{"ContactDescription"}{ContactName} = $xpc->findvalue('//sr:values/sr:source/sr:contactDescription/sr:contactName'); 
					$metadata{"source"}{"ContactDescription"}{TypeOfContact} = $xpc->findvalue('//sr:values/sr:source/sr:contactDescription/sr:typeOfContact'); 
					$metadata{"source"}{"ContactDescription"}{Email} = $xpc->findvalue('//sr:values/sr:source/sr:contactDescription/sr:email'); 
					$metadata{"source"}{"ContactDescription"}{Phone} = $xpc->findvalue('//sr:values/sr:source/sr:contactDescription/sr:phone'); 
					$metadata{"source"}{"ContactDescription"}{Address} = $xpc->findvalue('//sr:values/sr:source/sr:contactDescription/sr:address'); 
				}
			}
			if($xpc->exists('//sr:values/sr:method')) {
				$metadata{"method"}{methodID} = $xpc->findvalue('//sr:values/sr:method/@methodID'); 
				$metadata{"method"}{methodCode} = $xpc->findvalue('//sr:values/sr:method/sr:methodCode'); 
				$metadata{"method"}{methodDescription} = $xpc->findvalue('//sr:values/sr:method/sr:methodDescription'); 
				$metadata{"method"}{methodLink} = $xpc->findvalue('//sr:values/sr:method/sr:methodLink'); 
				#~ $metadata{"method"}{fullMethodcode} = ($xpc->findvalue('//sr:values/sr:source/)
			}
			#### LEE VALORES ###
			my $i=0;
			foreach my $val (@Values) {
				my %row;
				my $xpcc = XML::LibXML::XPathContext->new($val);
				$xpcc->registerNs("sr","http://www.cuahsi.org/waterML/1.1/");
				$row{'DateTimeUTC'} = $xpcc->findvalue('./@dateTimeUTC');
				#~ $DateTimeUTC = as.POSIXct(DateTimeUTC, format="%Y-%m-%dT%H:%M:%S", tz="GMT")
				$row{'UTCOffset'} = $xpcc->findvalue('./@timeOffset');
      #~ UTCOffset <- ifelse(grepl(":", UTCOffset),
                          #~ as.numeric(substr(UTCOffset, nchar(UTCOffset)-4, nchar(UTCOffset)-3)),
                          #~ as.numeric(UTCOffset))
      #~ utcDiff = as.difftime(UTCOffset, units="hours")
      #~ DateTime = as.POSIXct(DateTimeUTC + utcDiff)
				$row{'DateTime'} = $xpcc->findvalue('./@dateTime');
				$row{'CensorCode'} = $xpcc->findvalue('./@censorCode');
				$row{'MethodCode'} = $xpcc->findvalue('./@methodCode');
				$row{'MethodID'} = $xpcc->findvalue('./@methodID');
				$row{'SourceCode'} = $xpcc->findvalue('./@sourceCode');
				$row{'SourceID'} = $xpcc->findvalue('./@sourceID');
				$row{'SampleID'} = $xpcc->findvalue('./@sampleID');
				$row{'LabSampleCode'} = $xpcc->findvalue('./@labSampleCode');
				$row{'QualityControlLevelCode'} = $xpcc->findvalue('./@qualitycontrolLevelCode');
				$row{'DataValue'} = $val->textContent();
				%{$result[$i]} = %row; # ("DateTimeUTC"=>$DateTimeUTC, "UTCOffset"=>$UTCOffset, "DateTime"=>$DateTime, "CensorCode"=>$CensorCode, "MethodCode"=>$MethodCode, "SourceCode"=>$SourceCode, "LabSampleCode"=>$LabSampleCode, "QualityControlLevelCode"=>$QualityControlLevelCode, "DataValue"=>$DataValue);
				$i++;
			}
		#~ } else {
			#~ die "WaterML Response tag not found";
		#~ }
	#~ } 
	} else {
		die "WaterML Response tag not found";
	}
	
	my $sep = (defined $options{"sep"}) ? substr($options{"sep"},0,1) : ",";
	if($output_format eq "json") {
		if(%metadata) {
			my %obj = %metadata;
			$obj{Values} = [@result];
			return toJSON(\%obj);
		} else {
			return toJSON(\@result);
		}
	} elsif ($output_format eq "json_pretty") {
		if(%metadata) {
			my %obj = %metadata;
			$obj{Values} = [@result];
			return encode('utf-8',toJSON(\%obj,1));
		} else {
			return encode('utf-8',toJSON(\@result,1));
		}
	} elsif ($output_format eq "csv") {
		my %opts = ("sep"=>$sep);
		if(%metadata) {
			return encode('utf-8',toText(\%metadata) . "\n#VALUES----------------------\n" . toCSV(\@result,\%opts) );
		} else {
			return encode('utf-8',toCSV(\@result,\%opts));
		}
	} elsif ($output_format eq "csv_pretty") {
		my %opts = ("pretty"=>1,"sep"=>$sep);
		if(%metadata) {
			return encode('utf-8',toText(\%metadata) . "\n#VALUES----------------------\n" . toCSV(\@result,\%opts) );
		} else {
			return encode('utf-8',toCSV(\@result,\%opts));
		}
	} else {
		if(%metadata) {
			my %obj = %metadata;
			$obj{Values} =[@result];
			print STDERR "parseWML: returning hashref with property Values\n";
			return \%obj;
		} else {
			my $Nres = @result;
			print STDERR "parseWML: returning arrayref of $Nres elements\n";
			return \@result; #, @SiteCode, @Network, @SiteID];
		}
	}
}

=head2 MakeWOFRequest

_[0]: server
_[1]: request [ GetSites | GetSiteInfo | GetVariables | GetValues ]
_[2]: parameters [ depende de request, leer documentaacion ]
_[3]: options [ no_proxy=>0 ]

returns waterml string

=cut

sub MakeWOFRequest {
	my $namespace = "http://www.cuahsi.org/his/1.1/ws/";
	
	my $server = shift @_;
	if(!defined $server) {
	  die "Falta parametro server";
	}
	my $request = shift @_;
	if(!defined $request) {
	  die "Falta parametro request";
	}	
	my %validRequests = ("GetSites"=>1, "GetSiteInfo"=>1, "GetVariables"=>1, "GetValues"=>1);
	if(!defined %validRequests{$request}) {
		die "Request:$request no valido. Opciones: GetSites | GetSiteInfo | GetVariables | GetValues";
	}
	my %parameters;
	if(defined $_[0]) {
	%parameters = (%parameters,%{shift @_});
	}
	my %options;
	if(defined $_[0]) {
		%options = (%options,%{shift @_});
	}
	my $no_proxy = (defined $options{no_proxy}) ? ($options{no_proxy} =~ /^[sStT1vV]/) ? 1 : 0 : 0;
	#~ my $output_format = (defined $options{output_format}) ? lc($options{output_format}) : "array";
	#~ my %valid_output_formats = ("array"=>1,"json"=>1,"waterml"=>1,"waterml_pretty"=>1, "json_pretty"=>1, "csv"=>1, "csv_pretty"=>1);
	#~ if(!defined $valid_output_formats{$output_format}) {
		#~ die "GetSitesFromWOF: output_format no valido. opciones: array, json, waterml, json_pretty, waterml_pretty, csv, csv_pretty";
	#~ } 
	# declare the default download timeout in seconds
	my $max_timeout = 360;

	# declare empty return data frame
	my %df; 

	# trim any leading and trailing whitespaces in server
	$server  =~ /^\s+|\s+$/;

	my $version="1.1";
	my $validnamespace="http://www.cuahsi.org/his/1.1/ws/";

	# if server ends with ?WSDL or ?wsdl, we assume that service is SOAP
	# otherwise, assume that service is REST
	my $SOAP = 1;

	# if server ends with .asmx, we also assume that the service is SOAP and we add ?WSDL
	$server .= ($server =~ /asmx$/) ? "?WSDL" : "";

	my $url;
	if(($url = $server) =~ s/\?WSDL|\?wsdl//) {
		#~ ($url = $server) =~ s/$1//;
		$SOAP = 1;
	} else {
	# in other cases we leave the URL as it is
		$SOAP = 0;
	}
	#~ print "url:$url\n"; exit;
	my $response;

	#if the service is SOAP:
	if ($SOAP == 1) {
		print STDERR "Is SOAP...($url) \n";
		#~ versionInfo <- WaterOneFlowVersion(server)
		#~ namespace <- versionInfo$Namespace
		#~ version <- versionInfo$Version

	#choose the right SOAP web method based on WaterML version and parameters
	#~ if (version == "1.0") {
      #~ methodName <- "GetSites"

      #~ envelope <- MakeSOAPEnvelope(namespace, methodName)
    #~ } else {
		my $methodName;
		my $envelope;
		switch ($request) {
			case "GetSites" { # | GetSiteInfo | GetVariables | GetValues
				if (!defined $parameters{"west"} || !defined $parameters{"south"} || !defined $parameters{"east"} || !defined $parameters{"north"} ) {
					$methodName = "GetSitesObject";
					$envelope = MakeSOAPEnvelope($namespace, $methodName);
				} else {
					$methodName = "GetSitesByBoxObject";
					my %env_parameters = ("west"=>$parameters{"west"}, "south"=>$parameters{"south"}, "north"=>$parameters{"north"}, "east"=>$parameters{"east"},"IncludeSeries"=>"false");
					$envelope = MakeSOAPEnvelope($namespace, $methodName, \%env_parameters );
				}
			#~ }
				
				#~ my %headers = ("Content-Type" => "text/xml", "SOAPAction" => $SOAPAction);

				print STDERR "downloading sites from: $url ...\n";
			} case "GetSiteInfo" {
				$methodName = "GetSiteInfoObject";
				if(!defined $parameters{"siteCode"}) {
					if(!defined $parameters{"site"}) {
						die "Falta parametro siteCode";
					} else {
						$parameters{"siteCode"}=$parameters{"site"};
					}
				}
				my %env_parameters = ("site"=>$parameters{siteCode});
				$envelope = MakeSOAPEnvelope($namespace,$methodName, \%env_parameters);
				print STDERR "downloading site info from: $url ...\n";
			} case "GetVariables" {
				$methodName = "GetVariableInfoObject";
				my %env_parameters;
				if(defined $parameters{"variableCode"}) {
					 $env_parameters{"variableCode"}=$parameters{"variableCode"};
				} elsif(defined $parameters{"variable"}) {
					 $env_parameters{"variableCode"}=$parameters{"variable"};
				}
				$envelope = MakeSOAPEnvelope($namespace,$methodName, \%env_parameters);
				print STDERR "downloading variables from: $url ...\n";
			} case "GetValues" {
				$methodName = "GetValuesObject";
				my %env_parameters;
				if(defined $parameters{"variableCode"}) {
					 $env_parameters{"variable"}=$parameters{"variableCode"};
				} elsif(defined $parameters{"variable"}) {
					 $env_parameters{"variable"}=$parameters{"variable"};
				} else {
					die "Falta parametro variableCode";
				}
				if(defined $parameters{"siteCode"}) {
					 $env_parameters{"location"}=$parameters{"siteCode"};
				} elsif(defined $parameters{"site"}) {
					 $env_parameters{"location"}=$parameters{"site"};
				} elsif(defined $parameters{"location"}) {
					$env_parameters{"location"}=$parameters{"location"};
				} else {
					die "Falta parametro siteCode";
				}
				if(!defined $parameters{"startDate"} || !defined $parameters{"endDate"}) {
					die "Falta parametro startDate y/o endDate";
				}
				%env_parameters = (%env_parameters,"startDate"=>$parameters{"startDate"},"endDate"=>$parameters{"endDate"});
				$envelope = MakeSOAPEnvelope($namespace,$methodName, \%env_parameters);
				print STDERR "downloading data values from: $url ...\n";
			}
		}
		my $SOAPAction = "$namespace$methodName";
		my $downloaded = 0;
		my $status;
		my $userAgent = LWP::UserAgent->new(agent => "perl post"); 
		$userAgent->timeout(30);
		if(defined $ENV{http_proxy}  && $no_proxy == 0) {
			$userAgent->proxy('http', $ENV{http_proxy});
		}
		my $request = HTTP::Request->new(
			POST => $url,
			HTTP::Headers->new(
			'SOAPAction' => $SOAPAction,
			'Content-Type' => 'text/xml')
			);
		$request->content($envelope);
		#~ print STDERR "\n-----\n".$envelope."\n-----\n";
		#~ $request->content_type("text/xml; charset=utf-8");
		my $start=time();
		$response = $userAgent->request($request);
		if($response->code == 200) {
			print STDERR "Descarga exitosa ...\n"; #$response->as_string;
		}
		else {
			print STDERR "Error en la descarga: " . $response->error_as_HTML . "\n";
		}
		#~ my $content = $ua->request($request)->as_string(); 
		$status = $response->code;
		$downloaded = 1;
		#~ if (!downloaded) {
		  #~ attr(df, "download.time") <- download.time["elapsed"]
		  #~ attr(df, "download.status") <- err
		  #~ attr(df, "parse.time") <- NA
		  #~ attr(df, "parse.status") <- NA
		  #~ return(df)
		#~ }

		my $status_code = $response->message;
		my $end=time();
		my $elapsed = $end - $start;
		print STDERR "download time: $elapsed seconds, status: $status_code\n";

		#in case of server error, print the error and exit
		if (lc($status_code) eq "server error") {
			print STDERR $response->as_string() . "\n";
			print STDERR "download.time: $elapsed\n";
			print STDERR "download.status: $status\n";
			print STDERR "parse.time: NA\n";
			print STDERR "parse.status: NA\n";
			die "server error";
		}
	} else {
		# If the service is REST:
		switch ($request) {
			case "GetSites" { # | GetSiteInfo | GetVariables | GetValues
				$server =~ s/\?$//;
				$server =~ s/\/$//;
				$server =~ s/plwof\/ws$/plwof\/ws\/GetSites/; 	## caso especial: plwof 
				if (defined $parameters{"west"} && defined $parameters{"south"} && defined $parameters{"east"} && defined $parameters{"north"} ) {
					my $uri = URI->new($server);
					$uri->query_form("west"=>$parameters{"west"}, "south"=>$parameters{"south"}, "east"=>$parameters{"east"}, "north"=>$parameters{"north"});
					$url = $uri; # "?west=" . $parameters{"west"} . "&south=" . $parameters{"south"} . "&east=" . $parameters{"east"} . "&north=" . $parameters{"north"};
				} else {
					$url = $server;
				}
				print STDERR "downloading sites from: $url ...\n";
			} case "GetSiteInfo" {
				$server =~ s/\?$//;
				$server =~ s/\/$//;
				$server =~ s/plwof\/ws$/plwof\/ws\/GetSiteInfo/; 	## caso especial: plwof 
				if(!defined $parameters{"siteCode"}) {
					if(!defined $parameters{"site"}) {
						die "Falta parametro siteCode";
					} else {
						$parameters{"siteCode"} = $parameters{"site"};
					}
				}
				my $uri = URI->new($server);
				$uri->query_form("site"=>$parameters{"siteCode"});
				$url = $uri;
				print STDERR "downloading site info from: $url ...\n";
			} case "GetVariables" {
				$server =~ s/\?$//;
				$server =~ s/\/$//;
				$server =~ s/plwof\/ws$/plwof\/ws\/GetVariables/; 	## caso especial: plwof 
				my $uri = URI->new($server);
				if(defined $parameters{"variableCode"}) {
					$uri->query_form("variableCode"=>$parameters{"variableCode"});
				} elsif(defined $parameters{"variable"}) {
					$uri->query_form("variableCode"=>$parameters{"variable"});
				}
				$url = $uri;
				print STDERR "downloading variables from: $url ...\n";
			} case "GetValues" {
				$server =~ s/\?$//;
				$server =~ s/\/$//;
				$server =~ s/plwof\/ws$/plwof\/ws\/GetValues/; 	## caso especial: plwof 
				my $siteCode = (defined $parameters{"siteCode"}) ? $parameters{"siteCode"} : (defined $parameters{"site"}) ? $parameters{"site"} : (defined $parameters{"location"}) ? $parameters{"location"} : "";
				my $variableCode = (defined $parameters{"variableCode"} ) ? $parameters{"variableCode"} : (defined $parameters{"variable"}) ? $parameters{"variable"} : "";
				if( $siteCode eq "" || $variableCode eq "" || !defined $parameters{"startDate"} || !defined $parameters{"endDate"}) {
					die "Falta parametro siteCode y/o variableCode y/o startDate y/o endDate";
				}
				my $uri = URI->new($server);
				$uri->query_form("siteCode"=>$siteCode,"variableCode"=>$variableCode,"startDate"=>$parameters{"startDate"},"endDate"=>$parameters{"endDate"});
				$url = $uri;
				print STDERR "downloading data values from: $url ...\n";
			}
		}

		my $downloaded = 0;
		my $status;
			#~ print $url; exit;
		my $userAgent = LWP::UserAgent->new(agent => "perl get"); 
		if(defined $ENV{http_proxy} && $no_proxy == 0) {
			$userAgent->proxy('http', $ENV{http_proxy});
		}
		my $request = HTTP::Request->new(GET => $url);
		my $start=time();
		$response = $userAgent->request($request);
		if($response->code == 200) {
			print STDERR "Descarga exitosa ...\n"; #$response->as_string;
		}
		else {
			print STDERR "Error en la descarga: " . $response->error_as_HTML . "\n";
		}
		$status = $response->code;
		$downloaded = 1;
		#~ if (!downloaded) {
		  #~ attr(df, "download.time") <- download.time["elapsed"]
		  #~ attr(df, "download.status") <- err
		  #~ attr(df, "parse.time") <- NA
		  #~ attr(df, "parse.status") <- NA
		  #~ return(df)
		#~ }

		my $status_code = $response->message;
		my $end=time();
		my $elapsed = $end - $start;
		print STDERR "download time: $elapsed seconds, status: $status_code\n";

		#in case of server error, print the error and exit
		if (lc($status_code) eq "server error") {
			print STDERR $response->as_string() . "\n";
			print STDERR "download.time: $elapsed\n";
			print STDERR "download.status: $status\n";
			print STDERR "parse.time: NA\n";
			print STDERR "parse.status: NA\n";
			die "server error";
		}
	}
	return  encode('utf-8',$response->decoded_content()); # decode('utf-8',$response->decoded_content()); # $response->decoded_content();
}

#~ =head2 funcion WaterMLVersion

#~ #' WaterMLVersion
#~ #'
#~ #' A helper function that finds out the WaterML version from
#~ #' the WaterML document. By default it checks for "http://www.opengis.net/waterml/2.0"
#~ #' Otherwise it tries to detect "http://www.cuahsi.org/waterML/1.1/" (for WaterML 1.1) or
#~ #' "http://www.cuahsi.org/WaterML/1.0/" (for WaterML 1.0)
#~ #'
#~ #' @param doc The XML document object
#~ #' @return A character with the WaterML version: either 1.0, 1.1, or 2.0
#~ #' @keywords WaterML
#~ #' @export
#~ #' @examples
#~ #' library(httr)
#~ #' library(XML)
#~ #' url <- "http://www.waterml2.org/KiWIS-WML2-Example.wml"
#~ #' response <- GET(url)
#~ #' doc <- xmlParse(response)
#~ #' version <- WaterMLVersion(doc)

#~ =cut

#~ sub WaterMLVersion {

  #~ #check namespaces
  #~ my ns_list <- xmlNamespaceDefinitions(doc, simplify=TRUE)
  #~ namespaces <- as.character(unlist(ns_list))

  #~ wml_2_0_namespace <- "http://www.opengis.net/waterml/2.0"
  #~ wml_1_1_namespace <- "http://www.cuahsi.org/waterML/1.1/"
  #~ wml_1_0_namespace <- "http://www.cuahsi.org/waterML/1.0/"

  #~ if (wml_2_0_namespace %in% namespaces) {
    #~ return ("2.0")
  #~ }

  #~ if (wml_1_1_namespace %in% namespaces) {
    #~ return ("1.1")
  #~ }

  #~ if (wml_1_0_namespace %in% namespaces) {
    #~ return ("1.0")
  #~ }

  #~ #if not found assume 1.1
  #~ return ("1.1")
#~ }
