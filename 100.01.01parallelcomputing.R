
# 并行运算测试
library(parallel)
setwd("I:/段光前-工作资料/开发任务/functions")


# Calculate the number of cores检查电脑当前可用核数
no_cores<-detectCores(logical=F)-1		#F-物理CPU核心数/T-逻辑CPU核心数

# Initiate cluster发起集群,同时创建数个R进行并行计算
# 只是创建待用的核,而不是并行运算环境
cl<-makeCluster(no_cores)

# 现只需要使用并行化版本的lapply,parLapply就可以
system.time(parLapply(cl, 1:10000000,function(exponent) 2^exponent))
# 当结束后要关闭集群,否则电脑内存会始终被R占用
stopCluster(cl)

system.time(lapply(1:10000000,function(exponent) 2^exponent))
gc() # 回收内存

# 变量作用域, 在Mac/Linux系统中使用 makeCluster(no_core, type="FORK")选项从而当并行运行时可包含所有环境变量
# 在Windows中由于使用的是Parallel Socket Cluster (PSOCK)，每个集群只加载base包，所以运行时要指定加载特定的包或变量

cl<-makeCluster(no_cores)
variates <- 2					#特定变量
clusterExport(cl, "variates")	# 将variates变量加载到集群中,导入多个c("a","b","c")，
                              # 注意点，加载变量到集群后，外界这个变量如何变化，都不改变
parLapply(cl, 2:4, function(exponent)  variates^exponent)
stopCluster(cl)
##############################
clusterExport(cl=NULL,varlist,envir=.GlobalEnv)		# varlist-要导入的对象名称(字符向量)
clusterEvalQ(cl, source(file="code.r"))            # 向集群中添加R脚本
clusterEvalQ(cl, library(rms))                    # 向集群中加载其他运行所需要的包
#############################

######################################## 2.foreach ##################################################
# 设计foreach思想可能是要创建一个lapply和for循环的标准，初始化过程有些不同，需要register注册集群
# 
# 后面的表达式尽量用{}括起来
# 
# %do%-执行单进程任务，即便启动多进程环境也是徒劳
# 
# %dopar%-多进程任务
##################################################################################################

library(foreach)
library(doParallel)			         #doParallel适合Windows/Linux/Mac
no_cores<-detectCores(logical=F)-1
cl<-makeCluster(no_cores) 		   #先发起集群
registerDoParallel(cl)			     #再进行登记注册
#最后结束集群
stopImplicitCluster()			       #停止隐式集群

#foreach函数可使用参数.combine控制结果汇总方法
base=2						#不需要将base变量加载到集群中
foreach(exponent = 2:4, .combine = c)  %dopar%   base^exponent
#数据框
foreach(exponent = 2:4, .combine = rbind)  %dopar%   base^exponent
foreach(exponent = 2:4, .combine = list, .multicombine = TRUE)  %dopar%   base^exponent
#最后list-combine方法是默认的.这个例子中用到.multicombine参数可避免未知的嵌套列表
foreach(exponent = 2:4, .combine = list)  %dopar%  base^exponent

##### foreach中变量作用域有些不同，它会自动加载本地环境(不能直接调用上层环境)到函数中
base<-2
cl<-makeCluster(2)
registerDoParallel(cl)
foreach(exponent = 2:4, .combine = c)  %dopar% base^exponent
stopCluster(cl)


#但对于父环境变量则不会加载
test<-function(exponent) {
  foreach(exponent = 2:4, .combine = c)  %dopar% base^exponent
}
test()
# Error in base^exponent : task 1 failed - "object 'base' not found"


#为解决error可使用.export参数而不要使用clusterExport.它可以加载最终版本变量,在函数运行前变量都是可以改变
base<-2
cl<-makeCluster(2)
registerDoParallel(cl)
base<-4
test<-function (exponent) {
  foreach(exponent = 2:4, .combine = c, .export = "base")  %dopar%  
    base^exponent
}
test()
stopCluster(cl)
# [1]  16  64 256
#类似可使用.packages参数来加载包(非系统安装包),比如.packages = c("rms", "mice")

###################################### 3.使用Fork|Sork ###############################
# FORK:"to divide in branches and go separate ways"
# 系统:Unix/Mac (not Windows) 
# 环境:所有
# 
# PSOCK:并行socket集群 
# 系统:All (including Windows) 
# 环境:空
#####################

###################################### 4.内存控制 ###########################
#如果不打算使用windows系统,建议尝试FORK模式,可实现内存共享从而节省内存
PSOCK:
  library(pryr)
no_cores<-detectCores(logical=F)
cl<-makeCluster(no_cores)
clusterExport(cl,"a")
clusterEvalQ(cl,library(pryr))
#address检查R对象的内部属性
parSapply(cl, X = 1:10, function(x) address(a)) == address(a)
#输出结果为FLASE说明没有实现内存共享
# [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE

# FORK:
  cl<-makeCluster(no_cores, type="FORK")
