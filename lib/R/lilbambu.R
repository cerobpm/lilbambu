#' addVariabletoLocal
#'
#' Esta funcion inserta en ODM una variable contenida en un dataframe como el producido por GetVariables del package WaterML.
#'
#' @import jsonlite
#' @param params lista de parametros (fila del data.frame)
#' @param update boolean comportamiento ante VariableName duplicado (si TRUE, actualiza) 
#' @return 1 row inserted or updated. VariableID:..." or "nothing inserted/updated"
#' @export

addVariabletoLocal<-function(params,update=FALSE) {
  upd_opt = if (update==TRUE) " -U " else ""
  if(is.na(params$UnitName) || is.na(params$UnitType))
  {
    params$VariableUnitsID=349
  } else {
    params$VariableUnitsID=system(paste('lilbambu GetUnitsID UnitsName="',params$UnitName,'" UnitsType="',params$UnitType,'"',sep=''), intern = TRUE)
  }
  DataType = if (!is.na(params$DataType)) params$DataType else "Unknown"
  ValueType = if (!is.na(params$ValueType)) params$ValueType else "Unknown"
  GeneralCategory = if (!is.na(params$GeneralCategory)) params$GeneralCategory else "Unknown"
  SampleMedium = if (!is.na(params$SampleMedium)) params$SampleMedium else "Unknown"
  NoDataValue = if (!is.na(params$NoDataValue)) params$NoDataValue else 0
  IsRegular = if (!is.na(params$IsRegular)) params$IsRegular else "FALSE"
  if(is.na(params$TimeUnitName)) {
    TimeUnitsID=352
  } else {
    TimeUnitsID=system(paste('lilbambu GetUnitsID UnitsName="',params$TimeUnitName,'" UnitsType=Time',sep=''), intern = TRUE)
  }
  TimeSupport =  if (!is.na(params$TimeSupport)) params$TimeSupport else 0
  str = paste('VariableCode="',params$FullVariableCode,'" VariableName="',params$VariableName,'" VariableUnitsID=',params$VariableUnitsID,' DataType="',DataType,'" ValueType="',ValueType,'" GeneralCategory="',GeneralCategory,'" SampleMedium="',SampleMedium,'" NoDataValue=',NoDataValue,' IsRegular=',IsRegular,' TimeUnitsID=',TimeUnitsID,' TimeSupport=',TimeSupport,upd_opt,sep='')
  result<-system(paste("lilbambu addVariable ",str,sep=''), intern = TRUE)
  status<-jsonlite::fromJSON(result)$status
  if(status != '200 OK') {
    return("nothing inserted / updated")
  } else {
    return(paste("1 row inserted or updated. VariableID:",jsonlite::fromJSON(result)$VariableID,sep=''))
  }
}

#' harvestVariables
#'
#' Esta funcion descarga Variables de un WOFWML WS e inserta en ODM usando "addVariableToLocal"
#'
#' @import WaterML
#' @param url WOFWML WS end point
#' @param update boolean comportamiento ante VariableID duplicado (si TRUE, actualiza) 
#' @return "1 row inserted or updated. VariableID:..." or "nothing inserted/updated"
#' @export
#' @examples
#' harvestVariables(http://brasilia.essi-lab.eu/gi-axe/services/cuahsi_1_1.asmx?WSDL",TRUE)

harvestVariables <-function(url,update=FALSE)
{
  variables<-GetVariables(url)
  results=data.frame
  for (i in 1:length(variables[,1]))
  {
    result<-addVariabletoLocal(variables[i,],update)
    results[i]=result
  }
  return(results)
}

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
#' harvestSites(http://brasilia.essi-lab.eu/gi-axe/services/cuahsi_1_1.asmx?WSDL",north=-32,south=-35,east=-55,west=-61,TRUE)

harvestSites <-function(url,north=90,south=-90,east=180,west=-180,update=FALSE)
{
  sites<-GetSites(url)
  res=c()
  for (i in 1:length(sites[,1]))
  {
    result<-addSitetoLocal(sites[i,],update)
    res=c(res,result)
  }
  return(results)
}




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

#' addSeriestoLocal
#'
#' Esta funcion inserta en ODM una Serie contenida en un dataframe como el producido por GetSiteInfo del package WaterML.
#'
#' @import jsonlite
#' @param params lista de parametros (fila del data.frame)
#' @param update boolean comportamiento ante VariableCode+SiteCode duplicado (si TRUE, actualiza) 
#' @return ""1 row inserted or updated. SeriesID:..." or "nothing inserted/updated"
#' @export

addSeriestoLocal<-function(params,update=FALSE) {
  upd_opt = if (update==TRUE) " -U " else ""
  # GET SiteID #
  extra_columns=c("methodCode","methodDescription","methodLink","organization","sourceDescription","citation","qualityControlLevelCode","qualityControlLevelDefinition","valueCount","beginDateTime","endDateTime","beginDateTimeUTC","endDateTimeUTC")
  extra_columns_str=''
  for(i in extra_columns) {
    if(!is.na(params[[i]])) {
      if(!toString(params[[i]]) == '') {
        colname = paste(toupper(substr(i, 1, 1)), substr(i, 2, nchar(i)), sep="")
        extra_columns_str = paste(extra_columns_str,' ',colname,'="',params[[i]],'"',sep='')
      }
    }
  }
  str = paste('SiteCode="',params$FullSiteCode,'" VariableCode="',params$FullVariableCode,'"',extra_columns_str,upd_opt,sep='')
  result<-system(paste("lilbambu addSeries ",str,sep=''), intern = TRUE)
  status<-jsonlite::fromJSON(result)$status
  if(status != '200 OK') {
    return("nothing inserted / updated")
  } else {
    return(paste("1 row inserted or updated. SeriesID:",jsonlite::fromJSON(result)$SeriesID,sep=''))
  }
}
