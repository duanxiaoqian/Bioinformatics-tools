######################################################################
#* Rscript function：WGCNA代谢物共表达网络分析流程
#* Author：jingxinxing
#* Date：2020/01/14
#* Version: v2.0
######################################################################
#
#* Usage：
#* New：
#
######################################################################
#
######################################################################
# 1.WGCNA分析前期准备
######################################################################
## 1.1 脚本运行计时开始
pt=proc.time()
## 1.2 WGCNA分析开始日期时间
print("WGCNA分析及绘图日志开始时间：")
d <- Sys.Date()
print("当前日期是：")
print(d)
weekdays(d)
months(d)
quarters(d)
print("国际标准时间是：")
d2 <- date()
print(d2)
print("分析开始：Start...")

## 1.3 设置WGCNA分析工作主目录
setwd("./")

## 1.4 创建代谢组WGCNA分析目录结构：WGCNA_M
dir()

if (dir.exists("WGCNA_M")) { # WGCNA目录存在，根据现有的情况进行建立目录结构
  list.files("WGCNA_M")
  getwd()
  setwd("./WGCNA_M")
  dir()

  if (dir.exists("1.Data_Processing")) { # 1.Data_Processing
    print("目录1.Data_Processing已经存在！")
    dir("./1.Data_Processing/")
    setwd("./1.Data_Processing/")
    if (dir.exists("1.1Data") & dir.exists("1.2Sample_filtered")) {
      print("子目录1.1Data和1.2Sample_filtered已经存在！")
      dir()
    } else {
      dir.create("1.1Data")
      dir.create("1.2Sample_filtered")
      dir()
    }
    setwd("../")
    getwd()
    dir()
  }

  if (dir.exists("2.Network_Construction")) { # 2.Network_Construction
    print("目录2.Network_Construction已经存在！")
  } else {
    dir.create("./2.Network_Construction/")
  }

  if (dir.exists("3.Module_Identification_and_Visualization")) { # 3.Module_Identification_and_Visualization
    print("目录3.Module_Identification_and_Visualization已经存在！")
  } else {
    dir.create("./3.Module_Identification_and_Visualization/")
  }

  if (dir.exists("4.Modules_with_External_Information_Associations_Analysis")) { # 4.Modules_with_External_Information_Associations_Analysis
    print("目录4.Modules_with_External_Information_Associations_Analysis已经存在！")
    dir("./4.Modules_with_External_Information_Associations_Analysis/")
    setwd("./4.Modules_with_External_Information_Associations_Analysis/")
    if (dir.exists("4.1Modules_Samples_Associations_Analysis") & dir.exists("4.2Modules_Traits_Associations_Analysis")) {
      print("子目录4.1Modules_Samples_Associations_Analysis和4.2Modules_Traits_Associations_Analysis已经存在！")
      dir()
    } else {
      dir.create("4.1Modules_Samples_Associations_Analysis")
      dir.create("4.2Modules_Traits_Associations_Analysis")
      getwd()
      dir()
    }
    setwd("../")
    getwd()
    dir()
  } else {
    dir.create("./4.Modules_with_External_Information_Associations_Analysis")
    setwd("./4.Modules_with_External_Information_Associations_Analysis")
    dir.create("4.1Modules_Samples_Associations_Analysis")
    dir.create("4.2Modules_Traits_Associations_Analysis")
    if (dir.exists("4.1Modules_Samples_Associations_Analysis") & dir.exists("4.2Modules_Traits_Associations_Analysis")) {
      print("目录：4.1Modules_Samples_Associations_Analysis和4.2Modules_Traits_Associations_Analysis已经建立！")
    } else {
      print("请检查目录：4.1Modules_Samples_Associations_Analysis和4.2Modules_Traits_Associations_Analysis")
    }
    setwd("../")
  }

  if (dir.exists("5.Hub_Network_&_TOM_Visualization")) { # 5.Hub_Network_&_TOM_Visualization
    print("目录5.Hub_Network_&_TOM_Visualization已经存在！")
    dir("./5.Hub_Network_&_TOM_Visualization/")
    setwd("./5.Hub_Network_&_TOM_Visualization/")
    if (dir.exists("5.1Modules_Hub_Network") & dir.exists("5.2TOM_Visualization")) {
      print("子目录5.1Modules_Hub_Network和5.2TOM_Visualization已经存在！")
      dir()
    } else {
      dir.create("5.1Modules_Hub_Network")
      dir.create("5.2TOM_Visualization")
      getwd()
      dir()
    }
    setwd("../")
    getwd()
    dir()
  } else {
    dir.create("./5.Hub_Network_&_TOM_Visualization/")
    setwd("5.Hub_Network_&_TOM_Visualization")
    dir.create("5.1Modules_Hub_Network")
    dir.create("5.2TOM_Visualization")
    if (dir.exists("5.1Modules_Hub_Network") & dir.exists("5.2TOM_Visualization")) {
      print("目录：5.1Modules_Hub_Network和5.2TOM_Visualization已经建立！")
    } else {
      print("请检查目录：5.1Modules_Hub_Network和5.2TOM_Visualization")
    }
    setwd("../")
  }

  # if (dir.exists("6.Biofunctional_Enrichment_Analysis")) { # 6.Biofunctional_Enrichment_Analysis
  #   print("目录6.Biofunctional_Enrichment_Analysis已经存在！")
  #   dir("./6.Biofunctional_Enrichment_Analysis/")
  #   setwd("./6.Biofunctional_Enrichment_Analysis/")
  #   if (dir.exists("6.1GO_Enrichment") & dir.exists("6.2KEGG_Enrichment")) {
  #     print("子目录6.1GO_Enrichment和6.2KEGG_Enrichment已经存在！")
  #     dir()
  #   } else {
  #     dir.create("6.1GO_Enrichment")
  #     dir.create("6.2KEGG_Enrichment")
  #     getwd()
  #     dir()
  #   }
  #   setwd("../")
  #   getwd()
  #   dir()
  # } else {
  #   dir.create("./6.Biofunctional_Enrichment_Analysis/")
  #   setwd("6.Biofunctional_Enrichment_Analysis")
  #   dir.create("6.1GO_Enrichment")
  #   dir.create("6.2KEGG_Enrichment")
  #   if (dir.exists("6.1GO_Enrichment") & dir.exists("6.2KEGG_Enrichment")) {
  #     print("目录：6.1GO_Enrichment和6.2KEGG_Enrichment已经建立！")
  #   } else {
  #     print("请检查目录：6.1GO_Enrichment和6.2KEGG_Enrichment")
  #   }
  #   setwd("../")
  # }
  setwd("../")

} else { # WGCNA目录不存在，从头新建WGCNA分析目录结构
  dir.create("WGCNA_M")
  setwd("./WGCNA_M")
  # 1.Data_Processing
  dir.create("1.Data_Processing")
  setwd("1.Data_Processing")
  ## 1.1Data
  dir.create("1.1Data")
  ## 1.2Sample_filtered
  dir.create("1.2Sample_filtered")
  if (dir.exists("1.1Data") & dir.exists("1.2Sample_filtered")) {
    print("WGCNA分析子目录1.Data_Processing建立成功！")
  } else {
    print("请检查WGCNA子目录：1.1Data和1.2Sample_filtered，可能没有建立成功！")
  }
  dir()
  setwd("../")
  # 2.Network_Construction
  dir.create("2.Network_Construction")
  if (dir.exists("2.Network_Construction")) {
    print("WGCNA分析子目录2.Network_Construction建立成功！")
  } else {
    print("请检查WGCNA子目录：2.Network_Construction，可能没有建立成功！")
  }
  # 3.Module_Identification_and_Visualization
  dir.create("3.Module_Identification_and_Visualization")
  if (dir.exists("3.Module_Identification_and_Visualization")) {
    print("WGCNA分析子目录3.Module_Identification_and_Visualization建立成功！")
  } else {
    print("请检查WGCNA子目录：3.Module_Identification_and_Visualization，可能没有建立成功！")
  }
  # 4.Modules_with_External_Information_Associations_Analysis
  dir.create("4.Modules_with_External_Information_Associations_Analysis")
  setwd("4.Modules_with_External_Information_Associations_Analysis")
  ## 4.1Modules_Samples_Associations_Analysis
  dir.create("4.1Modules_Samples_Associations_Analysis")
  ## 4.2Modules_Traits_Associations_Analysis
  dir.create("4.2Modules_Traits_Associations_Analysis")
  if (dir.exists("4.1Modules_Samples_Associations_Analysis") & dir.exists("4.2Modules_Traits_Associations_Analysis")) {
    print("WGCNA分析子目录4.Modules_with_External_Information_Associations_Analysis建立成功！")
  } else {
    print("请检查WGCNA子目录：4.1Modules_Samples_Associations_Analysis和4.2Modules_Traits_Associations_Analysis，可能没有建立成功！")
  }
  dir()
  setwd("../")
  # 5.Hub_Network_&_TOM_Visualization
  dir.create("5.Hub_Network_&_TOM_Visualization")
  setwd("./5.Hub_Network_&_TOM_Visualization")
  ## 5.1Modules_Hub_Network
  dir.create("5.1Modules_Hub_Network")
  ## 5.2TOM_Visualization
  dir.create("5.2TOM_Visualization")
  if (dir.exists("5.1Modules_Hub_Network") & dir.exists("5.2TOM_Visualization")) {
    print("WGCNA分析子目录5.Hub_Network_&_TOM_Visualization建立成功！")
  } else {
    print("请检查WGCNA子目录：5.1Modules_Hub_Network和5.2TOM_Visualization")
  }
  dir()
  setwd("../")
  # # 6.Biofunctional_Enrichment_Analysis
  # dir.create("6.Biofunctional_Enrichment_Analysis")
  # setwd("6.Biofunctional_Enrichment_Analysis")
  # ## 6.1GO_Enrichment
  # dir.create("6.1GO_Enrichment")
  # ## 6.2KEGG_Enrichment
  # dir.create("6.2KEGG_Enrichment")
  # if (dir.exists("6.1GO_Enrichment") & dir.exists("6.2KEGG_Enrichment")){
  #   print("WGCNA分析子目录6.Biofunctional_Enrichment_Analysis建立成功！")
  #   dir()
  # } else {
  #   print("请检查WGCNA子目录：6.1GO_Enrichmenth和6.2KEGG_Enrichment，可能没有建立成功！")
  # }
  dir()
  # setwd("../")
  getwd()
  if (dir.exists("1.Data_Processing") & dir.exists("2.Network_Construction") & dir.exists("3.Module_Identification_and_Visualization") & dir.exists("4.Modules_with_External_Information_Associations_Analysis") & dir.exists("5.Hub_Network_&_TOM_Visualization") & dir.exists("6.Biofunctional_Enrichment_Analysis")) {
    print("蛋白WGCNA分析目录系统已经建立！")
    length(list.dirs("./"))
  } else {
    print("请检查WGCNA各个目录！WGCNA分析目录系统可能建立失败！")
  }
  setwd("../")
}

## 1.5 批量导入R包
anp <- c("WGCNA", "openxlsx", "reshape2", "stringr", "dplyr", "ggplot2", "progress", "pheatmap", "clusterProfiler", "AnnotationHub", "DOSE", "org.Hs.eg.db", "GO.db", "rio", "topGO", "pathview", "mice", "COMBAT", "AnnotationDbi", "igraph", "enrichplot", "slickR", "svglite", "rmarkdown", "knitr")
sapply(anp, library, character.only = T)

## 1.6 脚本执行进度条
print("分析开始：Start")
ppbb <- progress_bar$new(total = 1000)
for (i in 1:1000) {
  ppbb$tick()
  Sys.sleep(1 / 1000)
}

## 1.7 WGCNA分析R环境及线程设置
### 1.7.1 options()函数允许用户设置和检查影响R计算和显示其结果的方式的各种全局选项
options(stringsAsFactors = FALSE)

### 1.7.2 打开多线程
# enableWGCNAThreads(nThreads = 3)
enableWGCNAThreads()
# Allowing parallel execution with up to 5 working processes.

######################################################################
######################################################################
######################################################################

# 一、数据处理
# ***
#   WGCNA分析的输入数据是蛋白表达矩阵数据和样品性状矩阵数据，经过对数据进行Z-score标准化、批次效应校正、缺失值处理后得到WGCNA分析所需的Cleandate。WGCNA后续分析都是基于Cleandata进行的。

# 1.数据处理（包括四个部分：
exprMat <- "Samples_and_Metabolin_"

## 1.2 读取数据（ExprDataRaw）
ExprDataRaw <- read.xlsx("ExprData_raw.xlsx", sheet = "metabolin", startRow = 1, colNames = T, rowNames = T, detectDates = F)

## 1.3.1 代谢物原始表达矩阵数据的列名：样品名称和一些其他代谢物质谱数据，我们后面只保留样品列和所有可信代谢物行数据
print("查看原始代谢物表达矩阵的列名，即样品名称：")
colnames(ExprDataRaw)


## 1.3.2 查看前6个代谢物（设置代谢物Metabolites为行名）
print("查看代谢物表达矩阵中前6个代谢物：")
head(rownames(ExprDataRaw))
# [1] "Sphingosine"
# [2] "3-alpha-Androstanediol glucuronide"
# [3] "LysoPE(15:0/0:0)"
# [4] "Deoxycholic acid"
# [5] "Glycocholic Acid"
# [6] "5a-Cholestane-3a,7a,12a,25-tetrol"

## 1.4 保存原始数据到目录：./WGCNA_M/1.Data_Processing/1.1Data
if (file.exists("ExprData_raw.xlsx") & dir.exists("./WGCNA_M/1.Data_Processing/1.1Data/")) {
  file.copy(from = "./ExprData_raw.xlsx", to = "./WGCNA_M/1.Data_Processing/1.1Data")
  file.exists("./WGCNA_M/1.Data_Processing/1.1Data")
} else {
  print("请注意：文件ExprData_raw.xlsx不存在！目录./WGCNA_M/1.Data_Processing/1.1Data/不存在！请检查后重试！")
  dir()
}

## 1.5 读取sample_information.xlsx文件中的样品和比较组信息
sample_info_1 <- read.xlsx("sample_information.xlsx", sheet = "样品信息", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE) # sample_info_1是sample_information.xlsx的sheet="样品信息"的数据
sample_info_2 <- read.xlsx("sample_information.xlsx", sheet = "比较组信息", startRow = 1, colNames = TRUE, rowNames = FALSE, detectDates = FALSE) # sample_info_2是sample_information.xlsx的sheet="比较组信息"的数据
print("查看样品信息")
sample_info_1
#    样品分组 样品编号 作图编号
# 1         A      1_1      1_1
# 2         A      1_2      1_2
# 3         A      1_3      1_3
# 4         A      1_4      1_4
# 5         A      1_5      1_5
# 6         A      1_6      1_6
# 7         A      1_7      1_7
# 8         A      1_8      1_8
# 9         A      1_9      1_9
# 10        A     1_10     1_10
# 11        A     1_11     1_11
# 12        B      2_1      2_1
# 13        B      2_2      2_2
# 14        B      2_3      2_3
# 15        B      2_4      2_4
# 16        B      2_5      2_5
# 17        B      2_6      2_6
# 18        B      2_7      2_7
# 19        B      2_8      2_8
# 20        B      2_9      2_9
# 21        B     2_10     2_10
# 22        B     2_11     2_11
# 23        C      3_1      3_1
# 24        C      3_2      3_2
# 25        C      3_3      3_3
# 26        C      3_4      3_4
# 27        C      3_5      3_5
# 28        C      3_6      3_6
# 29        C      3_7      3_7
# 30        C      3_8      3_8
# 31        C      3_9      3_9
# 32        C     3_10     3_10
# 33        C     3_11     3_11
dim(sample_info_1)
# [1] 33  3
print("查看比较组信息")
sample_info_2
# 比较组 交集 物种 韦恩
# 1    A/B   NA   NA   NA
# 2    B/C   NA   NA   NA
# 3    A/C   NA   NA   NA
dim(sample_info_2)
# [1] 3 4

## 1.6 获取Clean可信代谢物-样品数据矩阵（ExprDataClean）
sam_name <- sample_info_1$`作图编号`
sam_ma <- match(sam_name, colnames(ExprDataRaw)) # 获取样品在数据集中的位置索引

ExprDataClean <- ExprDataRaw[,sam_ma] # 根据样品名称位置索引提取干净的代谢物样品表达矩阵数据
print("查看Clean可信代谢物-样品数据矩阵的大小（行数和列数）")
dim(ExprDataClean) # 查看Clean可信代谢物-样品数据矩阵的大小（行数和列数）
# [1] 11044    33

## 1.7 可信代谢物数据的列名：样品名称和一些其他代谢物质谱数据，我们后面只保留样品列
print("去除无关的数据之后的代谢物表达矩阵数据的列名为：")
colnames(ExprDataClean)
# [1] "1_1"  "1_2"  "1_3"  "1_4"  "1_5"  "1_6"  "1_7"  "1_8"
# [9] "1_9"  "1_10" "1_11" "2_1"  "2_2"  "2_3"  "2_4"  "2_5"
# [17] "2_6"  "2_7"  "2_8"  "2_9"  "2_10" "2_11" "3_1"  "3_2"
# [25] "3_3"  "3_4"  "3_5"  "3_6"  "3_7"  "3_8"  "3_9"  "3_10"
# [33] "3_11"

print(paste0("去除无关的数据之后的代谢物表达矩阵的样品个数为：",length(colnames(ExprDataClean)),"个"))

## 1.8 查看前6个代谢物
print("查看前6个代谢物：")
head(rownames(ExprDataClean))
# [1] "Sphingosine"
# [2] "3-alpha-Androstanediol glucuronide"
# [3] "LysoPE(15:0/0:0)"
# [4] "Deoxycholic acid"
# [5] "Glycocholic Acid"
# [6] "5a-Cholestane-3a,7a,12a,25-tetrol"

## 1.9 Clean可信代谢物-样品数据矩阵的行列转置：t()函数
ExprDataClean_t <- t(ExprDataClean)
dim(ExprDataClean_t)
# [1]    33 11044
print("查看转置后的Clean数据的前5列：")
ExprDataClean_t[,1:5]
#@ 数据很多，这里省略

## 2.0 表达矩阵数据的标准化处理Z-score，其他标准化方法可以后续填加进来：scale()函数；
class(ExprDataClean_t)
# [1] "matrix"
ExprDataClean_t_Scale <- scale(ExprDataClean_t, center = T, scale = T)
class(ExprDataClean_t_Scale)
# [1] "matrix"
ExprDataClean_t_Scale <- as.data.frame(ExprDataClean_t_Scale)
print("查看前六个代谢物：")
head(colnames(ExprDataClean_t_Scale))
# [1] "Sphingosine"
# [2] "3-alpha-Androstanediol glucuronide"
# [3] "LysoPE(15:0/0:0)"
# [4] "Deoxycholic acid"
# [5] "Glycocholic Acid"
# [6] "5a-Cholestane-3a,7a,12a,25-tetrol"

print("查看样品名：")
rownames(ExprDataClean_t_Scale)
# [1] "1_1"  "1_2"  "1_3"  "1_4"  "1_5"  "1_6"  "1_7"  "1_8"
# [9] "1_9"  "1_10" "1_11" "2_1"  "2_2"  "2_3"  "2_4"  "2_5"
# [17] "2_6"  "2_7"  "2_8"  "2_9"  "2_10" "2_11" "3_1"  "3_2"
# [25] "3_3"  "3_4"  "3_5"  "3_6"  "3_7"  "3_8"  "3_9"  "3_10"
# [33] "3_11"

## 2.1 导出标准化的代谢物表达数据，中间数据，暂时不导出
# export(ExprDataClean_t_Scale, file = "dataExp_scale.xlsx", rowNames = T, colNames = T, zoom = 120)

## 2.2 样品批次效应校正batch effect，R包ComBat；
#######################################################################
# 待补充
#######################################################################

## 2.3 表达矩阵数据缺失值处理NA或NaN，R包Mice）
#######################################################################
# 待补充
#######################################################################

## 2.4 样品代谢物表达数据格式和内容检测，主要是缺失值的处理
gsp <- goodSamplesGenes(ExprDataClean_t_Scale, verbose = 3) # good samples proteins, gsp
# Flagging genes and samples with too many missing values.....step 1
length(gsp$goodGenes)
# [1] 11044
length(gsp$goodSamples)
# [1] 33
gsp$allOK
# [1] TRUE

## 2.5 表达矩阵的缺失数据的剔除，主要从观察值和变量值两个角度进行，对于代谢物就是从样品和代谢物两个维度进行阈值的筛选，超过缺失值筛选阈值的样品和代谢物就要剔除掉！
if (!gsp$allOK) {
  # Optionally, print the protein and sample names that were removed:
  if (sum(!gsp$goodGenes)>0)
    printFlush(paste("Removing proteins:", paste(names(ExprDataClean_t_Scale)[!gsp$goodGenes], collapse = ", ")));
  if (sum(!gsp$goodSamples)>0)
    printFlush(paste("Removing samples:", paste(rownames(ExprDataClean_t_Scale)[!gsp$goodSamples], collapse = ", ")));
  # Remove the offending proteins and samples from the data:
  ExprDataClean_t_Scale <- ExprDataClean_t_Scale[gsp$goodSamples, gsp$goodGenes]
  gsp <- goodSamplesGenes(ExprDataClean_t_Scale, verbose = 3) # good samples proteins, gsp
  length(gsp$goodGenes)
  length(gsp$goodSamples)
  gsp$allOK
  # [1] TRUE
}

## 2.6 离群样品检测和剔除，dist()和hclust()，绘制样品分层聚类树，查看是否有离群样品，ExprDataClean_t_Scale是样品代谢物表达矩阵数据（Clean）
sampletree <- hclust(dist(ExprDataClean_t_Scale), method = "average") # 计算距离矩阵
class(sampletree)
# [1] "hclust"
sampletree$dist.method
# [1] "euclidean"，欧氏距离=欧几里得距离
### 计算代谢物样品表达矩阵中的样品距离矩阵
dist_matrix <- dist(ExprDataClean_t_Scale)
dim(dist_matrix)
class(dist_matrix)
# [1] "dist"
dist_matrix <- as.matrix(dist_matrix)
colnames(dist_matrix)
# [1] "1_1"  "1_2"  "1_3"  "1_4"  "1_5"  "1_6"  "1_7"  "1_8"
# [9] "1_9"  "1_10" "1_11" "2_1"  "2_2"  "2_3"  "2_4"  "2_5"
# [17] "2_6"  "2_7"  "2_8"  "2_9"  "2_10" "2_11" "3_1"  "3_2"
# [25] "3_3"  "3_4"  "3_5"  "3_6"  "3_7"  "3_8"  "3_9"  "3_10"
# [33] "3_11"
rownames(dist_matrix) <- colnames(dist_matrix)
rownames(dist_matrix)
head(dist_matrix)
dist_matrix <- as.data.frame(dist_matrix)
dist_matrix <- data.frame(row.names = rownames(dist_matrix), dist_matrix)