parSapply(cl, X = 1:10, function(x) address(a)) == address(a)
#输出结果为TRUE说明实现内存共享
# [1] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE

b<-0
clusterExport(cl,"b")
parSapply(cl, X = 1:10, function(x) {b<-b + 1; b})
# [1]
# 1 1 1 1 1 1 1 1 1 1
parSapply(cl, X = 1:10, function(x) {b <<- b + 1; b})	#两个核心集群
# [1] 1 2 3 4 5 1 2 3 4 5
b
# [1] 0
#####

######为此可使用tryCatch捕捉错误，从而使出现错误后程序还能继续执行##
foreach(x=list(1,2,"a"),.combine=list)  %dopar%  
  {
    tryCatch({
      c(1/x, x, 2^x)
    }, error = function(e) return(paste0("The variable '", x, "'", 
                                         " caused the error: '", e, "'")))
  }
# [[1]]
# [1] 1 1 2
# [[2]]
# [1] 0.5 2.0 4.0
# [[3]]
# [1] "The variable 'a' caused the error: 'Error in 1/x: non-numeric argument to binary operator\n'"
######

######创建文件输出
cl<-makeCluster(no_cores, outfile = "debug.txt")
registerDoParallel(cl)
foreach(x=list(1, 2, "a"))  %dopar%  
  {
    print(x)
  }
stopCluster(cl)
#debug文件输出,当代码出现错误时不会出现以下信息
# starting worker pid=7392 on localhost:11411 at 00:11:21.077
# starting worker pid=7276 on localhost:11411 at 00:11:21.319
# starting worker pid=7576 on localhost:11411 at 00:11:21.762
#####

#####创建结点专用文件
cl<-makeCluster(no_cores, outfile = "debug.txt")
registerDoParallel(cl)
foreach(x=list(1, 2, "a"))  %dopar%  
  {
    cat(dput(x), file = paste0("debug_file_", x, ".txt"))
  } 
stopCluster(cl)
#####

#####DEBUG日志输出文件
library(foreach)
library(doParallel)			
no_cores<-detectCores(logical=F)-1
cl<-makeCluster(no_cores,outfile="debug.txt") 		
registerDoParallel(cl)			

ceshi<-function(x){
  a<-tryCatch(
    {
      c(1/x, x, 2^x)
    },error=function(e) 
      return(paste0("The variable '", x, "'", " caused the error: '", e, "'"))
  )
  cat(x,'-----',a,file=paste0("debug_file_", x, ".txt"))	#不同节点必须写入不同文件
  return(a)
}

foreach(x=list(1,2,"a",3,0,'b',4),.combine=c) %dopar% ceshi(x)

stopImplicitCluster()
stopCluster(cl)

########################  6 .任务载入、载入平衡 #############################
#  splitList(X,length(cl)) 将任务分割成多个部分，然后将其发送到不同集群中

# From the nnet example
parLapply(cl, c(10, 20, 30, 40, 50), function(neurons) 
  nnet(ir[samp,], targets[samp,], size = neurons))
# 改为:顺序调整,分配更加合理
# From the nnet example
parLapply(cl, c(10, 50, 30, 40, 20), function(neurons) 
  nnet(ir[samp,], targets[samp,], size = neurons))

##############################################

#########################  7. 内存载入      #################################
# ls()看work space中有什么变量。
# object.size()看每个变量占多大内存。
# memory.size()查看现在的work space的内存使用
# memory.limit()查看系统规定的内存使用上限
# memory.limit(newLimit)更改到一个新的上限
# rm(object)删除变量
# gc()做Garbage collection
#############################################################################


library(parallel) #用于并行计算
library(snowfall)  # 载入snowfall包,用于并行计算
system.time(
  for (i in 1:2250) {
    for (j in 1:100000) {
      s=i+j
    }
  }
)

myfun<-function(i){
  for (j in 1:100000) {
    s=i+j
  }
}
system.time({
  # 并行初始化
  sfInit(parallel = TRUE, cpus = detectCores(logical = F) - 1)
  # 进行lapply的并行操作
  # s<-sfLapply(1:2250, myfun)
  s<-sfLapply(1:3, function(x) c(x, x ^ 2, x ^ 3))
  # 结束并行，返还内存等资源
  sfStop()}
)
n <- 100
m <- 100

fun1 <- function(...) {
  ...
}

fun2 <- function(...) {
  ...
}

sfInit(parallel = TRUE, cpus = 10) #初始化

sfLibrary(MASS)     # 载入依赖R包MASS
sfLibrary(ggplot2)  # 载入依赖R包ggplot2

sfExport("n", "m")         # 载入依赖的对象
sfExport("fun1", "fun2")   # 载入依赖的函数

# 并行计算
result <- sfLapply(1:10000, myfun) 
# 注意：myfun是自己定义的函数，里面需要用到包MASS, ggplot2；变量m, n；函数fun1, fun2。

sfStop() # 结束并行









