
dir <- list.files("I:/段光前-工作资料/开发任务/all.figure")

readdir <- function(path=getwd(),...){
  mergedata <- openxlsx::read.xlsx()

  for (i in 2:length(dir)){
    data_i <- openxlsx::read.xlsx(filename=dir[i],...)
    mergedata = rbind(mergedata, data_i)
  }
  return(mergedata)
}


