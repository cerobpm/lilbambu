create view "SeriesCatalogXML" as 
SELECT "SeriesID",
    XMLELEMENT(NAME series, XMLATTRIBUTES("SeriesID" AS "seriesID"), XMLELEMENT(NAME "dataType", "SeriesCatalogView"."DataType"), XMLELEMENT(NAME variable, "VariableInfoXML"."VariableInfoXML"), XMLELEMENT(NAME "valueCount", "ValueCount"), XMLELEMENT(NAME "variableTimeInterval", XMLELEMENT(NAME "beginDateTime", "BeginDateTime"), XMLELEMENT(NAME "endDateTime", "EndDateTime"), XMLELEMENT(NAME "beginDateTimeUTC", "BeginDateTimeUTC"), XMLELEMENT(NAME "endDateTimeUTC", "EndDateTimeUTC")), XMLELEMENT(NAME method, XMLATTRIBUTES("SeriesCatalogView"."MethodID" AS "methodID"), XMLELEMENT(NAME "methodCode", "Methods"."MethodID"::text), XMLELEMENT(NAME "methodDescription", "SeriesCatalogView"."MethodDescription")), XMLELEMENT(NAME "source", XMLATTRIBUTES("SeriesCatalogView"."SourceID" AS "sourceID"), XMLELEMENT(NAME "sourceCode", "Sources"."SourceID"::text), XMLELEMENT(NAME organization, "SeriesCatalogView"."Organization"), XMLELEMENT(NAME "sourceDescription", "SeriesCatalogView"."SourceDescription"), XMLELEMENT(NAME "sourceLink", "Sources"."SourceLink"))) AS "SeriesCatalogXML"
   FROM "SeriesCatalogView",
    "VariableInfoXML",
    "Methods",
    "Sources"
  WHERE "SeriesCatalogView"."VariableID"="VariableInfoXML"."VariableID" 
  AND "SeriesCatalogView"."SourceID"="Sources"."SourceID"
  AND   "SeriesCatalogView"."SourceID"="Sources"."SourceID"
  ORDER BY "SeriesCatalogView"."SiteID", "SeriesCatalogView"."VariableID";
  
grant select on "SeriesCatalogView" to sololectura;
grant select on "SeriesCatalogView" to actualiza;
