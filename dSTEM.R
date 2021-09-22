#   Install Package:           'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
#   参数注释如下：
#   path为当前工作目录(需要STEM分析文件的所在目录)
#   filename为待STEM分析的文件名
#   sheet为需要处理数据的sheet name或sheet number
#   circle_num为最佳聚类个数获取的循环次数
#   max_cluster为设置的最大可能聚类个数
#   filter_std为布尔值，表示是（TURE）否（FALSE）过滤数据，默认为FALSE（一般输入数据是具有差异性的）
#   standardise为布尔值，表示是（TURE）否（FALSE）标准化（Z-score）数据，默认为T（标准化）
setwd("C:/Users/Pioneer/Desktop/产品经理工作内容-20200601/客户2020-06-成交/2020-10-23-李晓-南京农业大学/第二次黄酮靶向/售后")

filename <- "STC数据.xlsx"
sheet<-1
dSTEM(filename="rate.xlsx", sheet=1, circle_num=2, max_cluster=50, filter_std=FALSE, standardise=T, mode="metabolites")
  

dSTEM <- function(filename=filename, sheet=sheet, circle_num=2, max_cluster=50, filter_std=FALSE, standardise=T, mode="metabolites"){
  #"RMETA2","dplyr","Mfuzz","openxlsx", "ggplot2", "reshape2", "marray", "pheatmap"

  if (is.numeric(sheet)){
    group<-openxlsx::getSheetNames(filename)
    group<-group[sheet]
  }else if(is.character(sheet)){
    group<-sheet
  }
  data <- RMETA2::readxlsx(filename, rowNames = T, sheet = group)
  results_dir <- "时间序列分析"
  RMETA2::dirfile(results_dir,force = T)
  
  setwd( results_dir)
  
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
  RMETA2::auto_heatmap(data3, name = "Summary")
  
  print("数据保存")
  data4<-cbind(Metabolites=row.names(data),data2,data1)
  RMETA2::savexlsx1(data =data4 ,name ="分析原始数据.xlsx" ,sheet ="分析原始数据" )
  
  
  # 需要matrix数据类型
  count_matrix <- data.matrix(data2)
  library(Mfuzz, warn.conflicts=F)
  library(dplyr, warn.conflicts=F)
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
  c <- cir_num(circle_num=circle_num, m=m, eset=eset, max_cluster=max_cluster)
  print(paste0("获得最佳聚类个数为: ", c))

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
  RMETA2::savexlsx1(data =cl.size ,name ="Cluster Statistics.xlsx" ,sheet ="Cluster Statistics" )


  # 查看基因和cluster之间的membership
  membership <- cl$membership
  membership1 <- data.frame(membership)
  names(membership1)<-paste0("Cluster ",seq(1, c))
  membership1<-cbind(Metabolites=row.names(membership1),membership1)
  RMETA2::savexlsx1(data =membership1 ,name ="Membership.xlsx" ,sheet ="Membership" )

  # 提取cluster下的element,并保存成文件
  for (i in seq(1, c)){
    cluster_i <- data.frame("Cluster number"=cl$cluster[cl$cluster == i],check.names = F)
    cluster_i[,1] <- paste0("Cluster ",cluster_i[,1])

    print(paste0("保存Cluster " , i, "的热图"))
    if (dim(cluster_i)[1]>1){
      data_i <- data3[row.names(cluster_i),,drop=F]    #筛选出该Cluster的metabolites
      RMETA2::auto_heatmap(data_i, name = paste0("Cluster ", i)) #画热图
      
    }else {
      data_i <- data3[row.names(cluster_i),,drop=F] #筛选出该Cluster的metabolites
      RMETA2::auto_heatmap(data_i, name = paste0("Cluster ", i),col = F,row = F)
    }
    
    file.rename(paste0("heatmap-","Cluster ", i,".tif"),paste0("Cluster ", i," heatmap",".tif"))
    file.rename(paste0("heatmap-","Cluster ", i,".pdf"),paste0("Cluster ", i," heatmap",".pdf"))

    cluster_i <- cbind(cluster_i, data4[row.names(cluster_i), ]) # 合并
    # 提取每个cluster的element的membership
    mem.ship <- data.frame("Membership"=membership[row.names(cluster_i), i])
    cluster_i <- cbind(cluster_i, mem.ship) # 合并
    # 保存分析结果
    print(paste0("保存Cluster " , i, "的结果"))
    RMETA2::savexlsx1(data =cluster_i ,name =paste0("Cluster ", i,".xlsx") ,sheet =paste0("Cluster ", i))
    
    # 查看属于cluster cores的基因list. cluster cores为membership > 0.7的metabolites
    acore.list <- Mfuzz::acore(eset, cl, min.acore = 0.7)
    acore.list[[i]] <- dplyr::rename(acore.list[[i]], Metabolites=NAME)
    acore.list[[i]] <- dplyr::rename(acore.list[[i]], Membership=MEM.SHIP)
    
    RMETA2::savexlsx1(data =acore.list[[i]] ,name =paste0("Cluster ", i,".xlsx") ,sheet =paste("Cluster ", i, " cores", sep = ""))
    
    #画图，线的颜色以各个代谢物在该cluster的membership来定
    
    choosedata <- data.frame(t(select(cluster_i, contains("Expression")))) # 抽提画图信息（时间轴，表达量）
    h <- length(rownames(choosedata))
    suppressMessages(
    choosedata <- reshape2::melt(choosedata)  #将宽数据框变为长数据框， 便于画图
    )
    # choosedata['Expression Change(log2(v(i)/v(0))'] <- choosedata['value']
    choosedata['Samples'] <- colnames(data)
    choosedata['Membership'] <- rep(cluster_i$Membership,each=h,times=1) # 添加membership，指示颜色

    cl_draw(data=data, choosedata = choosedata, i=i, standardise=standardise, mode="metabolites")
  }
  setwd("../")
  print("STEM分析结束，热图、聚类图保存结束")
}