## 2.7 保存表达矩阵的样品聚类矩阵数据，此时的工作目录在./WGCNA_M
setwd("./WGCNA_M/1.Data_Processing/1.2Sample_filtered/") # 切换工作目录到：./WGCNA_M/1.Data_Processing/1.2Sample_filtered/

export(dist_matrix, file = "Distance_matrix.xlsx", rowNames = TRUE, colNames = TRUE, colWidths = "auto", zoom = 120)

## 2.8 绘制划线样品距离树
height <- sort(sampletree$height, decreasing = TRUE)
h <- height[3] # 提取排序第二的样品Height值
plot(sampletree, main = "Sample clustering to detect outliers", sub="", xlab="", col = "Blue")
abline(h = h+1, col = "red")

#### 2.8.1 PDF保存
pdf("SampleTree.pdf", width = 12, height = 8.5)
plot(sampletree, main = "Sample clustering to detect outliers", sub="", xlab="", col = "Blue")
abline(h = h+1, col = "red") # 画线
dev.off()

#### 2.8.2 PNG保存
png("SampleTree.png", width = 1200, height = 850)
plot(sampletree, main = "Sample clustering to detect outliers", sub="", xlab="", col = "Blue", lwd = 2, cex = 1.5, cex.lab = 1.5)
abline(h = h+1, col = "red") # 画线
dev.off()

## 2.9 sampletree数据保存，客户可能不需要，所以暂时不保存！
# class(sampletree)
# # [1] "hclust"
# save(sampletree, file = "sampletree.RData")

## 3.0 离群样品处理（测试暂不去除离群样品）
##########################################################
### 手动处理离群样品：G22
# all_sample <- sampletree$labels
# class(all_sample)
# # [1] "character"
# all_sample <- as.vector(all_sample)
# print(all_sample)
#######################################################################
# samindex <- which(all_sample == "G22") # 离群样品传参设置
#######################################################################
# keepsample <- all_sample[-samindex]
# print(keepsample)
# proExprData <- trusted_prot_clean_data_t[keepsample,] # 获得去除离群样品代谢物表达数据
# print("查看proExprData数据大小")
# dim(proExprData) # 查看proExprData数据大小
##########################################################

## 3.1 WGCNA代谢物表达矩阵Clean数据保存，此时工作路径在：./WGCNA_M/1.Data_Processing/1.2Sample_filtered，需要切换到：WGCNA_M/1.Data_Processing/1.1Data
setwd("../1.1Data/")
metaboExprData <- ExprDataClean_t_Scale
export(metaboExprData, file = "ExprData_clean.xlsx", rowNames = TRUE, colNames = TRUE, colWidths = "auto", zoom = 120)

## 3.2 样品性状数据矩阵读取：Sample_Traits.xlsx
traitData <- read.xlsx("../../../Sample_Traits.xlsx", sheet = 1, startRow = 1, colNames = T, rowNames = T, detectDates = F)
dim(traitData)
# [1] 33  6
print("性状矩阵中的性状分别为：")
colnames(traitData)
# [1] "TraitA"        "TraitB"        "TraitC"
# [4] "Height_CM"     "Weight_KG"     "Sex_0isW_1isM"
print(paste0("性状数量为：",length(colnames(traitData)),"个"))
print("性状矩阵中的样品名称分别为：")
rownames(traitData)
# [1] "1_1"  "1_2"  "1_3"  "1_4"  "1_5"  "1_6"  "1_7"  "1_8"
# [9] "1_9"  "1_10" "1_11" "2_1"  "2_2"  "2_3"  "2_4"  "2_5"
# [17] "2_6"  "2_7"  "2_8"  "2_9"  "2_10" "2_11" "3_1"  "3_2"
# [25] "3_3"  "3_4"  "3_5"  "3_6"  "3_7"  "3_8"  "3_9"  "3_10"
# [33] "3_11"
print(paste0("性状矩阵中的样品数量为：",length(rownames(traitData)),"个"))
print("性状矩阵数据如下所示：")
print(traitData)
# TraitA TraitB TraitC Height_CM Weight_KG Sex_0isW_1isM
# 1_1       1      0      0       170      65.0             0
# 1_2       1      0      0       180      77.5             1
# 1_3       1      0      0       175      60.0             0
# 1_4       1      0      0       169      63.0             1
# 1_5       1      0      0       177      68.7             0
# 1_6       1      0      0       171      66.0             1
# 1_7       1      0      0       166      56.6             0
# 1_8       1      0      0       180      80.0             1
# 1_9       1      0      0       178      67.3             0
# 1_10      1      0      0       195      85.0             1
# 1_11      1      0      0       155      50.2             0
# 2_1       0      1      0       166      60.3             1
# 2_2       0      1      0       172      60.5             0
# 2_3       0      1      0       175      65.5             1
# 2_4       0      1      0       180      72.4             0
# 2_5       0      1      0       177      70.0             1
# 2_6       0      1      0       168      60.7             0
# 2_7       0      1      0       170      67.0             1
# 2_8       0      1      0       166      58.0             0
# 2_9       0      1      0       176      69.3             1
# 2_10      0      1      0       173      65.0             0
# 2_11      0      1      0       182      77.7             1
# 3_1       0      0      1       191      88.0             0
# 3_2       0      0      1       192      90.0             1
# 3_3       0      0      1       180      82.0             0
# 3_4       0      0      1       185      76.6             1
# 3_5       0      0      1       178      75.0             0
# 3_6       0      0      1       175      56.6             1
# 3_7       0      0      1       180      80.0             0
# 3_8       0      0      1       177      67.3             1
# 3_9       0      0      1       168      85.0             0
# 3_10      0      0      1       170      50.2             1
# 3_11      0      0      1       166      60.3             0

file.copy(from = "../../../Sample_Traits.xlsx", to = "./", copy.mode = T)

## 3.3 绘制样品层次聚类树和样品性状热图
sampleTree2 = hclust(dist(metaboExprData), method = "average") # Re-cluster samples
# Convert traits to a color representation: white means low, red means high, grey means missing entry
# which(rownames(traitData) == "G22") # 这块需要处理成变量，因为G22只是一个离群样品
# newtraitData <- traitData[-which(rownames(traitData) == "G22"),] # 这个26也需要处理成变量，因为离群样品的位置也会变动
print("对比离群样品处理前和处理后的性状矩阵大小：")
dim(traitData)
# [1] 33  6

# dim(newtraitData) # 需要保存去除离群样品的性状数据

## 3.4 导出去掉离群样品的性状数据
export(traitData, file = "Sample_Traits_clean.xlsx", colNames = T, rowNames = T, firstRow = T, borders = "surrounding", zoom = 120, colWidths = "auto")

## 3.5 目录：./WGCNA_M/1.Data_Processing/1.1Data/中结果文件是否检测
if (length(dir("./")) == 4) {
  print("目录：./WGCNA_M/1.Data_Processing/1.1Data/中的文件已经全部生成！结果文件如下所示：")
  list.files("./")
} else {
  print("糟糕！目录：./WGCNA_M/1.Data_Processing/1.1Data/中的文件没有全部生成，请检查后再试！")
}

## 3.6 将样品性状值转为颜色标记
traitColors <- numbers2colors(traitData, signed = FALSE)
print("查看traitColors数据的前6行内容：")
head(traitColors)
# [,1]      [,2]      [,3]      [,4]      [,5]
# [1,] "#FF3300" "#FFFFFF" "#FFFFFF" "#FFB4A1" "#FFB4A1"
# [2,] "#FF3300" "#FFFFFF" "#FFFFFF" "#FF7E5E" "#FF714E"
# [3,] "#FF3300" "#FFFFFF" "#FFFFF`F" "#FF977D" "#FFCDC1"
# [4,] "#FF3300" "#FFFFFF" "#FFFFFF" "#FFB8A7" "#FFBCAC"
# [5,] "#FF3300" "#FFFFFF" "#FFFFFF" "#FF8F72" "#FF9F87"
# [6,] "#FF3300" "#FFFFFF" "#FFFFFF" "#FFAC97" "#FFB09C"
# [,6]
# [1,] "#FFFFFF"
# [2,] "#FF3300"
# [3,] "#FFFFFF"
# [4,] "#FF3300"
# [5,] "#FFFFFF"
# [6,] "#FF3300"

## 3.7 绘制样品表达矩阵和样品性状相关的树状图和热图（Plot the sample dendrogram and the heatmap colors underneath.）
setwd("../1.2Sample_filtered/") # 切换工作目录到./WGCNA_M/1.Data_Processing/1.2Sample_filtered/

plotDendroAndColors(sampleTree2, # a hierarchical clustering dendrogram such as one produced by hclust
                    traitColors, # Coloring of objects on the dendrogram. Either a vector (one color per object) or a matrix (can also be an array or a data frame) with each column giving one color per object. Each column will be plotted as a horizontal row of colors under the dendrogram.
                    groupLabels = names(traitData), # Labels for the colorings given in colors. The labels will be printed to the left of the color rows in the plot. If the argument is given, it must be a vector of length equal to the number of columns in colors. If not given, names(colors) will be used if available. If not, sequential numbers starting from 1 will be used.
                    main = "Sample dendrogram and trait heatmap",
                    autoColorHeight = TRUE, # logical: should the height of the color area below the dendrogram be automatically adjusted for the number of traits? Only effective if setLayout is TRUE.
                    addGuide = TRUE, # logical: should vertical "guide lines" be added to the dendrogram plot? The lines make it easier to identify color codes with individual samples.
                    guideAll = TRUE) # logical: add a guide line for every sample? Only effective for addGuide set TRUE.

#### 3.7.1 Save as PDF
pdf("Sample_dendrogram_and_trait_heatmap.pdf", width = 10, height = 10)
plotDendroAndColors(sampleTree2,
                    traitColors,
                    groupLabels = names(traitData),
                    main = "Sample dendrogram and trait heatmap",
                    autoColorHeight = TRUE,
                    addGuide = TRUE,
                    guideAll = TRUE)
dev.off()

#### 3.7.2 Save as PNG
png("Sample_dendrogram_and_trait_heatmap.png", width = 1000, height = 1000)
plotDendroAndColors(sampleTree2,
                    traitColors,
                    groupLabels = names(traitData),
                    main = "Sample dendrogram and trait heatmap",
                    autoColorHeight = TRUE,
                    addGuide = TRUE,
                    guideAll = TRUE)
dev.off()

## 3.8 目录./WGCNA_M/1.Data_Processing/1.2Sample_filtered/中的结果文件是否生成检测
if (length(dir("./")) == 5) {
  print("目录./WGCNA_M/1.Data_Processing/1.2Sample_filtered/中结果文件已经全部生成！结果文件如下所示：")
  list.files("./")
} else {
  print("糟糕！目录./WGCNA_M/1.Data_Processing/1.2Sample_filtered/中的结果文件没有全部生成，请检查！")
}

## 3.9 性状数据完整性检测：主要是缺失值的检测
gst <- goodSamplesGenes(traitData) # good samples traits
# Flagging genes and samples with too many missing values...
# ..step 1
gst$goodGenes
# [1] TRUE TRUE TRUE TRUE TRUE TRUE
goodGenes(traitData)
# [1] TRUE TRUE TRUE TRUE TRUE TRUE
gst$goodSamples
# [1] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
# [12] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
# [23] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
goodSamples(traitData)
# [1] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
# [12] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
# [23] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE

if (gst$allOK == TRUE) {
  print("恭喜，样品性状数据是符合分析要求的!")
} else if (gst$allOK == FALSE) {
  print("样品性状数据是不符合分析要求的，需要继续修改之后再继续往下分析")
}
# [1] "样品性状数据是符合分析要求的"

######################################################################
######################################################################
######################################################################

# 二、网络构建
# ***
#   蛋白共表达网络是无尺度（scale-free）的权重蛋白网络。无尺度特性，又称作无标度特性，是指网络的度分布满足幂律分布。幂律分布这一特性，正说明无尺度网络的度分布是呈集散分布：大部分的节点只有比较少的连接，而少数节点有大量的连接，这样的少数的多连接节点被称为共表达网络中的Hub节点。
#
# 为了尽量满足无尺度网络分布前提条件，需要选择邻接矩阵权重参数power的取值。设定power值从1-30，分别计算其得到的网络对应的相关系数和网络的平均连接度。其中，相关系数越高（最大为1），网络越接近无尺度网络分布，但同时还需要保证一定的蛋白连接度，所以这个power值在相关系数足够大的同时保证基因的连接度较大。
#
# 本次分析结果中所用的power值为：10（R^2 >= 8.5）

# 2. 构建共表达网络Contrustion Co-expression Network
#######################################################################
## 1.1 软阈值确定：β_Power_selected
powers <- c(c(1:10), seq(from = 12, to = 30, by = 2))
print(powers)
# [1]  1  2  3  4  5  6  7  8  9 10 12 14 16 18 20 22 24 26 28 30

## 1.2 设置网络类型为：type = unsigned
type <- "unsigned"
sft <- pickSoftThreshold(metaboExprData,
                         powerVector = powers,
                         networkType = type,
                         verbose = 5)
# pickSoftThreshold: will use block size 4050.
# pickSoftThreshold: calculating connectivity for given powers...
# ..working on genes 1 through 4050 of 11044
# ..working on genes 4051 through 8100 of 11044
# ..working on genes 8101 through 11044 of 11044
# Power SFT.R.sq  slope truncated.R.sq mean.k. median.k.
# 1      1   0.0427 -0.569          0.862 2380.00  2300.000
# 2      2   0.3420 -1.220          0.887  851.00   760.000
# 3      3   0.5410 -1.360          0.930  406.00   336.000
# 4      4   0.6820 -1.390          0.963  234.00   191.000
# 5      5   0.7410 -1.440          0.961  152.00   119.000
# 6      6   0.7520 -1.470          0.941  109.00    80.400
# 7      7   0.7620 -1.420          0.913   82.40    57.200
# 8      8   0.7830 -1.360          0.893   65.40    41.400
# 9      9   0.9070 -1.240          0.972   53.70    30.900
# 10    10   0.9250 -1.210          0.972   45.20    23.700
# 11    12   0.9220 -1.260          0.978   33.90    14.500
# 12    14   0.9170 -1.290          0.973   26.80     9.360
# 13    16   0.9090 -1.300          0.964   22.00     6.310
# 14    18   0.9010 -1.310          0.953   18.60     4.450
# 15    20   0.8910 -1.320          0.939   16.00     3.220
# 16    22   0.8920 -1.330          0.934   14.00     2.380
# 17    24   0.8910 -1.340          0.928   12.40     1.820
# 18    26   0.8810 -1.340          0.913   11.10     1.420
# 19    28   0.8790 -1.350          0.905   10.10     1.130
# 20    30   0.8820 -1.350          0.906    9.18     0.903
# max.k.
# 1    4190
# 2    2110
# 3    1230
# 4     802
# 5     579
# 6     452
# 7     368
# 8     310
# 9     267
# 10    239
# 11    212
# 12    192
# 13    177
# 14    165
# 15    156
# 16    148
# 17    142
# 18    136
# 19    131
# 20    127

## 1.3 保存sft数据，切换工作目录到：./WGCNA_M/2.Network_Construction/中
setwd("../../2.Network_Construction/")
hs <- createStyle(textDecoration = "BOLD",
                  fontColour = "#FFFFFF",
                  fontSize=12,
                  fontName="Arial",
                  fgFill = "#FF8000") # 设置headerStyle
export(sft, file = "Soft_Threshold_identification.xlsx", firstRow = TRUE, borderColour = "black", colNames = TRUE, borders = "columns", zoom = 120, headerStyle = hs)

## 1.4 自定义画布参数
op <- par(no.readonly = TRUE) #设置画布的图形排布方式，先设置默认变量 # 恢复时执行par(op)

## 1.5 可视化软阈值筛选(筛选标准：R-square=0.85)
par(mfrow = c(1,2))
par(mai=c(1.5, 1, 1.5, 0.6))
cex1 = 0.9
plot(sft$fitIndices[,1],
     -sign(sft$fitIndices[,3])*sft$fitIndices[,2],
     xlab="Soft Threshold (power)",
     ylab="Scale Free Topology Model Fit,signed R^2",
     type="n",
     cex.lab = 1.2,
     main = "Scale independence")
text(sft$fitIndices[,1], -sign(sft$fitIndices[,3])*sft$fitIndices[,2], labels=powers,cex=cex1, col="blue")
abline(h=0.85,col="red") # RsquaredCut = 0.85, desired minimum scale free topology fitting index R^2. 筛选标准：R-square=0.85
# Soft threshold与平均连通性
plot(sft$fitIndices[,1],
     sft$fitIndices[,5],
     xlab="Soft Threshold (power)",
     ylab="Mean Connectivity",
     type="n",
     cex.lab = 1.2,
     main = "Mean connectivity")
text(sft$fitIndices[,1], sft$fitIndices[,5], labels=powers, cex=cex1, col="blue")

#### 1.5.1 PDF保存
pdf("Soft_Threshold_identification.pdf", width = 10, height = 5)
par(mfrow = c(1,2))
cex1 = 0.9
plot(sft$fitIndices[,1], -sign(sft$fitIndices[,3])*sft$fitIndices[,2], xlab="Soft Threshold (power)", ylab="Scale Free Topology Model Fit,signed R^2", type="n", main = paste("Scale independence"))
text(sft$fitIndices[,1], -sign(sft$fitIndices[,3])*sft$fitIndices[,2], labels=powers, cex=cex1, col="blue")
## 筛选标准：R-square=0.85
abline(h=0.85, col="red") # RsquaredCut = 0.85, desired minimum scale free topology fitting index R^2.
## 软阈值Soft threshold与平均连通性Mean connectivity
plot(sft$fitIndices[,1], sft$fitIndices[,5], xlab="Soft Threshold (power)",ylab="Mean Connectivity", type="n", main = paste("Mean connectivity"))
text(sft$fitIndices[,1], sft$fitIndices[,5], labels=powers, cex=cex1, col="blue")
dev.off()

#### 1.5.2 PNG Save
png("Soft_Threshold_identification.png", width = 1000, height = 500)
par(mfrow = c(1,2))
cex1 = 0.9
plot(sft$fitIndices[,1], -sign(sft$fitIndices[,3])*sft$fitIndices[,2], xlab="Soft Threshold (power)", ylab="Scale Free Topology Model Fit,signed R^2", type="n", main = paste("Scale independence"))
text(sft$fitIndices[,1], -sign(sft$fitIndices[,3])*sft$fitIndices[,2], labels=powers, cex=cex1, col="blue")
## 筛选标准：R-square=0.85
abline(h=0.85, col="red")
## 软阈值Soft threshold与平均连通性Mean connectivity
plot(sft$fitIndices[,1], sft$fitIndices[,5], xlab="Soft Threshold (power)",ylab="Mean Connectivity", type="n", main = paste("Mean connectivity"))
text(sft$fitIndices[,1], sft$fitIndices[,5], labels=powers, cex=cex1, col="blue")
dev.off()

## 1.6 软阈值确定
power <- sft$powerEstimate
print(paste0("软阈值为：",power))
# [1] 9

## 1.7 检验选定的power（β）值下的网络是否逼近无标度：scale free
ADJ_cor <- abs(WGCNA::cor(metaboExprData, use = "p" ))^power # 计算临接矩阵Adjacency

print("查看ADJ_cor的部分数据：")
ADJ_cor[1:5,1:5]
# Sphingosine
# Sphingosine                        1.000000e+00
# 3-alpha-Androstanediol glucuronide 7.043107e-07
# LysoPE(15:0/0:0)                   3.070507e-05
# Deoxycholic acid                   1.341354e-12
# Glycocholic Acid                   6.396495e-10
# 3-alpha-Androstanediol glucuronide
# Sphingosine                                              7.043107e-07
# 3-alpha-Androstanediol glucuronide                       1.000000e+00
# LysoPE(15:0/0:0)                                         2.875366e-04
# Deoxycholic acid                                         2.773055e-10
# Glycocholic Acid                                         2.639371e-06
# LysoPE(15:0/0:0) Deoxycholic acid
# Sphingosine                            3.070507e-05     1.341354e-12
# 3-alpha-Androstanediol glucuronide     2.875366e-04     2.773055e-10
# LysoPE(15:0/0:0)                       1.000000e+00     1.278957e-04
# Deoxycholic acid                       1.278957e-04     1.000000e+00
# Glycocholic Acid                       1.700856e-05     1.519717e-05
# Glycocholic Acid
# Sphingosine                            6.396495e-10
# 3-alpha-Androstanediol glucuronide     2.639371e-06
# LysoPE(15:0/0:0)                       1.700856e-05
# Deoxycholic acid                       1.519717e-05
# Glycocholic Acid                       1.000000e+00

## 1.8 Calculates connectivity of a weighted network
if (NROW(ADJ_cor) < 5000) { # 代谢物少（<5000）的时候使用
  k <- as.vector(apply(ADJ_cor, 2, sum, na.rm = TRUE))
  head(k)
} else if (NROW(ADJ_cor) >= 5000) { # 代谢物多的时候使用：>= 5000
  k <- softConnectivity(datExpr = metaboExprData, power = power)
}
# softConnectivity: FYI: connecitivty of genes with less than 11 valid samples will be returned as NA.
# ..calculating connectivities....100%

## 1.9 可视化无标度网络特征
sizeGrWindow(10, 5) # 设置画布大小
par(mfrow=c(1,2)) # 设置图片排列方式：一行+两列
hist(k, main = "Histogram of Connectivity with\n Power: 30") # 绘制Histogram of k
scaleFreePlot(k, main = "Check Scale free topology (Power: 30)\n") # Visual check of scale-free topology. A simple visula check of scale-free network ropology.

# scaleFreeRsquared slope
# 1               0.9 -1.24

