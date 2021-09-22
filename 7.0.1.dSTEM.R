###########################################################################################################
#    
#   
#   主要参数注释如下：
#   filename为待时间序列分析数据的文件名
#   sheet为需要处理数据的sheet name或sheet number，默认为1
#   circle_num为最佳聚类个数获取的循环次数
#   max_cluster为设置的最大可能聚类簇个数
#   cluster_num为自定义聚类簇个数
#   filter_std为布尔值，表示是（TURE）否（FALSE）过滤数据，默认为FALSE（一般输入数据是具有差异性的）
#   standardise为布尔值，表示是（TURE）否（FALSE）标准化（Z-score）数据，默认为T（标准化）
#   mode模式，可选为"Metabolites"(代谢组模式)，"Proteins"(蛋白质组模式)，"transcripts"(转录组模式)，"genes"(基因组模式)
#
#
###########################################################################################################

###########################################################################################################
# 依赖包："dplyr","Mfuzz","openxlsx", "ggplot2", "reshape2", "marray", "pheatmap"
#
# 检测安装CRAN包
# package_list = c("BiocManager","dplyr","openxlsx","ggplot2","reshape2","pheatmap")
# for(pkg in package_list){
#   if (!requireNamespace(pkg, quietly = TRUE))
#     install.packages(pkg)
# }
# 
# # 检测安装bioconductor包
# package_list = c("Mfuzz", "marray")
# for(pkg in package_list){
#   if (!requireNamespace(pkg, quietly = TRUE))
#     BiocManager::install(pkg)
# }
###########################################################################################################

