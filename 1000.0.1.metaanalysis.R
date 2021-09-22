setwd("Z:/home/段光前/20191119-LM2019-1207")


RMETA2::createregistration()                 #创建项目登记单
data<-RMETA2::readregistration()     #提取项目登记单信息
# data<-RMETA2::addregistration(data,name="项目登记单1.xlsx")
data<-RMETA2::autodataprocess(data)  #获取数据并处理
#1.数据获取    data<-RMETA2::datafetch(data)
#              data$data$rawdata$data<-RMETA2::readxlsx(name="数据矩阵.xlsx",sheet=1)  #直接有数据矩阵
#另外获取模式  data<-RMETA2::dataregistration(name="数据矩阵.xlsx",sheet="数据矩阵",type="LCMS",dif = ,species = ) 
#2.预处理      data<-RMETA2::preprocess(data)
#3.缺省值筛选  data<-RMETA2::automissvalue(data)
#3.rsd筛选     data<-RMETA2::autorsdfilter(data)
#5.0值处理     data<-RMETA2::zeroprocess(data)
# RMETA2::getdata(data) #矩阵获取 
#最终矩阵获取  RMETA2::getfinaldata(data)
#选择矩阵获取  RMETA2::getselectdata(data,which="data")
# data[["info"]][["mulstatistics"]][["shape"]][[1]]<-c(21,22,23,25,23)
# data[["info"]][["mulstatistics"]][["fill"]][[1]]<-c("green3","blue3", "gold","darkviolet","firebrick")
data<-RMETA2::allstatistics(data)          #pca(all)运算
RMETA2::getallstatisticsmap(data,showname=T)  #获取有名字的pca(all)图
#RMETA2::getstatisticsmap(data,showname=F)
data<-RMETA2::datastatistics(data)         #各比较组多元统计参数填写
data<-RMETA2::automulstatistics(data,adjust = F)      #,rangei = 1,rangej = 1,orthoI = 2,mode = "OPLS"各比较组多元统计运算, amount = 5
#RMETA2::createstatistic(data)             #simca多元统计使用
#获取正交主成分 data$statistics$OPLS[[1]][[1]]$orthoI



#更改正交主成分 data$statistics$OPLS[[1]][[1]]$orthoI<-6
#重新多元统计   data<-RMETA2::singlemulstatistics(data,i=1,j=1)
#获取数据及图片 RMETA2::getstatisticsmap(data,showname=T)
data<-RMETA2::getvip(data,statistics=T)   #获取vip数据，VIP.xlsx或脚本内数据
data<-RMETA2::countdif(data)              #P,FC等参数运算  ,paired = T
#差异代谢物获取 RMETA2::getdifdata(data,VIP=1,FC=NA,Pvalue=0.05,adjPvalue=NA)
#未筛选数据获取 RMETA2::getdifalldata(data)
#热图数据获取   RMETA2::getdifheatmap(data,VIP=1,FC=NA,Pvalue=0.05,adjPvalue=NA,range=NULL)
#前50热图获取   RMETA2::getdifheatmap(data,VIP=1,FC=NA,Pvalue=0.05,adjPvalue=NA,range=1:50)
#火山数据获取   RMETA2::getdifvol(data)
RMETA2::createlist(data)                #获取整体项目报告
rmarkdown::render('./LM2019-0720-河北医科大学-小鼠海马组织-LCMS(项目报告)/项目报告-LCMS-2.0.7.Rmd') # 生成报告（需在该文件夹添加 项目报告-LCMS-2.0.7.Rmd 文件）


setwd("I:/段光前-工作资料/20190701-LM2019-0263/P2019051312+(S20192756)-生工-皱纹盘鲍眼柄组织-LCMS(项目报告)/8.代谢通路分析")

RMETA2::auto_allweb(name="挑选的代谢物-20191031.xlsx",KEGG="local",rich="local",from="LCMS",needlist=c("Metabolites","Compound ID","log2(FC)"),needgroup=NULL,species="mmu")
RMETA2::auto_allweb(name="分析组三.xlsx",KEGG="local",rich="local",from="LCMS",needlist=c("Metabolites","Compound ID"),needgroup=NULL,species="mmu")


RMETA2::getstatisticsmap(data, showname = T) # 获得有样品名的PCA，PLS和OPLS图


RMETA2::auto_alldraw(name = '/heatmap.xlsx',
                     drawwhat = "heatmap",row = T,col =T ) # 画行 列都聚类的图

