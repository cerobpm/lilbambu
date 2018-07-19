curl -X POST -d @getvar.json -H "Content-type: application/json" http://localhost:8080/wateroneflow/GetVariables
curl -X POST -d @addsource.json -H "Content-type: application/json" http://localhost:8080/wateroneflow/ws/AddSource
curl -X POST -d @addsite.json -H "Content-type: application/json" http://localhost:8080/wateroneflow/ws/AddSite
curl -X POST -d @addvaluescurl.json -H "Content-type: application/json" http://localhost:8080/wateroneflow/ws/AddValues
curl "http://localhost:8080/wateroneflow/ws/GetValues?SiteCode=alturas_prefe:55&VariableCode=2&StartDate=2018-07-01&EndDate=2018-07-19"
curl -X POST -d @getvalues.json -H "Content-type: application/json" http://localhost:8080/wateroneflow/ws/GetValues
