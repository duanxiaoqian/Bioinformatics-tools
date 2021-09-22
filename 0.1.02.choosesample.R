# choosing samples randomly
ind<-sample(3,nrow(iris),replace=TRUE,prob = c(0.7,0.1,0.2))
set.seed(100)
train<-iris[ind==1,]
test<-iris[ind==2,]
