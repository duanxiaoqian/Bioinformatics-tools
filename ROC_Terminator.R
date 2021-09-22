#######################################################
# This R script is designed for all-in-one ROC        #
# analysis.                                           #
#-----------------------------------------------------#
setwd("F:/ROC绘图-base")

options(stringsAsFactors = F)
options(warn = -1)

##install packages 
# install.packages("pROC") #install.packages("ROCR")
# install.packages("wesanderson") #colors palettes
# install.packages("openxlsx")

# load
library(pROC)
library(wesanderson)
library(openxlsx)
library(dplyr)


data = read.xlsx("HPA中TCGA ROC曲线作图数据.xlsx",sheet=1,rowNames = F,colNames = T,startRow = 1,
                 detectDates = F,na.strings = "#NA") %>% dplyr::select(`suvival(d)`,FPKM)

# check groups (should be <= 5)
num.value = ncol(data) - 1
if(num.value > 5){
  print("Error: Too many groups of observations!")
  q(save="no")
}

name.value = colnames(data)[2:ncol(data)]

# define favoritable colors
colors <- names(wes_palettes)
# [1] "BottleRocket1"  "BottleRocket2"  "Rushmore1"      "Rushmore"      
# [5] "Royal1"         "Royal2"         "Zissou1"        "Darjeeling1"   
# [9] "Darjeeling2"    "Chevalier1"     "FantasticFox1"  "Moonrise1"     
# [13] "Moonrise2"      "Moonrise3"      "Cavalcanti1"    "GrandBudapest1"
# [17] "GrandBudapest2" "IsleofDogs1"    "IsleofDogs2" 
col = wes_palette(colors[8],num.value,type=c("discrete"))

# ROC curve
pdf("1.ROC_Combined_1.pdf",height = 4,width = 4)
for (i in 1:num.value){
  if(i == 1){
    roc.data = roc(data[,1],data[,i+1],
        percent=T,plot=T, grid=T,lty=i,
        print.auc=F,col=col[i])
    text(30,50,"AUC",font = 2,col="darkgray")
    text(30,50-10*i,
         paste(name.value[i],":",sprintf("%0.4f",as.numeric(roc.data$auc))),
         col=col[i])
  }else{
    roc.data = roc(data[,1],data[,i+1],
        percent=T,plot=T, grid=T, add=T,lty=i,
        print.auc=F,col=col[i])
    text(30,50-10*i,
         paste(name.value[i],":",sprintf("%0.4f",as.numeric(roc.data$auc))),
         col=col[i])
  }
}
dev.off()

# smooth ROC curve
pdf("2.ROC_with_smooth_curve_Combined.pdf",height = 4,width = 4)
for (i in 1:num.value){
  if(i == 1){
    roc.data = roc(data[,1],data[,i+1],
                   percent=T,plot=T, grid=T,lty=i,smooth = T,
                   print.auc=F,col=col[i])
    text(30,50,"AUC",font = 2,col="darkgray")
    text(30,50-10*i,
         paste(name.value[i],":",sprintf("%0.4f",as.numeric(roc.data$auc))),
         col=col[i])
  }else{
    roc.data = roc(data[,1],data[,i+1],
                   percent=T,plot=T, grid=T, add=T,lty=i,smooth = T,
                   print.auc=F,col=col[i])
    text(30,50-10*i,
         paste(name.value[i],":",sprintf("%0.4f",as.numeric(roc.data$auc))),
         col=col[i])
  }
}
dev.off()

## ROC with Confidence intervals ##
transparentColor <- function(col,alpha=200){
  # alpha is an integer >= 1 and <= 255
  
  col.rgb = as.numeric(col2rgb(col))
  col.rgb.alpha = rgb(col.rgb[1],col.rgb[2],col.rgb[3],alpha=alpha,maxColorValue = 255)
  return(col.rgb.alpha)
}
  
