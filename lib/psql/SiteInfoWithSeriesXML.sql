create view "SitesWithSeriesCatalogXML" as 
with siteseriesagg as (
	select "Sites"."SiteID",xmlagg("SeriesCatalogXML") as "seriesCatalog"
	from "Sites","SeriesCatalogXML","SeriesCatalogView" 
	where "Sites"."SiteID"="SeriesCatalogView"."SiteID"
	and "SeriesCatalogView"."SeriesID"="SeriesCatalogXML"."SeriesID"
	group by "Sites"."SiteID")
select "SiteInfoXML"."SiteID",xmlelement(name "site","SiteInfoXML"."SiteInfoXML",siteseriesagg."seriesCatalog") as "site" from "SiteInfoXML",siteseriesagg where "SiteInfoXML"."SiteID"=siteseriesagg."SiteID"
order by "SiteInfoXML"."SiteID";

grant select on "SitesWithSeriesCatalogXML" to sololectura;
grant select on "SitesWithSeriesCatalogXML" to actualiza;
