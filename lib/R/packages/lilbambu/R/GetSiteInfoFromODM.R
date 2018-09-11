#' GetSiteInfoFromODM
#'
#' Esta función extrae la tabla de variables observadas para un sitio seleccionado de una base de datos ODM
#' Se debe indicar el SiteCode y permite filtrar por VariableCode, MethodID y SourceID.
#' Devuelve un data.frame con las filas como definiciones de series y columnas como sus propiedades.
#' El mismo sirve como parámetro de entrada para la función GetValuesFromODM
#' @param con Conexión a base de datos (creada con dbConnect)
#' @param SiteCode código de sitio
#' @param VariableCode código de variable (optativo)
#' @param MethodID ID de método (optativo)
#' @param SourceID ID de fuente (optativo)
#' @return un data.frame con las siguientes columnas: SiteID SiteName SiteCode FullSiteCode Latitude 
#'  Longitude Elevation_m State County Country Comments FeatureType VariableCode FullVariableCode  VariableName
#' ValueType  DataType GeneralCategory SampleMedium UnitName UnitType UnitAbbreviation NoDataValue
#'  IsRegular TimeUnitName TimeUnitAbbreviation TimeSupport
#' Speciation methodID methodCode methodDescription methodLink sourceID organization sourceDescription 
#' citation qualityControlLevelID 
#' qualityControlLevelCode qualityControlLevelDefinition valueCount beginDateTime
#'  endDateTime beginDateTimeUTC endDateTimeUTC 
#' @keywords series seriesCatalog ODM GetSiteInfo
#' @export
#' @examples
#' drv<-dbDriver("PostgreSQL")
#' con<-dbConnect(drv, user="sololectura",host='11.22.33.444',dbname='ODM')
#' GetSiteInfoFromODM(con,VariableCode='2',MethodID=1)

GetSiteInfoFromODM<-function(con,SiteCode,VariableCode=NULL,MethodID=NULL,SourceID=NULL) {
  filter=''
  if(!is.null(VariableCode)) {
    if(is.vector(VariableCode)) {
      filter=paste(filter," and \"Variables\".\"VariableCode\" in (",paste(paste("'",VariableCode,"'",sep=''),collapse=','),")",sep='')
    } else {
      filter=paste(filter," and \"Variables\".\"VariableCode\"='",VariableCode,"'",sep='')
    }
  }
  if(!is.null(MethodID)) {
    if(is.vector(MethodID)) {
      filter=paste(filter," and \"Methods\".\"MethodID\" in (",paste(MethodID,collapse=','),")",sep='')
    } else {
      filter=paste(filter," and \"Methods\".\"MethodID\"=",MethodID,sep='')
    }
  }
  if(!is.null(SourceID)) {
    if(is.vector(SourceID)) {
      filter=paste(filter," and \"Sources\".\"SourceID\" in (",paste(SourceID,collapse=','),")",sep='')
    } else {
      filter=paste(filter," and \"Sources\".\"SourceID\"=",SourceID,sep='')
    }
  }
  stmt = paste('select "SeriesID","Sites"."SiteID","Sites"."SiteCode","Sites"."SiteName","Sites"."Latitude","Sites"."Longitude",
"Sites"."Elevation_m","Sites"."State","Sites"."County","Sites"."Country","Sites"."Comments","Sites"."FeatureType",
"Variables"."VariableCode","Variables"."VariableName","Variables"."ValueType","Variables"."DataType","Variables"."GeneralCategory",
"Variables"."SampleMedium","Units"."UnitsName", "Units"."UnitsType","Units"."UnitsAbbreviation", "Variables"."NoDataValue",
"Variables"."IsRegular",timeunits."UnitsName" as "TimeUnitsName",timeunits."UnitsAbbreviation" as "TimeUnitsAbbreviation",
"Variables"."TimeSupport","Variables"."Speciation","Methods"."MethodID","Methods"."MethodCode","Methods"."MethodDescription",
"Methods"."MethodLink","Sources"."SourceID","Sources"."Organization",
"Sources"."SourceDescription","Sources"."Citation","QualityControlLevels"."QualityControlLevelID","QualityControlLevels"."QualityControlLevelCode","QualityControlLevels"."Definition" as "QualityControlLevelDefinition",
"SeriesCatalogView"."ValueCount","SeriesCatalogView"."BeginDateTime","SeriesCatalogView"."EndDateTime","SeriesCatalogView"."BeginDateTimeUTC","SeriesCatalogView"."EndDateTimeUTC"
from "Sites","SeriesCatalogView","Variables","Methods","Sources","Units",(select * from "Units") timeunits,"QualityControlLevels" 
where "Sites"."SiteCode"=\'',SiteCode,'\' and "Sites"."SiteID"="SeriesCatalogView"."SiteID" and "SeriesCatalogView"."VariableUnitsID"="Units"."UnitsID" 
and "Variables"."VariableCode"="SeriesCatalogView"."VariableCode" and "Methods"."MethodID"="SeriesCatalogView"."MethodID"
 and "Sources"."SourceID"="SeriesCatalogView"."SourceID" and timeunits."UnitsID"="SeriesCatalogView"."TimeUnitsID"
 and "QualityControlLevels"."QualityControlLevelID"="SeriesCatalogView"."QualityControlLevelID"',filter,sep='')
  #message(stmt)
  siteinfo=dbGetQuery(con,stmt)
  if(length(siteinfo)==0) stop("No se encontraron variables observadas para los parametros seleccionados")
  message(paste("Se obtuvieron ",length(siteinfo$SeriesID)," variables observadas. ",sep=''))
  return(siteinfo)
}
