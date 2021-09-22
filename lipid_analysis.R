library(dplyr)
library(tidyverse)
library(RMETA2)
path <- "Z:/home/段光前/脂质项目/20200311-LM2020-0002/售后/售后1"
filename_neg <- 'LM20200002_neg.txt' # 名字中要包含的neg or pos
filename_pos <- 'LM20200002_pos.txt'
samplename <- 'samplename.xlsx'


setwd(path)
file.copy("../模板文件/samplename.xlsx", "./")
RMETA2::createregistration()                 #创建项目登记单
data<-RMETA2::readregistration()     #提取项目登记单信息
# data<-RMETA2::addregistration(data,name="项目登记单1.xlsx")
# data<-RMETA2::addregistration(data,name="项目登记单2.xlsx")
data$data$rawdata$data<- lipid_predeal(path = path, filename_neg = filename_neg, 
                                       filename_pos=filename_pos, samplename = samplename,
                                       normalize=T)
#2.预处理      
data<-RMETA2::preprocess(data)

#3.缺省值筛选  
data<-RMETA2::automissvalue(data)
#4.rsd筛选     
data<-RMETA2::autorsdfilter(data)
#5.0值处理     
data<-RMETA2::zeroprocess(data)
#矩阵获取
RMETA2::getdata(data) 
#最终矩阵获取  RMETA2::getfinaldata(data)
#选择矩阵获取  RMETA2::getselectdata(data,which="data")
data<-RMETA2::allstatistics(data)          #pca(all)运算
RMETA2::getallstatisticsmap(data,showname=T)  #获取有名字的pca(all)图
#RMETA2::getstatisticsmap(data,showname=F)
data<-RMETA2::datastatistics(data)         #各比较组多元统计参数填写
data<-RMETA2::automulstatistics(data)      #各比较组多元统计运算
#RMETA2::createstatistic(data)             #simca多元统计使用
#获取正交主成分 data$statistics$OPLS[[1]][[1]]$orthoI
#更改正交主成分 data$statistics$OPLS[[1]][[1]]$orthoI<-6
#重新多元统计   data<-RMETA2::singlemulstatistics(data,i=1,j=1)
#获取数据及图片 RMETA2::getstatisticsmap(data,showname=F)
data<-RMETA2::getvip(data,statistics=T)   #获取vip数据，VIP.xlsx或脚本内数据
data<-RMETA2::countdif(data)              #P,FC等参数运算
#差异代谢物获取 RMETA2::getdifdata(data,VIP=1,FC=NA,Pvalue=0.05,adjPvalue=NA)
#未筛选数据获取 RMETA2::getdifalldata(data)
#热图数据获取   RMETA2::getdifheatmap(data,VIP=1,FC=NA,Pvalue=0.05,adjPvalue=NA,range=NULL)
#前50热图获取   RMETA2::getdifheatmap(data,VIP=1,FC=NA,Pvalue=0.05,adjPvalue=NA,range=1:50)
#火山数据获取   RMETA2::getdifvol(data)
RMETA2::createlist(data)                #获取整体项目报告

RMETA2::auto_alldraw(name="代谢通路富集表.xlsx", drawwhat = "bubblechart")









