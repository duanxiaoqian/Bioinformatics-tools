#' Convert proprietory instrument manufacturer file types to .mzXML files
#'
#' @details MSConvert 
#' must be installed and in the case of windows
#' in the path in the environmental variables. The mzXML file conversion will occur
#' through shell commands using the command line version of MSConvert. If more than
#' one cpu is utilized the mzXML file conversion process will occur as a parallel
#' computation.
#' @param rawFiles character vector of full path names to raw data files.
#' @param outDir character full path to directory into which to write the mzXml
#' files output by MSConvert.
#' @param nCores numeric number of computer cores for parallel computation.
#' @param subSetSecs numeric vector of a minimum and maximum time window in
#' mzXML files (e.g. c(1500, 1900)).
#' @param centroid do the raw data files need to be centroided during conversion by MSConvert
#' NB. centroiding of data
#' is necessary for utilization of the "centWave" algorithm of xcms (\code{\link{findPeaks.centWave-methods}}).
#' @param zlib logical whether or not to apply zlib compression (default = TRUE). Will reduce
#' file size but may affect downstream data analysis.
#' @param MS2 logical should raw LC-MS data files converted by MSConvert to mzXml be converted
#' as MS/MS files (e.g. data-dependent MS/MS files).
#' @export
#' 
#' #' 
#' software <- "C:/Users/Pioneer/AppData/Local/Apps/ProteoWizard 3.0.19330.b48e33310 64-bit"
#' # setwd("C:/Users/Pioneer/Desktop/Pos")
#' infiletype <- ".wiff"  # type of rawfiles input,such as .raw  .wiff
#' path <- "J:/售后导图/LM2019-0639/POS" # path of working directory
#' type <- "BPC" # "BPC" or "TIC"
#' filetype <- ".mzXML" #".mzML",".mzXML",".mzData" and so on
#' # filling in information about  names of samples and files
#' file.copy("Z:/质谱数据/information.xlsx", paste0(path,"/information.xlsx"))
#' # choose <- c(paste0("QC_0", 1:6)) # choose filled with samplename should be better
#'  

# setwd(path)
#eg
# system.time(MSdeal(path, infiletype, nCores=4,
                   # filetype=filetype,
                   # type = type,
                   # software=software,
                   # process=NULL,   #NULL
                   # choose=NULL))



MSdeal <- function(path=path, infiletype=infiletype, nCores=NULL,
                   filetype=filetype,
                   type = type,
                   software=software,
                   choose=NULL,
                   process=NULL,
                   ...){
  
  rawFiles <- getgoalfile(path, infiletype)
  outfiletype <- strsplit(filetype,split = "\\.")[[1]][2]
  
  if (is.null(process)){
    pro1 <- proc.time()[3]/60
    MSConvert(rawFiles=rawFiles,outDir = path, 
              outfiletype=outfiletype, 
              nCores = nCores,software=software,...)
    Sys.sleep(1)
    pro11 <- proc.time()[3]/60
    message(paste0("Timing of MSconvert is ",(pro11-pro1)), " min")
    
    pro2 <- proc.time()[3]/60
    if (infiletype==".wiff"){
      df_filesname <- filenamechanging(path = path, filetype = filetype)
    }
    BPCorTIC_figure(path = path, filetype=filetype,
                    type = type,choose=choose, ...)
    pro22 <- proc.time()[3]/60
    message(paste0("Timing of BPCorTIC_figure is ",(pro22-pro2)), " min")
  }else if(process==1|process=="MSConvert"){
    pro1 <- proc.time()[3]/60
    MSConvert(rawFiles=rawFiles,outDir = path, 
              outfiletype=outfiletype, 
              nCores = nCores,software=software,...)
    pro11 <- proc.time()[3]/60
    message(paste0("Timing of MSconvert is ",(pro11-pro1)), " min")
  }else if(process==2|process=="BPCorTIC_figure"){
    pro2 <- proc.time()[3]/60
    if (infiletype==".wiff"){
      df_filesname <- filenamechanging(path = path, filetype = filetype)
    }
    BPCorTIC_figure(path = path, filetype=filetype,
                    type = type,choose=choose, ...)
    pro22 <- proc.time()[3]/60
    message(paste0("Timing of BPCorTIC_figure is ",(pro22-pro2)), " min")
  }
  gc()
}


