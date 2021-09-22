

# arguments defining
path <- "C:/Users/Pioneer/Desktop/Neg" # path of working directory
type <- "BPC" # "BPC" or "TIC"
filetype <- ".mzML" #".mzML",".mzXML",".mzData" and so on
sample_name <- NULL # parsing filename suffixed with filetype in default, but suggest to be set
sample_group <- c(rep("QC", 4),rep("X1", 5),
                  rep("X2", 3),rep("X3", 4),
                  rep("X4", 4),rep("X5", 3),
                  rep("XC", 9)) # need set correspondingly to samplename
choose <- c(1,2,3,6) # choose filled with samplename should be better

# eg
system.time(BPCorTIC_figure(path = path, filetype=filetype,
                type = type,
                sample_group = sample_group,
                sample_name = NULL,
                choose=choose
                ))

# main function
# warning points include that there should be mapped accurately between samplegroup 
# and prefix of CDF file names confirmed  exactly.
BPCorTIC_figure <- function(path=path, filetype=filetype,
                            type = type,
                            sample_name = NULL,
                            sample_group = sample_group,
                            choose=choose,
                            breaks=seq(0,45,5),
                            gap=2,
                            ...){

library(xcms)
library(magrittr)
library(MSnbase)
library(stats)

setwd(path)
mode <- paste0(type, " figure")
status <- ifelse(dir.exists(mode), {
  unlink(mode, recursive = TRUE, force = FALSE)
  dir.create(mode, showWarnings = TRUE, 
             recursive = FALSE,mode = "0777")
},dir.create(mode, showWarnings = TRUE, 
              recursive = FALSE,mode = "0777"))

## Get the full path to the MS files of diffenent filetype
files <- basename(dir(getwd()))
file <- files[grepl(pattern = filetype, x = files)]
if(is.null(sample_name)){
  file_name <- file %>% strsplit(., "_", fixed = T) %>% as.data.frame() %>% t()
  sample_name <- file_name[,ncol(file_name)] %>% gsub(., pattern = filetype,
                                                      replacement = "", fixed = TRUE)
}

pd <- data.frame(sample_name = sample_name,
                 sample_group = sample_group,
                 stringsAsFactors = FALSE)

print("Extracting the MS information, please waiting (this processing is slow) ...")
raw_data <- MSnbase::readMSData(files = paste0("./",file), 
                                msLevel. = 1, verbose = FALSE,
                                pdata = new("NAnnotatedDataFrame", pd),
                                mode = "onDisk",...)

print(paste0("The fetching MS infor is over, starting to extract information of ", type, "and this procedure is also slow"))
setwd(paste0("./", mode))
if (type=="BPC"){
  data <- MSnbase::chromatogram(raw_data, aggregationFun = "max",...)
  print(paste0("Extracting is over, to begin to drawing sigle_", type))
  sigle_BPCorTIC(data=data, type=type, breaks=breaks,...)
  print(paste0("Drawing merged_", type))
  merge_BPCorTIC(data=data, pd=pd, choose=choose, type=type, gap=gap, breaks=breaks,...)
}
if (type=="TIC"){
  data <- MSnbase::chromatogram(raw_data, aggregationFun = "sum",...)
  print(paste0("Extracting is over, to begin to drawing sigle_", type))
  sigle_BPCorTIC(data=data, type=type,  breaks=breaks,...)
  print(paste0("Drawing merged_", type))
  merge_BPCorTIC(data=data, pd=pd, choose=choose, type=type, gap=gap, breaks=breaks,...)
}
setwd("../")
print(paste0(type, "Drawing is over"))
gc()
}


drawing <- function(x=x, y=y, main=main, breaks=breaks,...){
  library(ggplot2)
  x<-x/60
  data <- data.frame("Retentime time(min)"=x, "Intensity"=y)
  ggplot(data, aes(x,y))+
    geom_line(color="#FF6600", size=0.6)+
    labs(title=main)+ xlab("Retentime time(min)")+ylab("Intensity")+
    theme_bw()+
    theme(panel.grid=element_blank(),
          plot.title = element_text(hjust = 0.5),
          plot.margin = unit(c(0.2, 0.2, 0.2, 0.2), "inches")
         )+
    scale_x_continuous(breaks = breaks)
}

