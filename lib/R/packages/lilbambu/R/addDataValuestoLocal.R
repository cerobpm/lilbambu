#' addDataValuestoLocal
#'
#' Esta funcion inserta en ODM una serie temporal contenida en un dataframe como el producido por GetValues del package WaterML.
#'
#' @import jsonlite
#' @import DBI
#' @import RPostgreSQL
#' @param con DB connection
#' @param SiteCode 
#' @param VariableCode
#' @param TimeSeries data.frame resultante de GetValues (WaterML Package) 
#' @param update boolean comportamiento ante registro duplicado (si TRUE, actualiza) 
#' @return "Number rows inserted or updated:..." or "nothing inserted/updated"
#' @export

addDataValuestoLocal<-function(con,SiteCode,VariableCode,update=FALSE) {
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
