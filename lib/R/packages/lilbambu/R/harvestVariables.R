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
#' harvestVariables("http://brasilia.essi-lab.eu/gi-axe/services/cuahsi_1_1.asmx?WSDL",TRUE)

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
