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
use DateTime::Format::Strptime;
my $strp = DateTime::Format::Strptime->new(
        pattern   => '%Y/%m/%d %H:%M:%S',
    );
my $dstrp = DateTime::Format::Strptime->new(
        pattern  ='%Y/%m/%d';


our($opt_f);
getopts("f:d:");

if(!$opt_f) {
die "falta -f file";
}
if(!$opt_d) {
die "falta -d tmp_dir";
}

if(!-e $opt_f) {
die "error archivo no encontrado";
}
if(!-d $opt_d) {
	die "directorio $opt_d no encontrado";
}
`ssconvert -S -T Gnumeric_stf:stf_csv $opt_f $opt_d/datadump.csv`;
opendir(my $dh,$opt_d) or die "no se pudo abrir el directorio $opt_d";
while(readdir $dh) {
	if($_ !~ /^datadump.csv.\d+$/) { next; }
	open(my $file,$opt_d/$_);
	while my $line (<$file>) {
		print "$line\n";
		chomp $line;
		my @a=split(/,/,$line);
		my $datetime;
		if($a[2] !~ /^\d\d\d\d\/\d\d\/\d\d\s\d\d:\d\d:\d\d$/) {
			 if($a[2] !~ /^\d\d\d\d\/\d\d\/\d\d/) { next; 
			} else {
				$datetime = $dstrp->parse_datetime($a[2]);
			}
		} else {
			$datetime = $strp->parse_datetime($a[2]);
		}
		if($a[3] !~ /^\d+(\.\d+)?$/) { next; }
		my $value = $a[3];
		if($a[4]!~/^\d+$/) { next; }
		my $sitecode = $a[4];
		
	}
}
