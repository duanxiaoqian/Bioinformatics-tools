# functional script
# eg
# List <- list(c(1,2,3,4), c(1,3,4,5), c(1,2,8,5,3))
# multi_intersect(List)
#' @param: List : a list contains solo vector to intersect

# simple but need more memory
multi_intersect <- function(List, accumulate=F){
  if (!is.list(List)){
    List <- as.list(List)
  }
  return(Reduce(intersect, List, accumulate=accumulate))
} 


# multi-intersect function
multiintersect <- function(List){
  List <- ifelse(is.list(List), List, as.list(List))
  length <- length(List)
  c <- as.vector(unlist(List))
  pd <- ele_number(c, unique(c))
  return(pd[,1][pd[,2]==length])
}

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







