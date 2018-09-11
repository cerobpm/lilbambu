#' GetValuesFromLocal
#' 
#' 
#' Esta función descarga los pares de fecha y valor de una base de datos ODM correspondientes a las series indicadas
#' usando SeriesID o VariableCode+SiteCode, entre las fechas StartDate y EndDate.
#' Devuelve un data.frame 
#' @param con conexión con la base de datos (creada mediante dbConnect)
#' @param SeriesID integer o vector de integer (obtenidos de GetSiteInfoFromLocal)
#' @param SiteCode string o vector de string (solo si SeriesID es NULL)
#' @param VariableCode string o vector de string (solo si SeriesID es NULL is SiteCode no es NULL)
#' @param StartDate ISO datetime UTC
#' @param EndDate   ISO datetime UTC
#' @return data.frame con las siguientes columnas: DateTime DataValue UTCOffset CensorCode DateTimeUTC MethodID SourceID QualityControlLevelCode SeriesID SiteCode VariableCode VariableName 
#' @export
#' @keywords values TimeSeries GetValues ODM
#' @examples
#' drv<-dbDriver("PostgreSQL")
#' con<-dbConnect(drv, user="sololectura",host='11.22.33.444',dbname='ODM')
#' SiteInfo<-GetSiteInfoFromODM(con,SiteCode='alturas_dinac:155',VariableCode='2')
#' GetValuesFromODM(con,SiteInfo,'2010-01-01','2015-01-01')

GetValuesFromODM<-function(con,SeriesID=NULL,SiteCode=NULL,VariableCode=NULL,StartDate,EndDate) {
  filter=''
  data=data.frame()
  if(!is.null(SeriesID)) {
    if(is.vector(SeriesID)) {
      filter = paste(filter,' and "SeriesCatalogView"."SeriesID" in (',paste(SeriesID,collapse=','),')',sep='')
    } else {
      filter = paste(filter,' and "SeriesCatalogView"."SeriesID"=',SeriesID,sep='')
    }
  } else {
    if(!is.null(SiteCode) && !is.null(VariableCode))  {
      if(is.vector(SiteCode)) {
        filter = paste(filter,' and "SeriesCatalogView"."SiteCode" in (',paste(paste("'",SiteCode,"'",sep=''),collapse=','),')',sep='')
      } else {
        filter = paste(filter,' and "SeriesCatalogView"."SiteCode"=\'',SiteCode,'\'',sep='')
      }
      if(is.vector(VariableCode)) {
        filter = paste(filter,' and "SeriesCatalogView"."VariableCode" in (',paste(paste("'",VariableCode,"'",sep=''),collapse=','),')',sep='')
      } else {
        filter = paste(filter,' and "SeriesCatalogView"."VariableCode"=\'',VariableCode,'\'',sep='')
      }
    } else {
    stop("Falta SeriesID o SiteCode+VariableCode")
    }
  }
  if(is.null(StartDate)) { stop("Falta StartDate")}
  if(is.null(EndDate)) { stop("Falta EndDate")}
  statement=paste('select "DataValues"."LocalDateTime" as "DateTime", "DataValues"."DataValue", "DataValues"."UTCOffset",
   "DataValues"."CensorCode", "DataValues"."DateTimeUTC","DataValues"."MethodID","DataValues"."SourceID","SeriesCatalogView"."QualityControlLevelCode",
   "SeriesCatalogView"."SeriesID","SeriesCatalogView"."SiteCode","SeriesCatalogView"."VariableCode","SeriesCatalogView"."VariableName"
   from "DataValues","SeriesCatalogView" where "DataValues"."SiteID"="SeriesCatalogView"."SiteID" and "DataValues"."VariableID"="SeriesCatalogView"."VariableID"
   and "DataValues"."DateTimeUTC">=\'',StartDate,'\' and "DataValues"."DateTimeUTC" <=\'',EndDate,'\'',filter,' order by "SeriesID","DateTimeUTC"',sep='')
  #message(statement)
  data<-rbind(data,dbGetQuery(con,statement))
  if(length(data)==0) stop("No se encontraron registros para los parametros seleccionados")
  message(paste("Se encontraron ",length(data[,1])," registros. ",sep=''))
  return(data)
}

