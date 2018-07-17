# APT
# sudo apt update
# sudo apt install perl5 postgresql tomcat8 cpanp

# PERL
# export PERL5LIB=$PERL5LIB:/home/jbianchi/lilbambu/lib/perl
# cpanp -i POSIX utf8 Encode  Getopt::Std Switch Env CGI JSON use CGI Astro::Time  DBI utf8 autobox::universal Config::IniFiles HTTP::Request LWP::UserAgent XML::LibXML

#POSTGRESQL
# sudo su postgres
# psql -c "create user leyden with superuser"
# exit
# createdb ODM
# psql ODM -f /home/jbianchi/lilbambu/lib/psql/ODMforPSQL_1.1_dump.sql
# psql ODM -c "create user sololectura with login"
# psql ODM -c "alter user sololectura with password 'alturas'"
# psql ODM -c "grant select on all tables is schema public to sololectura" 
# edit /etc/postgresql/9.6/main/pg_hba.conf :
	#  # "local" is for Unix domain socket connections only
	#	#local   all             all                                     peer   <- comentar esta linea
	#local   all             leyden                                  peer       <- agregar esta
	#local   ODM             sololectura                             password   <- y esta
# edit /home/jbianchi/lilbambu/config/lilbambu.ini
#  setear parametros de conexión a DB ODM

# TOMCAT
# edit /var/lib/tomcat8/conf/web.xml   descomentar esta parte:
#    <servlet>
        #~ <servlet-name>cgi</servlet-name>
        #~ <servlet-class>org.apache.catalina.servlets.CGIServlet</servlet-class>
        #~ <init-param>
          #~ <param-name>cgiPathPrefix</param-name>
          #~ <param-value>WEB-INF/cgi</param-value>
        #~ </init-param>
        #~ <load-on-startup>5</load-on-startup>
    #~ </servlet>
#sudo service tomcat8 restart
