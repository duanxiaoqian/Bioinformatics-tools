
path <- "J:/LM2019-1342/NEG/test"
infiletype<-infiletype <- ".wiff"
setwd(path)
getgoalfile <- function(path=path, infiletype=infiletype, full=T){
  files <- basename(dir(path))
  filepath <- files[grepl(pattern = infiletype, x = files)]
  if (full){return(paste0(path,"/",filepath))}else{return(filepath)}
}
getgoalfile(path, infiletype)


# changing filesname indicated into other special name 
changefilename <- function(path=path, filetype=filetype, 
                           changeto=NULL, separate=separate,
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

# df <- changefilename(path, filetype = ".mzXML", separate = "-")



