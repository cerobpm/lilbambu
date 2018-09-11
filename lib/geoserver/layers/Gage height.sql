SELECT
    "Sites"."Geometry",
    "SeriesCatalogView".*, 
    'http://localhost:8080/plwof/ws/GetValues?SiteCode=' || "SeriesCatalogView"."SiteCode" || '&VariableCode=' || "SeriesCatalogView"."VariableCode" || '&StartDate=' || to_char(current_timestamp - interval '7 days','YYYY-MM-DD"T"HH24:MI:SS') || '&EndDate=' || to_char(current_timestamp,'YYYY-MM-DD"T"HH24:MI:SS') "WaterML"
FROM "Sites"
JOIN "SeriesCatalogView"
ON ("Sites"."SiteCode"="SeriesCatalogView"."SiteCode" and "VariableName" = 'Gage height')
ORDER BY "SiteCode","VariableName","SourceID"
