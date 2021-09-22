library(openxlsx)
library(dplyr)
library(tidyr)
library(readxl)
setwd("Z:/项目数据/LCMS/2019/HT2019-0321-人血清/售后/售后2")


# system.time(hmdbname <- read.csv("hmdbname.csv", header = TRUE, 
#                      check.names = F, encoding = "UTF-8", 
#                      stringsAsFactors = F))
# system.time(hmdbname <- openxlsx::read.xlsx("hmdbname.xlsx"))
# system.time(hmdbname <- readxl::read_xlsx("hmdbname.xlsx"))
# 由上可知，这三种方法读数据，速度依次增加

hmdbname <- read.table("metaname.csv",sep = ",", header = T)
data <- RMETA2::readxlsx("meta02.xlsx"，sheet = 2)

RMETA2::autoID(name ="meta02.xlsx" ,needlist = "Metabolites") 


hmdbname$ %in% 


in_func <- function(goal=goal, hmdbname=hmdbname){
  return(ifelse(goal %in% hmdbname,hmdbname[1],NA))
}

map <- function(goal=goal,hmdbname=hmdbname  
){
  map1 <- na.omit(apply(hmdbname,1,in_func,goal=goal))
  map2 <- ifelse(is.logical(map1),NA,map1)
  return(map2)
}

# 原始方法
# 下面方法对于length大于20，有点乏力
# system.time(for (i in 1:length(data[,"Metabolites"])){
#   map1 <- na.omit(apply(hmdbname,1,in_func,x=data[,"Metabolites"][i]))
#   map2 <- ifelse(is.logical(map1),NA,map1)
#   map[[i]] <- map2
# })
# data$HMDBID <- unlist(map)
goal <- 1
data$HMDBID <- 1:length(data$Metabolites)
while (goal <= length(data$Metabolites)){
  data$HMDBID[goal]<-map(goal = data[,"Metabolites"][goal],hmdbname=hmdbname)
  print(goal)
  goal<-goal+1
  gc()
}

RMETA2::savexlsx1(data, name = "转换HMDBID的meta02-2.xlsx",sheet="转换HMDBID的meta02-2")



# library(foreach)
# library(doParallel)			         #doParallel适合Windows/Linux/Mac
# no_cores<-detectCores(logical=F)-1
# cl<-makeCluster(no_cores) 		   #先发起集群
# registerDoParallel(cl)			     #再进行登记注册
# 
# i=0
# t1 = Sys.time()
# goal <- 1:length(data[,"Metabolites"])
# foreach(goal=goal, .combine="c", .export=c("data","hmdbname","i","t1","in_func")) %dopar% {
#   data$HMDBID[goal]<-map(x = data[,"Metabolites"][goal],hmdbname=hmdbname)
#   i=i+1
#   print(paste("迭代了",i,"次",sep=""))
#   print(difftime(Sys.time(), t1, units = 'sec'))
#   gc()
# }
# 
# #最后结束集群
# stopImplicitCluster()	


gc()

