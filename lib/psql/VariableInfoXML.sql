CREATE OR REPLACE VIEW "VariableInfoXML" as 
  SELECT "Variables".*,
    XMLELEMENT(NAME "sr:variable", XMLELEMENT(NAME "variableCode", XMLATTRIBUTES(true AS "default", "VariableID" as "variableID"), "VariableCode"), XMLELEMENT(NAME "variableName", "VariableName"), XMLELEMENT(NAME "variableDescription", ''), XMLELEMENT(NAME "valueType", "ValueType"), "UnitsXML"."UnitsXML") AS "VariableInfoXML"
   FROM "Variables",
    "UnitsXML"
  WHERE "Variables"."VariableUnitsID" = "UnitsXML"."UnitsID";
