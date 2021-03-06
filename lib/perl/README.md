#/lib/perl

Esta carpeta contiene el módulo Perl que define las funciones de acceso a la Base de Datos ODM PSQL. Dichas funciones son utilizadas por la aplicación de escritorio y la aplicación web para extraer o insertar registros en la Base de Datos. Para poder utilizarlo debe agregar esta carpeta a @INC, por ejemplo:
  export PERL5LIB=$PERL5LIB:/home/user/lilbambu/lib/perl 

odm_load.pm documentation :

NAME
    odm_load package

SYNOPSIS
            use odm_load;
            my $dbh=odm_load::dbConnect;
            my %params=("VariableCode"=>"2","VariableName"=>"Gage height","VariableUnitsID"=>52);
            my @opts=("-U");
            my $status=odm_load::addVariable($dbh,\%params,\@opts);

DESCRIPTION
            Este modulo sirve para insertar, editar y seleccionar registros de la base de datos ODM/PGSQL

  FUNCION dbConnect()
            $_[0] => SCALAR   configuration file location .ini 
            $_[1] => HASH (DBUSER=>username,DBPASSWORD=>pass) (opcional, override conf file)

   returns
             database handle object (from DBI->connect)

  FUNCION addVariables()
            $_[0] => database handle object (from DBI->connect)
            $_[1] => HASHREF     parametros: ( "VariableCode"=> "10" , "VariableName"=> "Discharge","VariableUnitsID"=>36)
            $_[2] => ARRAYREF  options   -U => on conflict action do update

   returns
            {"status":"200 OK","VariableID":"$inserted_variable_id"} o {"status":"400 Bad Request"}

  funcion columnTypeCheck()
            $_[0] => Column Names ARRAY
            $_[1] => Column Types ARRAY
            $_[2] => input Columns HASH
            $_[3] => 1:allRequired, 2:checkValid, 0:none

   returns
            HASH of valid Column names=>{types}

  funcion GetVariables()
            $_[0] => database connection handler
            $_[1] => parameters HASH [valid params=  VariableCode"=>"STRING","VariableName"=>"STRING","VariableUnitsID"=>"INTEGER", "SampleMedium"=>"STRING","ValueType"=>"STRING","IsRegular"=>"BOOLEAN","DataType"=>"STRING", "GeneralCategory"=>"STRING","TimeSupport"=>"INTEGER","TimeUnitsID"=>"INTEGER
            $_[2] => options ARRAY [valid opts -f=[wml,json,fwt,csv]  ]

   returns
            VariablesResponse STRING in requested format (wml,sjon,fwt,csv) o {"status":"400 Bad Request"}

  funcion addSource()
            $_[0] => database connection handler
            $_[1] => parameters HASH [valid params=  "SourceID"=>"INTEGER","Organization"=>"STRING","SourceDescription"=>"STRING","SourceLink"=>"STRING","ContactName"=>"STRING","Phone"=>"STRING", "Email"=>"STRING","Address"=>"STRING","City"=>"STRING","State"=>"STRING","ZipCode"=>"STRING","Citation"=>"STRING","MetadataID"=>"INTEGER"
            $_[2] => options ARRAY [valid opts -U]  ]

   returns
            {"status":"200 OK","SourceID":"$inserted_source_id"} o {"status":"400 Bad Request"}

  funcion GetSources()
            $_[0] => database connection handler
            $_[1] => parameters HASH [valid params=  "SourceID"=>"INTEGER","Organization"=>"STRING","SourceDescription"=>"STRING","SourceLink"=>"STRING","ContactName"=>"STRING","Phone"=>"STRING", "Email"=>"STRING","Address"=>"STRING","City"=>"STRING","State"=>"STRING","ZipCode"=>"STRING","Citation"=>"STRING","MetadataID"=>"INTEGER"
            $_[2] => options ARRAY [valid opts -f [wml,json,fwt,csv]  ]

   returns
            ArrayOfSourceInfo STRING in requested format (wml,json,fwt,csv) o {"status":"400 Bad Request"}

  funcion makeRestRequest()
            $_[0] => database connection handler
            $_[1] => parameters HASH [valid params=  "Organization"=>"STRING"*,"RequestName"=>"STRING"*,"method"=>"STRING"       *:required
            $_[2] => options ARRAY [valid opts -f]  ]

   returns
            HTTP Response content STRING in requested format (wml) o {"status":"400 Bad Request"}

  funcion GetSourceLink()
            $_[0] => database connection handler
            $_[1] => Organization STRING
            $_[2] => options ARRAY [valid opts -U]

   returns
            STRING SourceLink

  funcion addSite()
            $_[0] => database connection handler
            $_[1] => parameters HASH [valid params=  "Organization"=>"STRING"*,"RequestName"=>"STRING"*,"method"=>"STRING"       *:required
            $_[2] => options ARRAY [valid opts -U]  ]

   returns
            {"status":"200 OK","SiteID":"$inserted_site_id"} o {"status":"400 Bad Request"}

  funcion GetSites
            $_[0] => database connection handler
            $_[1] => parameters HASH [valid params=  "SiteID"=>"INTEGER","SiteCode"=>"STRING","SiteName"=>"STRING","north"=>"FLOAT","south"=>"FLOAT","east"=>"FLOAT","west"=>"FLOAT","SiteType"=>"STRING","State"=>"STRING","County"=>"STRING"]
            $_[2] => options ARRAY [valid opts -f]  ]

   returns
            siteResponse STRING in requested format  or {"status":"400 Bad Request"}

  funcion GetSiteInfo()
            $_[0] => database connection handler
            $_[1] => parameters HASH [valid params=  "SiteCode"=>"STRING"]
            $_[2] => options ARRAY [valid opts -f]  ]

   returns
            SitesResponse STRING in requested format  or {"status":"400 Bad Request"}

  funcion addValues
            $_[0] => database connection handler
            $_[1] => parameters HASH [valid params=  "Values"=>"ARRAY"*,"SiteID"=>"INTEGER"*,"VariableID"=>"INTEGER"*,"MethodID"=>"INTEGER","SourceID"=>"INTEGER"*,"QualityControl"=>"INTEGER","UTCOffset"=>"INTEGER"]    *:required
            $_[2] => options ARRAY [valid opts -U]  ]

   returns
            {"status":"200 OK","ValuesID":[valueID_1,ValuesID2...]}  or {"status":"400 Bad Request"}

  funcion GetValues
            $_[0] => database connection handler
            $_[1] => parameters HASH [valid params=  "SiteCode"=>"STRING"*,"VariableCode"=>"STRING"*,"StartDate"=>"STRING"*,"EndDate"=>"STRING"*]    *:required
            $_[2] => options ARRAY [valid opts -f]  ]

   returns
            timeSeriesResponse STRING in required format  or {"status":"400 Bad Request"}

