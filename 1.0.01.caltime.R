# 计算程序运算时间,并返回函数的自身结果

caltime<- function(func=func){
  time0 <- proc.time()
  results<-func
  time <- proc.time()-time0
  print(time)
  return(results)
}

