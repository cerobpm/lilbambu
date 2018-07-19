#!/usr/bin/perl
use strict;
use warnings;

foreach(`psql meteorology sololectura -h 10.10.9.14 -c "copy (select \\"SiteID\\" from sites_link,series where series.estacion_id=sites_link.unid and var_id=2 and proc_id=1) to stdout with csv"`)
{
	chomp $_;
	`psql meteorology sololectura -h 10.10.9.14 -c "copy (select array_to_json(array_agg(('[' || quote_ident(timestart::text) || ',' || valor || ']')::json)) from sites_link,series,observaciones,valores_num where sites_link.\\"SiteID\\"=$_ and sites_link.unid=series.estacion_id and series.var_id=2  and series.proc_id=1 and observaciones.series_id=series.id and observaciones.id=valores_num.obs_id) to stdout" > addvalues.$_.json`;
	`lilbambu addValues Values=\@addvalues.$_.json SiteID=$_ VariableID=3 SourceID=5`;
	
}