################################################## 主程序 ##################################################
dSTEM <- function(filename=filename, sheet=1, 
                  circle_num=2, max_cluster=50, cluster_num=NULL,
                  filter_std=FALSE, standardise=T, mode="metabolites", ...){
  
  # 读取数据
  if (is.numeric(sheet)){
    group<-openxlsx::getSheetNames(filename)
    group<-group[sheet]
  }else if(is.character(sheet)){
    group<-sheet
  }
  data <- openxlsx::read.xlsx(filename, rowNames = T, sheet = group)
  
  # 创建文件夹，并设置工作目录
  results_dir <- "时间序列分析"
  if (!file.exists(results_dir)) {
    dir.create(results_dir)
  }
  else {
    unlink(results_dir, recursive = T, force = T)
    dir.create(results_dir)
  }
  setwd(results_dir)
  
  # 数据预处理
  print("数据预处理")
  data1 <- data
  colnames(data1) <- paste0(colnames(data1),".raw")
  colone_value <- data1[,1]
  if (!standardise){
    print("数据进行log2g归一化处理")
    value_log <- function(x, na.rm = FALSE) (log2(x/colone_value))
    data2 <- dplyr::mutate_all(.tbl = data1, .funs = value_log)
    colnames(data2) <- paste0(colnames(data), ".Expression Change(log2(v(i)/v(0))")
    row.names(data2) <- rownames(data1)
  }else{
    print("数据进行Z-score标准化处理...")
    data2<-t(scale(t(data1))) # 对row进行Z-score标准化
    colnames(data2) <- paste0(colnames(data), ".Expression Abundance(Z-score)")
  }
  
  print("热图总图保存")
  data3<-as.data.frame(data2)
  names(data3)<-colnames(data)
  auto_heatmap(data3, name = "Summary", ...)
  
  print("数据保存")
  library(openxlsx, warn.conflicts=F)
  data4<-cbind(Metabolites=row.names(data),data2,data1)
  openxlsx::write.xlsx(x =data4 ,file ="分析原始数据.xlsx" ,sheetName ="分析原始数据" )
  
  library(Mfuzz, warn.conflicts=F)
  library(dplyr, warn.conflicts=F)
  # 需要matrix数据类型
  count_matrix <- data.matrix(data2)
  eset <- new("ExpressionSet",exprs = count_matrix)
  
  # 根据标准差去除样本间差异太小的基因
  if (!filter_std){
    eset<-eset
  }else{
    print("当前数据正在进行过滤处理...")
    eset <- Mfuzz::filter.std(eset,min.std=0)
  }
  
  print("开始分析数据")
  #  评估出最佳的m值
  m <- Mfuzz::mestimate(eset)
  
  # 判断最佳的聚类个数
  if (is.null(cluster_num)){
  c <- cir_num(circle_num=circle_num, m=m, eset=eset, max_cluster=max_cluster)
  print(paste0("获得最佳聚类个数为: ", c))
  }else {
    c<-cluster_num
    print(paste0("自定义聚类个数为: ", c))
    }
  
  # 聚类总图
  cl <- Mfuzz::mfuzz(eset, c = c, m = m)
  pdf(file ="Cluster-summary.pdf",width = ceiling(sqrt(c))*4, height =ceiling(sqrt(c))*4)
  Mfuzz::mfuzz.plot(eset,cl,mfrow=c(ceiling(sqrt(c)),ceiling(sqrt(c))),new.window= FALSE,time.labels=names(data))
  suppressWarnings(mfuzzColorBar(main="Membership",cex.main=1)) #画lengend，默认dpi为300
  dev.off()
  
  tiff(file ="Cluster-summary.tif",width = ceiling(sqrt(c))*4*72, height =ceiling(sqrt(c))*4*72,pointsize = 12)
  Mfuzz::mfuzz.plot(eset,cl,mfrow=c(ceiling(sqrt(c)),ceiling(sqrt(c))),new.window= FALSE,time.labels=names(data))
  suppressWarnings(mfuzzColorBar(main="Membership",cex.main=1)) #画lengend，默认dpi为300
  dev.off()
  
  
  # 保存每个cluster中的element个数
  cl.size <- data.frame("Cluster number"=paste0("Cluster ",seq(1, c)),"Cluster amount"=cl$size,check.names = F)
  openxlsx::write.xlsx(x =cl.size ,file ="Cluster Statistics.xlsx" ,sheetName ="Cluster Statistics" )
  
  
  # 查看基因和cluster之间的membership
  membership <- cl$membership
  membership1 <- data.frame(membership)
  names(membership1)<-paste0("Cluster ",seq(1, c))
  membership1<-cbind(Metabolites=row.names(membership1),membership1)
  openxlsx::write.xlsx(x =membership1 ,file ="Membership.xlsx" ,sheetName ="Membership" )
  
  # 提取cluster下的element,并保存成文件
  for (i in seq(1, c)){
    cluster_i <- data.frame("Cluster number"=cl$cluster[cl$cluster == i],check.names = F)
    cluster_i[,1] <- paste0("Cluster ",cluster_i[,1])
    
    print(paste0("保存Cluster " , i, "的热图"))
    if (dim(cluster_i)[1]>1){
      data_i <- data3[row.names(cluster_i),,drop=F]    #筛选出该Cluster的metabolites
      auto_heatmap(data_i, name = paste0("Cluster ", i), ...) #画热图
      
    }else {
      data_i <- data3[row.names(cluster_i),,drop=F] #筛选出该Cluster的metabolites
      auto_heatmap(data_i, name = paste0("Cluster ", i),col = F,row = F, ...)
    }
    
    file.rename(paste0("heatmap-","Cluster ", i,".tif"),paste0("Cluster ", i," heatmap",".tif"))
    file.rename(paste0("heatmap-","Cluster ", i,".pdf"),paste0("Cluster ", i," heatmap",".pdf"))
    
    cluster_i <- cbind(cluster_i, data4[row.names(cluster_i), ]) # 合并
    
    # 提取每个cluster的element的membership
    mem.ship <- data.frame("Membership"=membership[row.names(cluster_i), i])
    cluster_i <- cbind(cluster_i, mem.ship) # 合并
    # 保存分析结果
    print(paste0("保存Cluster " , i, "的结果数据"))
    openxlsx::write.xlsx(x =cluster_i ,file =paste0("Cluster ", i,".xlsx") ,sheetName =paste0("Cluster ", i))
    
    # 查看属于cluster cores的基因list. cluster cores为membership > 0.7的metabolites
    acore.list <- Mfuzz::acore(eset, cl, min.acore = 0)
    acore.list[[i]] <- dplyr::rename(acore.list[[i]], Metabolites=NAME, Membership=MEM.SHIP) %>% 
                       dplyr::arrange(desc(Membership))
    openxlsx::write.xlsx(x =acore.list[[i]] ,file =paste0("Cluster ", i,".xlsx") ,sheetName =paste0("Cluster ", i))
    
    #画图，线的颜色以各个代谢物在该cluster的membership来定
    choosedata <- data.frame(t(select(cluster_i, contains("Expression")))) # 抽提画图信息（时间轴，表达量）
    h <- length(rownames(choosedata))
    suppressMessages(
      choosedata <- reshape2::melt(choosedata)  #将宽数据框变为长数据框， 便于画图
    )
    choosedata['Samples'] <- colnames(data)
    choosedata['Membership'] <- rep(cluster_i$Membership,each=h,times=1) # 添加membership，指示颜色
    cl_draw(data=data, choosedata = choosedata, i=i, standardise=standardise, mode="metabolites")
  }
  
  setwd("../")
  print("STEM分析结束，热图、聚类图保存结束")
}



################################### 设置循环次数，获得最佳聚类簇个数 ###################################
cir_num <- function(circle_num = 2, max_cluster = 50, eset = eset, m = m){
  print(paste("circle_num为：", circle_num, " ; max_cluster为：", max_cluster, sep = ""))
  if (circle_num > 6){
    circle_num <- 6
  }else {
    circle_num <- circle_num
  }
  c_list <- list()
  for (j in seq(1,circle_num)){
    tmp <- Mfuzz::Dmin(eset,m=m,crange=seq(10,max_cluster,5),repeats=3,visu=TRUE)
    for (i in seq(1,(length(tmp)-1))) {
      if ((tmp[i]-tmp[i+1])<0.005) {
        c1=5+5*i
        break
      }
      else {c1=max_cluster}
    }
    c_list <- append(c_list, c1)
  }
  c <- round(rowMeans(as.data.frame(c_list)))
  dev.off()
  return(c)
}

