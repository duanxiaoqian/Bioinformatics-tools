# simple HEATmap for PC Loading and other type

setwd("I:/段光前-工作资料/开发任务/练习数据集")
list <- dir("./",pattern = "*.xlsx" )
data <- lapply(list, openxlsx::read.xlsx, rowNames=T)
simple_heatmap <- function(data=data,
                           groupname = NA, 
                           color=NA,legendname=NA,
                           column_names_rot=0,
                           cluster_rows=T,
                           show_row_dend=F,
                           ...){
  library(ComplexHeatmap)
  data <- as.matrix(data)
  if (is.na(color)){
    color<-colorRampPalette(c("blue", "white","red"))(1000)
  }else{
    print("color argument must be availble like \"blue\" or \"#0000FF\" ")
    color<-color
  }
  if (is.na(legendname)){
    legendname <- "PC loadings"
  }else{
    legendname <- legendname
  }

  
  
  
  # heatmap body,width and height, By default, all heatmap components have fixed width or height
  if (ncol(data)<6){
    width <- ncol(data)
  }else if(ncol(data)<12){
    width <- 0.5*ncol(data)
  }else if(ncol(data)>=12){
    width <- 6
  }
  if (nrow(data)<=6){
    height <- 0.618*nrow(data)
  }else if(nrow(data)<12){
    height <- 10
  }else if(nrow(data)>=12){
    height <- 12
  } 
  
  
  # row col marker max 
  maxrowchar <- max(nchar(rownames(data)))
  maxcolchar <- max(nchar(colnames(data)))
  row_names_max_width <- max_text_width(rownames(data))
  column_names_max_height <- max_text_width(colnames(data))
  
  # legend width and height
  legend_height <- unit(height*0.4,"cm")
  legend_width  <- unit(height*0.618*0.3,"cm")
  
  # row col fontsize
  row_fontsize <- height/nrow(data)*72.27/2.54*0.5
  col_fontsize <- width/ncol(data)*72.27/2.54*0.3
  
   # the complete heatmap including all heatmap components (excluding the legends) 
  heatmap_width <-  unit((width+height/nrow(data)*maxrowchar/0.8/5), "cm")#+height*0.618*0.3
  heatmap_height <- unit(height+as.numeric(column_names_max_height)/10, "cm")
  
  #  save figure
  # library(Cairo)
  # library(showtext)
  groupname <- ifelse(is.na(groupname),"",paste0(groupname,"-"))
  
  # get figure width  height
  p1 <- ComplexHeatmap::Heatmap(data,
                             col = color,
                             name = legendname,
                             column_names_rot = column_names_rot,
                             cluster_rows = cluster_rows,
                             show_row_dend = show_row_dend,
                             cluster_columns =F,
                             width = width,
                             height = height,
                             row_names_max_width = row_names_max_width,
                             column_names_max_height = column_names_max_height,
                             heatmap_width = heatmap_width,
                             heatmap_height = heatmap_height,
                             row_names_gp = gpar(fontsize = row_fontsize),
                             column_names_gp = gpar(fontsize = col_fontsize),
                             row_names_centered = F,
                             column_names_centered = T,
                             heatmap_legend_param = list(legend_height = legend_height,
                                                         legend_width = legend_width)
  )
  figure_width <- ComplexHeatmap:::width(draw(p1))
  figure_height <- ComplexHeatmap:::height(draw(p1))

  ## PDF                   
  # Cairo::CairoPDF(file = paste0(groupname,legendname,"-heatmap.pdf"),width = 12, height = 12)
  pdf(file = paste0(groupname,legendname,"-heatmap.pdf"),
      width =as.numeric(figure_width)/10/2, 
      height = as.numeric(figure_height)/10/2
      )
  # showtext::showtext_begin()
  # ComplexHeatmap::Heatmap(data,
  #                         col = color,
  #                         name = legendname,
  #                         column_names_rot = column_names_rot,
  #                         cluster_rows = cluster_rows,
  #                         show_row_dend = show_row_dend,
  #                         cluster_columns =F,
  #                         width = width,
  #                         height = height,
  #                         row_names_max_width = row_names_max_width,
  #                         column_names_max_height = column_names_max_height,
  #                         heatmap_width = heatmap_width,
  #                         heatmap_height = heatmap_height,
  #                         row_names_gp = gpar(fontsize = row_fontsize),
  #                         column_names_gp = gpar(fontsize = col_fontsize),
  #                         row_names_centered = F,
  #                         column_names_centered = T,
  #                         heatmap_legend_param = list(legend_height = legend_height,
  #                                                     legend_width = legend_width)
  # )
  draw(p1)
  # showtext::showtext_end()
  # p2 <- rowAnnotation(text = row_anno_text(rownames(data)), width = max_text_width(rownames(data)))
  # draw(p1+p2)
  dev.off()
  # dev.new()
  
  ## tiff
  # Cairo::CairoTIFF(filename = paste0(groupname,legendname,"-heatmap.tiff"),width = 600, height = 600)
  tiff(filename = paste0(groupname,legendname,"-heatmap.tiff"),
       width = as.numeric(figure_width)*7.227/2, 
       height = as.numeric(figure_height)*7.227/2, 
       units = "px")
  draw(p1)
  dev.off()
}

simple_heatmap(data=data[[4]])