# Plot all BPCorTIC figure sololy
sigle_BPCorTIC <- function(data=data, type="BPC", breaks=breaks,...){
  library(MSnbase)
  library(stats)
  i<-1
  while (i <= length(data)) {
    rtime <- rtime(data[1, i])
    intensity <- intensity(data[1, i])
    pdf(paste0(data$sample_name[i],"_",type,".pdf"),width=15, height=8)
    print(drawing(rtime,intensity,main=paste0("Sample ", data$sample_name[i]), breaks=breaks))
    dev.off()
    jpeg(paste0(data$sample_name[i],"_",type,".jpg"),width=900, height=500)
    print(drawing(rtime,intensity,main=paste0("Sample ", data$sample_name[i]), breaks=breaks))
    dev.off()
    i=i+1
  }
}

merge_BPCorTIC <- function(data=data, pd=pd, choose=choose, type="BPC", breaks=breaks, gap=4, ...){

  names(data) <- pd$sample_name
  if(is.numeric(choose)){
    if (max(choose)>length(data)){
      stop("The choice of sample is not in range, please choose correct sample names or number")
    }
    names <- factor(names(data)[choose])
    data1 <- data[1,choose]
  }
  if(is.character(choose)){
    if (sum(choose %in% names(data)) < length(choose)){
      stop("The choice of sample is not in range, please choose correct sample names or number")
    }
    names <- factor(choose)
    data1 <- data[1,which(pd$sample_name%in%choose)]
  }
  if (length(choose)==1){
    stop(paste0("Drawing merged_", type, " Please choose two or more samples"))
  }
  
  rtime1 <- lapply(data1, MSnbase::rtime)%>%
            list_to_one(., colnames = "RT",names = names)

  intensity1 <- lapply(data1, MSnbase::intensity)%>%
                list_to_one(., colnames = "Intensity",names = names, gap = gap, fc=1)

  library(ggplot2)
  pdf(paste0("merged_",type,".pdf"),width=15, height=8)
  p <- cbind(rtime1,intensity1)[,-4] %>% ggplot(., aes(RT/60,Intensity,color=Samplenames))+
    geom_line(size=0.6)+
    labs(title=paste0("merged ", type))+ 
    xlab("Retentime time(min)")+
    ylab("Intensity")+
    theme_bw()+
    theme(panel.grid = element_blank(),
          plot.title = element_text(hjust = 0.5),
          plot.margin = unit(c(0.2, 0.2, 0.2, 0.2), "inches")
         )+
    scale_x_continuous(breaks = breaks)
  print(p)
  dev.off()
  jpeg(paste0("merged_",type,".jpg"), width = 900, height=500)
  print(p)
  dev.off()
}

dataframe_to_one <- function(df=df, colnames=colnames, names=names, gap=2, fc=0){
  if (ncol(df)==1){
    stop("dataframe df is only one column, not need to transform long dataframe")
  }
  df1 <- df[,1,drop=F]
  colnames(df1) <- colnames
  i <- 2
  while(i <= length(names)){
    df2 <- df[,i,drop=F]+(i-1)*max(df)/gap*fc
    colnames(df2) <- colnames
    df1 <- rbind(df1, df2)
    i=i+1
  }
  df1$Samplenames <- rep(factor(names), each=length(df[,1]))
  return(df1)
}

list_to_one <- function(list=list, colnames=colnames, names=names, gap=2, fc=0){
  if (length(list)==1){
    df1 <- as.data.frame(list[[1]]) 
    colnames(df1) <- colnames
    df1$Samplenames <- rep(names[1], length(list[[1]]))
  } else{
  df1 <- as.data.frame(list[[1]]) 
  colnames(df1) <- colnames
  df1$Samplenames <- rep(names[1], length(list[[1]]))
  i <- 2
  while(i <= length(names)){
    df2 <- as.data.frame(list[[i]])+(i-1)*max(unlist(list))/gap*fc
    colnames(df2) <- colnames
    df2$Samplenames <- rep(names[i], length(list[[i]]))
    df1 <- rbind(df1, df2)
    i=i+1
  }}
  return(df1)
}

# End