MSConvert <- function(rawFiles=NULL, outDir=NULL, outfiletype="mzML", 
                      nCores=NULL, 
                      subSetSecs=NULL,
                      software=software,
                      zlib=TRUE, 
                      centroid=TRUE, 
                      MS2=FALSE){
  #error handling
  if(is.null(rawFiles)){
    stop('Argument rawFiles is missing with no default')
  }
  # if necessary select analysis (i.e. results output) directory
  if(is.null(outDir)){
    message(paste0("Select the directory your ", outfiletype, " files will be written to...\n"))
    flush.console()
    
    outDir <- tcltk::tk_choose.dir(default = "",
                                   caption = paste0("Select the directory your .", 
                                                    outfiletype, "  files/ results files will be written to..."))
  }
  if(!is.null(nCores)){
    if(!require(foreach)){
      stop('foreach package must be installed. see ?install.packages')
    }
  }
  
  # Establish msconvert commands to be sent to shell commands, centroid/ MS2
  # (i.e. data dependent/independent) if necessary
  if(centroid == T){
    convType <- ifelse(MS2 == T, paste0('" --64 --', outfiletype, ifelse(zlib == T, ' --zlib ', ' '),
                                        '--filter "peakPicking true 1-2"'),
                       paste0('" --64 --', outfiletype, ifelse(zlib == T, ' --zlib ', ' '),
                              '--filter "peakPicking true 1-"'))
  } else {
    convType <- ifelse(MS2 == T, paste0('" --64 --', outfiletype, ifelse(zlib == T, ' --zlib ', ' '),
                                        '--filter "msLevel 1-2"'),
                       paste0('" --64 --', outfiletype, ifelse(zlib == T, ' --zlib ', ' '),
                              '--filter "msLevel 1-"'))
  }
  # if necessary subset by min and max time in seconds
  if(!is.null(subSetSecs)){
    # error handling, if length of argument is not equal two (i.e. min and max)
    if(length(subSetSecs) != 2){
      stop("subSetSecs argument must be a numeric vector of length two")
    } else {
      convType <- paste0(convType, ' --filter "scanTime [', subSetSecs[1], ',', subSetSecs[2], ']"')
    }
  }
  message(paste0("\nThe total number of rawfiles is ", length(rawFiles), "...\n"))
  message(paste0("Converting to ", outfiletype, " type files and initial peak picking: \n"),
          paste(basename(rawFiles), collapse="\n"), "\n")
  flush.console()
  

  command <- paste0('"',software,'/msconvert.exe" "', rawFiles, convType, ' -o "', outDir,'"')
  # if nCores not null then convert to mzML in parallel
  if(!is.null(nCores) & length(command) > 1){
    # start cluster
    message(paste0("Starting SNOW cluster with ", nCores, " local sockets...\n"))
    flush.console()
    cl <- parallel::makeCluster(nCores)
    doSNOW::registerDoSNOW(cl)
    message(paste0("Converting raw files and saving ", outfiletype, " Files in ", outDir, " directory...\n"))
    flush.console()
    # foreach and dopar from foreach package
    outTmp <- foreach(rawF=1:length(command)) %dopar% {system(command[rawF])}
    # stop SNOW cluster
    parallel::stopCluster(cl)
    rm(outTmp)
    # 6 cores 1519.29 seconds, 25.32 mins or 22.34 seconds per .RAW file
    # (average 280 MB per .RAW file)
  } else {
    # single threaded
    sapply(command, system)
    # single threaded 2500.63 seconds, 41.67 mins or 36.77 seconds per .RAW file
  }
  message("MSconverting work Done\n")
  flush.console()
}



