
# eg

str<- rep(c("abcdasda", "desadjama", "iyasheavaea"), each=2)

pattern<-"a"
num<-1
replacement<-"A"

# select elements equipped with the same column for list
      
ele<-function(list=list,num=num){
  pre <- c()
  for (i in list){
    pre<-append(pre, unlist(i)[num])
  }
  pre <- data.frame(pre, stringsAsFactors = F)
  return(pre)
}

# changing str all by default when num is NULL

strchange <- function(str=str, num=NULL, pattern=pattern, replacement=replacement, ...){
  # 获得匹配到pattern的位子
  b<- gregexpr(pattern, str)
  print(paste0("第",array(1:length(str), dim = c(length(str),1)),"个元素匹配到的位置为", b))
  # 获得匹配元素的最小范围
  minlen <- min(unlist(lapply(gregexpr(pattern, str), length)))
  
  if (is.null(num)) {
    str_done<-gsub(pattern,replacement,str,...)
  } 
  
  # 替换各个元素中第num个位子的pattern匹配
  else if (length(num)==1){
    if (num > minlen){
      print(paste0("num超出所匹配到pattern的边界值(",minlen,")，替换失败，请重新输入小于元素边界值的num"))
      str_done <- NULL
    }else{
      b <- ele(b, num)
      str_done <- c()
      for (i in 1:length(str)){
        scat <- unlist(strsplit(str[i],''))
        df_scat <- data.frame(scat, stringsAsFactors = F)
        df_scat[b[i,],]<-gsub(pattern,replacement,scat[b[i,]],...)
        
        .fun <- function(df){
          if (length(df[1,])==1){
            p1 <- df[1,]
          }else{p1<-df[1,1]}
          
          len<- length(df[,1])
          for (i in df[2:len,]){
            p1 <- paste0(p1,i)
          }
          return(p1)
        }
      pre <- .fun(df_scat)
      str_done <- append(str_done, pre)
      }
    }
    
  # 只替换某个元素中特定位子的pattern匹配 
  }else if(length(num)==2){
    nu<-unlist(b[num[1]])[num[2]]
    scat <- unlist(strsplit(str[num[1]],''))
    df_scat <- data.frame(scat, stringsAsFactors = F)
    df_scat[nu,]<-gsub(pattern,replacement,scat[nu],...)
    
    .fun <- function(df){
      if (length(df[1,])==1){
        p1 <- df[1,]
      }else{p1<-df[1,1]}
      
      len<- length(df[,1])
      for (i in df[2:len,]){
        p1 <- paste0(p1,i)
      }
      return(p1)
    }
    df_str <- data.frame(str, stringsAsFactors = F)
    df_str[num[1],] <- .fun(df_scat)
    str_done <- df_str[,1]
    
  }
  
  return(str_done)
}

# 
# str_done <- strchange(str=str,num=num,pattern = pattern,replacement = replacement)
# str_done <- caltime(strchange(str=str,num=1,pattern = pattern,replacement = replacement))
# str_done