#### 1.9.1 Save as PDF
pdf("Connectivity_and_Scale_free_topology_visualization.pdf", width = 10, height = 5)
sizeGrWindow(10, 5)
par(mfrow=c(1,2))
hist(k, main = "Histogram of Connectivity with\n Power: 30") # 绘制Histogram of k
scaleFreePlot(k, main = "Check Scale free topology (Power: 30)\n") # 绘制Scale free topology network if Power
dev.off()

#### 1.9.2 Save as PNG
png("Connectivity_and_Scale_free_topology_visualization.png", width = 1000, height = 500)
par(mfrow=c(1,2))
hist(k, main = "Histogram of Connectivity with\n Power: 30") # 绘制Histogram of k
scaleFreePlot(k, main="Check Scale free topology (Power: 30)\n") # 绘制Scale free topology network if Power
dev.off()

#######################################################################
## 2.0 无满足条件的power时选用：经验power
# 无向网络在power小于15或有向网络power小于30内，没有一个power值可以使无标度网络图谱结构R^2达到0.8，平均连接度较高如在100以上，可能是由于部分样品与其他样品差别太大。这可能由批次效应、样品异质性或实验条件对表达影响太大等造成。可以通过绘制样品聚类查看分组信息和有无异常样品。
# 如果这确实是由有意义的生物变化引起的，也可以使用下面的经验power值、
#
#######################################################################
# if (is.na(power)){
#   power <- ifelse(nSamples < 20, ifelse(type == "unsigned", 9, 18),
#                   ifelse(nSamples < 30, ifelse(type == "unsigned", 8, 16),
#                          ifelse(nSamples < 40, ifelse(type == "unsigned", 7, 14),
#                                 ifelse(type == "unsigned", 6, 12))))
# }
#######################################################################

## 2.1 画布恢复默认变量
par(op)

## 2.2 构建共表达网络：一步法网络构建（One-step network construction and module detection）
######################################################################
###
### power: 上一步计算的软阈值
### maxBlockSize: 计算机能处理的最大模块的基因数量 (默认5000)，这里是代谢物；
### 4G内存电脑可处理8000-10000个，16G内存电脑可以处理2万个，32G内存电脑可以处理3万个
### 计算资源允许的情况下最好放在一个block里面。
### corType: pearson or bicornumericLabels: 返回数字而不是颜色作为模块的名字，后面可以再转换为颜色
### saveTOMs：最耗费时间的计算，存储起来，供后续使用
### mergeCutHeight: 合并模块的阈值，越大模块越少
###
#######################################################################
nMetabolins <- ncol(metaboExprData)
cor <- WGCNA::cor
print(paste0("代谢物总数为：",nMetabolins,"个"))

nSamples <- nrow(metaboExprData)
print(paste0("样品总数为：",nSamples,"个"))

## 2.3 对二元变量，如样本性状信息计算相关性时，或代谢物表达严重依赖于疾病状态时，需设置下面参数
corType <- "pearson"
corFnc <- ifelse(corType == "pearson", cor, bicor)
maxPOutliers <- ifelse(corType == "pearson",1,0.05)

## 2.4 关联样品性状的二元变量时，设置
robustY <- ifelse(corType == "pearson",T,F)

## 2.5 Automatic network construction and module detection
# This function performs automatic network construction and module detection on large expression datasets in a block-wise manner.
setwd("../../")
net <- blockwiseModules(metaboExprData, # Expression data
                        power = power,
                        maxBlockSize = nMetabolins,
                        TOMType = type,
                        minModuleSize = 500,
                        reassignThreshold = 1e-6,
                        mergeCutHeight = 0.5,
                        numericLabels = TRUE,
                        pamRespectsDendro = FALSE,
                        saveTOMs = TRUE,
                        corType = corType,
                        maxPOutliers = maxPOutliers,
                        loadTOMs = TRUE,
                        saveTOMFileBase = paste0(exprMat, "tom"), verbose = 3)
# Calculating module eigengenes block-wise from all genes
# Flagging genes and samples with too many missing values...
# ..step 1
# ..Working on block 1 .
# TOM calculation: adjacency..
# ..will not use multithreading.
# Fraction of slow calculations: 0.000000
# ..connectivity..
# ..matrix multiplication (system BLAS)..
# ..normalization..
# ..done.
# ..saving TOM for block 1 into file Samples_and_Metabolin_.tom-block.1.RData
# ....clustering..
# ....detecting modules..
# ....calculating module eigengenes..
# ....checking kME in modules..
# ..removing 121 genes from module 1 because their KME is too low.
# ..removing 473 genes from module 2 because their KME is too low.
# ..removing 246 genes from module 3 because their KME is too low.
# ..removing 235 genes from module 4 because their KME is too low.
# ..removing 57 genes from module 5 because their KME is too low.
# ..removing 8 genes from module 6 because their KME is too low.
# ..removing 130 genes from module 7 because their KME is too low.
# ..reassigning 6 genes from module 1 to modules with higher KME.
# ..reassigning 1 genes from module 4 to modules with higher KME.
# ..reassigning 3 genes from module 5 to modules with higher KME.
# ..merging modules that are too close..
# mergeCloseModules: Merging modules whose distance is less than 0.5
# Calculating new MEs...

if (file.exists("Samples_and_Metabolin_tom-block.1.RData")) {
  print("TOM矩阵数据已经生成完毕!")
} else {
  print("TOM矩阵数据不存在!")
}

setwd("./WGCNA_M/2.Network_Construction/") # 切换工作目录到：./WGCNA_M/2.Network_Construction/目录中

## 2.6 根据模块中代谢物数目的多少，降序排列，依次编号为1-最大模块数、0-grey表示未分入任何模块的代谢物
print("根据模块中代谢物数目的多少，降序排列，依次编号为：1-最大模块数， 0-grey表示未分入任何模块的代谢物")
print("代谢物共表达网络中的识别的模块如下：")
table(net$colors)
# 0    1    2    3    4    5    6
# 2356 3497 1465 1113  932  918  763
print(paste0("MEsgrey(ME0)算在内，总共鉴定到的模块数量为：",NCOL(net$MEs),"个"))
print("各模块的编码如下所示：")
names(net$MEs)
# [1] "ME2" "ME6" "ME5" "ME4" "ME1" "ME3" "ME0"

######################################################################
######################################################################
######################################################################
# 三、模块识别及可视化分析
# ***
# 蛋白选定的power值，建立加权共表达网络模型，最终将11044个代谢物划分为6个模块，每个模块对应的蛋白个数分别为：MEturquoise 、MEblue ，MEbrown 、MEyellow、MEred、MEgreen，其中灰色模块为不能归属到任意模块的基因集合，没有参考意义。

# 每个模块中蛋白数量和对应代表颜色如下图所示：
######################################################################
# 3.模块识别和可视化（Module_Identification_and_Visualization）
#######################################################################
## 1.1 层级聚类树展示各个模块，灰色的为未分类到模块的代谢物
moduleLabels <- net$colors # Convert labels to colors for plotting
print("模块标记为：")
head(moduleLabels)
# Sphingosine 3-alpha-Androstanediol glucuronide
# 3                                  0
# LysoPE(15:0/0:0)                   Deoxycholic acid
# 1                                  1
# Glycocholic Acid  5a-Cholestane-3a,7a,12a,25-tetrol
# 1                                  5
tail(moduleLabels)
# His Phe Ile Lys     Lys Glu Gln Trp Desmethylranitidine
# 1                   5                   1
# Thr Ala Pro Trp     Asp Asp Gly His     His Val Leu Lys
# 4                   4                   6

## 1.2 保存moduleLabels为本地文件
moduleLabels_number <- as.data.frame(moduleLabels)
dim(moduleLabels_number)
# [1] 11044     1
print("查看moduleLabels_number的前6行内容：")
head(moduleLabels_number)
# moduleLabels
# Sphingosine                                   3
# 3-alpha-Androstanediol glucuronide            0
# LysoPE(15:0/0:0)                              1
# Deoxycholic acid                              1
# Glycocholic Acid                              1
# 5a-Cholestane-3a,7a,12a,25-tetrol             5

moduleLabels_number <- data.frame(rownames(moduleLabels_number), moduleLabels_number[,1])
colnames(moduleLabels_number) <- c("Metabolites", "moduleLabels")
head(moduleLabels_number)
# Metabolites moduleLabels
# 1                        Sphingosine            3
# 2 3-alpha-Androstanediol glucuronide            0
# 3                   LysoPE(15:0/0:0)            1
# 4                   Deoxycholic acid            1
# 5                   Glycocholic Acid            1
# 6  5a-Cholestane-3a,7a,12a,25-tetrol            5

## 1.3 数字代码到颜色的转换，获得moduleColors对象
moduleColors <- labels2colors(moduleLabels)
print("每个模块对应的颜色为：")
str(moduleColors)
head(moduleColors)
moduleLabels_Colors <- as.data.frame(moduleColors)

## 1.4 合并为一个新的数据框：ModuleColorsLabels
ModuleColorsLabels <- cbind(moduleLabels_number, moduleLabels_Colors)
head(ModuleColorsLabels)
# Metabolites moduleLabels moduleColors
# 1                        Sphingosine            3        brown
# 2 3-alpha-Androstanediol glucuronide            0         grey
# 3                   LysoPE(15:0/0:0)            1    turquoise
# 4                   Deoxycholic acid            1    turquoise
# 5                   Glycocholic Acid            1    turquoise
# 6  5a-Cholestane-3a,7a,12a,25-tetrol            5        green
dim(ModuleColorsLabels)
# [1] 11044     3

## 1.5 保存ModuleColorsLabels为xlsx文件，切换工作目录到：./WGCNA_M/3.Module_Identification_and_Visualization/内
setwd("../3.Module_Identification_and_Visualization/")
ModuleColorsLabels <- ModuleColorsLabels[order(ModuleColorsLabels$moduleLabels),] # 根据moduleLabels进行由低到高的排序
export(ModuleColorsLabels, file = "ModuleColorsLabels.xlsx", colNames = T, rowNames = T, firstRow = TRUE, borders = "columns", zoom = 120)

## 1.6 绘制模块颜色树状图
plotDendroAndColors(net$dendrograms[[1]],
                    moduleColors[net$blockGenes[[1]]],
                    "Module colors",
                    dendroLabels = FALSE,
                    hang = 0.03,
                    addGuide = TRUE,
                    guideHang = 0.05)

## 1.7 如果对结果不满意，还可以用recutBlockwiseTrees()函数
# recutBlockwiseTrees(
#   proExprData,
#   blocks = 5,
#   corType = "pearson",
#   networkType = "unsigned",
#   deepSplit = 2,
#   detectCutHeight = 0.995, minModuleSize = min(20, ncol(proExprData)/2 ),
#   pamStage = TRUE, pamRespectsDendro = TRUE,
#   minCoreKME = 0.5, minCoreKMESize = minModuleSize/3,
#   minKMEtoStay = 0.3,
#   reassignThreshold = 1e-6,
#   mergeCutHeight = 0.15, impute = TRUE,
#   trapErrors = FALSE, numericLabels = FALSE,
#   verbose = 0, indent = 0)

## 1.8 合并模块Merge Dynamic
MEDissThres <- 0.5
abline(h = MEDissThres, col = "red") # 在聚类图中画出剪切线
merge_modules <- mergeCloseModules(metaboExprData, moduleColors, cutHeight = MEDissThres, verbose = 3)
mergedColors <- merge_modules$colors # 合并后的颜色
mergedMEs <- merge_modules$newMEs # 新模块的特征向量代谢物
NCOL(mergedMEs)
# [1] 7

print("模块合并之后的各模块的名称为：")
names(mergedMEs)
# [1] "MEblue"      "MEred"       "MEgreen"     "MEyellow"
# [5] "MEbrown"     "MEturquoise" "MEgrey"

## 1.9 绘制合并之后的模块Cluster Dendrogram
plotDendroAndColors(net$dendrograms[[1]],
                    cbind(moduleColors, mergedColors),
                    c("Dynamic Tree Cut", "Merged dynamic"),
                    dendroLabels = FALSE,
                    hang = 0.03,
                    addGuide = TRUE,
                    guideHang = 0.05)

#### 1.9.1 Save as PDF
pdf(file = "Module_Cluster_Dendrogram_Merged_dynamic.pdf", width = 18, height = 10)
plotDendroAndColors(net$dendrograms[[1]], cbind(moduleColors, mergedColors), c(paste0("DynamicTreeCut"," (",NCOL(net$MEs),")"), paste0("MergedDynamic"," (",NCOL(mergedMEs),")")), dendroLabels = FALSE, hang = 0.03, addGuide = TRUE, guideHang = 0.05, cex.colorLabels = 0.9, cex.dendroLabels = 1.2, autoColorHeight = T, setLayout = T)
dev.off()

#### 1.9.2 Save as PNG
png(file = "Module_Cluster_Dendrogram_Merged_dynamic.png", width = 2000, height = 1000)
plotDendroAndColors(net$dendrograms[[1]], cbind(moduleColors, mergedColors), c(paste0("DynamicTreeCut"," (",NCOL(net$MEs),")"), paste0("MergedDynamic"," (",NCOL(mergedMEs),")")), dendroLabels = FALSE, hang = 0.03, addGuide = TRUE, guideHang = 0.05, cex.colorLabels = 1.2, cex.dendroLabels = 1.8, autoColorHeight = T, setLayout = T)
dev.off()

if (length(dir("./")) == 3) {
  print("目录：./WGCNA_M/3.Module_Identification_and_Visualization/中的结果文件已经全部生成！结果文件如下所示：")
  list.files("./")
} else {
  print("糟糕！目录：./WGCNA_M/3.Module_Identification_and_Visualization/中的结果文件没有全部生成，请检查！")
}

## 2.0 保存数据MEs为本地文件，中间文件暂时不导出
# export(as.data.frame(net$MEs), file = "net_MEs.xlsx", firstRow = TRUE, borders = "surrounding", zoom = 120, colNames = T, rowNames = T, colWidths = "auto")

## 2.1 保存合并之后的模块特有代谢物表达数据到目录：./WGCNA_M/4.Modules_with_External_Information_Associations_Analysis/4.1Modules_Samples_Associations_Analysis/中
setwd("../4.Modules_with_External_Information_Associations_Analysis/4.1Modules_Samples_Associations_Analysis/") # 切换工作路径

export(mergedMEs, file = "Module_Eigenmetabolites.xlsx", firstRow = T, colNames = T, rowNames = T, borders = "columns", zoom = 120)

######################################################################
######################################################################
######################################################################
# 四、模块与样品、性状的关联分析
# ***
####################################################################### 4.1 模块与额外信息进行关联分析（Modules_with_External_Information_Associations_Analysis）

## 1.1 模块数据提取和保存
MEs <- net$MEs
names(MEs)
# [1] "ME2" "ME6" "ME5" "ME4" "ME1" "ME3" "ME0"
class(MEs)
# [1] "data.frame"
dim(MEs)
# [1] 33  7
MEs_col <- MEs # MEs和MEs_col是一样的，只是列名用颜色名称替换了对应的数字编码
colnames(MEs_col)
# [1] "ME2" "ME6" "ME5" "ME4" "ME1" "ME3" "ME0"
colnames(MEs_col) <- paste0("ME", labels2colors(as.numeric(str_replace_all(colnames(MEs),"ME",""))))
MEs_col <- orderMEs(MEs_col)
names(MEs_col)
# [1] "MEblue"      "MEred"       "MEgreen"     "MEyellow"
# [5] "MEturquoise" "MEbrown"     "MEgrey"
class(MEs_col)
# [1] "data.frame"
dim(MEs_col)
# [1] 33  7

######################################################################
## 导出网络数据：Cytoscape和VisANT的数据格式
######################################################################
##  1.2 提取指定模块的代谢物
probes <- colnames(metaboExprData) ## 我们例子里面的probe就是代谢物名
head(probes)
# [1] "Sphingosine"
# [2] "3-alpha-Androstanediol glucuronide"
# [3] "LysoPE(15:0/0:0)"
# [4] "Deoxycholic acid"
# [5] "Glycocholic Acid"
# [6] "5a-Cholestane-3a,7a,12a,25-tetrol"

## 1.3 如果采用分步计算，或设置的blocksize>=总代谢物数，直接load计算好的TOM结果，否则需要再计算一遍，比较耗费时间
TOM <- TOMsimilarityFromExpr(metaboExprData,
                               power = power,
                               corType = corType,
                               networkType = type)

print("TOM矩阵（Topological Overlap Matrix）的数据维度为：")
dim(TOM)
# [1] 11044 11044
class(TOM)
# [1] "matrix"
dimnames(TOM) <- list(probes, probes)

## 1.4 先导出总的Cytoscape数据：Export the network into edge and node list files Cytoscape can read threshold 默认为0.5
setwd("../../../") # 切换当前工作目录
getwd()

cyt <- exportNetworkToCytoscape(TOM,
                                edgeFile = paste(exprMat, ".edges.txt", sep=""), # a data frame containing the edge data, with one row per edge
                                nodeFile = paste(exprMat, ".nodes.txt", sep=""), # a data frame containing the node data, with one row per node
                                weighted = TRUE,
                                threshold = 0,
                                nodeNames = probes,
                                nodeAttr = moduleColors,
                                includeColNames = TRUE)

## 1.5 生成各颜色模块的Cytoscape数据：Module Colors: "MEblue" "MEred" "MEgreen" "MEyellow" "MEturquoise" "MEbrown"

### 1.5.1 自定义函数：ModuleCyto
# ModuleCyto <- function(module = "blue") {
#   # Select module probes
#   inModule <- (moduleColors == module)
#   #
#   modProbes <- probes[inModule]
#   #
#   moduleTOM <- TOM[modProbes, modProbes]
#   # 提取每个代谢物的模块颜色标记信息
#   mcindex <- which(moduleColors == module)
#   MoCo <- moduleColors[mcindex]
#   paste0(module,"Module_cyt") <- exportNetworkToCytoscape(
#     paste0(module,"TOM"),
#     edgeFile = paste(module, "_module_cyt_edges.txt", sep=""), # a data frame containing the edge data, with one row per edge
#     nodeFile = paste(module, "_module_cyt_nodes.txt", sep=""), # a data frame containing the node data, with one row per node
#     weighted = TRUE,
#     threshold = 0,
#     nodeNames = modProbes,
#     nodeAttr = moduleColors)
# }
# #
# # ### blue Module ###
# ModuleCyto(module = "blue")

### 1.5.1 导出blueMolude的CYT数据
### Select module：blue ###
module_blue <- "blue"
## Select module probes
inModule_blue <- (moduleColors == module_blue)
modProbes_blue <- probes[inModule_blue]
#### 1.导出blueMolude的CYT数据
blueTOM <- TOM[modProbes_blue, modProbes_blue]
### 提取每个代谢物的模块blue颜色标记信息
mcindex <- which(moduleColors == "blue")
blue_moduleColors <- moduleColors[mcindex]
blueModule_cyt <- exportNetworkToCytoscape(blueTOM,
                                           edgeFile = paste(module_blue, "_module_cyt_edges.txt", sep=""), # a data frame containing the edge data, with one row per edge
                                           nodeFile = paste(module_blue, "_module_cyt_nodes.txt", sep=""), # a data frame containing the node data, with one row per node
                                           weighted = TRUE,
                                           threshold = 0,
                                           nodeNames = modProbes_blue,
                                           nodeAttr = blue_moduleColors)

### 1.5.2 导出redMolude的CYT数据
## Select module：red
module_red <- "red"
## Select module probes
inModule_red <- (moduleColors == module_red)
modProbes_red <- probes[inModule_red]
redTOM <- TOM[modProbes_red, modProbes_red]
### 提取每个代谢物的模块red颜色标记信息
mcindex <- which(moduleColors == "red")
red_moduleColors <- moduleColors[mcindex]
redModule_cyt <- exportNetworkToCytoscape(redTOM,
                                            edgeFile = paste(module_red, "_module_cyt_edges.txt", sep=""), # a data frame containing the edge data, with one row per edge
                                            nodeFile = paste(module_red, "_module_cyt_nodes.txt", sep=""), # a data frame containing the node data, with one row per node
                                            weighted = TRUE,
                                            threshold = 0,
                                            nodeNames = modProbes_red,
                                            nodeAttr = red_moduleColors)


### 1.5.3 导出greenMolude的CYT数据
## Select module：green
module_green <- "green"
## Select module probes
inModule_green <- (moduleColors == module_green)
modProbes_green <- probes[inModule_green]
greenTOM <- TOM[modProbes_green, modProbes_green]
### 提取每个代谢物的模块green颜色标记信息
mcindex <- which(moduleColors == "green")
green_moduleColors <- moduleColors[mcindex]
greenModule_cyt <- exportNetworkToCytoscape(greenTOM,
                                          edgeFile = paste(module_green, "_module_cyt_edges.txt", sep=""), # a data frame containing the edge data, with one row per edge
                                          nodeFile = paste(module_green, "_module_cyt_nodes.txt", sep=""), # a data frame containing the node data, with one row per node
                                          weighted = TRUE,
                                          threshold = 0,
                                          nodeNames = modProbes_green,
                                          nodeAttr = green_moduleColors)


### 1.5.4 导出yellowMolude的CYT数据
## Select module：yellow
module_yellow <- "yellow"
## Select module probes
inModule_yellow <- (moduleColors == module_yellow)
modProbes_yellow <- probes[inModule_yellow]
yellowTOM <- TOM[modProbes_yellow, modProbes_yellow]

### 提取每个代谢物的模块brown颜色标记信息
mcindex <- which(moduleColors == "yellow")
yellow_moduleColors <- moduleColors[mcindex]
yellowModule_cyt <- exportNetworkToCytoscape(yellowTOM,
                                             edgeFile = paste(module_yellow, "_module_cyt_edges.txt", sep=""), # a data frame containing the edge data, with one row per edge
                                             nodeFile = paste(module_yellow, "_module_cyt_nodes.txt", sep=""), # a data frame containing the node data, with one row per node
                                             weighted = TRUE,
                                             threshold = 0,
                                             nodeNames = modProbes_yellow,
                                             nodeAttr = yellow_moduleColors)