BPCorTIC_figure <- function(path=path, filetype=filetype,
                            type = type,
                            choose=NULL,
                            breaks=seq(0,45,5),
                            gap=2,
                            ...){
  
  library(xcms)
  library(magrittr)
  library(dplyr)
  library(MSnbase)
  library(stats)
  library(RMETA2)
  
  setwd(path)
  mode <- paste0(type, " figure")
  status <- ifelse(dir.exists(mode), {
    unlink(mode, recursive = TRUE, force = FALSE)
    dir.create(mode, showWarnings = TRUE, 
               recursive = FALSE,mode = "0777")
  },dir.create(mode, showWarnings = TRUE, 
               recursive = FALSE,mode = "0777"))
  
  pd <- RMETA2::readxlsx("./information.xlsx")
  status1 <- mapply(file.rename, gsub("^\\s+","",paste0(pd$filename,filetype)), gsub("^\\s+","",paste0(pd$sample_name,filetype))) 
  
  print("正在提取图谱信息，请等待(该过程较慢)。。。")
  raw_data <- MSnbase::readMSData(files = gsub("^\\s+","",paste0("./", paste0(pd$sample_name,filetype))), 
                                  msLevel. = 1, verbose = FALSE,
                                  pdata = new("NAnnotatedDataFrame", pd),
                                  mode = "onDisk",...)
  
  print(paste0("图谱信息提取结束，开始提取", type, "的信息，该过程更慢。。。"))
  setwd(paste0("./", mode))
  if (type=="BPC"){
    data <- MSnbase::chromatogram(raw_data, aggregationFun = "max",...)
    print(paste0("提取结束，开始绘制sigle_", type))
    sigle_BPCorTIC(data=data, type=type, breaks=breaks,...)
    if (!is.null(choose)){
      print(paste0("绘制merged_", type))
      merge_BPCorTIC(data=data, pd=pd, choose=choose, type=type, gap=gap, breaks=breaks,...)
    }
  }
  if (type=="TIC"){
    data <- MSnbase::chromatogram(raw_data, aggregationFun = "sum",...)
    print(paste0("提取结束，开始绘制sigle_", type))
    sigle_BPCorTIC(data=data, type=type,  breaks=breaks,...)
    if (!is.null(choose)){
      print(paste0("绘制merged_", type))
      merge_BPCorTIC(data=data, pd=pd, choose=choose, type=type, gap=gap, breaks=breaks,...)
    }
  }
  setwd("../")
  print(paste0(type, "绘制结束"))
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
      stop("选择的样本不在范围内，请仔细查看样品名或编号，重新选择")
    }
    names <- factor(names(data)[choose])
    data1 <- data[1,choose]
  }
  if(is.character(choose)){
    if (sum(choose %in% names(data)) < length(choose)){
      stop("选择的样本不在范围内，请仔细查看样品名或编号，重新选择")
    }
    names <- factor(choose)
    data1 <- data[1,which(pd$sample_name%in%choose)]
  }
  if (length(choose)==1){
    stop(paste0("请选择2组或2组以上样品，绘制merged_", type))
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

# get Absolute Path of file
getgoalfile <- function(path=path, infiletype=infiletype, full=T){
  files <- basename(dir(path))
  filepath <- files[grepl(pattern = infiletype, x = files)]
  if (full){return(paste0(path,"/",filepath))}else{return(filepath)}
}

# changing filesname indicated into other special name 
changefilename <- function(path=path, filetype=filetype, 
                           changeto=NULL, separate="-",
                           choose=1, ...){
  library(magrittr)
  files <- list.files(path) %>% grepl(pattern = paste0(filetype, "$"), x=.) %>% list.files(path)[.]
  message(paste0("The number of filesname need to change is ", length(files)))
  if (!is.null(changeto)){
    if (length(files)!=length(changeto)){message("filesname need to change is not corresponding with filesname used, 
                                                 please check your changeto agument")}
    files_changed <- changeto
  }
  files_changed <- files %>% strsplit(x = ., split = separate, fixed = T) %>% data.frame()
  
  if (grepl(pattern = paste0(filetype, "$"), x=unlist(files_changed[choose,]))[1]){
    files_changed1 <- unlist(files_changed[choose,])
    message("filesname is equel to filesname changed, so there not need to change")
  }else{
    files_changed1 <- unlist(files_changed[choose,]) %>% paste0(., filetype)
    # changing filesname
    status <- mapply(file.rename, files, files_changed1)
    if (sum(length(status)) < length(files)) {
      message("If there are some FALSE, Warning that checking your filesname and filesname changed")
    }
    message("The replacement of filesname is successful")
  }
  return(data.frame(filesname=files,
                    filesname_changed=files_changed1,
                    row.names = paste0("files_", 1:length(files))))
}

# changing filenames by pattern
filenamechanging <- function(path=path, filetype=".mzXML", pattern = "-Sample\\d{3,4}", ...){
  library(magrittr)
  files <- list.files(path = path, pattern = paste0(filetype, "$"),...) 
  fileschanged <- files %>% 
    gsub(pattern = pattern, replacement = "",x = .,...)
  status <- mapply(file.rename, files, fileschanged)
  return(data.frame(filesname=files,
                    filesname_changed=fileschanged,
                    row.names = paste0("files_", 1:length(files))))
}

# eg: df <- changefilename(path, filetype = ".mzXML", separate = "-")

# End

