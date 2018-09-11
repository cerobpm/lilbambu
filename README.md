# lilbambu


/lib/psql/ODMpg.sql
- Esquema de base de datos PostgreSQL para un modelo de datos basado en ODM (Horsburgh, J. S., D. G. Tarboton, D. R. Maidment, and I. Zaslavsky (2008) A relational model for envi-
ronmental and water resources data Water Resources Research, 44, W05406, doi:10.1029/2007WR006392.)
	requiere: PostgreSQL >=9.5

/lib/perl/odm_load.pm
- módulo Perl con funciones de carga y extracción de registros a ODMpg utilizando formatos interoperables
	requiere: Perl>=5.22.1
		módulos Perl: utf8 Encode  Getopt::Std Switch Env CGI JSON use CGI Astro::Time  DBI utf8 autobox::universal Config::IniFiles HTTP::Request LWP::UserAgent XML::LibXML

/lib/perl/plwofclient.pm
- módulo Perl - Cliente web de servicio web WaterOneFlow (ver http://cuahsihis.blogspot.com/2012/11/an-introduction-to-wateroneflow-web.html) basado en el paquete R WaterML (https://cran.r-project.org/package=WaterML) 

/lib/R/*
- Paquetes R con funciones de extracción de registros de la base de datos ODMpg

/bin/lilbambu.pl
- aplicación Perl de escritorio para administrar la Base de Datos mediante comandos en un terminal

/bin/plwof.war
- aplicación web (Perl+CGI) que crea un punto de acceso interoperable (WaterOneFlow/WaterML) para extracción de registros de la Base de Datos mediante HTTP/GET o HTTP/POST y carga de registros mediante HTTP/POST. En el caso de POST el cliente debe adjuntar un archivo JSON
	requiere: Tomcat8

/bin/geoserver.war
- aplicación web Geoserver 2.11.0 con vistas y estilos aplicados a capas de información provenientes de ODMpg

/config/lilbambu.ini
- archivo de configuración de los módulos Perl para la conexión a ODMpg

/install/install.doc
- Instrucciones de instalación