RMETA2::auto_alldraw(name="heatmap.xlsx",needgroup=NULL,drawwhat="heatmap",row=T,col=T,datasave = F,range = NULL) #给热图矩阵画热图
#venny
RMETA2::auto_alldraw(name="差异代谢物.xlsx",needgroup=list(c(2:3)),drawwhat="venny",needlist="Metabolites")
RMETA2::auto_alldraw(name="venny.xlsx",needgroup=list(c(1:2)),drawwhat="venny",needlist="Metabolites")
RMETA2::auto_alldraw(name="venny.xlsx",needgroup=list(c(1,3)),drawwhat="venny",needlist="Metabolites")
RMETA2::auto_alldraw(name="venny.xlsx",needgroup=list(c(3,5)),drawwhat="venny",needlist="Metabolites")



RMETA2::dirfile(filename="代谢通路分析") 
RMETA2::autoID(name ="挑选的代谢物-20191031.xlsx" ,needgroup =NULL ,needlist = "Lipid") #脂质项目中，由于没有Compound ID,需要在hmdbname.csv中进行匹配
RMETA2::auto_allweb(name="ID.xlsx",KEGG="local",rich="local",from="LCMS",needlist=c("Lipid","Compound ID"),needgroup=NULL,species="mmu") #画KEGG图
RMETA2::auto_allweb(name="ID.xlsx",KEGG="local",rich="local",from="LCMS",needlist=c("Lipid","Compound ID","FC"),needgroup=NULL,species="ath")

RMETA2::getsplotmap(data,showname = F,mode = "OPLS",type=1)
RMETA2::getsplotmap(data,showname = F,mode = "OPLS",type=2) #VIP>1,is red
RMETA2::getloadingsmap(data,showname = F,mode = "OPLS",type=1)


RMETA2::dSTEM(filename = "时间序列.xlsx",sheet = 1,cluster = 15)


# class
RMETA2::autoclassified(name="差异代谢物.xlsx",needgroup=NULL,from="LCMS",needlist="Compound ID")

# network
setwd("Z:/项目数据/LCMS/2019/LM2019-0637/售后1/7. 网络调控图")
dir <- list.dirs("Z:/项目数据/LCMS/2019/LM2019-0637/售后1/7. 网络调控图")[-1]

setwd(dir[3])
RMETA2::auto_alldraw(name="ID.xlsx",drawwhat = "network", p=NA, opacityNoHover = 1,species="hsa",fontSize = 13)


# LM2019-1181
# 合并数据矩阵
library(dplyr)
datah <- RMETA2::readxlsx("数据矩阵-黄.xlsx")
datax <- RMETA2::readxlsx("数据矩阵-杏.xlsx") #[,-c(1:3, 10,12:13)]

uni <- dplyr::intersect(datah$Metabolites, datax$Metabolites)
datah1 <- datah[datah$Metabolites%in%uni, ]
datax1 <- datax[datax$Metabolites%in%uni, ]
datah2 <- datah[!(datah$Metabolites %in% uni),]
datax2 <- datax[!(datax$Metabolites %in% uni),]

dataall1 <- cbind(datah1,datax1[,-(1:13)])
dataall2 <- dplyr::full_join(datah2, datax2)
dataall <- rbind(dataall1, dataall2)
dataall[is.na(dataall)] <- 0

RMETA2::savexlsx1(dataall,"合并数据矩阵.xlsx","合并数据矩阵")
# save.image()

# find difference in each group
# 13d
datadiff <- RMETA2::readxlsx("差异代谢物.xlsx",sheet=3)
common <- intersect(datadiff$Metabolites, uni)
spe <- setdiff(datadiff$Metabolites,common)
common_7d <- datadiff[datadiff$Metabolites %in% common,]
spe_h_7d <- datah[datah$Metabolites %in% spe,]
spe_x_7d <- datax[datax$Metabolites %in% spe,]

RMETA2::savexlsx1(common_7d,"杏28d vs 黄28d-共有.xlsx","杏28d vs 黄28d-共有")
RMETA2::savexlsx1(spe_h_7d,"黄28d-特有.xlsx","黄28d-特有")
RMETA2::savexlsx1(spe_x_7d,"杏28d-特有.xlsx","杏28d-特有")

# 1067
# get data
countnum <- function(vector,element){
  # vector<- as.factor(vector)
  # element<-as.factor(element)
  return(sum(vector%in%element))
}
library(dplyr)
data_matrix <- RMETA2::readxlsx("数据矩阵.xlsx") %>% na.omit()
soil_S <-  cbind(select(data_matrix, Metabolites), select(data_matrix, starts_with("soil-S")))
soil_S <- soil_S[apply(soil_S[,-1],1,countnum,element=0)<3,]
root_S <-  cbind(select(data_matrix, Metabolites), select(data_matrix, starts_with("root-S")))
root_S <- root_S[apply(root_S[,-1],1,countnum,element=0)<3,]
leaf_S <-  cbind(select(data_matrix, Metabolites), select(data_matrix, starts_with("leaf-S")))
leaf_S <- leaf_S[apply(leaf_S[,-1],1,countnum,element=0)<3,]
RMETA2::savexlsx1(soil_S,name = "Venn_groupone.xlsx","soil_S")
RMETA2::savexlsx1(root_S,name = "Venn_groupone.xlsx","root_S")
RMETA2::savexlsx1(leaf_S,name = "Venn_groupone.xlsx","leaf_S")

