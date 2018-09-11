library(WaterML)
library(birk)
#__PARAMETROS___#
wml_rest_base_url="http://10.10.9.14:8080/wml"
output_base_dir="~/lilbambu/test"
#a: variable pronisticada y autoregresiva
a_siteCode=1257 ###  upstream siteCode
a_variableCode=2 ## upstream VariableCode
#b: variable regresora
b_siteCode=1701 ### downstream siteCode
b_variableCode=2 ## downstream VariableCode
startDate='2018-07-01T00:00' ### startDate
endDate='2018-08-03T00:00' #### endDate
t_tolerance=15*60 #### tolerancia en segundos para el emparejamiento de fechas
t_step=60*60  #### paso temporal en segundos
t_forward=24*60*60    #### horizonte de pronóstico en segundos (desde la fecha de pronóstico en adelante)
t_backward=12*60*60   #### periodo observado en segundos (desde la fecha de pronóstico hacia atrás)
days_plot_hidro=7 #### dias previos al instante de pronostico para plotear hidrograma
#______________#
min_absdt_row<-function(df) {
  index=which.min(df$absdt)
  return(df[index,])
}
    ##__getvalues__##
a=GetValues(paste(wml_rest_base_url,"/GetValues?siteCode=",a_siteCode,"&variableCode=",a_variableCode,"&startDate=",startDate,"&endDate=",endDate,sep=''))
a$name='a'
b=GetValues(paste(wml_rest_base_url,"/GetValues?siteCode=",b_siteCode,"&variableCode=",b_variableCode,"&startDate=",startDate,"&endDate=",endDate,sep=''))
b$name='b'
    ##_build data.frame_##
data=b[c("time","DataValue")]
regresoras=rbind(a[c("time","DataValue","name")],b[c("time","DataValue","name")])
maxtimeobs=max(data$time)
newrow=data.frame(time=maxtimeobs+t_step,DataValue=NA)
data=rbind(data,newrow)
regnames=c()
for(name in unique(regresoras$name)) {
  regresora=regresoras[regresoras$name==name,]
  for (t_lag in seq(from=t_step,to=t_backward,by=t_step)) 
  {
    for(i in 1:nrow(data))
    {
      index=which.min(abs(regresora$time + t_lag - data$time[i]))
      data$index[i]=index
      data$atime[i]=regresora$time[index]
      data$absdt[i]=abs(regresora$time[index]-data$time[i])
      data$aDataValue[i]=regresora$DataValue[index]
      data$keep[i]=if(as.numeric(data$absdt[i],units="secs")<t_tolerance) TRUE else FALSE
    }
    data=data[data$keep==TRUE,]
    data=data.frame(do.call("rbind",by(data,data$index,min_absdt_row)))
    colname=paste(name,".",t_lag,sep='')
    data[[colname]]=data$aDataValue
    data$aDataValue=NULL
    data$atime=NULL
    data$index=NULL
    data$absdt=NULL
    data$keep=NULL
    regnames=c(regnames,colname)
  }
}  
    #__fill obs horiz prono and fit__#
#obs=data[data$time>=maxtimeobs-t_backward,]
fitcoeffs=data.frame()
predcolnames=c()
for(horiz in seq(from=t_step,to=t_forward,by=t_step)) {
  for(i in 1:nrow(data)) {
    index = which.min(abs(data$time[i]+horiz-data$time))
    absdt=abs(data$time[i]+horiz-data$time[index])
    #data$atime=data$time[index]
    #data$absdt[i]=as.numeric(absdt,units="secs")
    data$aDataValue[i]=if(!is.null(data$DataValue[index]) & as.numeric(absdt,units="secs")<t_tolerance) data$DataValue[index] else NA
    #data$keep[i]=if(!is.null(data$DataValue[index]) & as.numeric(absdt,units="secs")<t_tolerance) TRUE else FALSE
  }
  colname=paste("h.",horiz,sep='')
  data[[colname]]=data$aDataValue
  data$aDataValue=NULL
#  s_data=data[data$keep==TRUE,]
  fitfunc=paste("lm(",colname,"~",paste(regnames,collapse='+'),",data=data,y=TRUE)",sep='')
  lfit=eval(parse(text=fitfunc))
  fitcoeffs=rbind(fitcoeffs,lfit$coefficients,colnames<-colnames(lfit$coefficients))
  predcolname=paste("p.",horiz,sep='')
  predcolnames=c(predcolnames,predcolname)
  data[[predcolname]]=predict(lfit,data)
  rmse=sqrt(mean((lfit$residuals)^2))
  Rnash=1-sum((lfit$residuals)^2)/sum((lfit$y-mean(lfit$y))^2)
  png(paste(output_base_dir,"/lfit.",sprintf('%08d',horiz),".png",sep=''))
  main=paste("Horizonte de pronostico ",as.difftime(horiz/3600,units=c('hours'))," horas",sep='')
  plot(data[[predcolname]]~data[[colname]],main=main,ylab='pred',xlab='obs',sub=paste("Rnash:",round(Rnash,2)," RMSE: ",round(rmse,4),sep=''))
  abline(0,1)
  dev.off()
}
system(paste("convert -loop 0 -delay 10 ",output_base_dir,"/lfit.*.png ",output_base_dir,"/lfit.gif",sep=''))
colnames(fitcoeffs)<-c("Intercept",regnames)
pronovalues=as.numeric(data[which.max(data$time),predcolnames])
pronodates=data$time[which.max(data$time)]+as.difftime(seq(from=t_step,to=t_forward,by=t_step),units=c("secs"))
prono=cbind.data.frame(time=pronodates,DataValue=pronovalues)
##_____plot hidrograma obs+prono____#
png(paste(output_base_dir,"/hidrograma.png",sep=''))
main=paste("hidrograma",sep='')
par(las=2)
plot(data$DataValue~data$time,main=main,xlim=c(max(prono$time)-as.difftime(days_plot_hidro,units=c("days")),max(prono$time)))
points(data_sim$DataValue~data_sim$time,col="red")
abline(v=data$time[which.max(data$time)])
abline(v=Sys.time(),lty=2)
at=seq(as.POSIXct(max(prono$time)-as.difftime(days_plot_hidro,units=c("days"))),as.POSIXct(max(prono$time)),length.out=10)
axis(1,at=at,labels=format.Date(at,'%Y-%m-%d %H:%M'))
abline(v=at,lt=3,col="grey")
dev.off()
