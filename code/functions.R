
# -------------------------------------------------------------------------
# formatting the input files to make a long-form dataframe

a = read.csv("data/peaks/27.csv")

col_names <- colnames(a)
for(i in 1:9){
  
  a2 = a %>% dplyr::select(1:i) %>%  
    # rename(col = 1) %>% 
    mutate(group = 1) %>% 
    as.list()
  
  a3 = a %>% dplyr::select(-(1:i)) %>%  dplyr::select(1:i) %>% 
    # rename(col = 1) %>% 
    mutate(group = 2) %>% 
    as.list()
  
  combined = bind_rows(a2, a3)
}