soil_H <-  cbind(select(data_matrix, Metabolites), select(data_matrix, starts_with("soil-H")))
soil_H <- soil_H[apply(soil_H[,-1],1,countnum,element=0)<3,]
root_H <-  cbind(select(data_matrix, Metabolites), select(data_matrix, starts_with("root-H")))
root_H <- root_H[apply(root_H[,-1],1,countnum,element=0)<3,]
leaf_H <-  cbind(select(data_matrix, Metabolites), select(data_matrix, starts_with("leaf-H")))
leaf_H <- leaf_H[apply(leaf_H[,-1],1,countnum,element=0)<3,]
RMETA2::savexlsx1(soil_H,name = "Venn_grouptwo.xlsx","soil_H")
RMETA2::savexlsx1(root_H,name = "Venn_grouptwo.xlsx","root_H")
RMETA2::savexlsx1(leaf_H,name = "Venn_grouptwo.xlsx","leaf_H")

#venn
RMETA2::auto_alldraw(name="Venn_groupone.xlsx",needgroup=list(c(1,2,3)),drawwhat="venny",needlist="Metabolites")
RMETA2::auto_alldraw(name="Venn_grouptwo.xlsx",needgroup=list(c(1,2,3)),drawwhat="venny",needlist="Metabolites")

# content change
common_S <- intersect(intersect(soil_S$Metabolites,root_S$Metabolites),leaf_S$Metabolites)
common_soil_S <- soil_S[soil_S$Metabolites%in%common_S,]
common_soil_S_content　<- data.frame("Metabolites"=common_soil_S$Metabolites, "Average(soil_S)"=rowMeans(common_soil_S[,-1]))
common_root_S <- root_S[root_S$Metabolites%in%common_S,]
common_root_S_content　<- data.frame("Metabolites"=common_root_S$Metabolites, "Average(root_S)"=rowMeans(common_root_S[,-1]))
common_leaf_S <- leaf_S[leaf_S$Metabolites%in%common_S,]
common_leaf_S_content　<- data.frame("Metabolites"=common_leaf_S$Metabolites, "Average(leaf_S)"=rowMeans(common_leaf_S[,-1]))
common_s_content <- cbind(common_soil_S_content,common_root_S_content$Average.root_S., common_leaf_S_content$Average.leaf_S.)
common_s_content <- cbind(common_s_content,common_s_content %>% transmute_at(vars(-Metabolites), function(x, na.rm = FALSE) (x/common_soil_S_content$Average.soil_S.)))

common_H <- intersect(intersect(soil_H$Metabolites,root_H$Metabolites),leaf_H$Metabolites)
common_soil_H <- soil_H[soil_H$Metabolites%in%common_H,]
common_soil_H_content　<- data.frame("Metabolites"=common_soil_H$Metabolites, "Average(soil_H)"=rowMeans(common_soil_H[,-1]))
common_root_H <- root_H[root_H$Metabolites%in%common_H,]
common_root_H_content　<- data.frame("Metabolites"=common_root_H$Metabolites, "Average(root_H)"=rowMeans(common_root_H[,-1]))
common_leaf_H <- leaf_H[leaf_H$Metabolites%in%common_H,]
common_leaf_H_content　<- data.frame("Metabolites"=common_leaf_H$Metabolites, "Average(leaf_H)"=rowMeans(common_leaf_H[,-1]))
common_H_content <- cbind(common_soil_H_content,common_root_H_content$Average.root_H., common_leaf_H_content$Average.leaf_H.)
common_H_content <- cbind(common_H_content,common_H_content %>% transmute_at(vars(-Metabolites), function(x, na.rm = FALSE) (x/common_soil_H_content$Average.soil_H.)))

RMETA2::savexlsx1(common_s_content,name = "commonMetabolites_content.xlsx","S_commonMetabolites_content")
RMETA2::savexlsx1(common_H_content,name = "commonMetabolites_content.xlsx","H_commonMetabolites_content")
RMETA2::savexlsx1(data.frame("S_H_commonMetabolites"=intersect(common_H,common_S)),name = "commonMetabolites_content.xlsx","S_H_commonMetabolites")