# 设置循环次数，获得最佳聚类个数
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

# 画cluster的折线图
cl_draw <- function(data=data, choosedata=choosedata, i=i, standardise=FALSE, mode="metabolites"){
  library("ggplot2")
  theme_set(theme_classic())
  p <- ggplot(data=choosedata,aes(x=factor(choosedata$Samples, level=colnames(data)), y=value)) + geom_line(aes(color = Membership, group = Membership)) +
    labs(title = paste0("Cluster ", i), subtitle = paste("contains ", length(choosedata$Membership)/length(colnames(data)), mode, sep = "")) +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5), legend.text.align = 0.5)
  
  # p + scale_color_gradientn(colours = rainbow(5)) # 颜色c("yellow","green","blue","purple","red")
  # #col <- c("#FF8F00", "#FFA700", "#FFBF00", "#FFD700",
  #          "#FFEF00", "#F7FF00", "#DFFF00", "#C7FF00", "#AFFF00",
  #          "#97FF00", "#80FF00", "#68FF00", "#50FF00", "#38FF00",
  #          "#20FF00", "#08FF00", "#00FF10", "#00FF28", "#00FF40",
  #          "#00FF58", "#00FF70", "#00FF87", "#00FF9F", "#00FFB7",
  #          "#00FFCF", "#00FFE7", "#00FFFF", "#00E7FF", "#00CFFF",
  #          "#00B7FF", "#009FFF", "#0087FF", "#0070FF", "#0058FF",
  #          "#0040FF", "#0028FF", "#0010FF", "#0800FF", "#2000FF",
  #          "#3800FF", "#5000FF", "#6800FF", "#8000FF", "#9700FF",
  #          "#AF00FF", "#C700FF", "#DF00FF", "#F700FF", "#FF00EF",
  #          "#FF00D7", "#FF00BF", "#FF00A7", "#FF008F", "#FF0078",
  #          "#FF0060", "#FF0048", "#FF0030", "#FF0018")
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

