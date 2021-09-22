
library(ggplot2)
library(openxlsx)
library(dplyr)
#火山图绘制

# 数据输入
setwd("I:/段光前-工作资料/开发任务/all.figure/Volcanoplot")
filename <- "volcano-VIP.xlsx"

volcanoPlotAll(filename)

volcanoPlotAll <- function(filename = filename,.fun="volcanoplot",...){
  library(ggplot2)
  library(openxlsx)
  data <- readalldata(filename = filename)
  print("开始画火山图")
  for (i in 1:length(data)){
    # print(names(data[i]))
    # print(data[i])
    if (.fun=="volcanoplot"){
      volcanoplot(data = data[[i]], name = names(data[i]))
    }else{
      volcanoplot2(data = data[[i]], name = names(data[i]))
      }
    print(paste0("绘制sheet ", names(data[i]), "的火山图"))
  }
  print("火山图绘制完成")
}

volcanoplot <- function(data=data, name=NA, pvalue= 0.05, FC=1, VIP=1,...){
  data$Class[(data$`P-value`>pvalue|data$`P-value`=="NA")|(data$`log2(FC)`<FC)|(data$`log2(FC)`>-FC)] <- "not-significant"
  data$Class[data$`P-value`<=pvalue&data$`log2(FC)`>=FC&data$VIP>=VIP] <- "up-regulated"
  data$Class[data$`P-value`<=pvalue&data$`log2(FC)`<=-FC&data$VIP>=VIP] <- "down-regulated"
  data <- rbind(data[data$Class=="not-significant",], 
                data[data$Class=="up-regulated",],
                data[data$Class=="down-regulated",])
  # 在各标签后添加个数
  data$Class[data$Class=="not-significant"] <- paste0("not-significant: ", summary(as.factor(data$Class))["not-significant"])
  data$Class[data$Class=="up-regulated"] <- paste0("up-regulated: ", summary(as.factor(data$Class))["up-regulated"])
  data$Class[data$Class=="down-regulated"] <- paste0("down-regulated: ", summary(as.factor(data$Class))["down-regulated"])
  x_lim <- max(data$`log2(FC)`, -data$`log2(FC)`)
  
  #绘制火山图
  theme_set(theme_classic())
  p <- ggplot2::ggplot(data,aes(`log2(FC)`, -log10(`P-value`), color = Class, size = VIP))+ 
       geom_point(alpha=0.6)+ 
       xlim(-x_lim, x_lim)+ 
       labs(x="log2(FC)", y="-log10(p-value)")+ 
       ggtitle("Volcano Plot")+
       theme(plot.title = element_text(hjust = 0.5))
  # print(p)
  p <- p + scale_color_manual(values = c("blue","grey", "red"))+
       geom_hline(aes(yintercept=-log10(pvalue)), colour="black", linetype="dashed", na.rm = T)+
       annotate("text", x = x_lim/1.5, y=-log10(pvalue)-0.2,label=paste0("p-value=", pvalue))+
       geom_vline(xintercept = c(-FC, FC), colour="black", linetype="dashed", na.rm = T)
  # print(p)
  ggsave(paste0("Volcano-", name, ".pdf"), p, width = 9, height = 7)#, device = "pdf"
  ggsave(filename = paste0("Volcano-", name, ".tiff"), plot = p, width = 9, height = 7, dpi = 300)
  statue = file.rename(paste0("Volcano-", name, ".tiff"), paste0("Volcano-", name, ".tif"))
}


volcanoplot2 <- function(data=data, name=NA, pvalue= 0.05, FC=1, VIP=1,...){
  library(dplyr)
  data$Class[(data$`P-value`>pvalue|data$`P-value`=="NA")|(data$`log2(FC)`<FC)|(data$`log2(FC)`>-FC)] <- "not significant"
  data$Class[data$`P-value`<=pvalue&data$`log2(FC)`>=FC&data$VIP>=VIP] <- "up-regulated"
  data$Class[data$`P-value`<=pvalue&data$`log2(FC)`<=-FC&data$VIP>=VIP] <- "down-regulated"
  x_lim <- max(data$`log2(FC)`, -data$`log2(FC)`)
  
  theme_set(theme_classic())
  p<-ggplot2::ggplot(data, aes(`log2(FC)`, -log10(`P-value`)))+
    geom_point(data=dplyr::filter(data, Class=="not-significant"),
               aes(size=VIP, color=Class), alpha=0.4)+ #, color="grey"
    geom_point(data=dplyr::filter(data, Class=="up-regulated"), 
               aes(size=VIP, color=Class), alpha=0.6)+ #, color="red"
    geom_point(data=dplyr::filter(data, Class=="down-regulated"),
               aes(size=VIP, color=Class), alpha=0.6)+ #, color="blue"
    xlim(-x_lim, x_lim)+ 
    scale_color_manual(values = c("blue","grey", "red"))+
    labs(x="log2(FC)", y="-log10(p-value)", title = "Volcano Plot")+ 
    #ggtitle("Volcano Plot")+
    theme(plot.title = element_text(hjust = 0.5))
  # print(p)
  p <- p +geom_hline(aes(yintercept=-log10(pvalue)), colour="black", linetype="dashed", na.rm = T)+
    annotate("text", x = x_lim/1.5, y=-0.85*log10(pvalue),label=paste0("p-value=", pvalue))+
    geom_vline(xintercept = c(-FC, FC), colour="black", linetype="dashed", na.rm = T)
    
  # print(p)
  # print(summary(p))
  ggsave(paste0("Volcano-", name, ".pdf"), p, width = 9, height = 7)#, device = "pdf"
  ggsave(filename = paste0("Volcano-", name, ".tiff"), plot = p, width = 9, height = 7, dpi = 300)
  statue = file.rename(paste0("Volcano-", name, ".tiff"), paste0("Volcano-", name, ".tif"))
}


#ggpubr ggscatter
