####火山图####
auto_volplot<-function(data,
                       name=NA,
                       type=NA,
                       dpi=300,
                       compression ="zip",
                       x=min(c(max(abs(c(floor(quantile(data[,2], probs = c(0.999))*1.2),floor(quantile(data[,2], probs = c(0.001))*1.2),4))),15)),
                       y=min(c(max(abs(c(floor(quantile(data[,1], probs = c(0.999))*1.6),4))),30)),
                       drawFC=NA,drawFC_linecolor="black",drawFC_linetype="dashed",
                       cex=1,
                       aspect.ratio=1,
                       size=c(0.5,3),
                       color=c("blue", "grey", "red"),
                       width=7,
                       height=6,
                       family="sans",
                       text=ggplot2::element_text(family=family),
                       plot.margin = ggplot2::unit(c(0.3,0.3,0.3,0.3),"in"),
                       plot.title = ggplot2::element_text(hjust = 0.5),
                       other=ggplot2::theme(),   #ggplot2::facet_wrap(~ Class)
                       legend.position = {if(is.na(VIP)){c(0.85,0.89)
                         }else{"right"}},
                       legend.background = {if(is.na(VIP)){ggplot2::element_rect(fill="white",colour="black",size=0.3)
                       }else{ggplot2::element_rect()}},
                       VIP=NA,p=0.05,linecolor="black",linetype="dashed"){
  
  
  library("ggplot2",quietly = T)
  library("ggrepel",quietly = T)
  
  vol<-data
  
  names(vol)[1]<-"P"
  names(vol)[2]<-"FC"
  
  
  ####火山图作图代码####
  vol[,"class"]<-"not-significant"
  
  if(is.na(drawFC)){
    vol$class[vol[,1]> -log10(p[1]) & vol[,2] > 0] <- "up-regulated"
    vol$class[vol[,1] > -log10(p[1]) & vol[,2] < 0] <- "down-regulated"
    
  }else {
    vol$class[vol[,1] > -log10(p[1]) & vol[,2] > log2(drawFC) ] <- "up-regulated"
    vol$class[vol[,1] > -log10(p[1]) & vol[,2] < (-log2(drawFC))] <- "down-regulated"
  }
  
  if(is.na(VIP)){
    pp<-ggplot(data = vol,mapping =aes(x =FC ,y = P,color=class,text=paste0("ID:",row.names(vol))) )+
      geom_point(size=cex)+
      scale_x_continuous(limits = c(-x,x))+
      scale_y_continuous(limits = c(0,y))+theme_bw()+
      theme(text=text,
            panel.grid=element_blank(),
            plot.title = plot.title,
            aspect.ratio=aspect.ratio,
            plot.margin = plot.margin,
            legend.position =legend.position,
            legend.background = legend.background,
            line = element_line(colour = "black"),
            legend.margin = margin(t = 0, r = 6, b = 6, l = 2, unit = "pt"))+
      guides(color=guide_legend(title=NULL))+
            scale_color_manual(values=c("down-regulated"=color[1],"not-significant"=color[2],"up-regulated"=color[3]))+
      labs(x="log2(FC)",y="-log10(P-value)",title = "Volcano Plot")
  }else {
    names(vol)[3]<-"VIP"
    vol$class[vol$VIP<VIP]<-"not-significant"
    vol<-vol[order(vol$VIP),]
    pp<-ggplot(data = vol,mapping =aes(x =FC ,y = P,color=class,size=VIP,text=paste0("ID:",row.names(vol))) )+
      geom_point()+
      scale_size_continuous(range=size)+
      scale_x_continuous(limits = c(-x,x))+
      scale_y_continuous(limits = c(0,y))+theme_bw()+
      theme(text=text,
            panel.grid=element_blank(),
            plot.title = plot.title,
            aspect.ratio=aspect.ratio,
            plot.margin = plot.margin,
            legend.position = legend.position,
            legend.background = legend.background,
            line = element_line(colour = "black"),
            legend.margin = margin(t = 0, r = 6, b = 6, l = 2, unit = "pt"))+
      guides(color=guide_legend(title=NULL))+
           scale_color_manual(values=c("down-regulated"=color[1],"not-significant"=color[2],"up-regulated"=color[3]))+guides(size = guide_legend(order = 1))+
      labs(x="log2(FC)",y="-log10(P-value)",title = "Volcano Plot")
  }
  
  
  if(is.null(p)){
    
  }else{
    
    for (i in 1:length(p)) {
      pp<-pp+geom_hline(yintercept = c(-log10(p[i])),linetype=linetype,size=0.5,colour = linecolor)+
        annotate("text", label = paste0("p-value=",p[i]), x = 0.8*x, y = c(-log10(p[i]))-y*0.02, size = 4, colour = linecolor)
    }
  }
  
  
  
  if(is.na(drawFC)){
    
  }else {
   pp<-pp+geom_vline(xintercept = c(log2(drawFC)),linetype=drawFC_linetype,size=0.5,colour = drawFC_linecolor)+
      geom_vline(xintercept = c(-log2(drawFC)),linetype=drawFC_linetype,size=0.5,colour = drawFC_linecolor)+
      annotate("text", label = paste0("FC=",drawFC), x = log2(drawFC)+0.15*x, y = y*0.95, size = 4, colour = drawFC_linecolor)+
      annotate("text", label = paste0("FC=","1/",drawFC), x = -log2(drawFC)-0.15*x, y = y*0.95, size = 4, colour = drawFC_linecolor)
  }
  
  pp<-pp+other
  
  if(is.na(name)){
    return(pp)
  }else{
    if(type=="html"){
      library("plotly")
      pp<-ggplotly(p = pp, width = width*100, height = height*100)
      htmltools::save_html(pp,name)
    }else if(type=="tiff"){
      ggsave(name,pp,dpi=dpi,width=width,height=height,compression =compression)
    }else{ggsave(name,pp,dpi=dpi,width =width,height = height)}
  }
  
}

######自动火山图#######
auto_volcano<-function(data,name=NULL,type=c("jpg","pdf"),...){
  vol<-data
  
  if(!is.null(name)){
    name1<-paste0("-",name)
  }else{
    name1<-name
  }
  
  vol<-vol[!is.na(vol[,2]),]
  vol<-vol[!is.na(vol[,1]),]
  vol<-vol[!vol[,2]==0,]
  if(tolower(names(vol)[1])=="p-value"|tolower(names(vol)[1])=="pvalue"){
    vol[,1]<-(-log10(vol[,1]))
  }else if(tolower(names(vol)[1])=="-log10(p-value)"){
  
  }else{
    vol[,1]<-(-log10(vol[,1]))
  }
  if(tolower(names(vol)[2])=="fc"){
    vol[,2]<-log2(vol[,2])
  }else if(tolower(names(vol)[2])=="log2(fc)"){

  }else{
    vol[,2]<-log2(vol[,2])
  }

  
  for(j in 1:length(type)){
    auto_volplot(data=vol,
                 name=ifelse(is.na(type[j]),type[j],paste("volcano",name1,".",type[j],sep="")) ,
                 type=type[j],
                 ...)
  }

  print("auto_volcano运行完成")
}