###  1.5.5 导出turquoiseMolude的CYT数据
## Select module：turquoise
module_turquoise <- "turquoise"
## Select module probes
inModule_turquoise <- (moduleColors == module_turquoise)
modProbes_turquoise <- probes[inModule_turquoise]
turquoiseTOM <- TOM[modProbes_turquoise, modProbes_turquoise]
### 提取每个代谢物的模块turquoise颜色标记信息
mcindex <- which(moduleColors == "turquoise")
turquoise_moduleColors <- moduleColors[mcindex]
turquoiseModule_cyt <- exportNetworkToCytoscape(turquoiseTOM,
                                                edgeFile = paste(module_turquoise, "_module_cyt_edges.txt", sep=""), # a data frame containing the edge data, with one row per edge
                                                nodeFile = paste(module_turquoise, "_module_cyt_nodes.txt", sep=""), # a data frame containing the node data, with one row per node
                                                weighted = TRUE,
                                                threshold = 0,
                                                nodeNames = modProbes_turquoise,
                                                nodeAttr = turquoise_moduleColors)

### 1.5.6 导出brownMolude的CYT数据
## Select module：brown
module_brown <- "brown"
## Select module probes
inModule_brown <- (moduleColors == module_brown)
modProbes_brown <- probes[inModule_brown]
brownTOM <- TOM[modProbes_brown, modProbes_brown]
### 提取每个代谢物的模块brown颜色标记信息
mcindex <- which(moduleColors == "brown")
brown_moduleColors <- moduleColors[mcindex]
brownModule_cyt <- exportNetworkToCytoscape(brownTOM,
                                            edgeFile = paste(module_brown, "_module_cyt_edges.txt", sep=""), # a data frame containing the edge data, with one row per edge
                                            nodeFile = paste(module_brown, "_module_cyt_nodes.txt", sep=""), # a data frame containing the node data, with one row per node
                                            weighted = TRUE,
                                            threshold = 0,
                                            nodeNames = modProbes_brown,
                                            nodeAttr = brown_moduleColors)

# ######################################################################
# ### 先导出总的VisANT
# ######################################################################
# vis = exportNetworkToVisANT(TOM,
#                             file = paste("VisANTInput-", exprMat, ".txt", sep=""),
#                             weighted = TRUE,
#                             threshold = 0)
# #### 1.blue module
# blue_vis <- exportNetworkToVisANT(blueTOM,
#                                   file = paste("VisANTInput-", module_blue, "_Module.txt", sep=""),
#                                   weighted = TRUE,
#                                   threshold = 0)
# export(blue_vis, file = "blue_module_vis.xlsx", firstRow = TRUE, borders = "columns", colWidths = "auto", zoom = 120)
# #### 2.brown module
# brown_vis <- exportNetworkToVisANT(brownTOM,
#                                    file = paste("VisANTInput-", module_brown, "_Module.txt", sep=""),
#                                    weighted = TRUE,
#                                    threshold = 0)
# export(brown_vis, file = "brown_module_vis.xlsx", firstRow = TRUE, borders = "columns", colWidths = "auto", zoom = 120)
# #### 3.yellow module
# yellow_vis <- exportNetworkToVisANT(yellowTOM,
#                                     file = paste("VisANTInput-", module_yellow, "_Module.txt", sep=""),
#                                     weighted = TRUE,
#                                     threshold = 0)
# export(yellow_vis, file = "yellow_module_vis.xlsx", firstRow = TRUE, borders = "columns", colWidths = "auto", zoom = 120)
# #### 4.turquoise module
# turquoise_vis <- exportNetworkToVisANT(turquoiseTOM,
#                                        file = paste("VisANTInput-", module_turquoise, "_Module.txt", sep=""),
#                                        weighted = TRUE,
#                                        threshold = 0)
# export(turquoise_vis, file = "turquoise_module_vis.xlsx", firstRow = TRUE, borders = "columns", colWidths = "auto", zoom = 120)

## 4.1 模块与样品关联分析（Modules_Samples_Associations_Analysis）
#######################################################################
### 绘制识别到的各模块在所有样品中的条形图Eigenprotein Barplot以及各个模块（去离群样品的）的代谢物表达箱线图Boxplot、热图Heatmap
#
#######################################################################
### 4.1.1 第一部分：模块特有代谢物的条形图：Eigenprotein Barplot
#######################################################################
setwd("./WGCNA_M/4.Modules_with_External_Information_Associations_Analysis/4.1Modules_Samples_Associations_Analysis/") # 切换工作目录到：./WGCNA_M/4.Modules_with_External_Information_Associations_Analysis/4.1Modules_Samples_Associations_Analysis/内

## 1.1 for循环遍历颜色模块，然后根据模块颜色新建对应颜色的目录
names(mergedMEs)
# [1] "MEblue"      "MEred"       "MEgreen"     "MEyellow"    "MEbrown"
# [6] "MEturquoise" "MEgrey"
MColor <- gsub("ME","",names(mergedMEs))
# [1] "blue"      "red"       "green"     "yellow"    "brown"     "turquoise"
# [7] "grey"
MColor_new <- MColor[-which(MColor=="grey")]
MColor_new
# [1] "blue"      "red"       "green"     "yellow"    "brown"     "turquoise"

for (i in MColor_new) {
  dir.create(i)
  print(paste0(i,"目录已经建立"))
}

## 1.2 绘制对应颜色模块特有代谢物表达条形图
## 自定义绘图函数：ModuleEigenmetaboliteBarplot
# ModuleEigenmetaboliteBarplot <- function(module = "blue") {
#   paste0(module,"_MEs_data") <- MEs_col %>% as.data.frame() %>% dplyr::select(paste0("ME",module))
#
#   ggplot(data = paste0(module,"_MEs_data"), mapping = aes(x = rownames(paste0(module,"_MEs_data")), y = paste0("ME",module))) +
#     geom_bar(stat="identity", colour = module, fill = module) +
#     theme_bw() +
#     xlab("") +
#     ylab("Eigenmetabolite Expression") +
#     geom_text(label = signif(paste0(module,"_MEs_data")[1], digits = 1), size = 3, check_overlap = T, col = "black", position = "identity", hjust = "middle", vjust = -1, fontface = "bold") +
#     theme(axis.title.y = element_text(size=14), axis.text.x = element_text(angle = 90, size = 12, face = "bold"))
# }
#
# ModuleEigenmetaboliteBarplot(module = "blue")

### 1.2.1 blue module ###
setwd("./blue/")
blue_MEs_data <- MEs_col %>% as.data.frame() %>% dplyr::select(MEblue)
samname <- factor(rownames(MEs_col), levels=c("1_1",  "1_2",  "1_3",  "1_4",  "1_5",  "1_6",  "1_7",  "1_8",  "1_9",  "1_10", "1_11", "2_1",  "2_2",  "2_3",  "2_4",  "2_5",  "2_6",  "2_7", "2_8",  "2_9",  "2_10", "2_11", "3_1",  "3_2",  "3_3",  "3_4",  "3_5",  "3_6",  "3_7",  "3_8",  "3_9",  "3_10", "3_11"))

ggplot(data = blue_MEs_data, mapping = aes(x = samname, y = MEblue)) +
  geom_bar(stat="identity", colour = "blue", fill = "blue") +
  geom_text(label = signif(blue_MEs_data$MEblue, digits = 1), size = 3, check_overlap = T, col = "black", position = "identity", hjust = "middle", vjust = -1, fontface = "bold") +
  theme_bw() +
  xlab("") +
  ylab("Eigenmetabolite Expression") +
  theme(axis.title.y = element_text(size=14), axis.text.x = element_text(angle = 90, size = 12, face = "bold"))
ggsave(filename = "blue_ModuleEigenmetabolite_barplot.pdf")
ggsave(filename = "blue_ModuleEigenmetabolite_barplot.png")

### 1.2.2 yellow module ###
setwd("../yellow/")
yellow_MEs_data <- MEs_col %>% as.data.frame() %>% dplyr::select(MEyellow)
ggplot(data = yellow_MEs_data, mapping = aes(x = samname, y = MEyellow)) +
  geom_bar(stat="identity", colour = "yellow", fill = "yellow") +
  geom_text(label = signif(yellow_MEs_data$MEyellow, digits = 1), size = 3, check_overlap = T, col = "black", position = "identity", hjust = "middle", vjust = -1, fontface = "bold") +
  theme_bw() +
  xlab("") +
  ylab("Eigenmetabolite Expression") +
  theme(axis.title.y = element_text(size=14), axis.text.x = element_text(angle = 90, size = 12, face = "bold"))
ggsave(filename = "yellow_ModuleEigenmetabolite_barplot.pdf")
ggsave(filename = "yellow_ModuleEigenmetabolite_barplot.png")

### 1.2.3 turquoise module ###
setwd("../turquoise/")
turquoise_MEs_data <- MEs_col %>% as.data.frame() %>% dplyr::select(MEturquoise)
ggplot(data = turquoise_MEs_data, mapping = aes(x = samname, y = MEturquoise)) +
  geom_bar(stat="identity", colour = "turquoise", fill = "turquoise") +
  geom_text(label = signif(turquoise_MEs_data$MEturquoise, digits = 1), size = 3, check_overlap = T, col = "black", position = "identity", hjust = "middle", vjust = -1, fontface = "bold") +
  theme_bw() +
  xlab("") +
  ylab("Eigenmetabolite Expression") +
  theme(axis.title.y = element_text(size=14), axis.text.x = element_text(angle = 90, size = 12, face = "bold"))
ggsave(filename = "turquoise_ModuleEigenmetabolite_barplot.pdf")
ggsave(filename = "turquoise_ModuleEigenmetabolite_barplot.png")

### 1.2.4 brown module ###
setwd("../brown/")
brown_MEs_data <- MEs_col %>% as.data.frame() %>% dplyr::select(MEbrown)
ggplot(data = brown_MEs_data, mapping = aes(x = samname, y = MEbrown)) +
  geom_bar(stat="identity", colour = "brown", fill = "brown") +
  geom_text(label = signif(brown_MEs_data$MEbrown, digits = 1), size = 3, check_overlap = T, col = "black", position = "identity", hjust = "middle", vjust = -1, fontface = "bold") +
  theme_bw() +
  xlab("") +
  ylab("Eigenmetabolite Expression") +
  theme(axis.title.y = element_text(size=14), axis.text.x = element_text(angle = 90, size = 12, face = "bold"))
ggsave(filename = "brown_ModuleEigenmetabolite_barplot.pdf")
ggsave(filename = "brown_ModuleEigenmetabolite_barplot.png")

### 1.2.5 red module ###
setwd("../red/")
red_MEs_data <- MEs_col %>% as.data.frame() %>% dplyr::select(MEred)
ggplot(data = red_MEs_data, mapping = aes(x = samname, y = MEred)) +
  geom_bar(stat="identity", colour = "red", fill = "red") +
  geom_text(label = signif(red_MEs_data$MEred, digits = 1), size = 3, check_overlap = T, col = "black", position = "identity", hjust = "middle", vjust = -1, fontface = "bold") +
  theme_bw() +
  xlab("") +
  ylab("Eigenmetabolite Expression") +
  theme(axis.title.y = element_text(size=14), axis.text.x = element_text(angle = 90, size = 12, face = "bold"))
ggsave(filename = "red_ModuleEigenmetabolite_barplot.pdf")
ggsave(filename = "red_ModuleEigenmetabolite_barplot.png")

### 1.2.6 green module ###
setwd("../green/")
green_MEs_data <- MEs_col %>% as.data.frame() %>% dplyr::select(MEgreen)
ggplot(data = green_MEs_data, mapping = aes(x = samname, y = MEgreen)) +
  geom_bar(stat="identity", colour = "green", fill = "green") +
  geom_text(label = signif(green_MEs_data$MEgreen, digits = 1), size = 3, check_overlap = T, col = "black", position = "identity", hjust = "middle", vjust = -1, fontface = "bold") +
  theme_bw() +
  xlab("") +
  ylab("Eigenmetabolite Expression") +
  theme(axis.title.y = element_text(size=14), axis.text.x = element_text(angle = 90, size = 12, face = "bold"))
ggsave(filename = "green_ModuleEigenmetabolite_barplot.pdf")
ggsave(filename = "green_ModuleEigenmetabolite_barplot.png")
setwd("../")

#######################################################################
## 1.3 第二部分：模块样品的代谢物表达箱线图：Boxplot
#######################################################################

## 1.3.1 WGCNA分析clean表达矩阵数据
dim(metaboExprData)
# [1]    33 11044
metabo_data_clean_new <- t(metaboExprData)
dim(metabo_data_clean_new)
print("查看转置后的WGCNA分析clean表达矩阵数据的列名：")
colnames(metabo_data_clean_new)
# [1] "1_1"  "1_2"  "1_3"  "1_4"  "1_5"  "1_6"  "1_7"  "1_8"  "1_9"  "1_10" "1_11" "2_1"  "2_2"  "2_3"  "2_4"  "2_5"  "2_6"  "2_7"
# [19] "2_8"  "2_9"  "2_10" "2_11" "3_1"  "3_2"  "3_3"  "3_4"  "3_5"  "3_6"  "3_7"  "3_8"  "3_9"  "3_10" "3_11"
metabo_data_clean_new <- cbind(rownames(metabo_data_clean_new), metabo_data_clean_new)
colnames(metabo_data_clean_new)[1] <- "Metabolite_Name"
colnames(metabo_data_clean_new)
# [1] "Metabolite_Name" "1_1"             "1_2"             "1_3"             "1_4"             "1_5"             "1_6"
# [8] "1_7"             "1_8"             "1_9"             "1_10"            "1_11"            "2_1"             "2_2"
# [15] "2_3"             "2_4"             "2_5"             "2_6"             "2_7"             "2_8"             "2_9"
# [22] "2_10"            "2_11"            "3_1"             "3_2"             "3_3"             "3_4"             "3_5"
# [29] "3_6"             "3_7"             "3_8"             "3_9"             "3_10"            "3_11"

### 1.3.2 blue module ###
mode(blueModule_cyt)
# # [1] "list"
class(blueModule_cyt)
# # [1] "list"
head(blueModule_cyt$nodeData)
# nodeName altName nodeAttr[nodesPresent, ]
# 1 Methyl 2-(10-heptadecenyl)-6-hydroxybenzoate      NA                     blue
# 2                       3-Oxohexadecanoic acid      NA                     blue
# 3                       3-Oxooctadecanoic acid      NA                     blue
# 4                           13,14-Dihydro PGE1      NA                     blue
# 5                                     Momordol      NA                     blue
# 6                                 17,18-DiHETE      NA                     blue
class(blueModule_cyt$nodeData)
# # [1] "data.frame"
dim(blueModule_cyt$nodeData)
# [1] 1465    3

blue_module_metabolites_label <- blueModule_cyt$nodeData
colnames(blue_module_metabolites_label) <- c("nodeName", "altName", "nodeAttr")
rownames(blue_module_metabolites_label) <- blue_module_metabolites_label$nodeName
head(blue_module_metabolites_label)
# nodeName altName nodeAttr
# Methyl 2-(10-heptadecenyl)-6-hydroxybenzoate Methyl 2-(10-heptadecenyl)-6-hydroxybenzoate      NA     blue
# 3-Oxohexadecanoic acid                                             3-Oxohexadecanoic acid      NA     blue
# 3-Oxooctadecanoic acid                                             3-Oxooctadecanoic acid      NA     blue
# 13,14-Dihydro PGE1                                                     13,14-Dihydro PGE1      NA     blue
# Momordol                                                                         Momordol      NA     blue
# 17,18-DiHETE                                                                 17,18-DiHETE      NA     blue
blue_module_metabolites_label$altName <- NULL # 去掉altName列
head(blue_module_metabolites_label)
# nodeName nodeAttr
# Methyl 2-(10-heptadecenyl)-6-hydroxybenzoate Methyl 2-(10-heptadecenyl)-6-hydroxybenzoate     blue
# 3-Oxohexadecanoic acid                                             3-Oxohexadecanoic acid     blue
# 3-Oxooctadecanoic acid                                             3-Oxooctadecanoic acid     blue
# 13,14-Dihydro PGE1                                                     13,14-Dihydro PGE1     blue
# Momordol                                                                         Momordol     blue
# 17,18-DiHETE                                                                 17,18-DiHETE     blue

#@ 获取属于蓝色模块中的代谢物表达矩阵数据：blue_Module_data，PSE = ProteinSampleExpression
head(blue_module_metabolites_label)
# nodeName nodeAttr
# Methyl 2-(10-heptadecenyl)-6-hydroxybenzoate Methyl 2-(10-heptadecenyl)-6-hydroxybenzoate     blue
# 3-Oxohexadecanoic acid                                             3-Oxohexadecanoic acid     blue
# 3-Oxooctadecanoic acid                                             3-Oxooctadecanoic acid     blue
# 13,14-Dihydro PGE1                                                     13,14-Dihydro PGE1     blue
# Momordol                                                                         Momordol     blue
# 17,18-DiHETE                                                                 17,18-DiHETE     blue
metabo_data_clean_new[1:5,1:5]
# Metabolite_Name                      1_1                  1_2
# Sphingosine                        "Sphingosine"                        "4.23216426389048"   "-0.393335722377462"
# 3-alpha-Androstanediol glucuronide "3-alpha-Androstanediol glucuronide" "-0.549231884634406" "-0.530086214996186"
# LysoPE(15:0/0:0)                   "LysoPE(15:0/0:0)"                   "-1.22225926739144"  "-0.93409061641951"
# Deoxycholic acid                   "Deoxycholic acid"                   "-0.763506640583135" "-0.798955986622118"
# Glycocholic Acid                   "Glycocholic Acid"                   "-0.462002282002322" "-0.453962894226622"
# 1_3                  1_4
# Sphingosine                        "-1.11415380028084"  "-0.345934428848354"
# 3-alpha-Androstanediol glucuronide "-0.5266056763911"   "-0.517509111011546"
# LysoPE(15:0/0:0)                   "1.10771650610039"   "-1.20145968615411"
# Deoxycholic acid                   "-0.797904102916744" "-0.476572911449033"
# Glycocholic Acid                   "1.48540098639969"   "-0.44866586601482"

#@ 合并数据
blue_Module_data <- merge.data.frame(x = blue_module_metabolites_label, y = metabo_data_clean_new, by.x = "nodeName", by.y = "Metabolite_Name", all.x = TRUE)

#@ 保存blue模块的代谢物表达矩阵数据
dim(blue_Module_data)
# [1] 1465   35
colnames(blue_Module_data)
# [1] "nodeName" "nodeAttr" "1_1"      "1_2"      "1_3"      "1_4"      "1_5"      "1_6"      "1_7"      "1_8"      "1_9"
# [12] "1_10"     "1_11"     "2_1"      "2_2"      "2_3"      "2_4"      "2_5"      "2_6"      "2_7"      "2_8"      "2_9"
# [23] "2_10"     "2_11"     "3_1"      "3_2"      "3_3"      "3_4"      "3_5"      "3_6"      "3_7"      "3_8"      "3_9"
# [34] "3_10"     "3_11"
head(rownames(blue_Module_data))
# [1] "1" "2" "3" "4" "5" "6"

setwd("../../../")
export(blue_Module_data, file = "blue_Module_data.xlsx", rowNames = T, colNames = T, borders = "columns", firstCol = TRUE, zoom = 120)

# 准备箱线图数据 #################################################################################################################################
metabo_name <- blue_Module_data$nodeName
dir.create("MEblue")
setwd("MEblue")

for (i in sam_name) {
  RSN <- as.data.frame(rep(i, NROW(blue_Module_data)))
  df <- as.data.frame(cbind(metabo_name, blue_Module_data[i]))
  df_new <- data.frame(df, RSN)
  colnames(df_new) <-  c("Metabolite_Name", "Expression", "Sample_abc")
  write.xlsx(df_new, file = paste("Sample_",i,"_blue_data.xlsx"))
}

filenames <- dir("./")
filenames2 <- grep('\\.xlsx', filenames, value = TRUE)
data <- data.frame()
for (i in filenames2) {
  # 构造数据路径
  path <- paste0(getwd(),'\\',i)
  # 读取并合并数据
  data <- rbind(data, read.xlsx(path))
  write.xlsx(data, file = "Sample_blue_data.xlsx")
}

blue_module_boxplot <- merge.data.frame(data, sample_info_1, by.x = "Sample_abc", by.y = "作图编号", all.x = T)
blue_module_boxplot$样品编号 <- NULL
colnames(blue_module_boxplot) <- c("Sample_abc", "Metabolite_Name", "Expression", "Sample_group")
needcoln <- c("Metabolite_Name", "Expression", "Sample_abc", "Sample_group")
blue_module_boxplot_data <- blue_module_boxplot[,needcoln]
export(blue_module_boxplot_data, file = "blue_module_boxplot_data.xlsx", rowNames = T, colNames = T, zoom = 120)
# ModuleBoxplotDataFunc <- function(module = "blue") {
#   for (i in sam_name) {
#     # paste0(module,"_Module_data")[,-2]
#     paste0("Sample_",i,"_",module,"_data") <- data.frame(paste0(module,"_Module_data")[1], paste0(module,"_Module_data")[i])
#     colnames(paste0("Sample_",i,"_",module,"_data")) <- c("Metabolite_Name", "Expression")
#     write.xlsx(paste0("Sample_",i,"_",module,"_data"), file = paste0("Sample_",i,"_",module,"_data.xlsx"))
#   }
# }
# ModuleBoxplotDataFunc(module = "blue")

#@ 绘制箱线图，这个文件是手动处理的，后面是脚本自动化处理这个文件
setwd("./WGCNA_M/4.Modules_with_External_Information_Associations_Analysis/4.1Modules_Samples_Associations_Analysis/")
setwd("./blue/")
# blue_boxplot_data <- read.xlsx("../../../../blue_module_boxplot_data.xlsx", sheet = 1, colNames = T, rowNames = F, detectDates = F)
blue_module_boxplot_data$Expression <- as.numeric(blue_module_boxplot_data$Expression)
samname <- factor(blue_module_boxplot_data$Sample_abc, levels=c("1_1",  "1_2",  "1_3",  "1_4",  "1_5",  "1_6",  "1_7",  "1_8",  "1_9",  "1_10", "1_11", "2_1",  "2_2",  "2_3",  "2_4",  "2_5",  "2_6",  "2_7", "2_8",  "2_9",  "2_10", "2_11", "3_1",  "3_2",  "3_3",  "3_4",  "3_5",  "3_6",  "3_7",  "3_8",  "3_9",  "3_10", "3_11"))
#@ 不分组绘图

