#' addSitetoLocal
#'
#' Esta funcion inserta en ODM un Site contenido en un dataframe como el producido por GetSites del package WaterML.
#'
#' @import jsonlite
#' @param params lista de parametros (fila del data.frame)
#' @param update boolean comportamiento ante VariableName duplicado (si TRUE, actualiza) 
#' @return ""1 row inserted or updated. VariableID:..." or "nothing inserted/updated"
#' @export

addSitetoLocal<-function(params,update=FALSE) {
  upd_opt = if (update==TRUE) " -U " else ""
  extra_columns=c("Elevation","State","County","Comments")
  extra_columns_str=''
  for(i in extra_columns) {
    if(!is.na(params[[i]])) {
      colname= if (i=="Elevation") "Elevation_m" else i
      extra_columns_str = paste(extra_columns_str,' ',colname,'="',params[[i]],'"',sep='')
    }
  }
  str = paste('SiteCode="',params$FullSiteCode,'" SiteName="',params$SiteName,'" Latitude=',params$Latitude,' Longitude=',params$Longitude,extra_columns_str,upd_opt,sep='')
  result<-system(paste("lilbambu addSite ",str,sep=''), intern = TRUE)
  status<-jsonlite::fromJSON(result)$status
  if(status != '200 OK') {
    return("nothing inserted / updated")
  } else {
    return(paste("1 row inserted or updated. SiteID:",jsonlite::fromJSON(result)$SiteID,sep=''))
  }
}
