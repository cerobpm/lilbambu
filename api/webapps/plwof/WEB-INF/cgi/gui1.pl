#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use POSIX qw(strftime);
use DBI;
use utf8;
use Encode;
use Switch;

binmode(STDOUT, ":utf8");

my $host = (defined $ENV{'HTTP_HOST'}) ? $ENV{'HTTP_HOST'} : ""; 


my $q = CGI->new(); 
my @param= $q->param();

my $op = (defined $q->param('op')) ? $q->param('op') : "";


&gui($op);

sub gui {
	my %methods = ( 
	 "GetSiteInfo" => { "validArgs"=> ["site"], "description"=>"Dado un número de sitio, este método devuelve los metadatos del sitio. 'site=value'"},
	 "GetSites"=> { "validArgs"=> [ "site"],"description"=> "Dado un vector de números de sitio, este método devuelve los metadatos de cada uno. Envíe el vector de números de sitios en el formato 'site=value,value,....'. Si se omite, devuelve la lista completa de sitios." } ,
	 "GetValues"=> { "validArgs"=> [ "site","variable","startDate","endDate"],"description"=>"Dado un número de sitio, una variable, una fecha inicial y una fecha final, este método devuelve una serie temporal. 'site=value&amp;variable=value&amp;startDate=YYYMMDD&amp;endDate=YYYYMMDD'" },
	 "GetVariables" => { "validArgs"=> ["VariableID","VariableCode","VariableName","VariableUnitsID","SampleMedium","ValueType","IsRegular","DataType","GeneralCategory","TimeSupport","TimeUnitsID"], "description"=>"Este método devuelve un listado de todas las variables." },
	 "GetSitesByBoxObject" => { "validArgs"=> ["north","south","east","west","includeSeries"]	 , "description"=>"Dados 4 límites en grados decimales de latitud/longitud, este método devuelve los metadatos de los sitios encontrados dentro de los mismos. 'north=value&amp;south&amp;value&amp;west=value&amp;east=value'"} );

	my $head = "  <head>
		<meta charset=\"utf-8\"/>
		<link rel=\"alternate\" type=\"text/xml\" href=\"gui.pl\"/>

		<style type=\"text/css\">
		
			BODY { color: #000000; background-color: white; font-family: ; margin-left: 0px; margin-top: 0px; }
			#content { margin-left: 30px; font-size: .70em; padding-bottom: 2em; }
			A:link { color: #336699; font-weight: bold; text-decoration: underline; }
			A:visited { color: #6699cc; font-weight: bold; text-decoration: underline; }
			A:active { color: #336699; font-weight: bold; text-decoration: underline; }
			A:hover { color: cc3300; font-weight: bold; text-decoration: underline; }
			P { color: #000000; margin-top: 0px; margin-bottom: 12px; font-family: ; }
			pre { background-color: #e5e5cc; padding: 5px; font-family: ; font-size: x-small; margin-top: -5px; border: 1px #f0f0e0 solid; }
			td { color: #000000; font-family: ; font-size: .7em; }
			h2 { font-size: 1.5em; font-weight: bold; margin-top: 25px; margin-bottom: 10px; border-top: 1px solid #003366; margin-left: -15px; color: #003366; }
			h3 { font-size: 1.1em; color: #000000; margin-left: -15px; margin-top: 10px; margin-bottom: 10px; }
			ul, ol { margin-top: 10px; margin-left: 20px; }
			li { margin-top: 10px; color: #000000; }
			font.value { color: darkblue; font: bold; }
			font.key { color: darkgreen; font: bold; }
			.heading1 { color: #ffffff; font-family: ; font-size: 26px; font-weight: normal; background-color: #003366; margin-top: 0px; margin-bottom: 0px; margin-left: -30px; padding-top: 10px; padding-bottom: 3px; padding-left: 15px; width: 105%; }
			.heading2 { font-size: 18 px; padding-top: 5 px; padding-bottom: 3 px; padding-left: 10 px; }
			.button { background-color: #dcdcdc; font-family: ; font-size: 1em; border-top: #cccccc 1px solid; border-bottom: #666666 1px solid; border-left: #cccccc 1px solid; border-right: #666666 1px solid; }
			.frmheader { color: #000000; background: #dcdcdc; font-family: ; font-size: .7em; font-weight: normal; border-bottom: 1px solid #dcdcdc; padding-top: 2px; padding-bottom: 2px; }
			.frmtext { font-family: ; font-size: .7em; margin-top: 8px; margin-bottom: 0px; margin-left: 32px; }
			.frmInput { font-family: ; font-size: 1em; }
			.intro { margin-left: -15px; }
			   
		</style>

		<title>INA SIyAH - Servicio web de datos WaterML</title>
		</head>";

	switch ($_[0]) {
		case "" {
		
		print "<html>

		
		$head
		<body>
			
		<div id=\"content\">

		<p class=\"heading1\">INA SIyAH - Servicio web de datos WaterML</p>
		<br>
	<span id=\"Span1\">
			<p class=\"intro\">Se admiten los siguientes métodos. Para una descripción formal visite <a href=\"http://water.sdsc.edu/waterOneFlow/NWIS/DailyValues.asmx?WSDL\">Service Description</a>.</p>
			
					<ul>
				
					<li>
						<a href=\"GetSiteInfo\">GetSiteInfo</a>
						<span id=\"MethodList_ctl01_Span2\">
							<br>Dado un número de sitio, este método devuelve los metadatos del sitio. 'site=value'
						</span>
					</li>
					<p />
				
					<li>
						<a href=\"GetSites\">GetSites</a>
						<span id=\"MethodList_ctl03_Span2\">
							<br>Dado un vector de números de sitio, este método devuelve los metadatos de cada uno. Envíe el vector de números de sitios en el formato 'site=value,value,....'. Si se omite, devuelve la lista completa de sitios.
						</span>
					</li>
					<li>
						<a href=\"GetSitesByBoxObject\">GetSitesByBoxObject</a>
						<span id=\"MethodList_ctl03_Span2\">
							<br>Dados 4 límites en grados decimales de latitud/longitud, este método devuelve los metadatos de los sitios encontrados dentro de los mismos. 'north=value&amp;south&amp;value&amp;west=value&amp;east=value'
						</span>
					</li>
					<p />
				
					<li>
						<a href=\"GetValues\">GetValues</a>
						<span id=\"MethodList_ctl05_Span2\">
							<br>Dado un número de sitio, una variable, una fecha inicial y una fecha final, este método devuelve una serie temporal. 'site=value&amp;variable=value&amp;startDate=YYYMMDD&amp;endDate=YYYYMMDD'
						</span>
					</li>
					<p />
				
					<li>
						<a href=\"GetVariables\">GetVariables</a>
						<span id=\"MethodList_ctl07_Span2\">
							<br>Este método devuelve un listado de todas las variables.
						</span>
					</li>
					<p />
			
			
					</ul>
				
		</span>";
		} else {
			if(!defined $methods{$_[0]}) {
				err("parametro op incorrecto");
			}
			my $form="	Pruebe llenar los parámetros para crear el URL de descarga:<form name=setargs action=\"$_[0]\" target=_blank><br><ul>";
			foreach(@{$methods{$_[0]}{'validArgs'}}) {
				$form .= "<li>$_:<input type=text name=\"$_\" oninput=\"update_url()\"></li>";
				}
			$form .= "</ul></form>";
			print "<html>

		
		$head
		<body>
			
		<div id=\"content\">

		<p class=\"heading1\">INA SIyAH - Servicio web de datos WaterML</p>
		<br>
	<span id=\"Span1\">
			<p class=\"heading2\">$_[0]</p>
			<p class=\"intro\"> $methods{$_[0]}->{'description'} </p>
			$form
			<p>URL de descarga: <a id=service_url target=_blank href=\"http://$host/plwof/ws/$_[0]?\">http://$host/plwof/ws/$_[0]?</href></p>
			<script language=\"javascript\">
				var update_url = function () {
					var inputs = document.forms.setargs.getElementsByTagName(\"input\");
					var new_url = 'http://$host/plwof/ws/$_[0]?';
					var count = 0;
					for(var h=0; h< inputs.length; h++) {
						if(inputs[h].value != '') {
							if(count > 0) {
								new_url += '&';
							}
							new_url += inputs[h].name + '=' + inputs[h].value;
							count = count + 1;
						}
					}
					document.getElementById('service_url').href = new_url;
					document.getElementById('service_url').innerHTML = new_url;
				};
			</script>
		</body>
	</html>";
		}
	}

			

		

	print "</body>
	</html>";
}
