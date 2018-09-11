# lilbambu


/lib/psql
- Esquema de base de datos PostgreSQL para un modelo de datos basado en ODM (Horsburgh, J. S., D. G. Tarboton, D. R. Maidment, and I. Zaslavsky (2008) A relational model for envi-
ronmental and water resources data Water Resources Research, 44, W05406, doi:10.1029/2007WR006392.)
	requiere: PostgreSQL >=9.5

/lib/perl
- módulo Perl con funciones de carga y extracción de registros a la Base de Datos utilizando formatos interoperables
	requiere: Perl>=5.22.1
		módulos Perl: utf8 Encode  Getopt::Std Switch Env CGI JSON use CGI Astro::Time  DBI utf8 autobox::universal Config::IniFiles HTTP::Request LWP::UserAgent XML::LibXML

/api/desktop
- aplicación Perl de escritorio para administrar la Base de Datos mediante comandos en un terminal

/api/webapps/wateroneflow
- aplicación web (Perl+CGI) que crea un punto de acceso interoperable (WaterOneFlow/WaterML) para extracción de registros de la Base de Datos mediante HTTP/GET o HTTP/POST y carga de registros mediante HTTP/POST. En el caso de POST el cliente debe adjuntar un archivo JSON
	requiere: Tomcat8

/config/lilbambu.ini
- archivo de configuración de la conexión a Base de Datos

/install/install.sh
- ejecutable de instalación
