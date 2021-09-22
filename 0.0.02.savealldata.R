#用于文件的保存
#保存xlsx文件，当文件存在时，添加sheet


#首行加粗，字体Arial
savexlsx1<-function(data=data,name=name,sheet=sheet){
  
  text<-paste0("在",name,"中保存",sheet,"表格")
  print(text)
  if(file.exists(name)){
    wb<-openxlsx::loadWorkbook(name)
  }else{wb<-openxlsx::createWorkbook()}
  
  tryfetch<-try({
    openxlsx::addWorksheet(wb,sheet)
  },silent = T)
  if(class(tryfetch)=="try-error"){
    openxlsx::removeWorksheet(wb,sheet)
    openxlsx::addWorksheet(wb,sheet)
  }
  
  openxlsx::writeData(wb,sheet=sheet,data)
  mode1<-openxlsx::createStyle(fontName = "Arial",textDecoration = "bold")
  mode2<-openxlsx::createStyle(fontName = "Arial")
  openxlsx::addStyle(wb,sheet=sheet,style = mode1,rows=1,cols = 1:dim(data)[2],gridExpand=T)
  openxlsx::addStyle(wb,sheet=sheet,style = mode2,rows=2:(dim(data)[1]+1),cols = 1:dim(data)[2],gridExpand=T)
  openxlsx::saveWorkbook(wb, file = name, overwrite = TRUE)
  print("保存完毕")
}

#save all sheet,data is a Large array containing dataframe,corresponding to output of fun. readallsheet
saveallsheet <- function(data=data,name=name){
  for (i in names(data)){
    savexlsx1(data=data[[i]], name = name, sheet = i)
  }
}
#ex
saveallsheet(data=data, name="差异.xlsx")

#无格式
savexlsx2<-function(data=data,name=name,sheet=sheet){
  text<-paste0("在",name,"中保存",sheet,"表格")
  print(text)
  if(file.exists(name)){
    wb<-openxlsx::loadWorkbook(name)
  }else{wb<-openxlsx::createWorkbook()}
  
  tryfetch<-try({
    openxlsx::addWorksheet(wb,sheet)
  },silent = T)
  if(class(tryfetch)=="try-error"){
    openxlsx::removeWorksheet(wb,sheet)
    openxlsx::addWorksheet(wb,sheet)
  }
  
  openxlsx::writeData(wb,sheet=sheet,data)
  openxlsx::saveWorkbook(wb, file = name, overwrite = TRUE)
  print("保存完毕")
}


#首行首列加粗，字体Arial
savexlsx3<-function(data=data,name=name,sheet=sheet){
  text<-paste0("在",name,"中保存",sheet,"表格")
  print(text)
  if(file.exists(name)){
    wb<-openxlsx::loadWorkbook(name)
  }else{wb<-openxlsx::createWorkbook()}
  
  tryfetch<-try({
    openxlsx::addWorksheet(wb,sheet)
  },silent = T)
  if(class(tryfetch)=="try-error"){
    openxlsx::removeWorksheet(wb,sheet)
    openxlsx::addWorksheet(wb,sheet)
  }
  
  openxlsx:: writeData(wb,sheet=sheet,data,rowNames = TRUE)
  mode1<-openxlsx::createStyle(fontName = "Arial",textDecoration = "bold")
  mode2<-openxlsx::createStyle(fontName = "Arial")
  openxlsx::addStyle(wb,sheet=sheet,style = mode1,rows=1,cols = 1:(dim(data)[2]+1),gridExpand=T)
  openxlsx::addStyle(wb,sheet=sheet,style = mode1,rows=2:(dim(data)[1]+1),cols = 1,gridExpand=T)
  openxlsx::addStyle(wb,sheet=sheet,style = mode2,rows=2:(dim(data)[1]+1),cols = 2:(dim(data)[2]+1),gridExpand=T)
  openxlsx::saveWorkbook(wb, file = name, overwrite = TRUE)
  print("保存完毕")
}


#首行加粗，字体Arial,部分字体变红
savexlsx4<-function(data=data,name=name,sheet=sheet){
  text<-paste0("在",name,"中保存",sheet,"表格")
  print(text)
  if(file.exists(name)){
    wb<-openxlsx::loadWorkbook(name)
  }else{wb<-openxlsx::createWorkbook()}
  
  tryfetch<-try({
    openxlsx::addWorksheet(wb,sheet)
  },silent = T)
  if(class(tryfetch)=="try-error"){
    openxlsx::removeWorksheet(wb,sheet)
    openxlsx::addWorksheet(wb,sheet)
  }
  
  openxlsx::writeData(wb,sheet=sheet,data)
  mode1<-openxlsx::createStyle(fontName = "Arial",textDecoration = "bold")
  mode2<-openxlsx::createStyle(fontName = "Arial")
  mode3<-openxlsx::createStyle(fontName = "Arial",fontColour = "red")
  openxlsx::addStyle(wb,sheet=sheet,style = mode1,rows=1,cols = 1:dim(data)[2],gridExpand=T)
  openxlsx::addStyle(wb,sheet=sheet,style = mode2,rows=2:(dim(data)[1]+1),cols = 1:dim(data)[2],gridExpand=T)
  openxlsx::addStyle(wb,sheet=sheet,style = mode3,rows=which(is.na(data[,"URL"]))+1,cols = 1:dim(data)[2],gridExpand=T)
  openxlsx::saveWorkbook(wb, file = name, overwrite = TRUE)
  print("保存完毕")
}


#首行加粗，字体Arial
savexlsx5<-function(data=data,name=name,sheet=sheet){
  text<-paste0("在",name,"中保存",sheet,"表格")
  print(text)
  if(file.exists(name)){
    wb<-openxlsx::loadWorkbook(name)
  }else{wb<-openxlsx::createWorkbook()}
  
  tryfetch<-try({
    openxlsx::addWorksheet(wb,sheet)
  },silent = T)
  if(class(tryfetch)=="try-error"){
    openxlsx::removeWorksheet(wb,sheet)
    openxlsx::addWorksheet(wb,sheet)
  }
  
  openxlsx:: writeData(wb,sheet=sheet,data,rowNames = TRUE)
  mode1<-openxlsx::createStyle(fontName = "Arial",textDecoration = "bold")
  mode2<-openxlsx::createStyle(fontName = "Arial")
  openxlsx::addStyle(wb,sheet=sheet,style = mode1,rows=1,cols = 1:(dim(data)[2]+1),gridExpand=T)
  openxlsx::addStyle(wb,sheet=sheet,style = mode1,rows=2:(dim(data)[1]+1),cols = 1,gridExpand=T)
  openxlsx::addStyle(wb,sheet=sheet,style = mode2,rows=2:(dim(data)[1]+1),cols = 2:(dim(data)[2]+1),gridExpand=T)
  openxlsx::saveWorkbook(wb, file = name, overwrite = TRUE)
  print("保存完毕")
}



addsheet1<-function(data=data,wb=wb,sheet=sheet){
  wb1<-wb
  
  openxlsx::addWorksheet(wb1,sheet)
  openxlsx::writeData(wb1,sheet=sheet,data)
  mode1<-openxlsx::createStyle(fontName = "Arial",textDecoration = "bold")
  mode2<-openxlsx::createStyle(fontName = "Arial")
  openxlsx::addStyle(wb1,sheet=sheet,style = mode1,rows=1,cols = 1:dim(data)[2],gridExpand=T)
  openxlsx::addStyle(wb1,sheet=sheet,style = mode2,rows=2:(dim(data)[1]+1),cols = 1:dim(data)[2],gridExpand=T)
  
  return(wb1)
}
