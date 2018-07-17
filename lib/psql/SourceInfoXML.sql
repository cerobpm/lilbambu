create view "SourceInfoXML" as SELECT "Sources"."SourceID",
    XMLELEMENT(NAME "sr:source", XMLELEMENT(NAME "sourceID", XMLATTRIBUTES(true AS "default", "Sources"."sourceID" AS "SourceID"), "Sources"."SourceID"), XMLELEMENT(NAME "Organization", "Sources"."Organization"), XMLELEMENT(NAME "SourceDescription", "Sources"."SourceDescription"), XMLELEMENT(NAME "SourceLink", "Sources"."SourceLink")) AS "SourceInfoXML"
   FROM "Sources";

grant select on "SourceInfoXML" to sololectura;
grant select on "SourceInfoXML" to actualiza;
