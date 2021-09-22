# dataframe like filtered by row on the condition
filterbyrow <- function(data, condition=0, number=3){
  data_num <- data[,sapply(data, class)=="numeric"]
  return(data[apply(data_num, 1, function(x){
    sum(x==condition)<number
  }),])
}



