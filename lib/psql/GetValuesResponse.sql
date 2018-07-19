with a as (
   select 
    xmlelement(name \"queryInfo\",
                xmlelement(name \"creationTime\",current_timestamp),
                xmlelement(name \"queryURL\",'$query_string'),
                xmlelement(name \"criteria\",
                   xmlattributes('getValues' as \"methodCalled\"),
                   xmlelement(name \"locationParam\",$_[1]->{SiteCode}),
                   xmlelement(name \"variableParam\",$_[1]->{VariableCode}),
                   xmlelement(name \"timeParam\",
                       xmlelement(name \"beginDateTime\",'$_[1]->{StartDate}'),
                       xmlelement(name \"endDateTime\",'$_[1]->{EndDate}')
                       )
                   )
               ) as query_info,
      "SiteInfoXML"."SiteInfoXML" as site_info,
      "VariableInfoXML"."VariableInfoXML" as variable
    from "Sites","Variables","SiteInfoXML","VariableInfoXML"
    where "Sites"."SiteID"="SiteInfoXML"."SiteID"
    and "Sites"."SiteCode"='$_[1]->{SiteCode}'
    and "Variables"."VariableID"="VariableInfoXML"."VariableID"
    and "Variables"."VariableCode='$_[1]->{VariableCode}'
     limit 1
    ),
  b as (
   select min("Units"."UnitsID") unit_id,
          xmlagg("ValuesXML"."ValueXML") as values
   from (select "Units"."UnitsID",
                "ValueXML" 
         from "Units","ValuesXML","DataValues","UnitsXML","Variables"
         where "DataValues"."SiteCode"='$_[1]->{SiteCode}' 
         and "DataValues"."VariableCode"='$_[1]->{VariableCode}' 
         and "DataValues"."LocalDateTime">='$_[1]->{StartDate}'
         and "DataValues"."LocalDateTime"<='$_[1]->{EndDate}'
         and "DataValues"."ValueID"="ValuesXML"."ValueID" 
         and "Units"."UnitID"="UnitsXML"."UnitID"
         and "Units"."UnitsID"="Variables"."VariableUnitsID"
         and "Variables"."VariableCode"="DataValues"."VariableCode"
         ) values_xml 
    )
select xmlelement(name \"GetValuesResponse\",
                  xmlattributes('http://www.cuahsi.org/waterML/1.1/' as \"xmlns:sr\", 'http://www.w3.org/2001/XMLSchema-instance' as \"xmlns:xsi\"),
                  a.query_info,
                  xmlelement(name \"sr:timeSeries\",a.site_info,a.variable,xmlelement(name values,coalesce(b.values,''),coalesce("UnitsXML"."UnitsXML",'')))
                  )
  from a 
       left join b on (a.query_info is not null) 
       left join "UnitsXML" on (b.unit_id="UnitsXML"."UnitsID")
