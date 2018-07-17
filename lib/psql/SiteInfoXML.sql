create or replace view "SiteInfoXML" as
SELECT "SiteID",
    XMLELEMENT(NAME "siteInfo", XMLATTRIBUTES("SiteID" AS oid), XMLELEMENT(NAME "sr:siteName", "SiteName"), XMLELEMENT(NAME "sr:siteCode", XMLATTRIBUTES(true AS "defaultId", "SiteID" as "siteID", 'SAT-CDP INA' AS network, 'INA' AS "agencyCode", 'INA' AS "agencyName"), "SiteCode"), XMLELEMENT(NAME "timeZoneInfo", XMLATTRIBUTES(false AS "siteUsesDaylightSavingsTime"), XMLELEMENT(NAME "defaultTimeZone", '-03')), XMLELEMENT(NAME "geoLocation", XMLELEMENT(NAME "geogLocation", XMLATTRIBUTES('LatLonPointType' AS "xsi:type", 'EPSG:4326' AS srs), XMLELEMENT(NAME "sr:latitude", "Latitude"), XMLELEMENT(NAME "sr:longitude", "Longitude")), XMLELEMENT(NAME "localSiteXY", XMLATTRIBUTES(spatial_ref_sys.auth_name::text AS "projectionInformation"), XMLELEMENT(NAME "X", st_x("Geometry")), XMLELEMENT(NAME "Y", st_y("Geometry")))), XMLELEMENT(NAME "sr:elevation_m", "Elevation_m"), XMLELEMENT(NAME "verticalDatum", "VerticalDatum"), XMLELEMENT(NAME "sr:siteProperty", XMLATTRIBUTES('Country' AS title), "Country"), XMLELEMENT(NAME "sr:siteProperty", XMLATTRIBUTES('State' AS title), "State"), XMLELEMENT(NAME "sr:siteProperty", XMLATTRIBUTES('Site Comments' AS title), "Comments")) AS "SiteInfoXML"
   FROM "Sites",
    spatial_ref_sys
  WHERE st_srid("Sites"."Geometry") = spatial_ref_sys.srid
  ORDER BY "Sites"."SiteID";
grant select on "SiteInfoXML" to sololectura;
grant select on "SiteInfoXML" to actualiza;
