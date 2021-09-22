

# createKEGGdb
setwd("I:/段光前-工作资料/开发任务/")

# 具体物种和缩写的对应关系可以查看KEGG的API：http://rest.kegg.jp/list/organism
library(createKEGGdb)
library(pkgbuild)

create_kegg_db("all")
packagedir <- "C:/Users/Pioneer/AppData/Local/Temp/RtmpiIMQ2U/file27acc3e7209"

#build package
pkgbuild::build("C:/Users/Pioneer/Documents/R packeges/ggthemr-master", dest_path = "C:\\Users\\Pioneer\\Documents\\R packeges")



