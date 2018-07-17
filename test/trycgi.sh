curl -X POST -d @getvar.json -H "Content-type: application/json" http://localhost:8080/wateroneflow/GetVariables
curl -X POST -d @addsource.json -H "Content-type: application/json" http://localhost:8080/wateroneflow/ws/AddSource
curl -X POST -d @addsite.json -H "Content-type: application/json" http://localhost:8080/wateroneflow/ws/AddSite
