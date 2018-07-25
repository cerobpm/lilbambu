#' harvestSeriesCatalog
#'
#' Esta funcion descarga SeriesCatalog de un WOFWML WS e inserta en ODM usando "addSeriestoLocal"
#'
#' @import WaterML
#' @param url WOFWML WS end point
#' @param SiteCode  FullSiteCode from GetSites
#' @param update boolean comportamiento ante SiteID*VariableID duplicado (si TRUE, actualiza) 
#' @return ""1 row inserted or updated. SeriesID:..." or "nothing inserted/updated"
#' @export
#' @examples
#' harvestSeriesCatalog("http://brasilia.essi-lab.eu/gi-axe/services/cuahsi_1_1.asmx?WSDL",TRUE)

harvestSeriesCatalog <-function(url,SiteCode,update=FALSE)
{
  siteinfo<-GetSiteInfo(url,SiteCode)
  results=c()
  for (i in 1:length(siteinfo[,1]))
  {
    result<-addSeriestoLocal(siteinfo[i,],update)
    results=c(results,result)
  }
  return(results)
}
