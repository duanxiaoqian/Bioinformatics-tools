# 工作目录
setwd("Z:/项目数据/LCMS/2019/PAL03174-中国医学科学院生物技术/售后1")
setwd("I:/段光前-工作资料/开发任务/functions")
# 读取数据
data <- readallsheet("./差异代谢物.xlsx", rowNames = F)
coplot <- function(data=data,name=name, .fun=.fun){
  for (i in names(data)){
    # .fun(i)
    data_df <- data[[i]][,-(2:8)]
    RMETA2::savexlsx1(data=data_df, name = "差异代谢物1.xlsx", sheet = i)
  }
}
coplot(data=data, name = "相关性矩阵.xlsx")
RMETA2::auto_alldraw(name="差异代谢物1.xlsx",needgroup=c(1:10),drawwhat="correlation")