#### PDF&PNG
ggplot(data = blue_module_boxplot_data, aes(x = samname, y = Expression)) +
  geom_boxplot(col = "black", fill = "blue") +
  theme_bw() +
  xlab("") +
  ylab("Metabolite Expression") +
  theme(axis.title.y = element_text(size=14), axis.text.x = element_text(angle = 90, size = 12, face = "bold")) +
  theme(plot.margin = unit(rep(0.6,4),'lines'), aspect.ratio = .6)
ggsave("blue_Module_boxplot.pdf", width = 12, height = 8.5, units = "in")
ggsave("blue_Module_boxplot.png", width = 12, height = 8.5, units = "in")
#
# ### 分组绘图：bygroup
# ### PDF&PNG
ggplot(data = blue_module_boxplot_data, aes(x = samname, y = Expression, colour = Sample_group)) +
  geom_boxplot() +
  theme_bw() +
  xlab("") +
  ylab("Metabolite Expression") +
  theme(axis.title.y = element_text(size=14), axis.text.x = element_text(angle = 90, size = 12, face = "bold"))
ggsave("blue_Module_boxplot_group.pdf", width = 12, height = 8.5, units = "in")
ggsave("blue_Module_boxplot_group.png", width = 12, height = 8.5, units = "in")
#
### 1.3.3 yellow module ###
#@ 获取属于黄色模块中的代谢物表达矩阵数据：yellow_Module_data
setwd("../../../../")
# [1] "D:/工作空间/鹿明生物蛋白质组学信息分析/研发/2020年研发工作目录/2020年1月/鹿明代谢分析组WGCNA分析流程及报告"
yellow_module_metabolites_label <- yellowModule_cyt$nodeData
colnames(yellow_module_metabolites_label) <- c("nodeName", "altName", "nodeAttr")
rownames(yellow_module_metabolites_label) <- yellow_module_metabolites_label$nodeName
yellow_module_metabolites_label$altName <- NULL # 去掉altName列
#
yellow_Module_data <- merge.data.frame(x = yellow_module_metabolites_label, y = metabo_data_clean_new, by.x = "nodeName", by.y = "Metabolite_Name", all.x = TRUE)
#@ 保存yellow模块的代谢物表达矩阵数据
export(yellow_Module_data, file = "yellow_Module_data.xlsx", rowNames = T, colNames = T, borders = "columns", firstCol = TRUE, zoom = 120)

#@ 流程获取箱线图数据
metabo_name <- yellow_Module_data$nodeName
dir.create("MEyellow")
setwd("MEyellow")

for (i in sam_name) {
  RSN <- as.data.frame(rep(i, NROW(yellow_Module_data)))
  df <- as.data.frame(cbind(metabo_name, yellow_Module_data[i]))
  df_new <- data.frame(df, RSN)
  colnames(df_new) <-  c("Metabolite_Name", "Expression", "Sample_abc")
  write.xlsx(df_new, file = paste("Sample_",i,"_yellow_data.xlsx"))
}

filenames <- dir("./")
filenames2 <- grep('\\.xlsx', filenames, value = TRUE)
data <- data.frame()
for (i in filenames2) {
  # 构造数据路径
  path <- paste0(getwd(),'\\',i)
  # 读取并合并数据
  data <- rbind(data, read.xlsx(path))
  write.xlsx(data, file = "Sample_yellow_data.xlsx")
}

yellow_module_boxplot <- merge.data.frame(data, sample_info_1, by.x = "Sample_abc", by.y = "作图编号", all.x = T)

yellow_module_boxplot$样品编号 <- NULL
colnames(yellow_module_boxplot) <- c("Sample_abc", "Metabolite_Name", "Expression", "Sample_group")
needcoln <- c("Metabolite_Name", "Expression", "Sample_abc", "Sample_group")
yellow_module_boxplot_data <- yellow_module_boxplot[,needcoln]

export(yellow_module_boxplot_data, file = "yellow_module_boxplot_data.xlsx", rowNames = T, colNames = T, zoom = 120)

#@ 不分组绘图
setwd("../WGCNA_M/4.Modules_with_External_Information_Associations_Analysis/4.1Modules_Samples_Associations_Analysis/yellow/")
yellow_module_boxplot_data$Expression <- as.numeric(yellow_module_boxplot_data$Expression)
samname <- factor(yellow_module_boxplot_data$Sample_abc, levels=c("1_1",  "1_2",  "1_3",  "1_4",  "1_5",  "1_6",  "1_7",  "1_8",  "1_9",  "1_10", "1_11", "2_1",  "2_2",  "2_3",  "2_4",  "2_5",  "2_6",  "2_7", "2_8",  "2_9",  "2_10", "2_11", "3_1",  "3_2",  "3_3",  "3_4",  "3_5",  "3_6",  "3_7",  "3_8",  "3_9",  "3_10", "3_11"))
#### PDF&PNG
ggplot(data = yellow_module_boxplot_data, aes(x = samname, y = Expression)) +
  geom_boxplot(col = "black", fill = "yellow") +
  theme_bw() +
  xlab("") +
  ylab("Metabolite Expression") +
  theme(axis.title.y = element_text(size=14), axis.text.x = element_text(angle = 90, size = 12, face = "bold")) +
  theme(plot.margin = unit(rep(0.6,4),'lines'), aspect.ratio = .6)
ggsave("yellow_Module_boxplot.pdf", width = 12, height = 8.5, units = "in")
ggsave("yellow_Module_boxplot.png", width = 12, height = 8.5, units = "in")
#
#@ 分组绘图：bygroup

# ### PDF&PNG
ggplot(data = yellow_module_boxplot_data, aes(x = samname, y = Expression, colour = Sample_group)) +
  geom_boxplot() +
  theme_bw() +
  xlab("") +
  ylab("Metabolite Expression") +
  theme(axis.title.y = element_text(size=14), axis.text.x = element_text(angle = 90, size = 12, face = "bold"))
ggsave("yellow_Module_boxplot_group.pdf", width = 12, height = 8.5, units = "in")
ggsave("yellow_Module_boxplot_group.png", width = 12, height = 8.5, units = "in")
#
### 1.3.4 turquoise module ###
#@ 获取属于蓝绿色模块中的代谢物表达矩阵数据：turquoise_Module_data

turquoise_module_metabolites_label <- turquoiseModule_cyt$nodeData
colnames(turquoise_module_metabolites_label) <- c("nodeName", "altName", "nodeAttr")
rownames(turquoise_module_metabolites_label) <- turquoise_module_metabolites_label$nodeName
turquoise_module_metabolites_label$altName <- NULL # 去掉altName列
#
turquoise_Module_data <- merge.data.frame(x = turquoise_module_metabolites_label, y = metabo_data_clean_new, by.x = "nodeName", by.y = "Metabolite_Name", all.x = TRUE)
#
export(turquoise_Module_data, file = "turquoise_Module_data.xlsx", rowNames = T, colNames = T, borders = "columns", firstCol = TRUE, zoom = 120)
#
# ### 绘制箱线图，这个文件是手动处理的，后面是脚本自动化处理这个文件
setwd("../../../../")
metabo_name <- turquoise_Module_data$nodeName
dir.create("MEturquoise")
setwd("MEturquoise")

for (i in sam_name) {
  RSN <- as.data.frame(rep(i, NROW(turquoise_Module_data)))
  df <- as.data.frame(cbind(metabo_name, turquoise_Module_data[i]))
  df_new <- data.frame(df, RSN)
  colnames(df_new) <-  c("Metabolite_Name", "Expression", "Sample_abc")
  write.xlsx(df_new, file = paste("Sample_",i,"_turquoise_data.xlsx"))
}

filenames <- dir("./")
filenames2 <- grep('\\.xlsx', filenames, value = TRUE)
data <- data.frame()
for (i in filenames2) {
  # 构造数据路径
  path <- paste0(getwd(),'\\',i)
  # 读取并合并数据
  data <- rbind(data, read.xlsx(path))
  write.xlsx(data, file = "Sample_turquoise_data.xlsx")
}

turquoise_module_boxplot <- merge.data.frame(data, sample_info_1, by.x = "Sample_abc", by.y = "作图编号", all.x = T)
turquoise_module_boxplot$样品编号 <- NULL
colnames(turquoise_module_boxplot) <- c("Sample_abc", "Metabolite_Name", "Expression", "Sample_group")
needcoln <- c("Metabolite_Name", "Expression", "Sample_abc", "Sample_group")
turquoise_module_boxplot_data <- turquoise_module_boxplot[,needcoln]
export(turquoise_module_boxplot_data, file = "turquoise_module_boxplot_data.xlsx", rowNames = T, colNames = T, zoom = 120)
getwd()
setwd("../WGCNA_M/4.Modules_with_External_Information_Associations_Analysis/4.1Modules_Samples_Associations_Analysis/turquoise/")
#
#### 不分组绘图
turquoise_module_boxplot_data$Expression <- as.numeric(turquoise_module_boxplot_data$Expression)
samname <- factor(turquoise_module_boxplot_data$Sample_abc, levels=c("1_1",  "1_2",  "1_3",  "1_4",  "1_5",  "1_6",  "1_7",  "1_8",  "1_9",  "1_10", "1_11", "2_1",  "2_2",  "2_3",  "2_4",  "2_5",  "2_6",  "2_7", "2_8",  "2_9",  "2_10", "2_11", "3_1",  "3_2",  "3_3",  "3_4",  "3_5",  "3_6",  "3_7",  "3_8",  "3_9",  "3_10", "3_11"))
# ### PDF&PNG
ggplot(data = turquoise_module_boxplot_data, aes(x = samname, y = Expression)) +
  geom_boxplot(col = "black", fill = "turquoise") +
  theme_bw() +
  xlab("") +
  ylab("Metabolite Expression") +
  theme(axis.title.y = element_text(size=14), axis.text.x = element_text(angle = 90, size = 12, face = "bold")) +
  theme(plot.margin = unit(rep(0.6,4),'lines'), aspect.ratio = .6)
ggsave("turquoise_Module_boxplot.pdf", width = 12, height = 8.5, units = "in")
ggsave("turquoise_Module_boxplot.png", width = 12, height = 8.5, units = "in")
#
# ### 分组绘图：bygroup
# ### PDF&PNG
ggplot(data = turquoise_module_boxplot_data, aes(x = samname, y = Expression, colour = Sample_group)) +
  geom_boxplot() +
  theme_bw() +
  xlab("") +
  ylab("Metabolite Expression") +
  theme(axis.title.y = element_text(size=14), axis.text.x = element_text(angle = 90, size = 12, face = "bold"))
ggsave("turquoise_Module_boxplot_group.pdf", width = 12, height = 8.5, units = "in")
ggsave("turquoise_Module_boxplot_group.png", width = 12, height = 8.5, units = "in")
#
### 1.3.5 brown module ###
# ### 获取属于棕色模块中的代谢物表达矩阵数据：brown_Module_data

brown_module_metabolites_label <- brownModule_cyt$nodeData
colnames(brown_module_metabolites_label) <- c("nodeName", "altName", "nodeAttr")
rownames(brown_module_metabolites_label) <- brown_module_metabolites_label$nodeName
brown_module_metabolites_label$altName <- NULL # 去掉altName列
brown_Module_data <- merge.data.frame(x = brown_module_metabolites_label, y = metabo_data_clean_new, by.x = "nodeName", by.y = "Metabolite_Name", all.x = TRUE)
export(brown_Module_data, file = "brown_Module_data.xlsx", rowNames = T, colNames = T, borders = "columns", firstCol = TRUE, zoom = 120)

#@ 准备箱线图数据
setwd("../../../../")
metabo_name <- brown_Module_data$nodeName
dir.create("MEbrown")
setwd("MEbrown")

for (i in sam_name) {
  RSN <- as.data.frame(rep(i, NROW(brown_Module_data)))
  df <- as.data.frame(cbind(metabo_name, brown_Module_data[i]))
  df_new <- data.frame(df, RSN)
  colnames(df_new) <-  c("Metabolite_Name", "Expression", "Sample_abc")
  write.xlsx(df_new, file = paste("Sample_",i,"_brown_data.xlsx"))
}

filenames <- dir("./")
filenames2 <- grep('\\.xlsx', filenames, value = TRUE)
data <- data.frame()
for (i in filenames2) {
  # 构造数据路径
  path <- paste0(getwd(),'\\',i)
  # 读取并合并数据
  data <- rbind(data, read.xlsx(path))
  write.xlsx(data, file = "Sample_brown_data.xlsx")
}

brown_module_boxplot <- merge.data.frame(data, sample_info_1, by.x = "Sample_abc", by.y = "作图编号", all.x = T)
brown_module_boxplot$样品编号 <- NULL
colnames(brown_module_boxplot) <- c("Sample_abc", "Metabolite_Name", "Expression", "Sample_group")
needcoln <- c("Metabolite_Name", "Expression", "Sample_abc", "Sample_group")
brown_module_boxplot_data <- brown_module_boxplot[,needcoln]
export(brown_module_boxplot_data, file = "brown_module_boxplot_data.xlsx", rowNames = T, colNames = T, zoom = 120)
getwd()
setwd("../WGCNA_M/4.Modules_with_External_Information_Associations_Analysis/4.1Modules_Samples_Associations_Analysis/brown/")
#
#### 不分组绘图
brown_module_boxplot_data$Expression <- as.numeric(brown_module_boxplot_data$Expression)
samname <- factor(brown_module_boxplot_data$Sample_abc, levels=c("1_1",  "1_2",  "1_3",  "1_4",  "1_5",  "1_6",  "1_7",  "1_8",  "1_9",  "1_10", "1_11", "2_1",  "2_2",  "2_3",  "2_4",  "2_5",  "2_6",  "2_7", "2_8",  "2_9",  "2_10", "2_11", "3_1",  "3_2",  "3_3",  "3_4",  "3_5",  "3_6",  "3_7",  "3_8",  "3_9",  "3_10", "3_11"))
# ### PDF&PNG
ggplot(data = brown_module_boxplot_data, aes(x = samname, y = Expression)) +
  geom_boxplot(col = "black", fill = "brown") +
  theme_bw() +
  xlab("") +
  ylab("Metabolite Expression") +
  theme(axis.title.y = element_text(size=14), axis.text.x = element_text(angle = 90, size = 12, face = "bold")) +
  theme(plot.margin = unit(rep(0.6,4),'lines'), aspect.ratio = .6)
ggsave("brown_Module_boxplot.pdf", width = 12, height = 8.5, units = "in")
ggsave("brown_Module_boxplot.png", width = 12, height = 8.5, units = "in")
#
# ### 分组绘图：bygroup
# ### PDF&PNG
ggplot(data = brown_module_boxplot_data, aes(x = samname, y = Expression, colour = Sample_group)) +
  geom_boxplot() +
  theme_bw() +
  xlab("") +
  ylab("Metabolite Expression") +
  theme(axis.title.y = element_text(size=14), axis.text.x = element_text(angle = 90, size = 12, face = "bold"))
ggsave("brown_Module_boxplot_group.pdf", width = 12, height = 8.5, units = "in")
ggsave("brown_Module_boxplot_group.png", width = 12, height = 8.5, units = "in")

### 1.3.6 red module ###
# ### 获取属于棕色模块中的代谢物表达矩阵数据：red_Module_data
red_module_metabolites_label <- redModule_cyt$nodeData
colnames(red_module_metabolites_label) <- c("nodeName", "altName", "nodeAttr")
rownames(red_module_metabolites_label) <- red_module_metabolites_label$nodeName
red_module_metabolites_label$altName <- NULL # 去掉altName列
red_Module_data <- merge.data.frame(x = red_module_metabolites_label, y = metabo_data_clean_new, by.x = "nodeName", by.y = "Metabolite_Name", all.x = TRUE)
export(red_Module_data, file = "red_Module_data.xlsx", rowNames = T, colNames = T, borders = "columns", firstCol = TRUE, zoom = 120)

#@ 准备箱线图数据
setwd("../../../../")
metabo_name <- red_Module_data$nodeName
dir.create("MEred")
setwd("MEred")

for (i in sam_name) {
  RSN <- as.data.frame(rep(i, NROW(red_Module_data)))
  df <- as.data.frame(cbind(metabo_name, red_Module_data[i]))
  df_new <- data.frame(df, RSN)
  colnames(df_new) <-  c("Metabolite_Name", "Expression", "Sample_abc")
  write.xlsx(df_new, file = paste("Sample_",i,"_brown_data.xlsx"))
}

filenames <- dir("./")
filenames2 <- grep('\\.xlsx', filenames, value = TRUE)
data <- data.frame()
for (i in filenames2) {
  # 构造数据路径
  path <- paste0(getwd(),'\\',i)
  # 读取并合并数据
  data <- rbind(data, read.xlsx(path))
  write.xlsx(data, file = "Sample_red_data.xlsx")
}

red_module_boxplot <- merge.data.frame(data, sample_info_1, by.x = "Sample_abc", by.y = "作图编号", all.x = T)
red_module_boxplot$样品编号 <- NULL
colnames(red_module_boxplot) <- c("Sample_abc", "Metabolite_Name", "Expression", "Sample_group")
needcoln <- c("Metabolite_Name", "Expression", "Sample_abc", "Sample_group")
red_module_boxplot_data <- red_module_boxplot[,needcoln]
export(red_module_boxplot_data, file = "red_module_boxplot_data.xlsx", rowNames = T, colNames = T, zoom = 120)
getwd()
setwd("../WGCNA_M/4.Modules_with_External_Information_Associations_Analysis/4.1Modules_Samples_Associations_Analysis/red/")
#
#### 不分组绘图
red_module_boxplot_data$Expression <- as.numeric(red_module_boxplot_data$Expression)
samname <- factor(red_module_boxplot_data$Sample_abc, levels=c("1_1",  "1_2",  "1_3",  "1_4",  "1_5",  "1_6",  "1_7",  "1_8",  "1_9",  "1_10", "1_11", "2_1",  "2_2",  "2_3",  "2_4",  "2_5",  "2_6",  "2_7", "2_8",  "2_9",  "2_10", "2_11", "3_1",  "3_2",  "3_3",  "3_4",  "3_5",  "3_6",  "3_7",  "3_8",  "3_9",  "3_10", "3_11"))
# ### PDF&PNG
ggplot(data = red_module_boxplot_data, aes(x = samname, y = Expression)) +
  geom_boxplot(col = "black", fill = "red") +
  theme_bw() +
  xlab("") +
  ylab("Metabolite Expression") +
  theme(axis.title.y = element_text(size=14), axis.text.x = element_text(angle = 90, size = 12, face = "bold")) +
  theme(plot.margin = unit(rep(0.6,4),'lines'), aspect.ratio = .6)
ggsave("red_Module_boxplot.pdf", width = 12, height = 8.5, units = "in")
ggsave("red_Module_boxplot.png", width = 12, height = 8.5, units = "in")
#
# ### 分组绘图：bygroup
# ### PDF&PNG
ggplot(data = red_module_boxplot_data, aes(x = samname, y = Expression, colour = Sample_group)) +
  geom_boxplot() +
  theme_bw() +
  xlab("") +
  ylab("Metabolite Expression") +
  theme(axis.title.y = element_text(size=14), axis.text.x = element_text(angle = 90, size = 12, face = "bold"))
ggsave("red_Module_boxplot_group.pdf", width = 12, height = 8.5, units = "in")
ggsave("red_Module_boxplot_group.png", width = 12, height = 8.5, units = "in")

### 1.3.7 green module ###
# ### 获取属于棕色模块中的代谢物表达矩阵数据：green_Module_data
green_module_metabolites_label <- greenModule_cyt$nodeData
colnames(green_module_metabolites_label) <- c("nodeName", "altName", "nodeAttr")
rownames(green_module_metabolites_label) <- green_module_metabolites_label$nodeName
green_module_metabolites_label$altName <- NULL # 去掉altName列
green_Module_data <- merge.data.frame(x = green_module_metabolites_label, y = metabo_data_clean_new, by.x = "nodeName", by.y = "Metabolite_Name", all.x = TRUE)
export(green_Module_data, file = "green_Module_data.xlsx", rowNames = T, colNames = T, borders = "columns", firstCol = TRUE, zoom = 120)

#@ 准备箱线图数据
setwd("../../../../")
metabo_name <- green_Module_data$nodeName
dir.create("MEgreen")
setwd("MEgreen")

for (i in sam_name) {
  RSN <- as.data.frame(rep(i, NROW(green_Module_data)))
  df <- as.data.frame(cbind(metabo_name, green_Module_data[i]))
  df_new <- data.frame(df, RSN)
  colnames(df_new) <-  c("Metabolite_Name", "Expression", "Sample_abc")
  write.xlsx(df_new, file = paste("Sample_",i,"_brown_data.xlsx"))
}

filenames <- dir("./")
filenames2 <- grep('\\.xlsx', filenames, value = TRUE)
data <- data.frame()
for (i in filenames2) {
  # 构造数据路径
  path <- paste0(getwd(),'\\',i)
  # 读取并合并数据
  data <- rbind(data, read.xlsx(path))
  write.xlsx(data, file = "Sample_green_data.xlsx")
}

green_module_boxplot <- merge.data.frame(data, sample_info_1, by.x = "Sample_abc", by.y = "作图编号", all.x = T)
green_module_boxplot$样品编号 <- NULL
colnames(green_module_boxplot) <- c("Sample_abc", "Metabolite_Name", "Expression", "Sample_group")
needcoln <- c("Metabolite_Name", "Expression", "Sample_abc", "Sample_group")
green_module_boxplot_data <- green_module_boxplot[,needcoln]
export(green_module_boxplot_data, file = "green_module_boxplot_data.xlsx", rowNames = T, colNames = T, zoom = 120)
getwd()
setwd("../WGCNA_M/4.Modules_with_External_Information_Associations_Analysis/4.1Modules_Samples_Associations_Analysis/green/")
#
#### 不分组绘图
green_module_boxplot_data$Expression <- as.numeric(green_module_boxplot_data$Expression)
samname <- factor(green_module_boxplot_data$Sample_abc, levels=c("1_1",  "1_2",  "1_3",  "1_4",  "1_5",  "1_6",  "1_7",  "1_8",  "1_9",  "1_10", "1_11", "2_1",  "2_2",  "2_3",  "2_4",  "2_5",  "2_6",  "2_7", "2_8",  "2_9",  "2_10", "2_11", "3_1",  "3_2",  "3_3",  "3_4",  "3_5",  "3_6",  "3_7",  "3_8",  "3_9",  "3_10", "3_11"))
# ### PDF&PNG
ggplot(data = green_module_boxplot_data, aes(x = samname, y = Expression)) +
  geom_boxplot(col = "black", fill = "green") +
  theme_bw() +
  xlab("") +
  ylab("Metabolite Expression") +
  theme(axis.title.y = element_text(size=14), axis.text.x = element_text(angle = 90, size = 12, face = "bold")) +
  theme(plot.margin = unit(rep(0.6,4),'lines'), aspect.ratio = .6)
