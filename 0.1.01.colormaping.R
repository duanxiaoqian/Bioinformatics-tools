
# A color mapping function should accept a vector of values and return a vector of corresponding colors. 
# Users should always use circlize::colorRamp2() function to generate the color mapping function with using Heatmap()

# install.packages("circlize")
colormaping <- function(numberfactor=numberfactor, colorfactor=colorfactor,...){
  library(circlize)
  col_fun = circlize::colorRamp2(numberfactor, colorfactor,...)
  return(col_fun)
}

# ?circlize

# col_fun(seq(-3, 3))
# colorRamp2(breaks, colors, transparency = 0, space = "LAB")
# values between -2 and 2 are linearly interpolated to get corresponding colors, 
# values larger than 2 are all mapped to red and values less than -2 are all mapped to green
# [1] "#00FF00FF" "#00FF00FF" "#B1FF9AFF" "#FFFFFFFF" "#FF9E81FF" "#FF0000FF" "#FF0000FF"
# col_fun=colormaping(c(-2,0,2), c("blue", "white", "red"))
# colorRamp2(seq(min(mat), max(mat), length = 10), rev(rainbow(10)))
# colors = structure(1:4, names = letters[1:4])