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
