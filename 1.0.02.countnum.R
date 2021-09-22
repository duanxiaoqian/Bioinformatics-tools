countnum <- function(vector,element){
  # vector<- as.factor(vector)
  # element<-as.factor(element)
  return(sum(vector%in%element))
}
library(dplyr)
data_matrix <- RMETA2::readxlsx("数据矩阵.xlsx") %>% na.omit()
soil_S <-  cbind(select(data_matrix, Metabolites), select(data_matrix, starts_with("soil-S")))
soil_S <- soil_S[apply(soil_S[,-1],1,countnum,element=0)<4,]
root_S <-  cbind(select(data_matrix, Metabolites), select(data_matrix, starts_with("root-S")))
root_S <- root_S[apply(root_S[,-1],1,countnum,element=0)<4,]
leaf_S <-  cbind(select(data_matrix, Metabolites), select(data_matrix, starts_with("leaf-S")))
leaf_S <- leaf_S[apply(leaf_S[,-1],1,countnum,element=0)<4,]
RMETA2::savexlsx1(soil_S,name = "Venn_groupone.xlsx","soil_S")
RMETA2::savexlsx1(root_S,name = "Venn_groupone.xlsx","root_S")
RMETA2::savexlsx1(leaf_S,name = "Venn_groupone.xlsx","leaf_S")

soil_H <-  cbind(select(data_matrix, Metabolites), select(data_matrix, starts_with("soil-H")))
soil_H <- soil_H[apply(soil_H[,-1],1,countnum,element=0)<4,]
root_H <-  cbind(select(data_matrix, Metabolites), select(data_matrix, starts_with("root-H")))
root_H <- root_H[apply(root_H[,-1],1,countnum,element=0)<4,]
leaf_H <-  cbind(select(data_matrix, Metabolites), select(data_matrix, starts_with("leaf-H")))
leaf_H <- leaf_H[apply(leaf_H[,-1],1,countnum,element=0)<4,]
RMETA2::savexlsx1(soil_H,name = "Venn_grouptwo.xlsx","soil_H")
RMETA2::savexlsx1(root_H,name = "Venn_grouptwo.xlsx","root_H")
RMETA2::savexlsx1(leaf_H,name = "Venn_grouptwo.xlsx","leaf_H")
