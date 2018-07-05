CREATE OR REPLACE VIEW "UnitsXML" as 
  SELECT "UnitsName",
         "UnitsID",
         "UnitsType",
         "UnitsAbbreviation",
         XMLELEMENT(NAME unit, XMLATTRIBUTES("UnitsID" as "unitsID"), XMLELEMENT(NAME "unitsName","UnitsName"),XMLELEMENT(NAME "unitsType","UnitsType"),XMLELEMENT(NAME "unitsAbbreviation","UnitsAbbreviation")) AS "UnitsXML"
  from "Units"
  order by "UnitsID";
