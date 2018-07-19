create view "ValuesXML" as 
select "DataValues"."ValueID",
       XMLELEMENT(NAME "sr:value", XMLATTRIBUTES("DataValues"."LocalDateTime" AS "dateTime", "DataValues"."DateTimeUTC" as "dateTimeUTC", "DataValues"."MethodID" AS "methodID", "DataValues"."SourceID" AS "sourceID", "DataValues"."SampleID" AS "sampleID", "DataValues"."ValueID" AS oid, "DataValues"."UTCOffset" AS "timeOffset"), "DataValues"."DataValue") AS "ValueXML"
from "DataValues";

grant select on "ValuesXML" to sololectura;
grant select on "ValuesXML" to actualiza;
