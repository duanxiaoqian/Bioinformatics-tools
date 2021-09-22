library(dplyr)
library(tidyverse)
library(RMETA2)
path <- "I:/段光前-工作资料/20190731-HT2019-0382"
filename_neg <- 'HT2019-0382-neg.txt'
filename_pos <- 'HT2019-0382-pos.txt'
samplename <- 'samplename.xlsx'
lipid_predata <- lipid_predeal(path = path, filename_neg = filename_neg, filename_pos=filename_pos, samplename = samplename)

# 合并，并改名调顺序
lipid_predeal <- function(path=path, filename_neg=filename_neg, 
                          filename_pos=filename_pos, 
                          samplename=samplename,
                          normalize=T,
                          ...){
  print("开始预处理")
  neg <- predeal.lipid(path=path, filename=filename_neg,...)
  pos <- predeal.lipid(path=path, filename=filename_pos,...)
  pos <- pos[colnames(neg)]
  
  # 更改列名，换成对应的样品名
  sample_name_neg <- openxlsx::read.xlsx(samplename, sheet=1)
  sample_df_neg <- dplyr::select(neg,starts_with("Area")) %>% dplyr::rename(!!setNames(sample_name_neg[,1], sample_name_neg[,2]))
  sample_df_neg <- sample_df_neg[order(colnames(sample_df_neg))]
  sample_name_pos <- openxlsx::read.xlsx(samplename, sheet=2)
  sample_df_pos <- dplyr::select(pos,starts_with("Area")) %>% dplyr::rename(!!setNames(sample_name_pos[,1], sample_name_pos[,2]))
  sample_df_pos <- sample_df_pos[order(colnames(sample_df_pos))]

  # 判断neg与pos的列名是否相同
  if (!sum(colnames(sample_df_neg)==colnames(sample_df_pos))==length(sample_df_neg)){
    stop("The samplenames of neg and pos are not same, please check column names translated by samplenames")
  }
  
  # 合并
  data_merged <- cbind(rbind(dplyr::select(neg,-starts_with("Area")), 
                       dplyr::select(pos,-starts_with("Area"))), rbind(sample_df_neg,sample_df_pos)) %>% 
                 dplyr::arrange(desc(Grade))
  data_merged_unique <- data_merged[!duplicated(data_merged$LipidIon),]

  # 增加ID列，并对列名进行更改
  data_final <- dplyr::mutate(data_merged_unique,
                              ID=array(seq(1, length(data_merged_unique$LipidIon)),
                              dim=c(length(data_merged_unique$LipidIon), 1))) %>% plyr::rename(c("LipidIon"="Lipid",
                                                                                                 "IonFormula"="Formula",
                                                                                                 "CalcMz"="m/z",
                                                                                                 "Ionmode"="Ion mode")) %>% select(-Grade)

  # 按报告既定顺序进行排序

  data_final1 <- data_final[,c(length(colnames(data_final)),9,11,12,1,2,3,10,4,5,6,7,8,13:(length(colnames(data_final))-1))]
  print("数据预处理完成")

  # 保存矩阵
  RMETA2::savexlsx1(data = data_final1, name="脂质预处理数据矩阵.xlsx",sheet = "脂质预处理数据矩阵")
  message("脂质数据预处理完成, 开始进入常规流程...")
  return(data_final1)
}



predeal.lipid <- function(path=path, filename=filename, normalize=T,...){
  setwd(path)
  data <- read.csv(filename,header = T, sep = "\t", encoding = 'utf-8', check.names = F)
  data <- dplyr::rename(data,"drop"=length(colnames(data)))
  
  vari.name1 <- c('LipidIon', 'LipidGroup', 'Class', 'FattyAcid', 'FA1', 'FA2', 'FA3', 'FA4',
                'CalcMz', 'IonFormula')
  
  if (!('FA3' %in% colnames(data))){
    data1 <- dplyr::mutate(data, FA3=array('',dim=c(length(data$FA1), 1)))
  }else{data1 <- data}
  if ('FA4' %in% colnames(data)){
    data1 <- dplyr::select(data1, vari.name1)
  }else{
    data1 <- dplyr::mutate(data1, FA4=array('',dim=c(length(data$FA1), 1))) %>% select(vari.name1)
  }
  
  data1$LipidIon <- gsub('_', '/',data1$LipidIon)
  data1$FattyAcid <- gsub('_', '/',data1$FattyAcid)
  if (stringr::str_detect(string = tolower(filename), pattern = 'neg')){
    data1$LipidIon <- gsub('-H', '', data1$LipidIon) %>% gsub(pattern = '-2H', replacement = '') %>% gsub(pattern = "+HCOO", replacement = '', fixed = T)
    data1 <- dplyr::mutate(data1, Ionmode=array('neg',dim = c(length(data$FA1), 1)))
  }else{
    data1$LipidIon <- gsub('+H', '', data1$LipidIon, fixed = T) %>% gsub(pattern = '+Na', replacement = '', fixed = T) %>% gsub(pattern = "+NH4", replacement = '', fixed = T)
    data1 <- dplyr::mutate(data1, Ionmode=array('pos',dim = c(length(data$FA1), 1)))
  }
  # vari.name2 <- c('Area[', 'Rt[', 'Grade[')
  
  # 归一化
  if (normalize){
    func <- function(x, na.rm = FALSE)(10000*x/sum(x, na.rm = FALSE))
    data2 <- dplyr::select(data, starts_with('Area[')) %>% transmute_all(.funs = func)
  }
  data2 <- dplyr::select(data, starts_with('Area['))
  
  # RT求平均值
  data3 <- data.frame("Retention time" = dplyr::select(data, starts_with('Rt[')) %>% rowMeans(), check.names = F)
  
  # 保留Grade分值最大列, 并按Grade排序
  mat<- function(x) {
    d1 <- data.frame(c1=c("A", "B", "C", "D", "NA"), c2=c(4,3,2,1,0), stringsAsFactors=FALSE)
    unname(setNames(d1[,2], d1[,1])[x])
    # d1$C2[match(x, d1$c1)]
  }
  # 同上表达(修改)：
  # within(df, {accept[accept=="A"]<-4
  #             name2[name2=="B"]<-3})
  data4 <- data.frame("Grade" = dplyr::select(data, starts_with('Grade[')) %>% transmute_all(.funs = mat) %>% rowSums(), check.names=F)
  data_bind <- cbind(data1, data3, data4,data2) %>% dplyr::arrange(desc(Grade))
  
  # 去重LipidIon
  data_final <-  data_bind[!duplicated(data_bind$LipidIon),]
  return(data_final)
}

  

