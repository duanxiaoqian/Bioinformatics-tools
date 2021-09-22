##downloading kegg database

library(clusterProfiler)
#kegg list 
kegg_list <- clusterProfiler:::kegg_list("pathway")

#kegg organism

organisms <- clusterProfiler:::kegg_list("organism")

# keggpath
download.organisms.KEGG <- function(organism) {
  library(magrittr)
  keggpathid2extid.df <- clusterProfiler:::kegg_link(organism, "pathway")
  if (is.null(keggpathid2extid.df)){
    write(paste(Sys.time(),"Pathway data of",organism,"is null."), stderr())
  }else{
    message(paste0(Sys.time()," Getting KEGG data of ",organism,"."))
    keggpathid2extid.df[,1] %<>% gsub("[^:]+:", "", .)
    keggpathid2extid.df[,2] %<>% gsub("[^:]+:", "", .)
    colnames(keggpathid2extid.df) <- c("pathway_id","gene_or_orf_id")
    message(paste(Sys.time(),"KEGG data of",organism,"has been downloaded."))
  }
  return(keggpathid2extid.df)
}

organism <- organisms[,2][1:10]
keggpathid2extid.df <- lapply(organism, download.organisms.KEGG)



