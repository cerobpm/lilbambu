for i in $(psql ODM -c "\d" | grep CV | cut -d\| -f2 | sed 's/\s//g');do echo ".$i."; pg_dump ODM -a -t \"$i\" > ~/lilbambu/lib/psql/$i\_data.sql;done
