
library(corrplot)
# 相关性图的绘制

# setwd("I:/段光前-工作资料/开发任务/all.figure/corrplot")
# 
# data <- mtcars
## 设置不同系列颜色
# col1 <- colorRampPalette(c("#7F0000", "red", "#FF7F00", "yellow", "white",
#                            "cyan", "#007FFF", "blue","#00007F"))(200)
# col2 <- colorRampPalette(c("#67001F", "#B2182B", "#D6604D", "#F4A582",
#                            "#FDDBC7", "#FFFFFF", "#D1E5F0", "#92C5DE",
#                            "#4393C3", "#2166AC", "#053061"))(10000)
# col3 <- colorRampPalette(c("red", "white", "blue"))(100)
# col4 <- colorRampPalette(c("#7F0000", "red", "#FF7F00", "yellow", "#7FFF7F",
#                            "cyan", "#007FFF", "blue", "#00007F"))(5000)
# method参数设定不同展示方式
# corrplot(cor)                #默认method="circle"
# 
# # order参数设定不同展示顺序，默认order="orginal"以原始顺序展示
# corrplot(cor, order = "AOE")
# 
# # diag = FALSE不展示对角线的相关系数
# corrplot(cor, order = "AOE", type = "upper", diag = FALSE)


# corplot(data=data)

#corplot相关性图
corplot<-function(data=data,color=NULL,tl.cex=NULL,name=NULL,datasave=T,trans=F,cor=T,...){
  library(corrplot)
  
  if(is.null(color)){
    color<-colorRampPalette(c("navy", "white", "firebrick3"))(100)
  }else{color<-color} 

  if(is.null(tl.cex)){
    tl.cex1<-10/(2+(dim(data)[1])/8+(max(nchar(row.names(data))))/8)
  }else{tl.cex1<-tl.cex}
  
  if(!trans){
    data<-data
  }else{data<-t(data)}
  
  if(cor){
    data<-cor(data)
  }else{
    data<-data
  }
  
  if(!is.null(name)){
  name1<-paste0("-",name)
  name2<-name
  }else{
  name1<-name
  name2<-"相关性矩阵"
  }
  
  ti<-paste0("correlation",name1,".tif")
  tiff(filename =ti,width = 800, height =800)
  data1<-corrplot::corrplot(data,type = c("upper"),
                            order="hclust", title = "\n Correlation", 
                            tl.pos = "td",tl.col="black",
                            tl.cex =tl.cex1,
                            col=color,diag = FALSE,...)
  dev.off()
  
  pd<-paste0("correlation",name1,".pdf")
  pdf(file=pd,width = 10, height = 10)
  data1<-corrplot::corrplot(data,type = c("upper"),
                            order="hclust", title = "\n\n Correlation", 
                            tl.pos = "td",tl.col="black",tl.cex =tl.cex1,
                            col=color,diag = FALSE,...)
  dev.off()
  
#保存相关性矩阵 
  library(openxlsx)
  if (datasave){
    openxlsx::write.xlsx(x=data,file="相关性矩阵.xlsx",sheetName=name2,rowNames=T)
  }
  print("相关性矩阵.xlsx保存完成")
  return("corrplot绘制完成")
}

library(openxlsx)
data<-openxlsx::read.xlsx("rate-correlation.xlsx", rowName=T)
cluster <- openxlsx::read.xlsx("Cluster 9.xlsx", rowName=T)
data_main <- data[ rownames(data) %in%rownames(cluster) ,]
corplot(data=data,trans=T)
