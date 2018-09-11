#' PlotValuesODM
#'
#' Esta función grafica las series temporales obtenidas mediante GetValuesFromODM
#' Admite hasta dos variables (variableName) distintas, sin límite para el número
#' de se sitios de cada variable.
#' @param Values data.frame obtenido mediante getValues (pueden concatenarse dos o mas)
#' @param output Archivo donde se imprima el gráfico (opcional). Por defecto abre un display x11
#' @param types vector Tipos de gráfico para cada variable ('l': línea, 'p': puntos, 's' escalones), en el orden de aparición (opcional)
#' @param width Ancho del gráfico (opcional)
#' @param height Altura del gráfico (opcional)
#' @param invert vector de boolean Determina si debe invertirse el eje Y para cada variable (opcional)
#' @param StartDate fecha inicial (opcional)
#' @param EndDate fecha final (opcional)
#' @return 0 
#' @keywords plot timeSeries values ODM
#' @export
#' @examples
#' drv<-dbDriver("PostgreSQL")
#' con<-dbConnect(drv, user="sololectura",host='11.22.33.444',dbname='ODM')
#' Values1<-GetValuesFromODM(con,SiteCode='alturas_dinac:155',VariableCode='2',StartDate='2010-01-01',EndDate='2015-01-01')
#' Values2<-GetValuesFromODM(con,SiteCode='alturas_dinac:153',VariableCode='2',StartDate='2010-01-01',EndDate='2015-01-01')
#' Values<-rbind(Values1,Values2) 
#' PlotValuesODM(values,seriesCatalog,output='~/tmp/plotValues.png')

PlotValuesODM<-function(Values,output=NULL,types=c('l'),width=800,height=700,invert=c(FALSE),StartDate=NULL,EndDate=NULL) {
  if(!is.null(output)) {
    png(output,width = width, height = height)
  } else {
    x11(width=width/72,height=height/72)
  }
  varnames=unique(Values$VariableName)
  if(length(varnames)>2) {
    stop('max 2 variables')
    return(1);
  }
  types=if (length(varnames) > length(types)) rep(types,length(varnames)) else types
  types=types[1:length(varnames)]
  axisides=c(2,4)
  colors=seq(1,50,1)
  invert=rep(invert,length(varnames))
  k=1
  legend=c()
  lcolors=c()
  lty=c()
  pch=c()
  for (i in 1:length(varnames)) {
    subset=Values[Values$VariableName==varnames[i],]
    ylim = if (invert[i]) c(max(subset$DataValue),min(subset$DataValue)) else c(min(subset$DataValue),max(subset$DataValue))
    xlim= c(if (!is.null(StartDate)) as.Date(StartDate) else  min(as.Date(Values$DateTimeUTC)),if (!is.null(EndDate)) as.Date(EndDate) else max(as.Date(Values$DateTimeUTC)))
    if(i==1) {
      par(mar=c(5.5,3.8,4.5,4.1),xpd=FALSE)
      plot(0,type="n",xlim=xlim,ylim=ylim,xlab='time',axes=FALSE,ylab=varnames[i])
      v=as.numeric(axis.Date(1, seq(min(Values$DateTimeUTC),max(Values$DateTimeUTC),length.out=10), format='%y-%m-%d'))
      abline(v=v,lty=3)
    } else {
      par(new = TRUE)
      plot(0,type="n",xlim=xlim,ylim=ylim,xlab=NA,axes=FALSE,ylab=NA)
      mtext(varnames[i],side=4,line=2)
    }
    roundto = if(varnames[i]=='altura') 2 else 0
    axis(axisides[i],round(seq(min(subset$DataValue),max(subset$DataValue),length.out=10),roundto))
    abline(h=round(seq(min(subset$DataValue),max(subset$DataValue),length.out=10),roundto),lty=3)
    Series=unique(subset(subset, select=c(SiteCode,VariableCode)))
    for(j in 1:nrow(Series)) {
      ThisSiteCode=Series$SiteCode[j]
      ThisVariableCode=Series$VariableCode[j]
      subsubset <- subset(subset,SiteCode == ThisSiteCode & VariableCode == ThisVariableCode)
      if(types[i]=='p') {
        points(subsubset$DataValue~as.Date(subsubset$DateTimeUTC),type='p',pch=16,cex=0.5,xaxt = 'n', yaxt = 'n',xlab=NA,ylab=NA,col=colors[k])
      } else {
        lines(subsubset$DataValue~as.Date(subsubset$DateTimeUTC),type=types[i],pch=16,cex=0.5,xaxt = 'n', yaxt = 'n',xlab=NA,ylab=NA,col=colors[k])
      }
      lty=c(lty,if(types[i]=='l' || types[i]=='s') 1 else NA)
      pch=c(pch,if(types[i]=='p') 20 else NA)
      thisLegendElem = paste(ThisVariableCode,'@',ThisSiteCode,sep='')
      legend=c(legend,thisLegendElem)
      lcolors=c(lcolors,colors[k])
      k=k+1
    }
  }
  if(FALSE %in% is.na(lty)) {
    legend('top',legend,col=lcolors,lty=lty,pch=pch,bg="white",horiz=TRUE)
  } else {
    legend('top',legend,col=lcolors,pch=pch,bg="white",horiz=TRUE)
  }
  if(!is.null(output)) {
    dev.off()
    message(paste("Se imprimio el plot en el archivo ",output,sep=''))
  }
  return(0)
}