## CI of the curve
# curve shape
pdf("3.ROC_with_confidence_level_ribbon.pdf",height = 3,width = 3*num.value)
par(mfrow=c(1,num.value))
for (i in 1:num.value){
    roc.data = roc(data[,1],data[,i+1],
                   percent=T,plot=T, grid=T,
                   print.auc=F,col=transparentColor("white",255))
    sens.ci <- ci.se(roc.data, boot.n=100,conf.level = 0.95,specificities=seq(0, 100, 5))
    plot(sens.ci,type="shape",col=transparentColor(col[i],100))
    
    text(30,40,"AUC",font = 2,col="darkgray")
    text(30,30,
         paste(name.value[i],":",sprintf("%0.4f",as.numeric(roc.data$auc))),
         col=col[i])
}
dev.off()

#curve bar
pdf("4.ROC_with_confidence_level_bars_Combined.pdf",height = 3,width = 3*num.value)
par(mfrow=c(1,num.value))
for (i in 1:num.value){
  roc.data = roc(data[,1],data[,i+1],
                 percent=T,plot=T, grid=T,
                 print.auc=F,col=col[i])
  sens.ci <- ci.se(roc.data, boot.n=100,conf.level = 0.95,specificities=seq(0, 100, 5))
  plot(sens.ci,type="bars",col=col[i])
  
  text(30,40,"AUC",font = 2,col="darkgray")
  text(30,30,
       paste(name.value[i],":",sprintf("%0.4f",as.numeric(roc.data$auc))),
       col=col[i])
}
dev.off()


## Performance ##
getROCPerformance <- function(rocdata){
  performance = coords(roc.data, "best", best.method = "youden",
                       ret=c("threshold", "sensitivity","specificity", 
                             "npv","ppv","tpr","fpr",
                             "tnr","fnr","fdr","accuracy",
                             "precision","youden"),
                       transpose = F)
  res = t(as.data.frame(performance))
  auc = as.numeric(roc.data$auc)
  res = rbind(auc,res)
  return(res)
}

perf.all = NULL
roc.data.all = NULL
for (i in 1:num.value){
  roc.data = roc(data[,1],data[,i+1],
                 percent=T,plot=F)
  roc.data.all = c(roc.data.all,roc.data)
  perf = getROCPerformance(roc.data)
  colnames(perf) = name.value[i]
  perf.all = cbind(perf.all,perf)
}
perf.all = as.data.frame(perf.all)
perf.all$Index = c("AUC","Best Cut-off Value","Sensitivity","Specificity",
                   "Negative Predictive Value","Positive Predictive Value",
                   "True Positive Rate","False Positive Rate",
                   "True Negatice Rate","False Negative Rate",
                   "False Discovery Rate","Accuracy","Precision","Youden Index")
perf.all = perf.all[,c(ncol(perf.all),1:(ncol(perf.all)-1))]
write.table(perf.all,"5.Model.Performance.csv",row.names = F,col.names = T,quote=F,sep=",")


## Delong Comparisons ##
pair = t(combn(2:ncol(data),2))

compair.result = NULL
for (i in 1:nrow(pair)){
  name1 = colnames(data)[pair[i,1]]
  compair.result$Model1.ROC = c(compair.result$Model1.ROC,name1)
  roc1 = roc(data[,1],data[,pair[i,1]],
             percent=T,plot=F)
  
  name2 = colnames(data)[pair[i,2]]
  compair.result$Model2.ROC = c(compair.result$Model2.ROC,name2)
  roc2 = roc(data[,1],data[,pair[i,2]],
             percent=T,plot=F)
  
  p = roc.test(roc1, roc2, reuse.auc=FALSE, boot.n = 1000, boot.stratified = F)$p.value
  compair.result$Pvalue.Delong.test = c(compair.result$Pvalue.Delong.test,p)
}
compair.result = as.data.frame(compair.result)
write.table(compair.result,"6.Delong.Comparision.csv",row.names = F,col.names = T,quote=F,sep=",")


