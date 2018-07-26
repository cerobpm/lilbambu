#' GetSitesFromODM
#'
#' Esta función extrae la tabla Sites de la base de datos ODM. Devuelve un data.frame cuyas filas corresponden a los sitios y las
#' columnas a las propiedades, el cual sirve como parámetro de entrada para la función extractSeriesCatalog.
#'  Se puede obtener el listado completo o filtrar por SiteCode, FeatureType o recuadro espacial (north,south,
#'  east,west)
#' @param con Conexión a base de datos (creada con dbConnect)
#' @param SiteCode Código del sitio (uno o mas 'a:int' o 'p:int', opcional)
#' @param FeatureType tipo de objeto espacial ('point' o 'area', 'grid', 'line', opcional)
#' @param north coordenada norte del recuadro (opcional)
#' @param south coordenada sur del recuadro (opcional)
#' @param west coordenada oeste del recuadro (opcional)
#' @param east coordenada este del recuadro (opcional)
#' @return un data.frame con las siguientes columnas:  SiteID, SiteCode, SiteName, Latitude, Longitude, Elevation_m,
#' State, County, Comments, FeatureType
#' @keywords Sites GetSites ODM
#' @export
#' @importFrom DBI dbDriver
#' @importFrom RPostgreSQL dbConnect dbGetQuery
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr filter
#' @examples
#' drv<-dbDriver("PostgreSQL")
#' con<-dbConnect(drv, user="sololectura",host='11.22.33.444',dbname='ODM')
#' sites<-GetSitesFromODM(con,featureType='point',north=-20,south=-25,east=-55,west=-60)

GetSitesFromODM<-function(con,SiteCode=NULL,FeatureType=NULL,north=NULL,south=NULL,east=NULL,west=NULL) {
  sites=data.frame()
  filter=''
  if(!is.null(SiteCode)) {
    if(is.vector(SiteCode)) {
      filter=paste(filter," and \"SiteCode\" in (",paste(paste("'",SiteCode,"'",sep=''),collapse=','),")",sep='')
    } else {
      filter=paste(filter," and \"SiteCode\"='",SiteCode,"'",sep='')
    }
  }
  if(!is.null(north) && !is.null(south) && !is.null(east) && !is.null(west)) {
    filter=paste(filter," and \"Latitude\">=",south," and \"Latitude\"<=",north," and \"Longitude\">=",west," and \"Longitude\"<=",east,sep='')
  }
  if(!is.null(FeatureType)) {
    filter=paste(filter," and \"FeatureType\"='",FeatureType,"'",sep='')
  }
  stmt = paste("select \"SiteID\",\"SiteCode\",\"SiteName\",\"Latitude\",\"Longitude\",\"Elevation_m\",\"State\",\"County\",\"Country\",\"Comments\",\"FeatureType\" from \"Sites\" where \"SiteCode\" is not null ",filter,sep='')
  #  message(stmt)
  sites=dbGetQuery(con,stmt)
  if(length(sites)==0) stop("No se encontraron features para los parametros seleccionados")
  message(paste("Se cargaron ",length(sites[,1])," features. ",sep=''))
  #  message(paste(names(series),series,'\n',sep=' '))
  return(sites)
}