ggsave("green_Module_boxplot.pdf", width = 12, height = 8.5, units = "in")
ggsave("green_Module_boxplot.png", width = 12, height = 8.5, units = "in")
#
# ### 分组绘图：bygroup
# ### PDF&PNG
ggplot(data = green_module_boxplot_data, aes(x = samname, y = Expression, colour = Sample_group)) +
  geom_boxplot() +
  theme_bw() +
  xlab("") +
  ylab("Metabolite Expression") +
  theme(axis.title.y = element_text(size=14), axis.text.x = element_text(angle = 90, size = 12, face = "bold"))
ggsave("green_Module_boxplot_group.pdf", width = 12, height = 8.5, units = "in")
ggsave("green_Module_boxplot_group.png", width = 12, height = 8.5, units = "in")
setwd("../")
getwd()
# ##########################################################################################################################################
# ## 1.4 第三部分：模块代谢物表达聚类热图（去掉离群样品的）：Heatmap
# #######################################################################
# ### blue module ###
setwd("./blue/")
blue_Module_heatmap_data <- blue_Module_data %>% as.data.frame() %>% dplyr::select(-nodeAttr)
rownames(blue_Module_heatmap_data) <- blue_Module_heatmap_data$nodeName

blue_Module_heatmap_data$nodeName <- NULL
blue_Module_heatmap_data <- as.data.frame(lapply(blue_Module_heatmap_data,as.numeric))
colnames(blue_Module_heatmap_data) <- c("1_1",  "1_2",  "1_3",  "1_4",  "1_5",  "1_6",  "1_7",  "1_8",  "1_9",  "1_10", "1_11", "2_1",  "2_2",  "2_3",  "2_4",  "2_5",  "2_6",  "2_7", "2_8",  "2_9",  "2_10", "2_11", "3_1",  "3_2",  "3_3",  "3_4",  "3_5",  "3_6",  "3_7",  "3_8",  "3_9",  "3_10", "3_11")

export(blue_Module_data, file = "blue_Module_data.xlsx", colNames = T, rowNames = T, borders = "columns", firstCol = TRUE, zoom = 120)
# ### PDF
pdf("blue_Module_heatmap.pdf", width = 8.5, height = 10)
pheatmap(blue_Module_heatmap_data,
         cluster_rows = T,
         cluster_cols = F,
         display_numbers = F,
         number_format = "%.3f",
         show_colnames = T,
         show_rownames = F,
         color=colorRampPalette(c("blue", "white", "red"),bias=1)(500),
         border_color = NA,
         cellwidth = 13,
         cellheight = 0.3,
         scale = "row",
         fontsize_col = 12)
dev.off()
# ### PNG
png("blue_Module_heatmap.png", width = 650, height = 850)
pheatmap(blue_Module_heatmap_data,
         cluster_rows = T,
         cluster_cols = F,
         display_numbers = F,
         number_format = "%.3f",
         show_colnames = T,
         show_rownames = F,
         color=colorRampPalette(c("blue", "white", "red"),bias=1)(500),
         border_color = NA,
         cellwidth = 13,
         cellheight = 0.3,
         scale = "row",
         fontsize_col = 12)
dev.off()
#
# ### yellow module ###
setwd("../yellow/")
yellow_Module_heatmap_data <- yellow_Module_data %>% as.data.frame() %>% dplyr::select(-nodeAttr)
rownames(yellow_Module_heatmap_data) <- yellow_Module_heatmap_data$nodeName
yellow_Module_heatmap_data$nodeName <- NULL
yellow_Module_heatmap_data <- as.data.frame(lapply(yellow_Module_heatmap_data,as.numeric))
colnames(yellow_Module_heatmap_data) <- c("1_1",  "1_2",  "1_3",  "1_4",  "1_5",  "1_6",  "1_7",  "1_8",  "1_9",  "1_10", "1_11", "2_1",  "2_2",  "2_3",  "2_4",  "2_5",  "2_6",  "2_7", "2_8",  "2_9",  "2_10", "2_11", "3_1",  "3_2",  "3_3",  "3_4",  "3_5",  "3_6",  "3_7",  "3_8",  "3_9",  "3_10", "3_11")

export(yellow_Module_data, file = "yellow_Module_data.xlsx", colNames = T, rowNames = T, borders = "columns", firstCol = TRUE, zoom = 120)
# ### PDF
pdf("yellow_Module_heatmap.pdf", width = 8.5, height = 10)
pheatmap(yellow_Module_heatmap_data,
         cluster_rows = T,
         cluster_cols = F,
         display_numbers = F,
         number_format = "%.3f",
         show_colnames = T,
         show_rownames = F,
         color=colorRampPalette(c("blue", "white", "red"),bias=1)(500),
         border_color = NA,
         cellwidth = 13,
         cellheight = 0.5,
         scale = "row",
         fontsize_col = 12)
dev.off()
# ### PNG
png("yellow_Module_heatmap.png", width = 650, height = 850)
pheatmap(yellow_Module_heatmap_data,
         cluster_rows = T,
         cluster_cols = F,
         display_numbers = F,
         number_format = "%.3f",
         show_colnames = T,
         show_rownames = F,
         color=colorRampPalette(c("blue", "white", "red"),bias=1)(500),
         border_color = NA,
         cellwidth = 13,
         cellheight = 0.5,
         scale = "row",
         fontsize_col = 12)
dev.off()
#
# ### turquoise ###
setwd("../turquoise/")
turquoise_Module_heatmap_data <- turquoise_Module_data %>% as.data.frame() %>% dplyr::select(-nodeAttr)
rownames(turquoise_Module_heatmap_data) <- turquoise_Module_heatmap_data$nodeName
turquoise_Module_heatmap_data$nodeName <- NULL
turquoise_Module_heatmap_data <- as.data.frame(lapply(turquoise_Module_heatmap_data,as.numeric))

colnames(turquoise_Module_heatmap_data) <- c("1_1",  "1_2",  "1_3",  "1_4",  "1_5",  "1_6",  "1_7",  "1_8",  "1_9",  "1_10", "1_11", "2_1",  "2_2",  "2_3",  "2_4",  "2_5",  "2_6",  "2_7", "2_8",  "2_9",  "2_10", "2_11", "3_1",  "3_2",  "3_3",  "3_4",  "3_5",  "3_6",  "3_7",  "3_8",  "3_9",  "3_10", "3_11")

export(turquoise_Module_data, file = "turquoise_Module_data.xlsx", colNames = T, rowNames = T, borders = "columns", firstCol = TRUE, zoom = 120)
# ### PDF
pdf("turquoise_Module_heatmap.pdf", width = 8.5, height = 10)
pheatmap(turquoise_Module_heatmap_data,
         cluster_rows = T,
         cluster_cols = F,
         display_numbers = F,
         number_format = "%.3f",
         show_colnames = T,
         show_rownames = F,
         color=colorRampPalette(c("blue", "white", "red"),bias=1)(500),
         border_color = NA,
         cellwidth = 13,
         cellheight = 0.15,
         scale = "row",
         fontsize_col = 12)
dev.off()
# ### PNG
png("turquoise_Module_heatmap.png", width = 650, height = 850)
pheatmap(turquoise_Module_heatmap_data,
         cluster_rows = T,
         cluster_cols = F,
         display_numbers = F,
         number_format = "%.3f",
         show_colnames = T,
         show_rownames = F,
         color=colorRampPalette(c("blue", "white", "red"),bias=1)(500),
         border_color = NA,
         cellwidth = 13,
         cellheight = 0.15,
         scale = "row",
         fontsize_col = 12)
dev.off()
# ### brown ###
setwd("../brown/")
brown_Module_heatmap_data <- brown_Module_data %>% as.data.frame() %>% dplyr::select(-nodeAttr)
rownames(brown_Module_heatmap_data) <- brown_Module_heatmap_data$nodeName
brown_Module_heatmap_data$nodeName <- NULL

brown_Module_heatmap_data <- as.data.frame(lapply(brown_Module_heatmap_data,as.numeric))
colnames(brown_Module_heatmap_data) <- c("1_1",  "1_2",  "1_3",  "1_4",  "1_5",  "1_6",  "1_7",  "1_8",  "1_9",  "1_10", "1_11", "2_1",  "2_2",  "2_3",  "2_4",  "2_5",  "2_6",  "2_7", "2_8",  "2_9",  "2_10", "2_11", "3_1",  "3_2",  "3_3",  "3_4",  "3_5",  "3_6",  "3_7",  "3_8",  "3_9",  "3_10", "3_11")

export(brown_Module_data, file = "brown_Module_data.xlsx", colNames = T, rowNames = T, borders = "columns", firstCol = TRUE, zoom = 120)
# ### PDF
pdf("brown_Module_heatmap.pdf", width = 8.5, height = 10)
pheatmap(brown_Module_heatmap_data,
         cluster_rows = T,
         cluster_cols = F,
         display_numbers = F,
         number_format = "%.3f",
         show_colnames = T,
         show_rownames = F,
         color=colorRampPalette(c("blue", "white", "red"),bias=1)(500),
         border_color = NA,
         cellwidth = 13,
         cellheight = 0.4,
         scale = "row",
         fontsize_col = 12)
dev.off()
# ### PNG
png("brown_Module_heatmap.png", width = 650, height = 850)
pheatmap(brown_Module_heatmap_data,
         cluster_rows = T,
         cluster_cols = F,
         display_numbers = F,
         number_format = "%.3f",
         show_colnames = T,
         show_rownames = F,
         color=colorRampPalette(c("blue", "white", "red"),bias=1)(500),
         border_color = NA,
         cellwidth = 13,
         cellheight = 0.4,
         scale = "row",
         fontsize_col = 12)
dev.off()
#
### red module ###
setwd("../red/")
red_Module_heatmap_data <- red_Module_data %>% as.data.frame() %>% dplyr::select(-nodeAttr)
rownames(red_Module_heatmap_data) <- red_Module_heatmap_data$nodeName
red_Module_heatmap_data$nodeName <- NULL

red_Module_heatmap_data <- as.data.frame(lapply(red_Module_heatmap_data,as.numeric))
colnames(red_Module_heatmap_data) <- c("1_1",  "1_2",  "1_3",  "1_4",  "1_5",  "1_6",  "1_7",  "1_8",  "1_9",  "1_10", "1_11", "2_1",  "2_2",  "2_3",  "2_4",  "2_5",  "2_6",  "2_7", "2_8",  "2_9",  "2_10", "2_11", "3_1",  "3_2",  "3_3",  "3_4",  "3_5",  "3_6",  "3_7",  "3_8",  "3_9",  "3_10", "3_11")

export(red_Module_data, file = "red_Module_data.xlsx", colNames = T, rowNames = T, borders = "columns", firstCol = TRUE, zoom = 120)
# ### PDF
pdf("red_Module_heatmap.pdf", width = 8.5, height = 10)
pheatmap(red_Module_heatmap_data,
         cluster_rows = T,
         cluster_cols = F,
         display_numbers = F,
         number_format = "%.3f",
         show_colnames = T,
         show_rownames = F,
         color=colorRampPalette(c("blue", "white", "red"),bias=1)(500),
         border_color = NA,
         cellwidth = 13,
         cellheight = 0.5,
         scale = "row",
         fontsize_col = 12)
dev.off()
# ### PNG
png("red_Module_heatmap.png", width = 650, height = 850)
pheatmap(red_Module_heatmap_data,
         cluster_rows = T,
         cluster_cols = F,
         display_numbers = F,
         number_format = "%.3f",
         show_colnames = T,
         show_rownames = F,
         color=colorRampPalette(c("blue", "white", "red"),bias=1)(500),
         border_color = NA,
         cellwidth = 13,
         cellheight = 0.4,
         scale = "row",
         fontsize_col = 12)
dev.off()
#

### green module ###
setwd("../green/")
green_Module_heatmap_data <- green_Module_data %>% as.data.frame() %>% dplyr::select(-nodeAttr)
rownames(green_Module_heatmap_data) <- green_Module_heatmap_data$nodeName
green_Module_heatmap_data$nodeName <- NULL

green_Module_heatmap_data <- as.data.frame(lapply(green_Module_heatmap_data,as.numeric))
colnames(green_Module_heatmap_data) <- c("1_1",  "1_2",  "1_3",  "1_4",  "1_5",  "1_6",  "1_7",  "1_8",  "1_9",  "1_10", "1_11", "2_1",  "2_2",  "2_3",  "2_4",  "2_5",  "2_6",  "2_7", "2_8",  "2_9",  "2_10", "2_11", "3_1",  "3_2",  "3_3",  "3_4",  "3_5",  "3_6",  "3_7",  "3_8",  "3_9",  "3_10", "3_11")
export(green_Module_data, file = "green_Module_data.xlsx", colNames = T, rowNames = T, borders = "columns", firstCol = TRUE, zoom = 120)
# ### PDF
pdf("green_Module_heatmap.pdf", width = 8.5, height = 10)
pheatmap(green_Module_heatmap_data,
         cluster_rows = T,
         cluster_cols = F,
         display_numbers = F,
         number_format = "%.3f",
         show_colnames = T,
         show_rownames = F,
         color=colorRampPalette(c("blue", "white", "red"),bias=1)(500),
         border_color = NA,
         cellwidth = 13,
         cellheight = 0.5,
         scale = "row",
         fontsize_col = 12)
dev.off()
# ### PNG
png("green_Module_heatmap.png", width = 650, height = 850)
pheatmap(green_Module_heatmap_data,
         cluster_rows = T,
         cluster_cols = F,
         display_numbers = F,
         number_format = "%.3f",
         show_colnames = T,
         show_rownames = F,
         color=colorRampPalette(c("blue", "white", "red"),bias=1)(500),
         border_color = NA,
         cellwidth = 13,
         cellheight = 0.4,
         scale = "row",
         fontsize_col = 12)
dev.off()
setwd("../")
getwd()
dir()
# [1] "blue"                         "brown"                       
# [3] "green"                        "Module_Eigenmetabolites.xlsx"
# [5] "red"                          "turquoise"                   
# [7] "yellow"

# ##########################################################################################################################################
# ### 7.3模块与性状关联分析Modules_Traits_Associations_Analysis
setwd("../4.2Modules_Traits_Associations_Analysis/")
if (corType == "pearson") {
  modTraitCor <- cor(MEs_col, traitData, use = "p")
  modTraitP <- corPvalueStudent(modTraitCor, nSamples)
} else {
  modTraitCorP <- bicorAndPvalue(MEs_col, traitData, robustY=robustY) # robustY=robustY
  modTraitCor <- modTraitCorP$bicor
  modTraitP <- modTraitCorP$p
}
#
# ### signif表示保留几位小数
textMatrix <- paste(signif(modTraitCor, 2), "\n(", signif(modTraitP, 1), ")", sep = "")
dim(textMatrix) <- dim(modTraitCor)
sizeGrWindow(10, 5)
par(mfrow = c(1,1))
#
# ### 保存数据为本地文件
export(modTraitCor, file = "Module-Trait_Cor_data.xlsx", colNames = T, rowNames = T, firstRow = TRUE, borders = "columns", colWidths = "auto", zoom = 120)
export(modTraitP, file = "Module-Trait_P-value_data.xlsx", colNames = T, rowNames = T, firstRow = TRUE, borders = "columns", colWidths = "auto", zoom = 120)
#
# ### 绘制性状与模块的相关性与显著性热图
labeledHeatmap(Matrix = modTraitCor,
               xLabels = colnames(traitData),
               yLabels = colnames(MEs_col),
               cex.lab = 1,
               cex.lab.x = 1.2,
               ySymbols = colnames(MEs_col),
               colorLabels = FALSE,
               colors = blueWhiteRed(50),
               textMatrix = textMatrix,
               setStdMargins = TRUE,
               cex.text = 0.7,
               zlim = c(-1,1),
               main = paste("Module-trait relationships heatmap"))
# ### Save as PDF
pdf(file = "Module-Trait_relationship.pdf", width = 8.5, height = 8.5)
labeledHeatmap(Matrix = modTraitCor,
               xLabels = colnames(traitData),
               yLabels = colnames(MEs_col),
               cex.lab = 1,
               cex.lab.x = 1.2,
               ySymbols = colnames(MEs_col),
               colorLabels = FALSE,
               colors = blueWhiteRed(50),
               textMatrix = textMatrix,
               setStdMargins = TRUE,
               cex.text = 0.7,
               zlim = c(-1,1),
               main = paste("Module-trait relationships heatmap"))
dev.off()
#
# ### Save as PNG
png(file = "Module-Trait_relationship.png", width = 850, height = 850)
labeledHeatmap(Matrix = modTraitCor,
               xLabels = colnames(traitData),
               yLabels = colnames(MEs_col),
               cex.lab = 1,
               cex.lab.x = 1.2,
               ySymbols = colnames(MEs_col),
               colorLabels = FALSE,
               colors = blueWhiteRed(50),
               textMatrix = textMatrix,
               setStdMargins = TRUE,
               cex.text = 0.7,
               zlim = c(-1,1),
               main = paste("Module-trait relationships heatmap"))
dev.off()
par(op) # 恢复默认参数
#
# ### 最后把模块代谢物显著性矩阵和模块Membership相关性矩阵联合起来,指定感兴趣模块进行分析

modNames <- substring(colnames(MEs_col), 3)
modNames
# [1] "blue"      "red"       "green"     "yellow"    "turquoise" "brown"    
# [7] "grey"
#
sizeGrWindow(10, 10)
par(mfrow = c(1,1))
# ####################################################################
### 计算模块与蛋白的相关性矩阵
if (corType=="pearson") {
  geneModuleMembership <- as.data.frame(cor(metaboExprData, MEs_col, use = "p"))
  MMPvalue <- as.data.frame(corPvalueStudent(
    as.matrix(geneModuleMembership), nSamples))
} else {
  geneModuleMembershipA <- bicorAndPvalue(metaboExprData, MEs_col, robustY=robustY)
  geneModuleMembership <- geneModuleMembershipA$bicor
  MMPvalue <- geneModuleMembershipA$p
}

geneModuleMembership[1:5,1:5]
MMPvalue[1:5,1:5]

### 计算性状与蛋白的相关性矩阵，只有连续型性状才能进行计算，如果是离散变量，在构建样品表时就转为0-1矩阵。
if (corType=="pearson") {
  geneTraitCor <- as.data.frame(cor(metaboExprData, traitData, use = "p"))
  geneTraitP <- as.data.frame(corPvalueStudent(
    as.matrix(geneTraitCor), nSamples))
} else {
  geneTraitCorA <- bicorAndPvalue(metaboExprData, traitData, robustY=robustY)
  geneTraitCor <- as.data.frame(geneTraitCorA$bicor)
  geneTraitP <- as.data.frame(geneTraitCorA$p)
}
geneTraitCor[1:5,1:5]
geneTraitP[1:5,1:5]

###################################################################### 
dir.create("TraitA")
setwd("TraitA")
### blue module与TraitA
module <- "blue"
pheno <- "TraitA"
# ### 获取关注的列
module_column <- match(module, modNames)
pheno_column <- match(pheno, colnames(traitData))
# ### 获取模块内的基因
moduleGenes <- moduleColors == module
### 与性状高度相关的基因，也是与性状相关的模型的关键基因
verboseScatterplot(abs(geneModuleMembership[moduleGenes, module_column]),
                   abs(geneTraitCor[moduleGenes, pheno_column]),
                   xlab = paste("Module Membership in", module, "module"),
                   ylab = paste("Metabolite significance for", pheno),
                   main = paste("Module membership vs. metabolite significance\n"),
                   cex.main = 1.2, cex.lab = 1.3, cex.axis = 1.2, col = module, abline = TRUE, abline.color = "red", abline.lty = 1, cex = 1, pch = 19)

# ### Save as PDF
pdf(file = "Module_membership(blue)_vs_significance(TraitA).pdf", width = 9.5, height = 9.5)
verboseScatterplot(abs(geneModuleMembership[moduleGenes, module_column]),
                   abs(geneTraitCor[moduleGenes, pheno_column]),
                   xlab = paste("Module Membership in", module, "module"),
                   ylab = paste("Metabolite significance for", pheno),
                   main = paste("Module membership vs. metabolite significance\n"),
                   cex.main = 1.2, cex.lab = 1.3, cex.axis = 1.2, col = module, abline = TRUE, abline.color = "red", abline.lty = 1, cex = 1, pch = 19)
dev.off()

### Save as PNG
png(file = "Module_membership(blue)_vs_significance(TraitA).png", width = 1000, height = 1000)
verboseScatterplot(abs(geneModuleMembership[moduleGenes, module_column]),
                   abs(geneTraitCor[moduleGenes, pheno_column]),
                   xlab = paste("Module Membership in", module, "module"),
                   ylab = paste("Metabolite significance for", pheno),
                   main = paste("Module membership vs. metabolite significance\n"),
                   cex.main = 1.2, cex.lab = 1.3, cex.axis = 1.2, col = module, abline = TRUE, abline.color = "red", abline.lty = 1, cex = 1, pch = 19)
dev.off()
# #####################################################################
### brown module与TraitA
module <- "brown"
pheno <- "TraitA"
# ### 获取关注的列
module_column <- match(module, modNames)
pheno_column <- match(pheno, colnames(traitData))
# ### 获取模块内的基因
moduleGenes <- moduleColors == module

# ### 与性状高度相关的基因，也是与性状相关的模型的关键基因
verboseScatterplot(abs(geneModuleMembership[moduleGenes, module_column]),
                   abs(geneTraitCor[moduleGenes, pheno_column]),
                   xlab = paste("Module Membership in", module, "module"),
                   ylab = paste("Metabolite significance for", pheno),
                   main = paste("Module membership vs. metabolite significance\n"),
                   cex.main = 1.2, cex.lab = 1.3, cex.axis = 1.2, col = module, abline = TRUE, abline.color = "red", abline.lty = 1, cex = 1, pch = 19)
