
#setwd("I:/段光前-工作资料/20190812-HT2019-2920")

#read all sheet of a xlsx file by default, return a array containing dataframe of each sheet
readallsheet <- function(filename=filename,needsheet=NULL,rowNames = F,startRow = 1,colNames=T,.fun=NULL,...){
  library(openxlsx)
  library(readxl)
  sheetnames <- names(openxlsx::loadWorkbook(filename))
  if (is.null(needsheet) & is.character(needsheet)){
    sheetnames <- needsheet
  }
  else if (is.list(needsheet)){
    sheetnames <- sheetnames[unlist(needsheet)]
  }
  else if (is.numeric(needsheet)){
    sheetnames <- sheetnames[needsheet]
  }
  datalist <- as.list(sheetnames)
  if (is.function(.fun)){
    .fun <- .fun
  }else{
    .fun <- function(i){
    print(paste0("正在读取",filename,"中sheet ", i, "的数据"))
    # data <- readxl::read_excel(path = filename, sheet=1) # 读出数据为tibble
    data<-openxlsx::read.xlsx(filename, sheet=i,rowNames = rowNames,startRow=startRow,colNames=colNames)
    if(colNames){
      data1<-openxlsx::read.xlsx(filename, sheet=i,colNames=F,rows = startRow,rowNames=rowNames)
      names(data)<-data1
      print("读取完毕")
      return(data)
     }
    }
  }
  data <- array(lapply(datalist, .fun),dimnames = list(sheetnames))
  return(data)
}


#read a txt file
readtxt <- function(filename=filename,rowNames = F,skip=0,header=T){
  print(paste0("读取",filename,"中数据"))
  data<-read.table(filename,header=header,check.names=F,encoding="UTF-8",stringsAsFactors=F,skip=skip)
  print("读取完毕")
  return(data)
}

#read a csv file
readcsv<-function(filename=filename,rowNames = F,skip=0,header=T){
  print(paste0("读取",filename,"中数据"))
  data<-read.csv(filename,header=header,check.names=F,encoding="UTF-8",stringsAsFactors=F,skip=skip)
  print("读取完毕")
  return(data)
}

#read all common typed files
readalldata<-function(filename=filename,needsheet=NULL,rowNames = F,skip=0,header=T){
  data<-NULL
  if(is.character(filename)){
    if(grepl(".txt$",filename)){ data<-readtxt(filename=filename,rowNames=rowNames,skip=skip,header=header)}
    if(grepl(".csv$",filename)){ data<-readcsv(filename=filename,rowNames=rowNames,skip=skip,header=header)}
    if(grepl(".xlsx$",filename)){ data<-readallsheet(filename=filename,needsheet=needsheet,rowNames=rowNames,
                                                     startRow=skip+1,colNames=header)}
  }else if(is.object(filename)){
    data<-readxlsx(filename=filename,needsheet=needsheet,rowNames=rowNames,startRow=skip+1,colNames=header)
  }
  return(data)
}

#ex
# data <- readalldata(filename = "差异代谢物.xlsx", needsheet=1)
# data <- readalldata(filename = "差异代谢物.xlsx", needsheet=list(c(1:6), c(1:2)))
# data <- readalldata("HT2019-2920-pos-M.csv",skip = 2)
