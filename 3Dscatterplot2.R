library(plotly)
library(htmlwidgets)
library(openxlsx)
library(dplyr)
#library(readxl)
path <- "I:/段光前-工作资料/开发任务/3DscatterPlot"
filename <- "trusted_proteins_pca_socre.xlsx"

ThreeD_scatterplot(path=path, filename = filename, symbol=F)
ThreeD_scatterplot <- function(path=path, filename=filename, symbol=FALSE){
  setwd(path)
  sheetnames <- names(openxlsx::loadWorkbook(file = filename)) 
  # sheetnames <- readxl::excel_sheets(filename) # 同上，大文件时用
  for (i in sheetnames){
    print(paste0("正在绘制", i, "比较组的3D PCA Plot"))
    # data <- readxl::read_excel(path = filename, sheet=i) # 读出数据为tibble
    # x <- dplyr::select(data, contains('PC1'))
    # y <- dplyr::select(data, contains('PC2'))
    # z <- dplyr::select(data, contains('PC3'))
    data <- openxlsx::read.xlsx(filename, sheet=i)
    x <- dplyr::select(data, contains('PC1'))
    y <- dplyr::select(data, contains('PC2'))
    z <- dplyr::select(data, contains('PC3'))
    groupcount <- length(unique(data$Group)) 
    if (groupcount <= 15){
      groupcount <- groupcount
    }else{
      groupcount <- 15
    }
    colors <- c('#33CC00','#FF0033','#0099FF','#FF9900','#CC00FF',
                '#99FF66','#FF6600','#33FFFF','#FFCC33','#FF33FF',
                '#336600','#FF6633','#0000FF','#FFFF00','#9900FF')[1:groupcount]#green,red, blue,yellow,purple
    if (symbol){
      groupcount <- ifelse(groupcount > 8, 8, groupcount)
      symbol <- data$Group
      symbols <- c("circle","square","diamond",
                   "circle-open","square-open",
                   "diamond-open","cross","x")[1:groupcount]
      
    }else{
      symbol <- NULL
      symbols <- "circle"
    }
    
    p <- plot_ly(data, type = "scatter3d", x = x[,], y = y[,], z = z[,], 
                 color = ~Group, 
                 colors = colors,
                 # size = ~, 
                 # sizes = c(),
                 symbol = symbol,
                 symbols = symbols,
                 #marker = list(symbol = sample(c("circle","square","circle-open" ,"diamond"),3)), 
                 #hovertext = ~Sample,
                 mode = "markers",
                 text = paste('Sample:', data$Sample, '<br>Group:', data$Group, 
                              '<br>PC1:', x[,],'<br>PC2:', y[,], '<br>PC3:', z[,]),
                 # textposition =  "middle center",
                 hoverinfo = 'text'
                 # Width = 800,
                 # height = 600,
    ) %>%
      #add_markers()%>%
      layout(title = paste0('3D PCA Plot in ', i),
             scene = list(xaxis = list(title = colnames(x),
                                       gridcolor = '#999999',
                                       range = c(min(x), max(x)),
                                       #type = 'log',
                                       zerolinewidth = 1,
                                       ticklen = 5,
                                       gridwidth = 2),
                          yaxis = list(title = colnames(y),
                                       gridcolor = '#999999',
                                       range = c(min(y), max(y)),
                                       zerolinewidth = 1,
                                       ticklen = 5,
                                       gridwith = 2),
                          zaxis = list(title = colnames(z),
                                       gridcolor = '#999999',
                                       range = c(min(z), max(z)),
                                       zerolinewidth = 1,
                                       ticklen = 5,
                                       gridwith = 2),
                          camera = list(eye = list(x=2, y=1.8, z=1.6))),
             # Width = 800,
             # height = 600,
             # margin = list(l = 100,t = 50,r = 100,b = 0),
             paper_bgcolor = '#FFFFFF',
             plot_bgcolor = '#FFFFFF'
      )
    
    suppressWarnings(saveWidget(p, paste0(i,".html"), selfcontained = F, libdir = path))
    suppressWarnings(orca(p, file = paste0(i,".pdf"),width = 1000, height = 800))
    suppressWarnings(orca(p, file = paste0(i,".png"),width = 1000, height = 800))
    print(paste0(i, "比较组3D PCA Plot绘制并保存完成"))
  }
  # Create a shareable link to your chart
  # Set up API credentials: https://plot.ly/r/getting-started
  # chart_link = api_create(p, filename="scatter3d-colorscale")
  # chart_link 
}