####################################### 画cluster的折线图 ###########################################
cl_draw <- function(data=data, choosedata=choosedata, i=i, standardise=FALSE, mode="metabolites"){
  library("ggplot2")
  choosedata[,"Samples"] <- factor(choosedata$Samples, level=colnames(data))
  theme_set(theme_classic())
  p <- ggplot(data=choosedata,aes(x=Samples, y=value)) + 
    geom_line(aes(color = Membership, group = Membership)) +
    labs(title = paste0("Cluster ", i), 
         subtitle = paste("contains", length(choosedata$Membership)/length(colnames(data)), mode, sep = " ")) +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5), legend.text.align = 0.5)
  
  # 配色
  col <- c("#FFFF66","#FFFF33","#FFFF00","#33FF66","#33CC33","#33CC00",
           "#0099FF","#0066FF","#6633CC","#663399","#663366","#990099",
           "#FF0066","#FF0033","#CC0000")
  if (!standardise){
    p <- p + scale_color_gradientn(colours = col, breaks = seq(0, 1, 0.1)) +
      scale_y_continuous(name = 'Expression Change (log2(v(i)/v(0))')
  }else{
    p <- p + scale_color_gradientn(colours = col, breaks = seq(0, 1, 0.1)) +
      scale_y_continuous(name = 'Expression Abundance (Z-score)')
  }
  
  # 保存图片
  print(paste("保存Cluster ", i, "的聚类图", sep = ""))
  ggsave(filename = paste0("Cluster ", i,".pdf"), plot = p, width = 9, height = 7)
  ggsave(filename = paste0("Cluster ", i,".tiff"), plot = p, width = 9, height = 7, dpi = 300)
}

############################################# 画热图 #################################################
auto_heatmap <- function(data = data, name = NULL, color = NULL, row = T, col = F, ...){
  library(pheatmap)
  # 颜色
  if (is.null(color)) {
    color <- colorRampPalette(c("green", "black", "red"))(10000)
  }
  else if (color==1){
    color <- colorRampPalette(c("green", "#FFFFFF", "red"))(10000)
  }else if (color==2){
    color <- colorRampPalette(c("#33CCFF", "#FFFFCC", "#FF6633"))(10000)
  }else if (!(color==1|color==2)){
    color <- color
  }
  
  # cell大小
  namelenth <- max(nchar(row.names(data)))
  cellheight <- 600/dim(data)[1]
  if (cellheight < 1) {
    cellheight <- 1
  }
  if (cellheight > 15) {
    cellheight <- 15
  }
  cellwidth <- 600/dim(data)[2]
  if (cellwidth < 10) {
    cellwidth <- 10
  }
  if (cellwidth > 50) {
    cellwidth <- 50
  }
   
  # 字体大小
  fontsize_row <- 0.818 * cellheight
  fontsize_col <- 0.618 * cellwidth
  if (fontsize_col > 15) {
    fontsize_col <- 15
  }
  
  # 树轴长度
  treeheight_row <- 40 + dim(data)[1] * 0.05
  treeheight_col <- 40 + dim(data)[2] * 0.05 
  
  # 画布大小
  hei <- 800 + fontsize_row + treeheight_col
  wid <- 800 + namelenth * cellheight * 0.6 + treeheight_row
  
  # 画图
  ti <- paste0(name, "-heatmap.tif")
  tiff(filename = ti, width = wid, height = hei)
  pheatmap::pheatmap(data, 
                     treeheight_row = treeheight_row, treeheight_col = treeheight_col, 
                     scale = "row", display_numbers = FALSE,
                     cluster_cols = col, cluster_rows = row, border_color = NA, 
                     fontsize_row = fontsize_row, fontsize_col = fontsize_col, 
                     cellwidth = cellwidth, cellheight = cellheight, 
                     color = color, ...)
  dev.off()
  
  pd <- paste0(name, "-heatmap.pdf")
  pdf(pd, width = wid * 0.014, height = hei * 0.014)
  pheatmap::pheatmap(data, 
                     treeheight_row = treeheight_row, treeheight_col = treeheight_col, 
                     scale = "row", display_numbers = FALSE,
                     cluster_cols = col, cluster_rows = row, border_color = NA, 
                     fontsize_row = fontsize_row, fontsize_col = fontsize_col, 
                     cellwidth = cellwidth, cellheight = cellheight, 
                     color = color, ...)
  dev.off()
  }

############################################# For example ###########################################
# 
# setwd("C:/Users/Pioneer/Desktop/产品经理工作内容-20200601/客户2020-06-成交/2020-10-23-李晓-南京农业大学/第二次黄酮靶向/售后")
# filename <- "rate.xlsx"
# dSTEM(filename=filename)
# 
# dSTEM(filename=filename, sheet=1,
#       circle_num=2, max_cluster=50, cluster_num=10,
#       filter_std=FALSE, standardise=T, mode="metabolites",
#       color=1
#       )
#####################################################################################################