# ### Save as PDF
pdf(file = "Module_membership(brown)_vs_significance(TraitA).pdf", width = 9.5, height = 9.5)
verboseScatterplot(abs(geneModuleMembership[moduleGenes, module_column]),
                   abs(geneTraitCor[moduleGenes, pheno_column]),
                   xlab = paste("Module Membership in", module, "module"),
                   ylab = paste("Metabolite significance for", pheno),
                   main = paste("Module membership vs. metabolite significance\n"),
                   cex.main = 1.2, cex.lab = 1.3, cex.axis = 1.2, col = module, abline = TRUE, abline.color = "red", abline.lty = 1, cex = 1, pch = 19)
dev.off()
### Save as PNG
png(file = "Module_membership(brown)_vs_significance(TraitA).png", width = 1000, height = 1000)
verboseScatterplot(abs(geneModuleMembership[moduleGenes, module_column]),
                   abs(geneTraitCor[moduleGenes, pheno_column]),
                   xlab = paste("Module Membership in", module, "module"),
                   ylab = paste("Metabolite significance for", pheno),
                   main = paste("Module membership vs. metabolite significance\n"),
                   cex.main = 1.2, cex.lab = 1.3, cex.axis = 1.2, col = module, abline = TRUE, abline.color = "red", abline.lty = 1, cex = 1, pch = 19)
dev.off()
# ####################################################################
### green module and TraitA
module <- "green"
pheno <- "TraitA"
### 获取关注的列
module_column <- match(module, modNames)
pheno_column <- match(pheno, colnames(traitData))
### 获取模块内的基因
moduleGenes <- moduleColors == module
### 与性状高度相关的基因，也是与性状相关的模型的关键基因
verboseScatterplot(abs(geneModuleMembership[moduleGenes, module_column]),
                   abs(geneTraitCor[moduleGenes, pheno_column]),
                   xlab = paste("Module Membership in", module, "module"),
                   ylab = paste("Metabolite significance for", pheno),
                   main = paste("Module membership vs. metabolite significance\n"),
                   cex.main = 1.2, cex.lab = 1.3, cex.axis = 1.2, col = module, abline = TRUE, abline.color = "red", abline.lty = 1, cex = 1, pch = 19)

### Save as PDF
pdf(file = "Module_membership(green)_vs_significance(TraitA).pdf", width = 9.5, height = 9.5)
verboseScatterplot(abs(geneModuleMembership[moduleGenes, module_column]),
                   abs(geneTraitCor[moduleGenes, pheno_column]),
                   xlab = paste("Module Membership in", module, "module"),
                   ylab = paste("Metabolite significance for", pheno),
                   main = paste("Module membership vs. metabolite significance\n"),
                   cex.main = 1.2, cex.lab = 1.3, cex.axis = 1.2, col = module, abline = TRUE, abline.color = "red", abline.lty = 1, cex = 1, pch = 19)
dev.off()
### Save as PNG
png(file = "Module_membership(green)_vs_significance(TraitA).png", width = 1000, height = 1000)
verboseScatterplot(abs(geneModuleMembership[moduleGenes, module_column]),
                   abs(geneTraitCor[moduleGenes, pheno_column]),
                   xlab = paste("Module Membership in", module, "module"),
                   ylab = paste("Metabolite significance for", pheno),
                   main = paste("Module membership vs. metabolite significance\n"),
                   cex.main = 1.2, cex.lab = 1.3, cex.axis = 1.2, col = module, abline = TRUE, abline.color = "red", abline.lty = 1, cex = 1, pch = 19)
dev.off()
# ####################################################################
### yellow module and TraitA
module <- "yellow"
pheno <- "TraitA"
### 获取关注的列
module_column <- match(module, modNames)
pheno_column <- match(pheno, colnames(traitData))
### 获取模块内的基因
moduleGenes <- moduleColors == module

### 与性状高度相关的基因，也是与性状相关的模型的关键基因
verboseScatterplot(abs(geneModuleMembership[moduleGenes, module_column]),
                   abs(geneTraitCor[moduleGenes, pheno_column]),
                   xlab = paste("Module Membership in", module, "module"),
                   ylab = paste("Metabolite significance for", pheno),
                   main = paste("Module membership vs. metabolite significance\n"),
                   cex.main = 1.2, cex.lab = 1.3, cex.axis = 1.2, col = module, abline = TRUE, abline.color = "red", abline.lty = 1, cex = 1, pch = 19)

### Save as PDF
pdf(file = "Module_membership(yellow)_vs_significance(TraitA).pdf", width = 9.5, height = 9.5)
verboseScatterplot(abs(geneModuleMembership[moduleGenes, module_column]),
                   abs(geneTraitCor[moduleGenes, pheno_column]),
                   xlab = paste("Module Membership in", module, "module"),
                   ylab = paste("Metabolite significance for", pheno),
                   main = paste("Module membership vs. metabolite significance\n"),
                   cex.main = 1.2, cex.lab = 1.3, cex.axis = 1.2, col = module, abline = TRUE, abline.color = "red", abline.lty = 1, cex = 1, pch = 19)
dev.off()
### Save as PNG
png(file = "Module_membership(yellow)_vs_significance(TraitA).png", width = 1000, height = 1000)
verboseScatterplot(abs(geneModuleMembership[moduleGenes, module_column]),
                   abs(geneTraitCor[moduleGenes, pheno_column]),
                   xlab = paste("Module Membership in", module, "module"),
                   ylab = paste("Metabolite significance for", pheno),
                   main = paste("Module membership vs. metabolite significance\n"),
                   cex.main = 1.2, cex.lab = 1.3, cex.axis = 1.2, col = module, abline = TRUE, abline.color = "red", abline.lty = 1, cex = 1, pch = 19)
dev.off()
dir()
# [1] "Module_membership(blue)_vs_significance(TraitA).pdf"  
# [2] "Module_membership(blue)_vs_significance(TraitA).png"  
# [3] "Module_membership(brown)_vs_significance(TraitA).pdf" 
# [4] "Module_membership(brown)_vs_significance(TraitA).png" 
# [5] "Module_membership(green)_vs_significance(TraitA).pdf" 
# [6] "Module_membership(green)_vs_significance(TraitA).png" 
# [7] "Module_membership(yellow)_vs_significance(TraitA).pdf"
# [8] "Module_membership(yellow)_vs_significance(TraitA).png"
#
# #######################################################################
# ## 8.模块Hub关键代谢物的共表达网络和TOM矩阵的可视化Hub_Proteins_Co-Expression_Network_and_TOM_Visualization
# ####################################################################
setwd("../../../5.Hub_Network_&_TOM_Visualization/5.1Modules_Hub_Network/")

### blue module ###
dim(blue_Module_data)
# [1] 1465   35
blue_Module_datExpr <- t(blue_Module_data)

blue_Module_intramodularConnet <- intramodularConnectivity.fromExpr(blue_Module_datExpr, 
                                                                    colors = blue_Module_data$nodeAttr, 
                                                                    corFnc = "cor", corOptions = "use = 'p'",
# weights = NULL,
                                                                    distFnc = "dist", distOptions = "method = 'euclidean'",
                                                                    networkType = "unsigned", power = 6,
                                                                    scaleByMax = FALSE,
                                                                    ignoreColors = if (is.numeric(colors)) 0 else "grey",
                                                                    getWholeNetworkConnectivity = TRUE)
#
dim(blue_Module_intramodularConnet)
# [1] 1465   4
#
names(blue_Module_intramodularConnet)
# # [1] "kTotal"  "kWithin" "kOut"    "kDiff"
#
### 根据模块内连接度由高往低进行排序，取top50代谢物作为Hub Protein进行Hub代谢物进行网络图可视化
IntramConnet_blue <- blue_Module_intramodularConnet$kTotal
blue_Module_Hub_metabolite <- data.frame(blue_Module_data, IntramConnet_blue)
dim(blue_Module_Hub_metabolite)
# [1] 1465  36
names(blue_Module_Hub_metabolite)
#
colnames(blue_Module_Hub_metabolite)[1] <- "Metabolite_Name"
colnames(blue_Module_Hub_metabolite)[2] <- "Module_Color"
colnames(blue_Module_Hub_metabolite)
#
class(blue_Module_Hub_metabolite)
# # [1] "data.frame"
dim(blue_Module_Hub_metabolite)
# [1] 1465   36
#
blue_Module_Hub_metabolite$IntramConnet_blue <- as.numeric(blue_Module_Hub_metabolite$IntramConnet_blue)
class(blue_Module_Hub_metabolite$IntramConnet_blue)
#
blue_Module_Hub_metabolite <- blue_Module_Hub_metabolite[order(-blue_Module_Hub_metabolite$IntramConnet_blue),] # 由高到低排序
#
blue_Module_Hub_metabolite_top50 <- blue_Module_Hub_metabolite[1:51,]
#
# ### 导出全部的模块代谢物连接度数据
export(blue_Module_Hub_metabolite, file = "blue_Module_Hub_metabolite.xlsx", colNames = T, rowNames = F, firstRow = T, borders = "columns", zoom = 120)
#
# ### 导出top50的代谢物连接数据
export(blue_Module_Hub_metabolite_top50, file = "blue_Module_Hub_metabolite_top50.xlsx", colNames = T, rowNames = F, firstRow = T, borders = "columns",  zoom = 120)
#
#
### yellow module ###
yellow_Module_datExpr <- t(yellow_Module_data)
yellow_Module_intramodularConnet <- intramodularConnectivity.fromExpr(yellow_Module_datExpr, colors = yellow_Module_data$nodeAttr,
                                                                      corFnc = "cor", corOptions = "use = 'p'",
                                                                      # weights = NULL,
                                                                      distFnc = "dist", distOptions = "method = 'euclidean'",
                                                                      networkType = "unsigned", power = 6,
                                                                      scaleByMax = FALSE,
                                                                      ignoreColors = if (is.numeric(colors)) 0 else "grey",
                                                                      getWholeNetworkConnectivity = TRUE)
#
#
# ### 根据模块内连接度由高往低进行排序，取top50代谢物作为Hub Protein进行Hub代谢物进行网络图可视化
IntramConnet_yellow <- yellow_Module_intramodularConnet$kTotal
yellow_Module_Hub_metabolite <- data.frame(yellow_Module_data, IntramConnet_yellow)
#
colnames(yellow_Module_Hub_metabolite)[1] <- "Metabolite_Name"
colnames(yellow_Module_Hub_metabolite)[2] <- "Module_Color"
#
#
yellow_Module_Hub_metabolite$IntramConnet_yellow <- as.numeric(yellow_Module_Hub_metabolite$IntramConnet_yellow)
#
yellow_Module_Hub_metabolite <- yellow_Module_Hub_metabolite[order(-yellow_Module_Hub_metabolite$IntramConnet_yellow),] # 由高到低排序
#
yellow_Module_Hub_metabolite_top50 <- yellow_Module_Hub_metabolite[1:51,]
#
# ### 导出全部的模块代谢物连接度数据
export(yellow_Module_Hub_metabolite, file = "yellow_Module_Hub_metabolite.xlsx", colNames = T, rowNames = F, firstRow = T, borders = "columns", zoom = 120)
#
# ### 导出top50的代谢物连接数据
export(yellow_Module_Hub_metabolite_top50, file = "yellow_Module_Hub_metabolite_top50.xlsx", colNames = T, rowNames = F, firstRow = T, borders = "columns", zoom = 120)
#
### turquoise module ###
turquoise_Module_datExpr <- t(turquoise_Module_data)
#
turquoise_Module_intramodularConnet <- intramodularConnectivity.fromExpr(turquoise_Module_datExpr, colors = turquoise_Module_data$nodeAttr,
                                                                         corFnc = "cor", corOptions = "use = 'p'",
                                                                         # weights = NULL,
                                                                         distFnc = "dist", distOptions = "method = 'euclidean'",
                                                                         networkType = "unsigned", power = 6,
                                                                         scaleByMax = FALSE,
                                                                         ignoreColors = if (is.numeric(colors)) 0 else "grey",
                                                                         getWholeNetworkConnectivity = TRUE)
#

# ### 根据模块内连接度由高往低进行排序，取top50代谢物作为Hub Protein进行Hub代谢物进行网络图可视化
IntramConnet_turquoise <- turquoise_Module_intramodularConnet$kTotal
turquoise_Module_Hub_metabolite <- data.frame(turquoise_Module_data, IntramConnet_turquoise)
#
colnames(turquoise_Module_Hub_metabolite)[1] <- "Metabolite_Name"
colnames(turquoise_Module_Hub_metabolite)[2] <- "Module_Color"
#
#
turquoise_Module_Hub_metabolite$IntramConnet_turquoise <- as.numeric(turquoise_Module_Hub_metabolite$IntramConnet_turquoise)
#
turquoise_Module_Hub_metabolite <- turquoise_Module_Hub_metabolite[order(-turquoise_Module_Hub_metabolite$IntramConnet_turquoise),] # 由高到低排序
#
turquoise_Module_Hub_metabolite_top50 <- turquoise_Module_Hub_metabolite[1:51,]
#
# ### 导出全部的模块代谢物连接度数据
export(turquoise_Module_Hub_metabolite, file = "turquoise_Module_Hub_metabolite.xlsx", colNames = T, rowNames = F, firstRow = T, borders = "columns", zoom = 120)
#
# ### 导出top50的代谢物连接数据
export(turquoise_Module_Hub_metabolite_top50, file = "turquoise_Module_Hub_metabolite_top50.xlsx", colNames = T, rowNames = F, firstRow = T, borders = "columns", zoom = 120)
#
# ### brown module ###
# dim(brown_Module_PSE_data)
# # [1] 602  28
brown_Module_datExpr <- t(brown_Module_data)
# dim(brown_Module_datExpr)
#
brown_Module_intramodularConnet <- intramodularConnectivity.fromExpr(brown_Module_datExpr, colors = brown_Module_data$nodeAttr,
                                                                     corFnc = "cor", corOptions = "use = 'p'",
                                                                     # weights = NULL,
                                                                     distFnc = "dist", distOptions = "method = 'euclidean'",
                                                                     networkType = "unsigned", power = 6,
                                                                     scaleByMax = FALSE,
                                                                     ignoreColors = if (is.numeric(colors)) 0 else "grey",
                                                                     getWholeNetworkConnectivity = TRUE)
#
# dim(brown_Module_intramodularConnet)
# # [1] 602   4
#
# names(brown_Module_intramodularConnet)
# # [1] "kTotal"  "kWithin" "kOut"    "kDiff"
#
# ### 根据模块内连接度由高往低进行排序，取top50代谢物作为Hub Protein进行Hub代谢物进行网络图可视化
IntramConnet_brown <- brown_Module_intramodularConnet$kTotal
brown_Module_Hub_metabolite <- data.frame(brown_Module_data, IntramConnet_brown)
# dim(brown_Module_Hub_protein)
# names(brown_Module_Hub_protein)
#
colnames(brown_Module_Hub_metabolite)[1] <- "Metabolite_Name"
colnames(brown_Module_Hub_metabolite)[2] <- "Module_Color"
# colnames(brown_Module_Hub_protein)
#
# class(brown_Module_Hub_protein)
# # [1] "data.frame"
# dim(brown_Module_Hub_protein)
#
brown_Module_Hub_metabolite$IntramConnet_brown <- as.numeric(brown_Module_Hub_metabolite$IntramConnet_brown)
# class(brown_Module_Hub_protein$IntramConnet_brown)
#
brown_Module_Hub_metabolite <- brown_Module_Hub_metabolite[order(-brown_Module_Hub_metabolite$IntramConnet_brown),] # 由高到低排序
# class(brown_Module_Hub_protein)
# # [1] "data.frame"
#
brown_Module_Hub_metabolite_top50 <- brown_Module_Hub_metabolite[1:51,]
#
# ### 导出全部的模块代谢物连接度数据
export(brown_Module_Hub_metabolite, file = "brown_Module_Hub_metabolite.xlsx", colNames = T, rowNames = F, firstRow = T, borders = "columns", zoom = 120)
#
# ### 导出top50的代谢物连接数据
export(brown_Module_Hub_metabolite_top50, file = "brown_Module_Hub_metabolite_top50.xlsx", colNames = T, rowNames = F, firstRow = T, borders = "columns", zoom = 120)
#
#
### red module ###
red_Module_datExpr <- t(red_Module_data)
red_Module_intramodularConnet <- intramodularConnectivity.fromExpr(red_Module_datExpr, colors = red_Module_data$nodeAttr,
                                                                      corFnc = "cor", corOptions = "use = 'p'",
                                                                      # weights = NULL,
                                                                      distFnc = "dist", distOptions = "method = 'euclidean'",
                                                                      networkType = "unsigned", power = 6,
                                                                      scaleByMax = FALSE,
                                                                      ignoreColors = if (is.numeric(colors)) 0 else "grey",
                                                                      getWholeNetworkConnectivity = TRUE)
#
#
# ### 根据模块内连接度由高往低进行排序，取top50代谢物作为Hub Protein进行Hub代谢物进行网络图可视化
IntramConnet_red <- red_Module_intramodularConnet$kTotal
red_Module_Hub_metabolite <- data.frame(red_Module_data, IntramConnet_red)
#
colnames(red_Module_Hub_metabolite)[1] <- "Metabolite_Name"
colnames(red_Module_Hub_metabolite)[2] <- "Module_Color"
#
#
red_Module_Hub_metabolite$IntramConnet_red <- as.numeric(red_Module_Hub_metabolite$IntramConnet_red)
#
red_Module_Hub_metabolite <- red_Module_Hub_metabolite[order(-red_Module_Hub_metabolite$IntramConnet_red),] # 由高到低排序
#
red_Module_Hub_metabolite_top50 <- red_Module_Hub_metabolite[1:51,]
#
# ### 导出全部的模块代谢物连接度数据
export(red_Module_Hub_metabolite, file = "red_Module_Hub_metabolite.xlsx", colNames = T, rowNames = F, firstRow = T, borders = "columns", zoom = 120)
#
# ### 导出top50的代谢物连接数据
export(red_Module_Hub_metabolite_top50, file = "red_Module_Hub_metabolite_top50.xlsx", colNames = T, rowNames = F, firstRow = T, borders = "columns", zoom = 120)

### green module ###
green_Module_datExpr <- t(green_Module_data)
green_Module_intramodularConnet <- intramodularConnectivity.fromExpr(green_Module_datExpr, colors = green_Module_data$nodeAttr,
                                                                   corFnc = "cor", corOptions = "use = 'p'",
                                                                   # weights = NULL,
                                                                   distFnc = "dist", distOptions = "method = 'euclidean'",
                                                                   networkType = "unsigned", power = 6,
                                                                   scaleByMax = FALSE,
                                                                   ignoreColors = if (is.numeric(colors)) 0 else "grey",
                                                                   getWholeNetworkConnectivity = TRUE)
#
#
# ### 根据模块内连接度由高往低进行排序，取top50代谢物作为Hub Protein进行Hub代谢物进行网络图可视化
IntramConnet_green <- green_Module_intramodularConnet$kTotal
green_Module_Hub_metabolite <- data.frame(green_Module_data, IntramConnet_green)
#
colnames(green_Module_Hub_metabolite)[1] <- "Metabolite_Name"
colnames(green_Module_Hub_metabolite)[2] <- "Module_Color"
#
#
green_Module_Hub_metabolite$IntramConnet_green <- as.numeric(green_Module_Hub_metabolite$IntramConnet_green)
#
green_Module_Hub_metabolite <- green_Module_Hub_metabolite[order(-green_Module_Hub_metabolite$IntramConnet_green),] # 由高到低排序
#
green_Module_Hub_metabolite_top50 <- green_Module_Hub_metabolite[1:51,]
#
# ### 导出全部的模块代谢物连接度数据
export(green_Module_Hub_metabolite, file = "green_Module_Hub_metabolite.xlsx", colNames = T, rowNames = F, firstRow = T, borders = "columns", zoom = 120)
#
# ### 导出top50的代谢物连接数据
export(green_Module_Hub_metabolite_top50, file = "green_Module_Hub_metabolite_top50.xlsx", colNames = T, rowNames = F, firstRow = T, borders = "columns", zoom = 120)

# #######################################################################
# ## 8.1 模块关键代谢物网络图可视化：Modules_Hub-P_Network_Visualization
# ######################################################################
### blue module ###
blueModule_cyt_df <- blueModule_cyt$edgeData
class(blueModule_cyt_df)
names(blueModule_cyt_df)
# # [1] "fromNode"    "toNode"      "weight"      "direction"   "fromAltName"
# # [6] "toAltName"
dim(blueModule_cyt_df)
# [1] 1072380      6
blueModule_cyt_df[,4:6] <- NULL
dim(blueModule_cyt_df)
# [1] 1072380      3
head(blueModule_cyt_df)
# fromNode
# 1 Methyl 2-(10-heptadecenyl)-6-hydroxybenzoate
# 2 Methyl 2-(10-heptadecenyl)-6-hydroxybenzoate
# 3 Methyl 2-(10-heptadecenyl)-6-hydroxybenzoate
# 4 Methyl 2-(10-heptadecenyl)-6-hydroxybenzoate
# 5 Methyl 2-(10-heptadecenyl)-6-hydroxybenzoate
# 6 Methyl 2-(10-heptadecenyl)-6-hydroxybenzoate
# toNode      weight
# 1             3-Oxohexadecanoic acid 0.001054379
# 2             3-Oxooctadecanoic acid 0.001539126
# 3                 13,14-Dihydro PGE1 0.128474207
# 4                           Momordol 0.052753974
# 5                       17,18-DiHETE 0.057378487
# 6 9-hydroxy-16-oxo-hexadecanoic acid 0.002534045
colnames(blue_Module_Hub_metabolite_top50)
blue_Module_Hub_metabolite_top50_ID <- blue_Module_Hub_metabolite_top50[,1:2]
dim(blue_Module_Hub_metabolite_top50_ID)
head(blue_Module_Hub_metabolite_top50_ID)
# Metabolite_Name Module_Color
# 391                           5-Hydroxykynurenamine         blue
# 832                 Glycerol 1-propanoate diacetate         blue
# 1456                                     Xanthosine         blue
# 14   (1S,2R,4R)-p-Menth-8-ene-2,10-diol 2-glucoside         blue
# 1413                                  Triticonazole         blue
# 1288                                      Radicicol         blue
blue_Hub_Network <- merge.data.frame(blue_Module_Hub_metabolite_top50_ID, blueModule_cyt_df, by.x = "Metabolite_Name", by.y = "fromNode", all.y = TRUE)
#
dim(blue_Hub_Network)
head(blue_Hub_Network)
tail(blue_Hub_Network)
#
blue_Hub_Network_new <- blue_Hub_Network[complete.cases(blue_Hub_Network),]
blue_Hub_Network_new <- blue_Hub_Network_new[order(-blue_Hub_Network_new$weight),]
blue_Hub_Network_plot <- blue_Hub_Network_new %>% dplyr::select(Metabolite_Name, toNode, weight, Module_Color) # 数据框列的位置的重新排列
names(blue_Hub_Network_plot)
# [1] "Metabolite_Name"   "toNode"       "weight"       "Module_Color"
blue_Hub_Network_plot <- blue_Hub_Network_plot[1:50,] # 取前50个蛋白
blue_Hub_Net_plot_ig <- graph_from_data_frame(blue_Hub_Network_plot, directed = F) # 参数directed为真，则有箭头，为假则无箭头方向
#@ layout = layout_with_kk

