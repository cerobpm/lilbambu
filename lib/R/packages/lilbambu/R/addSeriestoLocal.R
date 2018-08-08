#' addSeriestoLocal
#'
#' Esta funcion inserta en ODM una Serie contenida en un dataframe como el producido por GetSiteInfo del package WaterML.
#'
#' @import jsonlite
#' @param params lista de parametros (fila del data.frame)
#' @param SourceCode prefix default 'Unknown'
#' @param update boolean comportamiento ante VariableCode+SiteCode duplicado (si TRUE, actualiza)
#' @return ""1 row inserted or updated. SeriesID:..." or "nothing inserted/updated"
#' @export

addSeriestoLocal<-function(params,SourceCode='Unknown',update=FALSE) {
  upd_opt = if (update==TRUE) " -U " else ""
  # GET SiteID #
  extra_columns=c("methodCode","methodDescription","methodLink","sourceID","organization","sourceDescription","citation","qualityControlLevelCode","qualityControlLevelDefinition","valueCount","beginDateTime","endDateTime","beginDateTimeUTC","endDateTimeUTC")
  extra_columns_str=''
  for(i in extra_columns) {
    # if(!is.na(params[[i]])) {
      if(!toString(params[[i]]) == '' & !toString(params[[i]]) == 'NA') {
        colname = paste(toupper(substr(i, 1, 1)), substr(i, 2, nchar(i)), sep="")
        extra_columns_str = paste(extra_columns_str,' ',colname,'="',params[[i]],'"',sep='')
      }
    #}
  }
  stmt = paste('lilbambu addSeries SourceCode="',SourceCode,'" SiteCode="',params$FullSiteCode,'" VariableCode="',params$FullVariableCode,'"',extra_columns_str,upd_opt,sep='')
  #write(stmt, stderr())
  result<-system(stmt, intern = TRUE)
  status<-jsonlite::fromJSON(result)$status
  if(status != '200 OK') {
    return("nothing inserted / updated")
  } else {
    return(paste("1 row inserted or updated. SeriesID:",jsonlite::fromJSON(result)$SeriesID,sep=''))
  }
}
