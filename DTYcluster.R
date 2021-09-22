library(RMETA2)

setwd("I:/段光前-工作资料/开发任务/all.figure/sample")
filename <- c("工作簿2.xlsx", )
filename1 <- "时间序列分析数据1.xlsx"

data <- RMETA2::readxlsx(filename1, rowNames = T, sheet = 1)
for (i in 1){
  cluster_i <- RMETA2::readxlsx(filename[i], rowNames = F, sheet = 1)
  choosedata <- data.frame(t(select(cluster_i, contains("Expression")))) # 抽提画图信息（时间轴，表达量）
  h <- length(rownames(choosedata))
  suppressMessages(
    choosedata <- reshape2::melt(choosedata)  #将宽数据框变为长数据框， 便于画图
  )
  # choosedata['Expression Change(log2(v(i)/v(0))'] <- choosedata['value']
  choosedata['Samples'] <- colnames(data)
  choosedata['Membership'] <- rep(cluster_i$Membership,each=h,times=1) # 添加membership，指示颜色
  
  RMETA2::cl_draw(data=data, choosedata = choosedata, i=i, standardise=T, mode = "proteins")
}