#### PDF
pdf(file = "blue_Hub_Network.pdf", width = 8.5, height = 8.5)
plot(blue_Hub_Net_plot_ig, layout = layout_with_kk, vertex.color = "blue", vertex.size = 10, vertex.label.cex = 0.9, vertex.label.dist = 1.5, vertex.label.color = "black")
dev.off()
#### PNG
png(file = "blue_Hub_Network.png", width = 850, height = 850)
plot(blue_Hub_Net_plot_ig, layout = layout_with_kk, vertex.color = "blue", vertex.size = 10, vertex.label.cex = 0.9, vertex.label.dist = 1.5, vertex.label.color = "black")
dev.off()
#
### yellow module ###
yellowModule_cyt_df <- yellowModule_cyt$edgeData
names(yellowModule_cyt_df)
# [1] "fromNode"    "toNode"      "weight"      "direction"   "fromAltName"
# [6] "toAltName"
yellowModule_cyt_df[,4:6] <- NULL
colnames(yellow_Module_Hub_metabolite_top50)
yellow_Module_Hub_metabolite_top50_ID <- yellow_Module_Hub_metabolite_top50[,1:2]
yellow_Hub_Network <- merge.data.frame(yellow_Module_Hub_metabolite_top50_ID, yellowModule_cyt_df, by.x = "Metabolite_Name", by.y = "fromNode", all.y = TRUE)
yellow_Hub_Network_new <- yellow_Hub_Network[complete.cases(yellow_Hub_Network),]
yellow_Hub_Network_new <- yellow_Hub_Network_new[order(-yellow_Hub_Network_new$weight),]
yellow_Hub_Network_plot <- yellow_Hub_Network_new %>% dplyr::select(Metabolite_Name, toNode, weight, Module_Color) # 数据框列的位置的重新排列
names(yellow_Hub_Network_plot)
# [1] "Metabolite_Name"   "toNode"       "weight"       "Module_Color"

yellow_Hub_Network_plot <- yellow_Hub_Network_plot[1:50,] # 取前50个蛋白

yellow_Hub_Net_plot_ig <- graph_from_data_frame(yellow_Hub_Network_plot, directed = F) # 参数directed为真，则有箭头，为假则无箭头方向
#@ layout = layout_with_kk
#### PDF
pdf(file = "yellow_Hub_Network.pdf", width = 8.5, height = 8.5)
plot(yellow_Hub_Net_plot_ig, layout = layout_with_kk, vertex.color = "yellow", vertex.size = 10, vertex.label.cex = 0.9, vertex.label.dist = 1.5, vertex.label.color = "black")
dev.off()
#### PNG
png(file = "yellow_Hub_Network.png", width = 850, height = 850)
plot(yellow_Hub_Net_plot_ig, layout = layout_with_kk, vertex.color = "yellow", vertex.size = 10, vertex.label.cex = 0.9, vertex.label.dist = 1.5, vertex.label.color = "black")
dev.off()

### turquoise module ###
turquoiseModule_cyt_df <- turquoiseModule_cyt$edgeData
names(turquoiseModule_cyt_df)
# [1] "fromNode"    "toNode"      "weight"      "direction"   "fromAltName"
# [6] "toAltName"
turquoiseModule_cyt_df[,4:6] <- NULL
turquoise_Module_Hub_metabolite_top50_ID <- turquoise_Module_Hub_metabolite_top50[,1:2]
turquoise_Hub_Network <- merge.data.frame(turquoise_Module_Hub_metabolite_top50_ID, turquoiseModule_cyt_df, by.x = "Metabolite_Name", by.y = "fromNode", all.y = TRUE)
turquoise_Hub_Network_new <- turquoise_Hub_Network[complete.cases(turquoise_Hub_Network),]
turquoise_Hub_Network_new <- turquoise_Hub_Network_new[order(-turquoise_Hub_Network_new$weight),]
turquoise_Hub_Network_plot <- turquoise_Hub_Network_new %>% dplyr::select(Metabolite_Name, toNode, weight, Module_Color) # 数据框列的位置的重新排列
names(turquoise_Hub_Network_plot)
# [1] "Protein_ID"   "toNode"       "weight"       "Module_Color"
turquoise_Hub_Network_plot <- turquoise_Hub_Network_plot[1:50,] # 取前50个蛋白
turquoise_Hub_Net_plot_ig <- graph_from_data_frame(turquoise_Hub_Network_plot, directed = F) # 参数directed为真，则有箭头，为假则无箭头方向
#@ layout = layout_with_kk
#
#### PDF
pdf(file = "turquoise_Hub_Network.pdf", width = 8.5, height = 8.5)
plot(turquoise_Hub_Net_plot_ig, layout = layout_with_kk, vertex.color = "turquoise",vertex.size = 10, vertex.label.cex = 0.9, vertex.label.dist = 1.5, vertex.label.color = "black")
dev.off()
#### PNG
png(file = "turquoise_Hub_Network.png", width = 850, height = 850)
plot(turquoise_Hub_Net_plot_ig, layout = layout_with_kk, vertex.color = "turquoise",vertex.size = 10, vertex.label.cex = 0.9, vertex.label.dist = 1.5, vertex.label.color = "black")
dev.off()

### brown module ###
brownModule_cyt_df <- brownModule_cyt$edgeData
names(brownModule_cyt_df)
# [1] "fromNode"    "toNode"      "weight"      "direction"   "fromAltName"
# [6] "toAltName"
brownModule_cyt_df[,4:6] <- NULL
brown_Module_Hub_metabolite_top50_ID <- brown_Module_Hub_metabolite_top50[,1:2]
brown_Hub_Network <- merge.data.frame(brown_Module_Hub_metabolite_top50_ID, brownModule_cyt_df, by.x = "Metabolite_Name", by.y = "fromNode", all.y = TRUE)
brown_Hub_Network_new <- brown_Hub_Network[complete.cases(brown_Hub_Network),]
brown_Hub_Network_new <- brown_Hub_Network_new[order(-brown_Hub_Network_new$weight),]
brown_Hub_Network_plot <- brown_Hub_Network_new %>% dplyr::select(Metabolite_Name, toNode, weight, Module_Color) # 数据框列的位置的重新排列
names(brown_Hub_Network_plot)
# [1] "Metabolite_Name"   "toNode"       "weight"       "Module_Color"
brown_Hub_Network_plot <- brown_Hub_Network_plot[1:50,] # 取前50个蛋白
brown_Hub_Net_plot_ig <- graph_from_data_frame(brown_Hub_Network_plot, directed = F) # 参数directed为真，则有箭头，为假则无箭头方向
#@ layout = layout_with_kk
#
#### PDF
pdf(file = "brown_Hub_Network.pdf", width = 8.5, height = 8.5)
plot(brown_Hub_Net_plot_ig, layout = layout_with_kk, vertex.color = "brown",vertex.size = 10, vertex.label.cex = 0.9, vertex.label.dist = 1.5, vertex.label.color = "black")
dev.off()
#### PNG
png(file = "brown_Hub_Network.png", width = 850, height = 850)
plot(brown_Hub_Net_plot_ig, layout = layout_with_kk, vertex.color = "brown",vertex.size = 10, vertex.label.cex = 0.9, vertex.label.dist = 1.5, vertex.label.color = "black")
dev.off()


### red module ###
redModule_cyt_df <- redModule_cyt$edgeData
redModule_cyt_df[,4:6] <- NULL
red_Module_Hub_metabolite_top50_ID <- red_Module_Hub_metabolite_top50[,1:2]
red_Hub_Network <- merge.data.frame(red_Module_Hub_metabolite_top50_ID, redModule_cyt_df, by.x = "Metabolite_Name", by.y = "fromNode", all.y = TRUE)
red_Hub_Network_new <- red_Hub_Network[complete.cases(red_Hub_Network),]
red_Hub_Network_new <- red_Hub_Network_new[order(-red_Hub_Network_new$weight),]
red_Hub_Network_plot <- red_Hub_Network_new %>% dplyr::select(Metabolite_Name, toNode, weight, Module_Color) # 数据框列的位置的重新排列
red_Hub_Network_plot <- red_Hub_Network_plot[1:50,] # 取前50个蛋白
red_Hub_Net_plot_ig <- graph_from_data_frame(red_Hub_Network_plot, directed = F) # 参数directed为真，则有箭头，为假则无箭头方向
#@ layout = layout_with_kk
#
#### PDF
pdf(file = "red_Hub_Network.pdf", width = 8.5, height = 8.5)
plot(red_Hub_Net_plot_ig, layout = layout_with_kk, vertex.color = "red",vertex.size = 10, vertex.label.cex = 0.9, vertex.label.dist = 1.5, vertex.label.color = "black")
dev.off()
#### PNG
png(file = "red_Hub_Network.png", width = 850, height = 850)
plot(red_Hub_Net_plot_ig, layout = layout_with_kk, vertex.color = "red",vertex.size = 10, vertex.label.cex = 0.9, vertex.label.dist = 1.5, vertex.label.color = "black")
dev.off()

### green module ###
greenModule_cyt_df <- greenModule_cyt$edgeData
greenModule_cyt_df[,4:6] <- NULL
green_Module_Hub_metabolite_top50_ID <- green_Module_Hub_metabolite_top50[,1:2]
green_Hub_Network <- merge.data.frame(green_Module_Hub_metabolite_top50_ID, greenModule_cyt_df, by.x = "Metabolite_Name", by.y = "fromNode", all.y = TRUE)
green_Hub_Network_new <- green_Hub_Network[complete.cases(green_Hub_Network),]
green_Hub_Network_new <- green_Hub_Network_new[order(-green_Hub_Network_new$weight),]
green_Hub_Network_plot <- green_Hub_Network_new %>% dplyr::select(Metabolite_Name, toNode, weight, Module_Color) # 数据框列的位置的重新排列
green_Hub_Network_plot <- green_Hub_Network_plot[1:50,] # 取前50个蛋白
green_Hub_Net_plot_ig <- graph_from_data_frame(green_Hub_Network_plot, directed = F) # 参数directed为真，则有箭头，为假则无箭头方向
#@ layout = layout_with_kk
#
#### PDF
pdf(file = "green_Hub_Network.pdf", width = 8.5, height = 8.5)
plot(green_Hub_Net_plot_ig, layout = layout_with_kk, vertex.color = "green",vertex.size = 10, vertex.label.cex = 0.9, vertex.label.dist = 1.5, vertex.label.color = "black")
dev.off()
#### PNG
png(file = "green_Hub_Network.png", width = 850, height = 850)
plot(green_Hub_Net_plot_ig, layout = layout_with_kk, vertex.color = "green",vertex.size = 10, vertex.label.cex = 0.9, vertex.label.dist = 1.5, vertex.label.color = "black")
dev.off()
getwd()
# [1] "D:/工作空间/鹿明生物蛋白质组学信息分析/研发/2020年研发工作目录/2020年1月/鹿明代谢分析组WGCNA分析流程及报告/WGCNA_M/5.Hub_Network_&_TOM_Visualization/5.1Modules_Hub_Network"
dir()
# [1] "blue_Hub_Network.pdf"                      
# [2] "blue_Hub_Network.png"                      
# [3] "blue_Module_Hub_metabolite.xlsx"           
# [4] "blue_Module_Hub_metabolite_top50.xlsx"     
# [5] "brown_Hub_Network.pdf"                     
# [6] "brown_Hub_Network.png"                     
# [7] "brown_Module_Hub_metabolite.xlsx"          
# [8] "brown_Module_Hub_metabolite_top50.xlsx"    
# [9] "green_Hub_Network.pdf"                     
# [10] "green_Hub_Network.png"                     
# [11] "green_Module_Hub_metabolite.xlsx"          
# [12] "green_Module_Hub_metabolite_top50.xlsx"    
# [13] "red_Hub_Network.pdf"                       
# [14] "red_Hub_Network.png"                       
# [15] "red_Module_Hub_metabolite.xlsx"            
# [16] "red_Module_Hub_metabolite_top50.xlsx"      
# [17] "turquoise_Hub_Network.pdf"                 
# [18] "turquoise_Hub_Network.png"                 
# [19] "turquoise_Module_Hub_metabolite.xlsx"      
# [20] "turquoise_Module_Hub_metabolite_top50.xlsx"
# [21] "yellow_Hub_Network.pdf"                    
# [22] "yellow_Hub_Network.png"                    
# [23] "yellow_Module_Hub_metabolite.xlsx"         
# [24] "yellow_Module_Hub_metabolite_top50.xlsx"


# ####################################################################
######################################################################
#
# ## 8.2 TOM矩阵可视化：TOM_Visualization
# ##########################################################################################################################################
#
setwd("../5.2TOM_Visualization/")
### 所有代谢物TOM矩阵热图 ###
TOM <- TOMsimilarityFromExpr(metaboExprData,
                             power=power,
                             corType=corType,
                             networkType=type)
# load(net$TOMFiles[1], verbose = T) # 导入计算好的TOM
TOM <- as.matrix(TOM) # 数据类型转换
dissTOM <- 1-TOM
dim(dissTOM)
plotTOM <- dissTOM^7
diag(plotTOM) <- NA
dim(plotTOM)
#
## 可视化dissTOM
png(file = "Network_Heatmap_All.png", width = 1200, height = 1200)
TOMplot(dissTOM, # a matrix containing the topological overlap-based dissimilarity
net$dendrograms, # the corresponding hierarchical clustering dendrogram
moduleColors, # optional specification of module colors to be plotted on top
main = "Network heatmap (All)")
dev.off()
# ######################################################################
### 然后随机选取部分代谢物作图：400 ###
nSelect <- 400
# # # For reproducibility, we set the random seed
set.seed(100) # 设定随机种子
select <- sample(nMetabolins, size = nSelect)
selectTOM <- dissTOM[select, select]
dim(selectTOM)
# [1] 400 400
# #
# # # There’s no simple way of restricting a clustering tree to a subset of genes, so we must re-cluster.
selectTree <- hclust(as.dist(selectTOM), method = "average") # 构建代谢物分层聚类树
selectColors <- moduleColors[select]
# # ## Open a graphical window，设置画布大小
sizeGrWindow(10,10)
# # # Taking the dissimilarity to a power, say 10, makes the plot more informative by effectively changing the color palette; setting the diagonal to NA also improves the clarity of the plot
plotDiss <- selectTOM^7
diag(plotDiss) <- NA
### 绘制随机选择的TOM矩阵（400）
# TOMplot(plotDiss, selectTree, selectColors, main = "Network heatmap plot, selected proteins")
# #
#### PDF
pdf("Network_Heatmap_400.pdf", width = 10, height = 10)
TOMplot(plotDiss, selectTree, selectColors, main = "Network heatmap (400)")
dev.off()
# # ## PNG Save
png("Network_Heatmap_400.png", width = 1200, height = 1200)
TOMplot(plotDiss, selectTree, selectColors, main = "Network heatma (400)")
dev.off()
#

##########################################################
## WGCNA分析完成进度条
ppbb <- progress_bar$new(
  format = "  完成百分比 [:bar] :percent",
  total = 1000, clear = FALSE, width= 100)
for (i in 1:1000) {
  ppbb$tick()
  Sys.sleep(1 / 1000)
}

#######################################################################
## 10.WGCNA Analysis END!
sessionInfo()
# R version 3.6.1 (2019-07-05)
# Platform: x86_64-w64-mingw32/x64 (64-bit)
# Running under: Windows 10 x64 (build 18363)
#
# Matrix products: default
#
# locale:
#   [1] LC_COLLATE=Chinese (Simplified)_China.936
# [2] LC_CTYPE=Chinese (Simplified)_China.936
# [3] LC_MONETARY=Chinese (Simplified)_China.936
# [4] LC_NUMERIC=C
# [5] LC_TIME=Chinese (Simplified)_China.936
#
# attached base packages:
#   [1] grid      stats4    parallel  stats     graphics  grDevices utils
# [8] datasets  methods   base
#
# other attached packages:
#   [1] Rgraphviz_2.28.0       enrichplot_1.4.0       igraph_1.2.4.2
# [4] COMBAT_0.0.4           corpcor_1.6.9          mvtnorm_1.0-11
# [7] mice_3.6.0             lattice_0.20-38        pathview_1.24.0
# [10] topGO_2.36.0           SparseM_1.77           graph_1.62.0
# [13] rio_0.5.16             GO.db_3.8.2            org.Hs.eg.db_3.8.2
# [16] AnnotationDbi_1.46.1   IRanges_2.18.3         S4Vectors_0.22.1
# [19] Biobase_2.44.0         DOSE_3.10.2            AnnotationHub_2.16.1
# [22] BiocFileCache_1.8.0    dbplyr_1.4.2           BiocGenerics_0.30.0
# [25] clusterProfiler_3.12.0 pheatmap_1.0.12        progress_1.2.2
# [28] ggplot2_3.2.1          dplyr_0.8.3            stringr_1.4.0
# [31] reshape2_1.4.3         openxlsx_4.1.4         WGCNA_1.68
# [34] fastcluster_1.1.25     dynamicTreeCut_1.63-1
#
# loaded via a namespace (and not attached):
#   [1] tidyselect_0.2.5              lme4_1.1-21
# [3] robust_0.4-18.1               RSQLite_2.1.4
# [5] htmlwidgets_1.5.1             BiocParallel_1.18.1
# [7] munsell_0.5.0                 codetools_0.2-16
# [9] preprocessCore_1.46.0         withr_2.1.2
# [11] colorspace_1.4-1              GOSemSim_2.10.0
# [13] knitr_1.26                    rstudioapi_0.10
# [15] robustbase_0.93-5             labeling_0.3
# [17] KEGGgraph_1.44.0              urltools_1.7.3
# [19] polyclip_1.10-0               bit64_0.9-7
# [21] farver_2.0.1                  vctrs_0.2.0
# [23] generics_0.0.2                xfun_0.11
# [25] R6_2.4.1                      doParallel_1.0.15
# [27] graphlayouts_0.5.0            bitops_1.0-6
# [29] fgsea_1.10.1                  gridGraphics_0.4-1
# [31] assertthat_0.2.1              promises_1.1.0
# [33] scales_1.1.0                  ggraph_2.0.0
# [35] nnet_7.3-12                   gtable_0.3.0
# [37] tidygraph_1.1.2               rlang_0.4.2
# [39] zeallot_0.1.0                 splines_3.6.1
# [41] lazyeval_0.2.2                acepack_1.4.1
# [43] impute_1.58.0                 broom_0.5.2
# [45] europepmc_0.3                 checkmate_1.9.4
# [47] BiocManager_1.30.10           yaml_2.2.0
# [49] backports_1.1.5               httpuv_1.5.2
# [51] qvalue_2.16.0                 Hmisc_4.3-0
# [53] tools_3.6.1                   ggplotify_0.0.4
# [55] RColorBrewer_1.1-2            ggridges_0.5.1
# [57] Rcpp_1.0.3                    plyr_1.8.5
# [59] base64enc_0.1-3               zlibbioc_1.30.0
# [61] purrr_0.3.3                   RCurl_1.95-4.12
# [63] prettyunits_1.0.2             rpart_4.1-15
# [65] viridis_0.5.1                 cowplot_1.0.0
# [67] haven_2.2.0                   ggrepel_0.8.1
# [69] cluster_2.1.0                 magrittr_1.5
# [71] data.table_1.12.8             DO.db_2.9
# [73] triebeard_0.3.0               packrat_0.5.0
# [75] mitml_0.3-7                   matrixStats_0.55.0
# [77] hms_0.5.2                     mime_0.7
# [79] xtable_1.8-4                  XML_3.98-1.20
# [81] readxl_1.3.1                  gridExtra_2.3
# [83] compiler_3.6.1                tibble_2.1.3
# [85] crayon_1.3.4                  minqa_1.2.4
# [87] htmltools_0.4.0               pcaPP_1.9-73
# [89] later_1.0.0                   Formula_1.2-3
# [91] tidyr_1.0.0                   rrcov_1.4-9
# [93] DBI_1.0.0                     tweenr_1.0.1
# [95] MASS_7.3-51.4                 rappdirs_0.3.1
# [97] boot_1.3-23                   Matrix_1.2-18
# [99] pan_1.6                       forcats_0.4.0
# [101] pkgconfig_2.0.3               fit.models_0.5-14
# [103] rvcheck_0.1.7                 foreign_0.8-72
# [105] xml2_1.2.2                    foreach_1.4.7
# [107] XVector_0.24.0                digest_0.6.23
# [109] Biostrings_2.52.0             cellranger_1.1.0
# [111] fastmatch_1.1-0               htmlTable_1.13.3
# [113] curl_4.3                      shiny_1.4.0
# [115] jomo_2.6-10                   nloptr_1.2.1
# [117] lifecycle_0.1.0               nlme_3.1-143
# [119] jsonlite_1.6                  viridisLite_0.3.0
# [121] pillar_1.4.2                  KEGGREST_1.24.1
# [123] fastmap_1.0.1                 httr_1.4.1
# [125] DEoptimR_1.0-8                survival_3.1-8
# [127] interactiveDisplayBase_1.22.0 glue_1.3.1
# [129] zip_2.0.4                     UpSetR_1.4.0
# [131] png_0.1-7                     iterators_1.0.12
# [133] bit_1.1-14                    ggforce_0.3.1
# [135] stringi_1.4.3                 blob_1.2.0
# [137] latticeExtra_0.6-28           memoise_1.1.0
#######################################################################

## 脚本耗时
print("脚本运行时间为：")
proc.time()-pt
