# calculate elements times in a vector
# return a  df
ele_number <- function(Vector=Vector, elements=elements,...){
  number <- c()
  for (i in 1:length(elements)){
    number[i] <- sum(Vector%in%elements[i])
  }
  pd <- data.frame(elements=elements,
                   number=number)
  return(pd)
}
