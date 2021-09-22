# 
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("Cardinal")

#kegg富集包KEGGREST 安装

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("KEGGREST")

suppressMessages(library(KEGGREST))
library(dplyr)

 
url <- mark.pathway.by.objects("path:eco00260",c("eco:b0002", "eco:c00263"))
if(interactive()){browseURL(url)}
url <- color.pathway.by.objects("path:eco00260",c("eco:b0002", "eco:c00263"),c("#ff0000", "#00ff00"), c("#ffff00", "yellow"))
# KEGGREST包所有函数

# kegg数据库子库，19个
databaselist <- listDatabases() 
ls('package:KEGGREST')

# 获取所有kegg物种
species <- keggList("organism")

# 获取某一物种所有基因
hsagene <- keggList("hsa")  
# hsagene[1:2]
# names(hsagene) %>% length()
gene_name_definition <- sapply(hsagene, FUN = function(x)strsplit(x, split = "; "))
gene_name_definition_1 <- gene_name_definition %>% sapply(., function(x) {x[1]}) 
gene_name_definition_2 <- gene_name_definition %>% sapply(., function(x) {x[2]})
geneinfo <- data.frame(Entry=names(hsagene), Genename=gene_name_definition_1, Description=gene_name_definition_2)

# 获取物种kegg 通路
res <- keggList("pathway", "hsa")
res[1]
res%>%length()

# 获取某一通路的基因list 
ge <- keggGet("hsa00010")[[1]]$GENE
gene_name <- ge[seq(0,length(ge),2)]
gene_entry <- ge[seq(1,length(ge),2)] %>% paste0("hsa",":", .)
keggpathway_geneinfor <- data.frame(Entry=gene_entry, Genename_description=gene_name)

# 获取某一基因的文献
# 安装挖掘PubMed的R包RISmed，pubmed.mineR
library(RISmed)
library(pubmed.mineR)

# 下载文献数据
search_topic <- c("(metabolomics)")#"(ALDH7A1) AND (ALDH9A1)"
search_query <- EUtilsSummary(search_topic, 
                              # db = "pubmed",
                            # type = "esearch",
                            retmax=200,
                            datetype='pdat',
                            mindate=2015,
                            maxdate=2021)
# 查看检索内容
summary(search_query)

# 看下文献ID
QueryId(search_query)

# 文献数据展现
records <- EUtilsGet(search_query)

# 获取摘要信息
records@AbstractText[1]

# 获取文献类型，综述或论著
records@PublicationType[1]


# 提取检索结果
pubmed <- tibble('Title'=ArticleTitle(records), # 文章题目
                 'Year'=YearPubmed(records), #收录年份
                 'journal'=ISOAbbreviation(records) #期刊
                 )

# 可以查看一下发论文最多的杂志
library(ggplot2)
library(tidyverse)
ggplot(pubmed, aes(fct_infreq(journal)))+
  geom_bar()+
  coord_flip()+
  theme_classic()

# 主题词统计
word <- records@Mesh

## 去除列表中NA
word <- word[!is.na(word)]

# 每一个MESH去重
library(dplyr)
word <- lapply(word, distinct, Heading, .keep_all=T)

# 提取第一列的词
# wordtable <- list()
# for(i in 1:length(word)){
#   wordtable[[i]] <-word[[i]][,1]
# }
# 简便写法如下
wordtable <- reduce(word, rbind)[,1]

# 计算词频
wordcd <- table(unlist(wordtable))
head(wordcd)

# 辞云可视化
library(wordcloud2)
wordcloud2(wordcd,size = 0.3)

# 或者
library(wordcloud)
library(RColorBrewer)
wordcd <- as.data.frame(wordcd)
wordcloud(wordcd$Var1, wordcd$Freq, col=rev(brewer.pal(8, "Set2")))


## 文献摘要文本分析
library(pubmed.mineR)

## 导入下载好的摘要
pubmed_abstracts <- pubmed.mineR::readabs("I:/段光前-工作资料/开发任务/keggdatabaseloading/abstract-metabolomi-set.txt")

# 摘要信息查看
pubmed_abstracts1 <- pubmed_abstracts@Abstract[1]
# 函数`SentenceToken()` 获取信息,句子信息
SentenceToken(pubmed_abstracts1)

# pubmedID
pubmed_abstracts@PMID[1]

# 重点
Sys.setlocale('LC_ALL', 'C') #避免特殊字符问题报错

# 词频的统计及可视化
abswords <- word_atomizations(pubmed_abstracts)

## 词频可视化前15个
library(ggpubr)
ggdotchart(abswords[1:15,], x="words", y="Freq",
           color = "Freq",  
           # palette = rev(brewer.pal(8, "Set2")),
           sorting = "descending",
           add = "segments", # 增加棒棒
           ggtheme = theme_pubr(),
           rotate = T
           )

## 基因名统计与可视化
## 基因频率
absgene <- gene_atomization(pubmed_abstracts)

absgene <- as.data.frame(absgene)
absgene$Freq <- as.numeric(absgene$Freq)

# 基因频率可视化
ggdotchart(absgene[1:15,], x = "Gene_symbol", y = "Freq",
           color = "Freq",
           # palette = c("#00AFBB", "#E7B800", "#FC4E07"),
           sorting = "descending",
           add = "segments",
           ggtheme = theme_pubr(),
           rotate = T
           )






