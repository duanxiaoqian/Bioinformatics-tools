# search new R packages in CRAN by pkgsearch
find_packeges <- function(pkgname="ROC", n=5){
  # install.packages("pkgsearch")  # for searching packages
  # install.packages("dlstats")
  # install.packages("dplyr")
  # install.packages("ggplot2")
  
  # options(stringsAsFactors = F)
  options(warn = -1)
  
  library(pkgsearch)
  library(dlstats)
  library(dplyr)
  library(ggplot2)
  
  message("Starting to search packages contained with keyword of \"", pkgname, 
          "\"...\n",
          "if long time no response, please shut down and run again...")
  PkgShort <- pkgsearch::pkg_search(query=pkgname,size=200)%>% 
    dplyr::filter(maintainer_name != "ORPHANED", score > 190) %>%
    dplyr::select(score, package, downloads_last_month) %>%
    dplyr::arrange(desc(downloads_last_month))
  message("We found ", length(PkgShort$package), 
          " packages about \"", 
          pkgname, "\"")
  
  # plot top n
  if (!(n>2&is.numeric(n)&n<=length(PkgShort$package))){
    message("n must be numeric , >2 and < the max packages-number, please change it")
  }
  downloads <- PkgShort$package[1:n] %>% dlstats::cran_stats(.)
  p <- ggplot2::ggplot(downloads, aes(end, downloads, group=package, color=package)) +
    geom_line() + geom_point(aes(shape=package)) +
    theme_bw()+ xlab("year")+
    scale_y_continuous(trans = 'log2') 
  print(p)
  # dev.off()
  return(PkgShort)
}
# pkg <- find_packeges(pkgname="opencv", n=3)
