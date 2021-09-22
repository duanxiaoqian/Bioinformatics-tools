
library(LDheatmap)

setwd("C:/Users/Pioneer/Desktop/LD")
GenE<-  read.csv("chr12GenE.txt", sep = "\t", )
L <-  read.csv("chr12L.txt", sep = ",", header = F)

# LDheatmap(CEUSNP, genetic.distances = stack(L)$values[1:15],color = grey.colors(20))
# data(CEUData)
# class(CEUDist)
# 
# attributes(CEUSNP)
# attributes(GenE)
# colnames(GenE) <- sub("_", "", colnames(GenE))
E<- data.frame(lapply(GenE, genetics::genotype))
LDheatmap(E, genetic.distances = stack(L)$values,color = grey.colors(20))
LDheatmap(E, genetic.distances = stack(L)$values,color = colorRampPalette(rev(c("#FFFF99", "orange", "red")), space = "rgb")(18))


