#' addSitestoLocal
#'
#' Esta funcion inserta en ODM un Site contenido en un dataframe como el producido por GetSites del package WaterML.
#'
#' @import jsonlite
#' @import DBI
#' @import RPostgreSQL
#' @param sites data.frame resultante de GetSites (WaterML) 
#' @param update boolean comportamiento ante VariableName duplicado (si TRUE, actualiza) 
#' @return "N rows inserted or updated. VariableID:..." or "nothing inserted/updated"
#' @export

addSitestoLocal<-function(con,sites,update=FALSE) {
  upd_opt = if (update==TRUE) " -U " else ""
#  extra_columns=c("Elevation","State","County","Comments")
#  extra_columns_str=''
#  for(i in extra_columns) {
  #  if(any(!is.na(sites[[i]]))) {
 #     colname= if (i=="Elevation") "Elevation_m" else i
#      extra_columns
   # }
#  }
  sites$Elevation_m=sites$Elevation
  sites$SiteCode=sites$FullSiteCode
  sites<-subset(sites,select=-c(Elevation,SiteID,FullSiteCode))
  jsites<-jsonlite::toJSON(sites)
  result<-system2(paste("lilbambu addSites -I",sep=''),input=jsites, intern = TRUE)
  status<-jsonlite::fromJSON(result)$status
  if(status != '200 OK') {
    return("nothing inserted / updated")
  } else {
    return(paste("N rows inserted or updated. SiteID:",paste(jsonlite::fromJSON(result)$SiteID,collapse=','),sep=''))
  }
}
