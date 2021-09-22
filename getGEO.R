# cytoscope file 
setwd("C:/Users/Pioneer/Desktop/产品经理工作内容-20200601/客户2020-8-17-线下/2020-9-7-孙鑫-沈阳药科大学")

library(openxlsx)
library(dplyr)

data <- read.csv("targetSymbol.txt",sep = "\t")

data_drug <- read.csv("Drug_Disease.txt",header = F,sep = "\t")

data_type <- read.csv("type.txt",header = T,sep = "\t")
data$Symbol %in% data_type$Node 

data_drug_only <- data[data$Symbol %in%  data_drug$V1,]

molLists <- data_drug_only$MolName %>% unique() %>% data.frame()

colnames(molLists) <- "molLists"

# write.csv(molLists, file = "molLists.txt", sep = "\t")

# 2. type.txt

#1. 安装GEOquery包，可https://www.bioconductor.org/packages/release/bioc/html/GEOquery.html查看详情
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("GEOquery")


#2.下载数据
options(warn=-1)
suppressMessages(library(GEOquery))
# setwd("") #设置工作目录
GPL16043 <- getGEO('GPL16043', destdir=".")
# 用Table(GPL16043)可以得到表达矩阵！
# 用Meta(GPL16043)可以得到描述信息
names(Meta(GPL16043))
head(Table(GPL16043))




