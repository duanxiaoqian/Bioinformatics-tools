# PCA 分解操作

library(knitr)
kable(head(USJudgeRatings))
class(USJudgeRatings[,1])

# step1:数据标准化(中心化)
dat_scale=scale(USJudgeRatings,scale=F)
options(digits=4, scipen=4)
kable(head(dat_scale))

# step2:求相关系数矩阵
dat_cor=cor(dat_scale)

# step3:计算特征值和特征向量；
# 利用eigen函数计算相关系数矩阵的特征值和特征向量。这个是主成分分析法的精髓。
dat_eigen=eigen(dat_cor)
dat_var=dat_eigen$values ## 相关系数矩阵的特征值

pca_var=dat_var/sum(dat_var) #PCA占比值
pca_cvar=cumsum(dat_var)/sum(dat_var)  #PCA 累加

# step4:崖低碎石图和累积贡献图
library(ggplot2)
p=ggplot(,aes(x=1:12,y=pca_var))
p1=ggplot(,aes(x=1:12,y=pca_cvar))
p+geom_point(pch=2,lwd=3,col=2)+geom_line(col=2,lwd=1.2)
p1+geom_point(pch=2,lwd=3,col=2)+geom_line(col=2,lwd=1.2)

# step5:主成分载荷：主成分载荷表示各个主成分与原始变量的相关系数。
pca_vect= dat_eigen$vector  ## 相关系数矩阵的特征向量
loadings=sweep(pca_vect,2,sqrt(pca_var),"*")
rownames(loadings)=colnames(USJudgeRatings)

# step6:主成分得分计算和图示
# 将中心化的变量dat_scale乘以特征向量矩阵即得到每个观测值的得分
pca_score=as.matrix(dat_scale)%*%pca_vect 


# 用princomp函数
pca<-princomp(USJudgeRatings, cor=FALSE)
pca_<-princomp(USJudgeRatings, cor=T)

#'princomp'只能在单位比变量多的情况下使用
data.pr<-princomp(data,cor=TRUE)
#cor是逻辑变量 当cor=TRUE表示用样本的相关矩阵R做主成分分析
当cor=FALSE表示用样本的协方差阵S做主
das = summary(data.pr,loadings=TRUE)

#当样品比比变量少时用fast.prcomp
data.pca = fast.prcomp(data,retx=T,scale=F,center=T)
a = summary(data.pca)
pc = as.data.frame(a$x)

data(Harman23.cor)
