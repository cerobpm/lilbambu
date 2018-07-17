#!/usr/bin/perl
use strict;
use warnings;

foreach(`psql meteorology sololectura -h 10.10.9.14 -c "copy(select tabla||':'||unid::text,nombre,st_x(geom),st_y(geom),coalesce(distrito,'Unknown'),coalesce(pais,'Unknown') from estaciones where real=true) to stdout with csv"`)
{
  chomp $_;
  #~ print "$_\n"; next;
  my @a=split(/,/,$_);
  `lilbambu addSite SiteCode=$a[0] SiteName="$a[1]" Longitude=$a[2] Latitude=$a[3] State="$a[4]" Country="$a[5]"`;
 }
