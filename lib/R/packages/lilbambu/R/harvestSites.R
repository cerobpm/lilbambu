#' harvestSites
#'
#' Esta funcion descarga Sites de un WOFWML WS e inserta en ODM usando "addSitesToLocal"
#'
#' @import WaterML
#' @param url WOFWML WS end point
#' @param update boolean comportamiento ante SiteID duplicado (si TRUE, actualiza)
#' @return ""1 row inserted or updated. SiteID:..." or "nothing inserted/updated"
#' @export
#' @examples
#' harvestSites("http://brasilia.essi-lab.eu/gi-axe/services/cuahsi_1_1.asmx?WSDL",north=-32,south=-35,east=-55,west=-61,TRUE)

harvestSites <-function(url,north=NULL,south=NULL,east=NULL,west=NULL,update=FALSE)
{
  sites<-GetSites(url,north=north,south=south,east=east,west=west)
  res=c()
  for (i in 1:length(sites[,1]))
  {
    result<-addSitetoLocal(sites[i,],update)
    res=c(res,result)
  }
  return(result)
}
