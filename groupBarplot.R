# 分组柱状图
setwd("C:/Users/Pioneer/Desktop")

# read xlsx file
library(openxlsx)
readxlsx<- function(name=name, sheet=sheet, colnames=F,...){
   data <- openxlsx::read.xlsx(name, sheet,...)
   data1<- openxlsx::read.xlsx(name, sheet, colNames=colnames,...)
   colnames(data)<-data1[1,]
   return(data)
}

data <- openxlsx::read.xlsx("陈霞师姐-plaque-assay-analysis.xlsx", 
                            sheet = 3)
data1 <- openxlsx::read.xlsx("陈霞师姐-plaque-assay-analysis.xlsx", 
                            sheet = 3, colNames=F)
colnames(data) <- data1[1,]

# transform data into long-format type data
library(reshape2)
data_long <- reshape2::melt(data, id.vars=c("Sample", "Group")) 
# data_long$variable <- factor(data_long$variable, rev(unique(data_long$variable)))

# drawing figure
library(ggplot2)

ggplot(data_long, aes(x=Group, y=value, fill=variable, ymin=min(value), ymax=max(value)))+
      geom_bar(stat="identity",position = "dodge",width=0.8)+coord_polar(clip = "off")+
      theme_bw()
      scale_fill_discrete()

# read data
data <- readxlsx("陈霞师姐作图数据-final-20191101.xlsx",2,F)
     
library(reshape2)
data_long <- reshape2::melt(data)
data_long$variable <- factor(data_long$variable, rev(unique(data_long$variable)))
sd<-apply(data[,-1],2,sd)
mean<-apply(data[,-1],2,mean)
# drawing figure
library(ggplot2)
data_long$sd <- rep(sd,each=3)
data_long$ymin <- rep(mean-sd,each=3)
data_long$ymax <- rep(mean+sd,each=3)
ggplot(data_long, aes(variable, value, color=variable))+
      geom_errorbar(aes(ymin=ymin ,ymax=ymax),
                 size=1)+
   geom_point(stat = "summary", fun.y="mean")+
   xlab("Group")+
   ylab("cell viability(%)")+
   scale_y_continuous(breaks = seq(0,100,20),limits = c(0,100))+
   coord_fixed(ratio =0.125)+
   # theme(axis.line.y=element_line())
   # coord_polar(direction = -1)+
   theme_bw()
