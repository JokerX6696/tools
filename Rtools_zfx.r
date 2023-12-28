# 使用 R 语言过程中 可以提升效率的部分小工具


# 用于输出数据write.table时， 首行缺失或错位的问题 返回矩阵后需要手动给第一列行名赋值
normalize_mtx <- function(Mtx){
  df <- Mtx
  rnm <- rownames(df)
  new_df <- data.frame(name=rnm,df)
  names(new_df)[1] = ""
  return(new_df)
}

